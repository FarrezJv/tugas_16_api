import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/brand.dart';
import 'package:tugas_16_api/model/brand_user_model.dart';
import 'package:tugas_16_api/model/get_brand.dart';
import 'package:tugas_16_api/utils/gambar.dart';

class TambahBrand extends StatefulWidget {
  const TambahBrand({super.key});

  @override
  State<TambahBrand> createState() => _TambahBrandState();
}

class _TambahBrandState extends State<TambahBrand> {
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  AddBrand? user;
  String? errorMessage;

  void tambahBrand() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("empty brand name")));
      setState(() => isLoading = false);
      return;
    }

    try {
      final result = await BrandAPI.tambahBrand(name: name);
      setState(() {
        user = result;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Tambah Brand berhasil")));
      print(user?.toJson());
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppImage.logo_png, width: 150),
                Text(
                  "BrandNow Admin Feature.",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: FutureBuilder<List<GetBrandData>>(
                      future: BrandAPI.getBrand(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final brands = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "list of brands",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8A6BE4),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              SizedBox(
                                height: 60,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: brands.length,
                                  itemBuilder: (context, index) {
                                    final dataUser = brands[index];
                                    return InkWell(
                                      onTap: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            title: Text("Edit Nama Brand"),
                                            content: TextFormField(
                                              controller: nameController
                                                ..text = dataUser.name ?? "",
                                              decoration: InputDecoration(
                                                labelText: "Nama Brand",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              OutlinedButton(
                                                // style: ElevatedButton.styleFrom(
                                                //   backgroundColor:
                                                //       Colors.deepPurple,
                                                // ),
                                                onPressed: () async {
                                                  setState(
                                                    () => isLoading = true,
                                                  );
                                                  await BrandAPI.updateBrand(
                                                    name: nameController.text,
                                                    id: dataUser.id ?? 0,
                                                  );
                                                  setState(
                                                    () => isLoading = false,
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                child: isLoading
                                                    ? SizedBox(
                                                        height: 18,
                                                        width: 18,
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      )
                                                    : Text("Simpan"),
                                              ),
                                              OutlinedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("Batal"),
                                              ),
                                            ],
                                          ),
                                        );
                                        setState(() {});
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
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
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (dataUser.imageUrl != null &&
                                                dataUser.imageUrl!.isNotEmpty)
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.network(
                                                  dataUser.imageUrl!,
                                                  height: 24,
                                                  width: 24,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            else
                                              Icon(
                                                Icons.image_not_supported,
                                                color: Colors.black,
                                                size: 24,
                                              ),

                                            SizedBox(width: 8),

                                            Text(
                                              dataUser.name ?? "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onLongPress: () {},
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text("Gagal Memuat Data Brand");
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "add new brands",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8A6BE4),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Nama Brand",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.store_mall_directory),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              tambahBrand();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8A6BE4),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: Icon(Icons.add, color: Colors.white),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Tambah Brand",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
