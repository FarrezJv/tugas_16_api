import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/history_api.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/model/history/history.dart';
import 'package:tugas_16_api/views/reviews/reviews_page.dart';

class ToRateTab extends StatefulWidget {
  final Function(Goods) onReviewed;
  const ToRateTab({super.key, required this.onReviewed});

  @override
  State<ToRateTab> createState() => _ToRateTabState();
}

class _ToRateTabState extends State<ToRateTab> {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load history: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    final toRate = _transactions
        .expand(
          (kultum) => kultum.items.map(
            (item) => {"item": item, "transactionId": kultum.id},
          ),
        )
        .where((map) => !(map["item"] as Goods).hasReviewed)
        .toList();

    if (toRate.isEmpty) {
      return Center(child: Text("You don’t have any products to review."));
    }

    return ListView.builder(
      itemCount: toRate.length,
      itemBuilder: (BuildContext context, int index) {
        final goods = toRate[index]["item"] as Goods;
        final transactionId = toRate[index]["transactionId"] as int;

        return Card(
          // color: AppColor.neutral,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(goods.product.name),
            subtitle: Text(
              "Qty: ${goods.quantity} | Harga: ${goods.product.price}",
            ),
            trailing: ElevatedButton(
              onPressed: () async {
                final result = await context.push(
                  ReviewPage(item: goods, transactionId: transactionId),
                );

                if (result == true) {
                  widget.onReviewed(goods);
                  setState(() {
                    goods.hasReviewed = true;
                  });
                }
              },

              child: Text("Review"),
            ),
          ),
        );
      },
    );
  }
}
