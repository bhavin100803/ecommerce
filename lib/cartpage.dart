import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cartprovider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.black,
           leading: Container(
             margin: const EdgeInsets.only(left: 12), // spacing from edge or other icons
             decoration: BoxDecoration(
               color: Colors.white, // background color
               shape: BoxShape.circle, // use BoxShape.circle for perfect circular background
             ),
             child: IconButton(
               icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black,size: 20,),
               onPressed: () {
                 Navigator.pop(context);
               },
             ),
           ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(top: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: Colors.grey.shade50, // set your desired background color
                            height: 80,
                            width: 80,
                            child: Image.network(
                              item.product['image'],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              item.product['category'],
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "\$${item.product['price']}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => cart.removeFromCart(item.product),
                            icon: const Icon(Icons.delete_outline_outlined, color: Colors.deepOrange),
                          ),
                          Container(

                            // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                      child: Icon(Icons.remove,size: 15,),onTap: (){
                                    cart.decreaseQuantity(item.product);
                                  },),
                                  SizedBox(width: 10,),
                                  // IconButton(
                                  //   icon: const Icon(Icons.remove, size: 15),
                                  //   onPressed: () => cart.decreaseQuantity(item.product),
                                  // ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 10,),
                                  GestureDetector(
                                    child: Icon(Icons.add, size: 20,),onTap: (){
                                    cart.increaseQuantity(item.product);
                                  },),
                                  // IconButton(
                                  //   icon: const Icon(Icons.add, size: 15),
                                  //   onPressed: () => cart.increaseQuantity(item.product),
                                  // ),
                                ],
                              ),
                            ),
                            height: 30,
                            width: 90,
                          ),

                        ],
                      ),
                    ],
                  ),
                );

              },
            ),
          ),

          // Summary + Checkout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Discount Code",
                          hintStyle: TextStyle(
                            color: Colors.grey,       // Customize the hint text color
                            fontSize: 14,                  // Customize font size
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          suffixIcon: TextButton(
                            onPressed: () {
                            },
                            child: const Text(
                              "Apply",
                              style: TextStyle(color: Colors.deepOrange),
                            ),
                          ),
                        ),
                      ),

                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subtotal",style: TextStyle(color: Colors.grey),),
                    Text("\$${cart.total.toStringAsFixed(2)}"),
                  ],
                ),
                const SizedBox(height: 4),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("\$${cart.total.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Checkout action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Checkout", style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
