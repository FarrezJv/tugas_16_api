import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:tugas_16_api/api/reviews.dart';
import 'package:tugas_16_api/model/history/history.dart';

class ReviewPage extends StatefulWidget {
  final Goods item;
  final int transactionId;

  const ReviewPage({
    super.key,
    required this.item,
    required this.transactionId,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _rating = 0;
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  Future<void> _submitReview() async {
    if (_rating == 0 || _controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon isi rating dan komentar")),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final response = await AuthenticationApiReviews.addReviews(
        productId: widget.item.product.id,
        transactionId: widget.transactionId,
        rating: _rating.toInt(),
        review: _controller.text,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.item.product;

    return Scaffold(
      appBar: AppBar(
        title: Text("Review ${product.name}"),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Beri Rating:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                StarRating(
                  rating: _rating,
                  onRatingChanged: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                  color: Colors.amber,
                  starCount: 5,
                  size: 32,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Tulis Ulasan:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Bagikan pengalamanmu...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submitReview,
                          icon: const Icon(Icons.send),
                          label: const Text("Kirim"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
