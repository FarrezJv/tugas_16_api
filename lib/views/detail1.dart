import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/keranjang.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/model/products/tampil_produk.dart';
import 'package:tugas_16_api/utils/rupiah.dart';
import 'package:tugas_16_api/views/halaman_keranjang.dart';

class ProductDetailPage extends StatefulWidget {
  final Detail product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = "M";
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final int discount = int.tryParse(p.discount ?? "0") ?? 0;
    final int priceInt = int.tryParse(p.price) ?? 0;
    final int finalPrice = discount > 0
        ? (priceInt * (100 - discount) ~/ 100)
        : priceInt;

    final int totalPrice = finalPrice * quantity;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 300,
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

                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.8),
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
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        context.push(CartPage2());
                      },
                    ),
                  ),
                ),

                if (discount > 0)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "-$discount%",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (discount > 0) ...[
                    Text(
                      formatRupiah(p.price),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      formatRupiah(finalPrice.toString()),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ] else
                    Text(
                      formatRupiah(p.price),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Text(
                        "Size",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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

                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    p.description,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Reviews",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text("View All", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Quantity",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                          ),
                          Text(
                            "$quantity",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Price",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        formatRupiah(totalPrice.toString()),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A6BE4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final result = await AuthenticationApiCart.addCart(
                            productId: widget.product.id,
                            quantity: quantity,
                          );

                          // await fetchCartCount();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result.message)),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Gagal menambahkan ke keranjang: $e",
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
