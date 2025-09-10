import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/brand.dart';
import 'package:tugas_16_api/api/category.dart';
import 'package:tugas_16_api/api/produk.dart';
import 'package:tugas_16_api/model/products/tambah_produk.dart';
import 'package:tugas_16_api/model/products/tampil_produk.dart';
import 'package:tugas_16_api/utils/gambar.dart';
import 'package:tugas_16_api/widgets/card_product.dart';
import 'package:tugas_16_api/widgets/produk_edit.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Detail> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    try {
      final result = await AuthenticationApiProduct.getProduct();
      setState(() {
        _products = result.data;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat produk: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Ambil data kategori dan brand dari API
  Future<Map<String, List<Map<String, dynamic>>>>
  _fetchCategoryAndBrandLists() async {
    final kategoriData = await AuthenticationApiCat.getCategories();
    final brandData = await BrandAPI.getBrand();

    final kategoriList = kategoriData.data
        .map((k) => {'id': k.id, 'name': k.name})
        .toList();

    final brandList = brandData
        .map((b) => {'id': b.id, 'name': b.name})
        .toList();

    return {'kategori': kategoriList, 'brand': brandList};
  }

  /// Tambah produk
  Future<void> _showAddDialog() async {
    final data = await _fetchCategoryAndBrandLists();

    final result = await showProductFormDialog(
      context: context,
      id: null,
      initialData: null,
      kategoriList: data['kategori']!,
      brandList: data['brand']!,
    );

    if (result != null) _loadProducts();
  }

  /// Edit produk
  Future<void> _showEditDialog(Detail product) async {
    final data = await _fetchCategoryAndBrandLists();

    final initialData = GetProducts(
      id: product.id,
      name: product.name,
      description: product.description,
      price: int.tryParse(product.price) ?? 0,
      stock: int.tryParse(product.stock) ?? 0,
      discount: int.tryParse(product.discount) ?? 0,
      category: product.category ?? "",
      categoryId: int.tryParse(product.categoryId ?? "0") ?? 0,
      brand: product.brand ?? "",
      brandId: int.tryParse(product.brandId ?? "0") ?? 0,
      imageUrls: product.imageUrls ?? [],
      imagePaths: [], // kosongkan karena ini hanya untuk upload file baru
    );

    final result = await showProductFormDialog(
      context: context,
      id: product.id,
      initialData: initialData,
      kategoriList: data['kategori']!,
      brandList: data['brand']!,
    );

    if (result != null) _loadProducts();
  }

  Future<void> _deleteProduct(int id) async {
    try {
      await AuthenticationApiProduct.deleteProduct(productId: id);
      _loadProducts();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menghapus produk: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        // foregroundColor: Colors.deepPurple,
        // title: const Text(
        //   "📦 Daftar Produk",
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 20,
        //     color: Colors.white,
        //   ),
        // ),
        title: Image.asset(AppImage.logo_png, width: 150),
        actions: [
          IconButton(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add_circle_outline),
            color: const Color(0xFF8A6BE4),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: _loading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF8A6BE4)),
                  SizedBox(height: 12),
                  Text(
                    "Memuat produk...",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : _products.isEmpty
          ? const Center(
              child: Text(
                "📭 Belum ada produk yang tersedia.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ProductCard(
                      product: product,
                      onEdit: () => _showEditDialog(product),
                      onDelete: () => _deleteProduct(product.id),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
