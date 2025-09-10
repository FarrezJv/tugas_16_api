import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_16_api/api/produk.dart';
import 'package:tugas_16_api/model/products/tambah_produk.dart';

Future<AddProdukModel?> showProductFormDialog({
  required BuildContext context,
  int? id,
  GetProducts? initialData,
  required List<Map<String, dynamic>> kategoriList,
  required List<Map<String, dynamic>> brandList,
}) {
  final nameController = TextEditingController(text: initialData?.name ?? '');
  final descriptionController = TextEditingController(
    text: initialData?.description ?? '',
  );
  final priceController = TextEditingController(
    text: initialData?.price != null ? initialData!.price.toString() : '',
  );

  final stockController = TextEditingController(
    text: initialData?.stock != null ? initialData!.stock.toString() : '',
  );
  final discountController = TextEditingController(
    text: initialData?.discount != null ? initialData!.discount.toString() : '',
  );

  String? selectedCategory;
  int? selectedCategoryId;
  String? selectedBrand;
  int? selectedBrandId;

  List<File> selectedImages = [];
  bool isLoading = false;

  if (initialData != null) {
    selectedCategory = initialData.category;
    selectedCategoryId = initialData.categoryId;
    selectedBrand = initialData.brand;
    selectedBrandId = initialData.brandId;
  }

  return showDialog<AddProdukModel>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickImages() async {
            final picker = ImagePicker();
            final pickedFiles = await picker.pickMultiImage();
            if (pickedFiles.isNotEmpty) {
              setState(() {
                selectedImages = pickedFiles.map((e) => File(e.path)).toList();
              });
            }
          }

          Future<void> submit() async {
            if (nameController.text.isEmpty ||
                descriptionController.text.isEmpty ||
                priceController.text.isEmpty ||
                stockController.text.isEmpty ||
                selectedCategoryId == null ||
                selectedBrandId == null ||
                (id == null && selectedImages.isEmpty)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "All fields are required and at least one image must be selected (for adding).",
                  ),
                ),
              );
              return;
            }

            setState(() => isLoading = true);

            try {
              final price = int.tryParse(priceController.text) ?? 0;
              final stock = int.tryParse(stockController.text) ?? 0;
              final discount = int.tryParse(discountController.text) ?? 0;

              AddProdukModel result;
              if (id == null) {
                result = await AuthenticationApiProduct.addProduct(
                  name: nameController.text,
                  description: descriptionController.text,
                  prices: price,
                  stock: stock,
                  discount: discount,
                  categoryId: selectedCategoryId!,
                  brandId: selectedBrandId!,
                  images: selectedImages,
                );
              } else {
                result = await AuthenticationApiProduct.updateProduct(
                  id: id,
                  name: nameController.text,
                  description: descriptionController.text,
                  prices: price,
                  stock: stock,
                  discount: discount,
                  categoryId: selectedCategoryId!,
                  brandId: selectedBrandId!,
                  images: selectedImages.isNotEmpty ? selectedImages : null,
                );
              }

              if (context.mounted) Navigator.pop(context, result);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to save product: $e")),
                );
              }
            } finally {
              setState(() => isLoading = false);
            }
          }

          return AlertDialog(
            title: Text(id == null ? "Add Product" : "Edit Product"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 3,
                  ),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Price"),
                  ),
                  TextField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Stock"),
                  ),
                  TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Discount (%)",
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    decoration: const InputDecoration(labelText: "Category"),
                    items: kategoriList.map((kategori) {
                      return DropdownMenuItem<int>(
                        value: kategori["id"],
                        child: Text(kategori["name"]),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final selected = kategoriList.firstWhere(
                        (k) => k["id"] == value,
                      );
                      setState(() {
                        selectedCategoryId = selected["id"];
                        selectedCategory = selected["name"];
                      });
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: selectedBrandId,
                    decoration: const InputDecoration(labelText: "Brand"),
                    items: brandList.map((brand) {
                      return DropdownMenuItem<int>(
                        value: brand["id"],
                        child: Text(brand["name"]),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final selected = brandList.firstWhere(
                        (b) => b["id"] == value,
                      );
                      setState(() {
                        selectedBrandId = selected["id"];
                        selectedBrand = selected["name"];
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var file in selectedImages)
                        Image.file(
                          file,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      if (selectedImages.isEmpty && initialData != null)
                        for (var url in initialData.imageUrls)
                          Image.network(
                            url,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: pickImages,
                    icon: const Icon(Icons.image),
                    label: const Text("Choose Images"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : ElevatedButton(
                      onPressed: submit,
                      child: Text(id == null ? "Add" : "Save"),
                    ),
            ],
          );
        },
      );
    },
  );
}
