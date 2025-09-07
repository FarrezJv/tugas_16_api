import 'package:flutter/material.dart';
import 'package:tugas_16_api/api/check_out.dart';
import 'package:tugas_16_api/api/keranjang.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/model/Check_out/checkout.dart';
import 'package:tugas_16_api/model/cart_model/get_cart_model.dart';
import 'package:tugas_16_api/shared_preference/shared.dart';
import 'package:tugas_16_api/utils/rupiah.dart';

class CartPage2 extends StatefulWidget {
  const CartPage2({super.key});

  @override
  State<CartPage2> createState() => _CartPage2State();
}

class _CartPage2State extends State<CartPage2> {
  List<GetCart> cartItems = [];
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      final result = await AuthenticationApiCart.getCart();
      setState(() {
        cartItems = result.data;
      });
    } catch (e) {
      print("Error get cart: $e");
    }
  }

  Future<void> doCheckout() async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("There are no items in your cart")),
      );
      return;
    }

    try {
      final userId = await PreferenceHandler.getUserId();

      final items = cartItems.map((item) {
        return Item(
          product: BuyNow(
            id: item.product.id,
            name: item.product.name,
            price: item.product.price,
          ),
          quantity: item.quantity.toString(),
        );
      }).toList();

      final total = totalPrice;

      final response = await AuthenticationApiCheckOut.addCheckout(
        userId: userId!,
        items: items,
        total: total,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Checkout failed: $e")));
    }
  }

  Future<void> deleteItem(int cartId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Product"),
          content: const Text(
            "Do you want to remove this item from your cart?",
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => context.pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await AuthenticationApiCart.deleteCart(CartId: cartId);
      setState(() {
        cartItems.removeWhere((item) => item.id == cartId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item removed successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to remove item: $e")));
    }
  }

  Future<void> deleteAllItems() async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Your cart is empty")));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete All"),
          content: const Text(
            "Are you sure you want to clear all items from your cart?",
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => context.pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                "Delete All",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      for (var item in List.from(cartItems)) {
        await AuthenticationApiCart.deleteCart(CartId: item.id);
      }
      if (!mounted) return;
      setState(() {
        cartItems.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All items were successfully removed")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Oops! Couldnt delete all items: $e")),
      );
    }
  }

  int get totalPrice {
    int sum = 0;
    for (var item in cartItems) {
      sum += getDiscountedPrice(item.product) * item.quantity;
    }
    return sum;
  }

  int getDiscountedPrice(Product product) {
    final int price = int.tryParse(product.price) ?? 0;
    final int discount = int.tryParse(product.discount) ?? 0;
    if (discount > 0) {
      return price - ((price * discount) ~/ 100);
    }
    return price;
  }

  void showCheckoutBottomSheet() {
    if (cartItems.isEmpty) return;

    final subtotal = totalPrice;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                "Confirmation of Checkout",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...cartItems.map((e) {
                final price = getDiscountedPrice(e.product);
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      e.product.imageUrls.isNotEmpty
                          ? e.product.imageUrls.first
                          : "https://via.placeholder.com/40",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(e.product.name),
                  subtitle: Text("x${e.quantity}"),
                  trailing: Text(
                    formatRupiah((price * e.quantity).toString()),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatRupiah(subtotal.toString()),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8A6BE4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async => await doCheckout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A6BE4),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6f8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "My Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => isEditMode = !isEditMode),
            child: Text(
              isEditMode ? "Done" : "Edit",
              style: const TextStyle(color: const Color(0xFF8A6BE4)),
            ),
          ),
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () => deleteAllItems(),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final priceAfterDiscount = getDiscountedPrice(item.product);

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item.product.imageUrls.isNotEmpty
                                ? item.product.imageUrls.first
                                : "https://via.placeholder.com/70",
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  if ((int.tryParse(item.product.discount) ??
                                          0) >
                                      0)
                                    Text(
                                      formatRupiah(item.product.price),
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  const SizedBox(width: 6),
                                  Text(
                                    formatRupiah(priceAfterDiscount.toString()),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: const Color(0xFF8A6BE4),
                                    ),
                                  ),
                                ],
                              ),
                              if (!isEditMode)
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (item.quantity > 1) {
                                          setState(() => item.quantity--);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      item.quantity.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() => item.quantity++);
                                      },
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: const Color(0xFF8A6BE4),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        if (isEditMode)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteItem(item.id),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -1),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        formatRupiah(totalPrice.toString()),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8A6BE4),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => showCheckoutBottomSheet(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A6BE4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
