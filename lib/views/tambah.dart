import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_16_api/api/brand.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/model/brand_user_model.dart';
import 'package:tugas_16_api/model/get_brand.dart';
import 'package:tugas_16_api/utils/gambar.dart';
import 'package:tugas_16_api/views/adminproducts.dart';

class TambahBrand extends StatefulWidget {
  const TambahBrand({super.key});

  @override
  State<TambahBrand> createState() => _TambahBrandState();
}

class _TambahBrandState extends State<TambahBrand> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;
  pickFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print(image);
    print(image?.path);
    setState(() {
      pickedFile = image;
    });
    if (image == null) {
      return;
    } else {
      final response = await BrandAPI.postFotoBrand(
        name: "ACAK",
        image: File(image.path),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Berhasil upload gambar")));
    }
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushReplacement(Adminproducts());
        },
        backgroundColor: Color(0xFF8A6BE4),

        child: Icon(Icons.inventory_2, color: Colors.white),
      ),
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
                                        setState(() => isLoading = false);
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
                                                  // setState(
                                                  //   () => isLoading = true,
                                                  // );
                                                  Navigator.of(context).pop();

                                                  await BrandAPI.updateBrand(
                                                    name: nameController.text,
                                                    id: dataUser.id ?? 0,
                                                  ).then((value) {});

                                                  setState(
                                                    () => isLoading = false,
                                                  );
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
                                      onLongPress: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            title: Text("Hapus Brand"),
                                            content: Text(
                                              "Apakah kamu yakin ingin menghapus '${dataUser.name}'?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("Batal"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  try {
                                                    await BrandAPI.deleteBrand(
                                                      name: dataUser.name ?? "",
                                                      id: dataUser.id ?? 0,
                                                    );
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "Brand '${dataUser.name}' berhasil dihapus",
                                                        ),
                                                      ),
                                                    );
                                                    setState(() {});
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "Gagal hapus brand: $e",
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  "Hapus",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    pickedFile != null
                        ? Image.file(File(pickedFile?.path ?? ""))
                        : Container(
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            height: 200,
                            width: 200,

                            child: Text("Gambar belum di upload"),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: pickFoto,
                          child: Text("Ambil Foto"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
