import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/history_api.dart';
import 'package:tugas_16_api/model/history/history.dart';

class MyReviewsTab extends StatefulWidget {
  const MyReviewsTab({super.key});

  @override
  State<MyReviewsTab> createState() => _MyReviewsTabState();
}

class _MyReviewsTabState extends State<MyReviewsTab> {
  bool _loading = true;
  List<Kultum> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await AuthenticationApiHistory.getHistory();
      if (!mounted) return;
      setState(() {
        _transactions = history.data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load history: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final reviewed = _transactions
        .expand(
          (kultum) => kultum.items.map(
            (item) => {"item": item, "transactionId": kultum.id},
          ),
        )
        .where((map) => (map["item"] as Goods).hasReviewed)
        .toList();

    if (reviewed.isEmpty) {
      return const Center(
        child: Text(
          "You haven’t reviewed any products yet.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: reviewed.length,
      itemBuilder: (BuildContext context, int index) {
        final goods = reviewed[index]["item"] as Goods;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.star, color: Color(0xFF8A6BE4), size: 32),
            title: Text(
              goods.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Qty: ${goods.quantity} | Harga: Rp${goods.product.price}",
              style: const TextStyle(color: Colors.black54),
            ),
            trailing: const Text(
              "Reviewed",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
