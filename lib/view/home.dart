import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/application/auth/view_model/LoginViewModel.dart';
import 'package:my_app/view/user_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List products = [];
  bool isLoading = true;
  late LoginViewModel loginViewModel;

  @override
  void initState() {
    super.initState();
    loginViewModel = LoginViewModel();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/Product/"),
      );

      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception("Failed to load products");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product List",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await loginViewModel.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.black),
          onPressed: () {
            Navigator.push(context,  MaterialPageRoute(builder: (_) => UserDetailPage()));
          },
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text("No products found"))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(product['product_name'] ?? 'No name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Details: ${product['product_details']}"),
                        Text("Price: ₹${product['product_price']}"),
                        Text("Category: ${product['product_category']}"),
                        Text(
                          "Available: ${product['is_available'] ? 'Yes' : 'No'}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
