// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tugas_16_api/api/produk.dart';
// import 'package:tugas_16_api/extension/navigation.dart';
// import 'package:tugas_16_api/model/products/tambah_produk.dart';
// import 'package:tugas_16_api/utils/gambar.dart';
// import 'package:tugas_16_api/views/adminproducts.dart'; // kalau kamu pakai asset logo disini

// class AdminProduct extends StatefulWidget {
//   const AdminProduct({super.key});

//   @override
//   State<AdminProduct> createState() => _AdminProductState();
// }

// class _AdminProductState extends State<AdminProduct> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController brandIdController = TextEditingController();
//   final TextEditingController categoryIdController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController stockController = TextEditingController();
//   final TextEditingController discountController = TextEditingController();

//   bool isLoading = false;
//   AddProdukModel? product;
//   String? errorMessage;
//   final ImagePicker _picker = ImagePicker();
//   XFile? pickedFile;
//   pickFoto() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     print(image);
//     print(image?.path);
//     setState(() {
//       pickedFile = image;
//     });
//     // if (image == null) {
//     //   return;
//     // } else {
//     //   final response = await AuthenticationApiProduct.postFotoProduct(
//     //     name: "ACAK",
//     //     image: File(image.path),
//     //   );
//     //   ScaffoldMessenger.of(
//     //     context,
//     //   ).showSnackBar(const SnackBar(content: Text("Berhasil upload gambar")));
//     // }
//   }

//   Future<void> addProduct() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     final name = nameController.text.trim();
//     final description = descriptionController.text.trim();
//     final brandId = int.tryParse(brandIdController.text) ?? 0;
//     final categoryId = int.tryParse(categoryIdController.text) ?? 0;
//     final price = int.tryParse(priceController.text) ?? 0;
//     final stock = int.tryParse(stockController.text) ?? 0;
//     final discount = int.tryParse(discountController.text) ?? 0;

//     if (name.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Product name cannot be empty")),
//       );
//       setState(() => isLoading = false);
//       return;
//     }

//     try {
//       final result = await AuthenticationApiProduct.addProduct(
//         name: name,
//         description: description,
//         brandId: brandId,
//         categoryId: categoryId,
//         price: price,
//         stock: stock,
//         discount: discount,
//         images: pickedFile != null ? File(pickedFile!.path) : File(''),
//         // images: pickedFile != null ? [pickedFile!.path] : [],
//       );
//       setState(() {
//         product = result;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Product added successfully")),
//       );
//       print(product?.toJson());
//     } catch (e) {
//       setState(() {
//         errorMessage = e.toString();
//       });
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(errorMessage.toString())));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType keyboardType = TextInputType.text,
//     IconData? icon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: icon != null ? Icon(icon) : null,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//          floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           context.pushReplacement(Adminproducts());
//         },
//         backgroundColor: const Color(0xFF8A6BE4),
//         child: const Icon(Icons.inventory_2, color: Colors.white),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Logo di atas
//               Image.asset(AppImage.logo_png, width: 150),
//               const Text(
//                 "Admin Product Feature.",
//                 style: TextStyle(color: Colors.grey),
//               ),
//               const SizedBox(height: 20),

//               Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       const Text(
//                         "Add New Product",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF8A6BE4),
//                         ),
//                       ),
//                       const SizedBox(height: 16),

//                       /// Preview Foto
//                       pickedFile != null
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: Image.file(
//                                 File(pickedFile!.path),
//                                 height: 150,
//                                 width: double.infinity,
//                                 fit: BoxFit.contain,
//                               ),
//                             )
//                           : Container(
//                               height: 150,
//                               width: double.infinity,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade200,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Text("No photo selected"),
//                             ),
//                       const SizedBox(height: 16),

//                       OutlinedButton.icon(
//                         onPressed: pickFoto,
//                         icon: const Icon(Icons.image),
//                         label: const Text("Select Photo"),
//                       ),
//                       const SizedBox(height: 16),

//                       /// Form Input
//                       _buildTextField(
//                         controller: nameController,
//                         label: "Product Name",
//                         icon: Icons.shopping_bag,
//                       ),
//                       _buildTextField(
//                         controller: descriptionController,
//                         label: "Description",
//                         icon: Icons.description,
//                       ),
//                       _buildTextField(
//                         controller: brandIdController,
//                         label: "Brand ID",
//                         keyboardType: TextInputType.number,
//                         icon: Icons.store,
//                       ),
//                       _buildTextField(
//                         controller: categoryIdController,
//                         label: "Category ID",
//                         keyboardType: TextInputType.number,
//                         icon: Icons.category,
//                       ),
//                       _buildTextField(
//                         controller: priceController,
//                         label: "Price",
//                         keyboardType: TextInputType.number,
//                         icon: Icons.attach_money,
//                       ),
//                       _buildTextField(
//                         controller: stockController,
//                         label: "Stock",
//                         keyboardType: TextInputType.number,
//                         icon: Icons.inventory,
//                       ),
//                       _buildTextField(
//                         controller: discountController,
//                         label: "Discount (%)",
//                         keyboardType: TextInputType.number,
//                         icon: Icons.percent,
//                       ),

//                       const SizedBox(height: 20),

//                       /// Submit Button
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: isLoading ? null : addProduct,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF8A6BE4),
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 2,
//                                 )
//                               : const Text(
//                                   "Add Product",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
