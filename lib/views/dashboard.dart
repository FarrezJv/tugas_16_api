import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/brand.dart';
import 'package:tugas_16_api/api/category.dart';
import 'package:tugas_16_api/api/produk.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/model/brand/get_brand.dart';
import 'package:tugas_16_api/model/category/get_categories.dart';
import 'package:tugas_16_api/model/products/tampil_produk.dart';
import 'package:tugas_16_api/utils/gambar.dart';
import 'package:tugas_16_api/utils/rupiah.dart';
import 'package:tugas_16_api/views/detail1.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<GetCatModel> futureCategory;
  late Future<GetProdukModel> futureProduct;
  final TextEditingController searchController = TextEditingController();

  List<Detail> allProducts = []; // semua produk
  List<Detail> filteredProducts = []; // hasil filter

  @override
  void initState() {
    super.initState();
    futureProduct = AuthenticationApiProduct.getProduct();
    futureCategory = AuthenticationApiCat.getCategories();

    // dengarkan perubahan search
    searchController.addListener(() {
      filterProducts();
    });
  }

  void filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts
            .where((p) => p.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                  "Welcome to BrandNow.",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // 🔍 Search
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: "Search...",
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8A6BE4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.mic, color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔹 Brand Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Choose Brand",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text("View All", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),

                FutureBuilder<List<GetBrandData>>(
                  future: BrandAPI.getBrand(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Text("Gagal Memuat Brand");
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("No Brand found");
                    }

                    final brands = snapshot.data!;
                    return SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: brands.length,
                        itemBuilder: (context, index) {
                          final b = brands[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (b.imageUrl != null &&
                                    b.imageUrl!.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      b.imageUrl!,
                                      height: 24,
                                      width: 24,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.image_not_supported,
                                    size: 24,
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  b.name ?? "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // 🔹 Produk Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "New Arrival",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text("View All", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 20),

                FutureBuilder<GetProdukModel>(
                  future: futureProduct,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (!snapshot.hasData ||
                        snapshot.data!.data.isEmpty) {
                      return const Text("No Products found");
                    }

                    // simpan semua produk sekali saja
                    if (allProducts.isEmpty) {
                      allProducts = snapshot.data!.data;
                      filteredProducts = allProducts;
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.65,
                          ),
                      itemBuilder: (context, index) {
                        final p = filteredProducts[index];
                        return GestureDetector(
                          onTap: () {
                            context.push(ProductDetailPage(product: p));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // gambar produk
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: p.imageUrls.isNotEmpty
                                          ? Image.network(
                                              p.imageUrls[0],
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              height: 150,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image,
                                                size: 50,
                                              ),
                                            ),
                                    ),
                                    if (p.discount.isNotEmpty)
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            "-${p.discount}%",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                // detail produk
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (p.discount.isNotEmpty) ...[
                                        Text(
                                          formatRupiah(p.price),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        Text(
                                          formatRupiah(
                                            (int.parse(p.price) *
                                                    (100 -
                                                        int.parse(
                                                          p.discount,
                                                        )) ~/
                                                    100)
                                                .toString(),
                                          ),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ] else
                                        Text(
                                          formatRupiah(p.price),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
