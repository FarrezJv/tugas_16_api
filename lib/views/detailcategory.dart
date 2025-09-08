import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/produk.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/model/products/tampil_produk.dart';
import 'package:tugas_16_api/utils/rupiah.dart';
import 'package:tugas_16_api/views/detail1.dart';

class ProductByCategoryPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ProductByCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductByCategoryPage> createState() => _ProductByCategoryPageState();
}

class _ProductByCategoryPageState extends State<ProductByCategoryPage> {
  List<Detail> allProducts = [];
  List<Detail> displayedProducts = [];
  List<String> brands = [];
  String selectedBrand = "All";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory();
  }

  Future<void> fetchProductsByCategory() async {
    try {
      final result = await AuthenticationApiProduct.getProduct();
      final products = result.data;

      //filter by category
      final filtered = products
          .where((p) => p.categoryId.toString() == widget.categoryId.toString())
          .toList();

      // ambil brand unik
      final uniqueBrands = filtered
          .map((p) => p.brand ?? "")
          .where((b) => b.isNotEmpty)
          .toSet()
          .toList();

      setState(() {
        allProducts = filtered;
        displayedProducts = List.from(allProducts);
        brands = ["All", ...uniqueBrands];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void applyBrandFilter(String brand) {
    setState(() {
      selectedBrand = brand;
      if (brand == "All") {
        displayedProducts = List.from(allProducts);
      } else {
        displayedProducts = allProducts
            .where((p) => (p.brand ?? "") == brand)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
            // color: AppColor.text,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Dropdown filter brand
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Text(
                        "Brand: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Montserrat",
                          // color: AppColor.text,
                        ),
                      ),
                      SizedBox(width: 8),
                      DropdownButton<String>(
                        value: selectedBrand,
                        items: brands
                            .map(
                              (b) => DropdownMenuItem(
                                value: b,
                                child: Text(
                                  b == "All" ? "All Brands" : b,
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    // color: AppColor.text,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) applyBrandFilter(value);
                        },
                      ),
                    ],
                  ),
                ),

                // Grid produk
                Expanded(
                  child: displayedProducts.isEmpty
                      ? Center(child: Text("No products found"))
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.60,
                              ),
                          itemCount: displayedProducts.length,
                          itemBuilder: (context, index) {
                            final p = displayedProducts[index];
                            final discount =
                                int.tryParse(p.discount ?? "0") ?? 0;
                            return GestureDetector(
                              onTap: () {
                                context.push(ProductDetailPage(product: p));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  // color: AppColor.neutral,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// product image + discount badge
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(12),
                                          ),
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: p.imageUrls.isNotEmpty
                                                ? Image.network(
                                                    p.imageUrls[0],
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    color: Colors.grey[300],
                                                    child: Icon(
                                                      Icons.image,
                                                      size: 50,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        if (discount > 0)
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              padding: EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                // color: AppColor.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                "-$discount%",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),

                                    /// product info
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /// name
                                          Text(
                                            p.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              // color: AppColor.text,
                                            ),
                                          ),
                                          SizedBox(height: 10),

                                          /// price + discount price
                                          if (discount > 0) ...[
                                            Text(
                                              formatRupiah(p.price),
                                              style: TextStyle(
                                                fontSize: 13,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                          Text(
                                            discount > 0
                                                ? formatRupiah(
                                                    (int.parse(p.price) *
                                                            (100 - discount) ~/
                                                            100)
                                                        .toString(),
                                                  )
                                                : formatRupiah(p.price),
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              // color: AppColor.primary,
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
                        ),
                ),
              ],
            ),
    );
  }
}
