import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/brand.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/model/brand_user_model.dart';
import 'package:tugas_16_api/views/tambah.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController nameController = TextEditingController();
  AddBrand? userData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Text("Welcome to Laza.", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search...",
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.mic, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Choose Brand",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text("View All", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: FutureBuilder<List<AddBrandData>>(
                        future: BrandAPI.getBrand(),
                        builder:
                            (
                              BuildContext context,
                              AsyncSnapshot<List<AddBrandData>> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasData) {
                                final brands = snapshot.data!;

                                // final filteredUsers = users.where((user) {
                                //   final name = user.fullName.toLowerCase() ?? "";
                                //   // return name.contains(_searchQuery);
                                // }).toList();

                                // if (filteredUsers.isEmpty) {
                                //   return const Text("Karakter tidak ditemukan.");
                                // }

                                return SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: brands.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final dataUser = brands[index];
                                      return GestureDetector(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent.shade100,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              dataUser.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          final dialog =
                                              await showDialog(
                                                context: context,
                                                builder: (context) => StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                      title: Text("Edit Data"),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextFormField(
                                                            controller:
                                                                nameController
                                                                  ..text =
                                                                      userData
                                                                          ?.data
                                                                          .name ??
                                                                      '-',
                                                            // decoration: InputDecoration(
                                                            //   hintText: "Pertanyaan",
                                                            // ),
                                                          ),
                                                          SizedBox(height: 12),
                                                        ],
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            setState(() {
                                                              isLoading = true;
                                                            });
                                                            // await BrandAPI.updateBrand(
                                                            //   name:
                                                            //       nameController
                                                            //           .text,
                                                            // ); ERORRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: isLoading
                                                              ? CircularProgressIndicator()
                                                              : Text("OK"),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                              ),
                                                          child: Text("Back"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ).then((value) async {
                                                final data =
                                                    await BrandAPI.getBrand();
                                                setState(() {
                                                  // userData = data; ERORRRRRRRR
                                                  isLoading = false;
                                                });
                                              });
                                        },
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const Text("Gagal Memuat data");
                              }
                            },
                      ),
                    ),
                    SizedBox(width: 5),

                    SizedBox(
                      width: 50,
                      child: Expanded(
                        child: Container(
                          width: 20,
                          color: Color.fromARGB(255, 235, 235, 235),
                          height: 50,
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              context.push(TambahBrand());
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Arrival",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text("View All", style: TextStyle(color: Colors.grey)),
                  ],
                ),

                // GridView.builder(
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   itemCount: products.length,
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     childAspectRatio: 0.65,
                //     crossAxisSpacing: 12,
                //     mainAxisSpacing: 12,
                //   ),
                //   itemBuilder: (context, index) {
                //     final product = products[index];
                //     return Container(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(12),
                //         color: Colors.grey.shade100,
                //       ),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Expanded(
                //             child: Stack(
                //               children: [
                //                 ClipRRect(
                //                   borderRadius: BorderRadius.vertical(
                //                     top: Radius.circular(12),
                //                   ),
                //                   child: Image.network(
                //                     product["image"]!,
                //                     fit: BoxFit.cover,
                //                     width: double.infinity,
                //                   ),
                //                 ),
                //                 Positioned(
                //                   top: 8,
                //                   right: 8,
                //                   child: Icon(
                //                     Icons.favorite_border,
                //                     color: Colors.grey,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           Padding(
                //             padding: EdgeInsets.all(8.0),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                   product["name"]!,
                //                   maxLines: 2,
                //                   overflow: TextOverflow.ellipsis,
                //                   style: TextStyle(fontWeight: FontWeight.w500),
                //                 ),
                //                 SizedBox(height: 4),
                //                 Text(
                //                   product["price"]!,
                //                   style: TextStyle(fontWeight: FontWeight.bold),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
