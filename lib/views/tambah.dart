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

  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  AddBrand? user;
  String? errorMessage;

  // ambil foto
  Future<void> pickFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedFile = image;
    });
  }

  // tambah brand (nama + foto)
  Future<void> tambahBrand() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama brand tidak boleh kosong")),
      );
      setState(() => isLoading = false);
      return;
    }

    if (pickedFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Foto brand belum dipilih")));
      setState(() => isLoading = false);
      return;
    }

    try {
      await BrandAPI.postFotoBrand(name: name, image: File(pickedFile!.path));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Tambah Brand berhasil")));

      nameController.clear();
      setState(() {
        pickedFile = null;
      });
    } catch (e) {
      setState(() => errorMessage = e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushReplacement(Adminproducts());
        },
        backgroundColor: const Color(0xFF8A6BE4),
        child: const Icon(Icons.inventory_2, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppImage.logo_png, width: 150),
                const Text(
                  "BrandNow Admin Feature.",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                /// Form Tambah Brand
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Add New Brand",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8A6BE4),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Nama Brand",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.store_mall_directory),
                          ),
                        ),
                        const SizedBox(height: 16),
                        pickedFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(pickedFile!.path),
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit
                                      .contain, // ✅ agar gambar tidak crop
                                ),
                              )
                            : Container(
                                height: 150,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text("Belum ada foto dipilih"),
                              ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: pickFoto,
                                icon: const Icon(Icons.image),
                                label: const Text("Pilih Foto"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLoading ? null : tambahBrand,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8A6BE4),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        "Tambah Brand",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// List Brand
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: FutureBuilder<List<GetBrandData>>(
                      future: BrandAPI.getBrand(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final brands = snapshot.data!;
                          return Column(
                            children: brands.map((dataUser) {
                              return InkWell(
                                onTap: () async {
                                  setState(() => isLoading = false);
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Text("Edit Nama Brand"),
                                      content: TextFormField(
                                        controller: nameController
                                          ..text = dataUser.name ?? "",
                                        decoration: InputDecoration(
                                          labelText: "Nama Brand",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        OutlinedButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();

                                            await BrandAPI.updateBrand(
                                              name: nameController.text,
                                              id: dataUser.id ?? 0,
                                            ).then((value) {});

                                            setState(() => isLoading = false);
                                          },
                                          child: isLoading
                                              ? const SizedBox(
                                                  height: 18,
                                                  width: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                )
                                              : const Text("Simpan"),
                                        ),
                                        OutlinedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Batal"),
                                        ),
                                      ],
                                    ),
                                  );
                                  setState(() {});
                                },
                                onLongPress: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Text("Hapus Brand"),
                                      content: Text(
                                        "Apakah kamu yakin ingin menghapus '${dataUser.name}'?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Batal"),
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
                                          child: const Text(
                                            "Hapus",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      if (dataUser.imageUrl != null &&
                                          dataUser.imageUrl!.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            dataUser.imageUrl!,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.contain, // ✅ tidak crop
                                          ),
                                        )
                                      else
                                        const Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                          color: Colors.black54,
                                        ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          dataUser.name ?? "",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return const Text("Gagal Memuat Data Brand");
                        }
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
