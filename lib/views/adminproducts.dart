// import 'package:flutter/material.dart';
// import 'package:tugas_16_api/api/brand.dart';
// import 'package:tugas_16_api/api/category.dart';
// import 'package:tugas_16_api/api/produk.dart';
// import 'package:tugas_16_api/model/products/tambah_produk.dart';
// import 'package:tugas_16_api/model/products/tampil_produk.dart';
// import 'package:tugas_16_api/widgets/product_desain.dart';
// import 'package:tugas_16_api/widgets/produk_edit.dart';

// class Adminproducts extends StatefulWidget {
//   const Adminproducts({super.key});

//   @override
//   State<Adminproducts> createState() => _AdminproductsState();
// }

// class _AdminproductsState extends State<Adminproducts> {
//   List<Detail> _products = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//   }

//   Future<void> _loadProducts() async {
//     setState(() => _loading = true);
//     try {
//       final result = await AuthenticationApiProduct.getProduct();
//       setState(() {
//         _products = result.data;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Gagal memuat produk: $e")));
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   /// Ambil data kategori dan brand dari API
//   Future<Map<String, List<Map<String, dynamic>>>>
//   _fetchCategoryAndBrandLists() async {
//     final kategoriData = await AuthenticationApiCat.getCategories();
//     final brandData = await BrandAPI.getBrand();

//     final kategoriList = kategoriData.data
//         .map((k) => {'id': k.id, 'name': k.name})
//         .toList();

//     final brandList = brandData.data
//         .map((b) => {'id': b.id, 'name': b.name})
//         .toList();

//     return {'kategori': kategoriList, 'brand': brandList};
//   }

//   /// Tambah produk
//   Future<void> _showAddDialog() async {
//     final data = await _fetchCategoryAndBrandLists();

//     final result = await showProductFormDialog(
//       context: context,
//       id: null,
//       initialData: null,
//       kategoriList: data['kategori']!,
//       brandList: data['brand']!,
//     );

//     if (result != null) _loadProducts();
//   }

//   /// Edit produk
//   Future<void> _showEditDialog(Detail product) async {
//     final data = await _fetchCategoryAndBrandLists();

//     final initialData = GetProducts(
//       id: product.id,
//       name: product.name,
//       description: product.description,
//       price: int.tryParse(product.price) ?? 0,
//       stock: int.tryParse(product.stock) ?? 0,
//       discount: int.tryParse(product.discount) ?? 0,
//       category: product.category ?? "",
//       categoryId: int.tryParse(product.categoryId ?? "0") ?? 0,
//       brand: product.brand ?? "",
//       brandId: int.tryParse(product.brandId ?? "0") ?? 0,
//       imageUrls: product.imageUrls ?? [],
//       imagePaths: [], // kosongkan karena ini hanya untuk upload file baru
//     );

//     final result = await showProductFormDialog(
//       context: context,
//       id: product.id,
//       initialData: initialData,
//       kategoriList: data['kategori']!,
//       brandList: data['brand']!,
//     );

//     if (result != null) _loadProducts();
//   }

//   Future<void> _deleteProduct(int id) async {
//     try {
//       await AuthenticationApiProduct.deleteProduct(productId: id);
//       _loadProducts();
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Gagal menghapus produk: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Daftar Produk"),
//         actions: [IconButton(onPressed: _showAddDialog, icon: Icon(Icons.add))],
//       ),
//       body: _loading
//           ? Center(child: CircularProgressIndicator())
//           : _products.isEmpty
//           ? Center(child: Text("Belum ada produk"))
//           : GridView.builder(
//               padding: EdgeInsets.all(12),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.75,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: _products.length,
//               itemBuilder: (context, index) {
//                 final product = _products[index];
//                 return ProductDesign(
//                   product: product,
//                   onEdit: () => _showEditDialog(product),
//                   onDelete: () => _deleteProduct(product.id),
//                 );
//               },
//             ),
//     );
//   }
// }
