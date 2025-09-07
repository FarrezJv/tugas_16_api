import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/category.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/model/category/get_categories.dart';
import 'package:tugas_16_api/shared_preference/shared.dart';
import 'package:tugas_16_api/utils/gambar.dart';
import 'package:tugas_16_api/views/detailcategory.dart';
import 'package:tugas_16_api/views/halaman.dart';

class AdminCategory extends StatefulWidget {
  const AdminCategory({super.key});

  @override
  State<AdminCategory> createState() => _AdminCategoryState();
}

class _AdminCategoryState extends State<AdminCategory> {
  late Future<GetCatModel> futureCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = AuthenticationApiCat.getCategories();
  }

  Future<void> _refreshCategories() async {
    setState(() {
      futureCategory = AuthenticationApiCat.getCategories();
    });
  }

  Future<void> _deleteCategory(int id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Kategori"),
        content: Text("Yakin mau hapus kategori $name?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await AuthenticationApiCat.deleteCategory(id: id, name: name);

        _refreshCategories();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kategori $name berhasil dihapus")),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal hapus kategori: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // logo
                Image.asset(AppImage.logo_png, width: 150),

                const SizedBox(height: 8),
                const Text(
                  "Category Section.",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: FutureBuilder<GetCatModel>(
                      future: futureCategory,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData ||
                            snapshot.data!.data.isEmpty) {
                          return const Text("No Categories found");
                        }

                        final categories = snapshot.data!.data;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: categories.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // tampil 2 kolom
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1,
                              ),
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            return GestureDetector(
                              onTap: () {
                                context.push(
                                  ProductByCategoryPage(
                                    categoryId: cat.id,
                                    categoryName: cat.name,
                                  ),
                                );
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
                                child: Stack(
                                  children: [
                                    // isi kategori
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.category,
                                            size: 40,
                                            color: Color(0xFF8A6BE4),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            cat.name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // tombol delete
                                    // Positioned(
                                    //   top: 8,
                                    //   right: 8,
                                    //   child: CircleAvatar(
                                    //     backgroundColor: Colors.white,
                                    //     radius: 16,
                                    //     child: IconButton(
                                    //       padding: EdgeInsets.zero,
                                    //       icon: const Icon(
                                    //         Icons.delete,
                                    //         size: 18,
                                    //         color: Colors.red,
                                    //       ),
                                    //       onPressed: () =>
                                    //           _deleteCategory(cat.id, cat.name),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
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
