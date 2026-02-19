import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }


Future<void> fetchData() async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/Product/'),
  );

  print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    setState(() {
      posts = json.decode(response.body);
      isLoading = false;
    });
  } else {
    setState(() {
      isLoading = false;
    });
  }
}



  // Future<void> fetchData() async {
  //   final response = await http.get(
  //     Uri.parse('http://10.0.2.2:8000/Product/'),
  //   );



  //   if (response.statusCode == 200) {
  //     setState(() {
  //       posts = json.decode(response.body);
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     throw Exception("Failed to load data");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Data"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(posts[index]['title']),
                    subtitle: Text(posts[index]['body']),
                  ),
                );
              },
            ),
    );
  }
}
