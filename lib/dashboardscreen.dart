import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist/productdetailscreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> categories = [];
  List allProducts = [];
  List filteredProducts = [];
  bool isLoading = true;
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final categoryResponse =
      await http.get(Uri.parse('https://fakestoreapi.com/products/categories'));
      final productResponse =
      await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (categoryResponse.statusCode == 200 && productResponse.statusCode == 200) {
        categories = List<String>.from(json.decode(categoryResponse.body));
        allProducts = json.decode(productResponse.body);
        setState(() {
          selectedCategory = '';
          filteredProducts = allProducts;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading dashboard data')),
      );
    }
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredProducts = category == ''
          ? allProducts
          : allProducts.where((item) => item['category'] == category).toList();
    });
  }

  final List<IconData> categoryIcons = [
    Icons.devices,        // Electronics
    Icons.checkroom,      // Clothing
    Icons.shopping_bag,   // Groceries
    Icons.chair,          // Home
    Icons.brush,          // Beauty
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 12), // spacing from edge or other icons
            decoration: BoxDecoration(
              color: Colors.grey.shade100, // background color
              shape: BoxShape.circle, // use BoxShape.circle for perfect circular background
            ),
            child: IconButton(
              icon: const Icon(Icons.grid_view_outlined, color: Colors.black),
              onPressed: () {
                // handle notification action
              },
            ),
          ),
          Spacer(),
          Container(
            margin: const EdgeInsets.only(right: 12), // spacing from edge or other icons
            decoration: BoxDecoration(
              color: Colors.grey.shade100, // background color
              shape: BoxShape.circle, // use BoxShape.circle for perfect circular background
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {
                // handle notification action
              },
            ),
          ),

        ],
      ),

      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search
          Container(
          // margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune, color: Colors.grey), // Filter icon
                onPressed: () {
                  // Add filter functionality here
                },
              ),
            ],
          ),
        ),
              const SizedBox(height: 20),

              // Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/event.png',
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 20),

              // Category Chips
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.orange.shade100,
                            radius: 25,
                            child: Icon(
                              categoryIcons[index],  // Change icon based on index
                              color: Colors.deepOrange,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            categories[index],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),



              const SizedBox(height: 20),

              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Special For You',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text('See all', style: TextStyle(color: Colors.deepOrange)),
                ],
              ),
              const SizedBox(height: 10),

              // Products Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];

                  // Example dummy color list – you can replace this with product['colors']
                  final List<Color> productColors = [
                    Colors.blue,
                    Colors.black,
                    Colors.orange,
                    Colors.red,
                    Colors.purple,
                  ];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 200, // Fixed height for each item
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Image.network(
                                  product['image'],
                                  height: 100,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ),
                                Positioned(
                                  top: 2,
                                  right: 1,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                      color: Colors.deepOrange,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(7),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                product['title'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${product['price']}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      productColors.length > 4 ? 4 : productColors.length,
                                          (i) => Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: CircleAvatar(
                                          radius: 8,
                                          backgroundColor: productColors[i],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),


            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("favorite"));
}

class extra extends StatelessWidget {
  const extra({super.key});

  @override
  @override
  Widget build(BuildContext context) => Center(child: Text("page"));
}




class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("profile"));
}