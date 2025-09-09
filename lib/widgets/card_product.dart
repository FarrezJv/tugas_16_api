import 'package:flutter/material.dart';
import 'package:tugas_16_api/model/products/tampil_produk.dart';

class ProductCard extends StatelessWidget {
  final Detail product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: product.imageUrls.isNotEmpty
                  ? Image.network(
                      product.imageUrls.first ?? "",
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 50),
                    )
                  : const Center(child: Icon(Icons.image, size: 50)),
            ),
          ),

          // Info produk
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Rp ${product.price}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Stok: ${product.stock}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  "${product.brand ?? "-"} • ${product.category ?? "-"}",
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),

          // Tombol aksi
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
