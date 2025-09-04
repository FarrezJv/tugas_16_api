import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/brand.dart';
import 'package:tugas_16_api/api/produk.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/model/get_brand.dart';
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
  @override
  void initState() {
    super.initState();
    // futureBrand = BrandAPI.getBrand();
    futureProduct = AuthenticationApiProduct.getProduct();
  }

  late Future<GetProdukModel> futureProduct;
  final TextEditingController nameController = TextEditingController();
  GetBrand? userData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppImage.logo_png, width: 150),
                Text(
                  "Welcome to BrandNow.",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
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
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8A6BE4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.mic, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: FutureBuilder<List<GetBrandData>>(
                        future: BrandAPI.getBrand(),
                        builder:
                            (
                              BuildContext context,
                              AsyncSnapshot<List<GetBrandData>> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 4,
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final brands = snapshot.data!;
                                return SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: brands.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final dataUser = brands[index];
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                right: 10,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(30),
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
                                                  if (dataUser.imageUrl !=
                                                          null &&
                                                      dataUser
                                                          .imageUrl!
                                                          .isNotEmpty)
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      child: Image.network(
                                                        dataUser.imageUrl!,
                                                        height: 24,
                                                        width: 24,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  else
                                                    Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.black,
                                                      size: 24,
                                                    ),

                                                  SizedBox(width: 8),

                                                  Text(
                                                    dataUser.name ?? "",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const Text("Gagal Memuat data");
                              }
                            },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                SizedBox(height: 20),
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

                    final products = snapshot.data!.data;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.65,
                          ),
                      itemBuilder: (context, index) {
                        final p = products[index];
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

                // GridView.builder(
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   itemCount: products.length,
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     childAspectRatio: 0.65,
                //     crossAxisSpacing: 12,
                //     mainAxisSpacing: 12,
                //   ),
                //   itemBuilder: (context, index) {
                //     final product = products[index];
                //     return Container(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(12),
                //         color: Colors.grey.shade100,
                //       ),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Expanded(
                //             child: Stack(
                //               children: [
                //                 ClipRRect(
                //                   borderRadius: BorderRadius.vertical(
                //                     top: Radius.circular(12),
                //                   ),
                //                   child: Image.network(
                //                     product["image"]!,
                //                     fit: BoxFit.cover,
                //                     width: double.infinity,
                //                   ),
                //                 ),
                //                 Positioned(
                //                   top: 8,
                //                   right: 8,
                //                   child: Icon(
                //                     Icons.favorite_border,
                //                     color: Colors.grey,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           Padding(
                //             padding: EdgeInsets.all(8.0),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                   product["name"]!,
                //                   maxLines: 2,
                //                   overflow: TextOverflow.ellipsis,
                //                   style: TextStyle(fontWeight: FontWeight.w500),
                //                 ),
                //                 SizedBox(height: 4),
                //                 Text(
                //                   product["price"]!,
                //                   style: TextStyle(fontWeight: FontWeight.bold),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
