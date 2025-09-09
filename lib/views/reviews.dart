import 'package:flutter/material.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/shared_preference/shared.dart';
import 'package:tugas_16_api/views/halaman.dart';
import 'package:tugas_16_api/views/review_tab.dart';
import 'package:tugas_16_api/widgets/tab.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Rating",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: tabController,
          labelColor: const Color(0xFF8A6BE4),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF8A6BE4),
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: "To Rate"),
            Tab(text: "My Reviews"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Bagian Tab
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                ToRateTab(
                  onReviewed: (goods) {
                    setState(() {});
                  },
                ),
                const MyReviewsTab(),
              ],
            ),
          ),

          // Tombol Logout
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A6BE4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  PreferenceHandler.removeUserId();
                  PreferenceHandler.removeToken();
                  PreferenceHandler.removeLogin();
                  context.pushReplacement(HalamanMulai());
                },
                child: const Text(
                  "LOG OUT",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
