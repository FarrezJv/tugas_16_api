import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_16_api/api/brand.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/model/brand/brand_user_model.dart';
import 'package:tugas_16_api/model/brand/get_brand.dart';
import 'package:tugas_16_api/utils/gambar.dart';
import 'package:tugas_16_api/views/add_Screen/tambah_produk.dart';
import 'package:tugas_16_api/views/category_views/category.dart' hide Card;

class TambahBrand extends StatefulWidget {
  const TambahBrand({super.key});

  @override
  State<TambahBrand> createState() => _TambahBrandState();
}

class _TambahBrandState extends State<TambahBrand> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;

  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  AddBrand? user;
  String? errorMessage;

  late Future<List<GetBrandData>> _futureBrand;

  @override
  void initState() {
    super.initState();
    _futureBrand = BrandAPI.getBrand();
  }

  void _refreshBrand() {
    setState(() {
      _futureBrand = BrandAPI.getBrand();
    });
  }

  Future<void> pickFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedFile = image;
    });
  }

  // tambah brand (nama + foto)
  Future<void> tambahBrand() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Brand Name not found")));
      setState(() => isLoading = false);
      return;
    }

    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Brand photo has not been selected")),
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      await BrandAPI.postFotoBrand(name: name, image: File(pickedFile!.path));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Add Brand Successfully")));

      nameController.clear();
      setState(() {
        pickedFile = null;
      });
      _refreshBrand(); // refresh setelah tambah
    } catch (e) {
      setState(() => errorMessage = e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppImage.logo_png, width: 150),
                const Text(
                  "BrandNow Admin Feature.",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                /// Form Tambah Brand
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Add New Brand",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8A6BE4),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Name Brand",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.store_mall_directory),
                          ),
                        ),
                        const SizedBox(height: 16),
                        pickedFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(pickedFile!.path),
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Container(
                                height: 150,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text("No photos selected"),
                              ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: pickFoto,
                                icon: const Icon(Icons.image),
                                label: const Text("Select Photo"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLoading ? null : tambahBrand,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8A6BE4),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        "Add Brand",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// List Brand
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: FutureBuilder<List<GetBrandData>>(
                      future: _futureBrand,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final brands = snapshot.data!;
                          return Column(
                            children: brands.map((dataUser) {
                              return InkWell(
                                onTap: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Text("Edit Nama Brand"),
                                      content: TextFormField(
                                        controller: nameController
                                          ..text = dataUser.name ?? "",
                                        decoration: InputDecoration(
                                          labelText: "Nama Brand",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        OutlinedButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            // nameController.clear();
                                            await BrandAPI.updateBrand(
                                              name: nameController.text,
                                              id: dataUser.id ?? 0,
                                            );
                                            _refreshBrand();
                                            // setState(() {});
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Brand updated successfully",
                                                ),
                                              ),
                                            );
                                            // setState(() {});
                                          },
                                          child: const Text("Simpan"),
                                        ),
                                        OutlinedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Batal"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                onLongPress: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Text("Hapus Brand"),
                                      content: Text(
                                        "Apakah kamu yakin ingin menghapus '${dataUser.name}'?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Batal"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              await BrandAPI.deleteBrand(
                                                name: dataUser.name ?? "",
                                                id: dataUser.id ?? 0,
                                              );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Brand '${dataUser.name}' berhasil dihapus",
                                                  ),
                                                ),
                                              );

                                              _refreshBrand();
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Gagal hapus brand: $e",
                                                  ),
                                                ),
                                              );
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Hapus",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      if (dataUser.imageUrl != null &&
                                          dataUser.imageUrl!.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            dataUser.imageUrl!,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      else
                                        const Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                          color: Colors.black54,
                                        ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          dataUser.name ?? "",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        dataUser.id.toString() ?? "",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return const Text("Gagal Memuat Data Brand");
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Grid Admin Features
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Admin Other Features",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8A6BE4),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children: [
                            InkWell(
                              onTap: () {
                                context.push(CategoryTab());
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey.shade200,
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        "assets/images/4b547fcf2f6167531e136d9b37aa88dc.jpg",
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.black.withOpacity(0.4),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "Categories",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context.push(ProductListScreen());
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey.shade200,
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        "assets/images/market.jpg",
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.black.withOpacity(0.4),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "Products",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
