import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cartpage.dart';
import 'cartprovider.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedColorIndex = 0;
  int selectedTabIndex = 0;

  final List<Color> colorOptions = [
    Color(0xFF8A1538),
    Color(0xFF0B0B45),
    Color(0xFF1A1A1A),
    Color(0xFFAD794B),
    Color(0xFFCC3333),
  ];



  final List<String> tabTitles = ['Description', 'Specifications', 'Reviews'];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Product Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50, // Background color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Product Image
                    Center(
                      child: SizedBox(
                        height: 350,
                        width: 350,
                        child: Image.network(
                          product['image'],
                          fit: BoxFit.contain, // or BoxFit.cover / fill / fitHeight etc.
                        ),
                      ),
                    ),


                    // Favorite and Share buttons
                    Positioned(
                      top: 10,
                      right: 20,
                      child: Row(
                        children: [
                          _buildIconButton(Icons.share_outlined),

                          const SizedBox(width: 10),
                          _buildIconButton(Icons.favorite_border),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 20,
                      child: Row(
                        children: [
                          GestureDetector(
                              child: _buildIconButton(Icons.arrow_back_ios_new),onTap: (){
                                Navigator.pop(context);
                          },),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            // Bottom Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['title'],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('\$${product['price']}',
                      style: const TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 10),

                  const Text('Color'),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(colorOptions.length, (i) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColorIndex = i;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColorIndex == i
                                  ? Colors.deepOrange
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: colorOptions[i],
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  // Tabs
                  Row(
                    children: List.generate(
                      tabTitles.length,
                          (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTabIndex = index;
                          });
                        },
                        child: tabButton(tabTitles[index], isSelected: selectedTabIndex == index),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tab Content
                  Text(
                    getTabContent(selectedTabIndex),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),

                  const SizedBox(height: 16),

                  // Quantity and Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:  EdgeInsets.only(left:  15,),
                        decoration:  BoxDecoration(
                        color: Colors.black,
                          borderRadius:BorderRadius.circular(50),
                        ),
                        width: 300,
                        height: 50,
                        child:  Row(
                          children: [
                            Container(
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:  Center(child: Text('-  1  +',style: TextStyle(color: Colors.white),)),
                            ),
                            SizedBox(width: 75,),
                            GestureDetector(
                              onTap: (){
                                Provider.of<CartProvider>(context, listen: false).addToCart(product);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CartPage()),
                                );
                              },
                              child: Container(
                                height: 35,
                                width: 120,
                                decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(child: Text("Add to Cart",style: TextStyle(color: Colors.white,fontSize: 16),)),
                              ),
                            )
                          ],
                        ),

                      )


                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3), // shadow position: x=0, y=3
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 20,
        color: Colors.black,
      ),
    );

  }


  Widget tabButton(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  String getTabContent(int index) {
    switch (index) {
      case 0:
        return 'This wireless headphone delivers rich sound and a comfortable fit. Great for workouts and calls.';
      case 1:
        return 'Bluetooth 5.2, 10h battery life, noise cancellation, sweat resistant.';
      case 2:
        return '⭐️⭐️⭐️⭐️☆ - "Very comfortable and clear sound!"\n⭐️⭐️⭐️⭐️⭐️ - "Best I’ve used so far!"';
      default:
        return '';
    }
  }
}
