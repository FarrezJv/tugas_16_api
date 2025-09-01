import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/brand.dart';
import 'package:tugas_16_api/model/brand_user_model.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama Brand tidak boleh kosong")),
      );
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

      // PreferenceHandler.saveToken(user?.data.name.toString() ?? "");
      print(user?.toJson());
    } catch (e) {
      print(e);
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
      appBar: AppBar(
        // title: Text("Tambah Brand"),
        // backgroundColor: Colors.deepPurple,
        // centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [Colors.deepPurple, Colors.blueAccent],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Masukkan Nama Brand",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
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
                      onPressed: isLoading ? null : tambahBrand,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Tambah Brand",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
