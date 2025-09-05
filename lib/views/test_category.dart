import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/category.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/model/category/get_categories.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key});

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  late Future<GetCatModel> futureCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = AuthenticationApiCat.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.background,
      body: FutureBuilder<GetCatModel>(
        future: futureCategory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(child: Text("No Categories found"));
          }

          final categories = snapshot.data!.data;

          return ListView.separated(
            padding: EdgeInsets.all(16),
            separatorBuilder: (context, index) => SizedBox(height: 11),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              // final assetPath = getCategoryAsset(cat.name ?? "");
              Text(cat.name ?? "");
              return GestureDetector(
                onTap: () {
                  // context.push(
                  //   ProductByCategoryPage(
                  //     categoryId: cat.id,
                  //     categoryName: cat.name,
                  //   ),
                  // );
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    // image: DecorationImage(
                    //   image: AssetImage(assetPath),
                    //   fit: BoxFit.cover,
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.4),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      cat.name,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        // color: AppColor.neutral,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
