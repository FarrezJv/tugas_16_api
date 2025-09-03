import 'package:flutter/material.dart';
import 'package:tugas_16_api/model/products/tampil_produk.dart';
import 'package:tugas_16_api/utils/rupiah.dart';

class ProductDetailPage extends StatefulWidget {
  final Detail product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = "M";

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian gambar + tombol back & cart
            Stack(
              children: [
                SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: PageView(
                    children: p.imageUrls.isNotEmpty
                        ? p.imageUrls.map((url) {
                            return Image.network(url, fit: BoxFit.cover);
                          }).toList()
                        : [
                            Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, size: 80),
                            ),
                          ],
                  ),
                ),
                // Tombol overlay di atas gambar
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.7),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.7),
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // aksi ke cart
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Bagian detail
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        formatRupiah(p.price),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Size
                  Row(
                    children: [
                      const Text(
                        "Size",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Size Guide"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: ["S", "M", "L", "XL", "2XL"].map((size) {
                      final isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 18,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF8A6BE4)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    p.description,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),

                  // Reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Reviews",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("View All", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Price"),
                Text(
                  formatRupiah(p.price),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A6BE4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Add to Cart",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
