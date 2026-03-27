import 'package:flutter/material.dart';
import 'package:my_app/application/auth/view_model/LoginViewModel.dart';
import 'package:my_app/view/home.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LOGIN',style: TextStyle(
                  color: Colors.black,
                ),
                ),
                Text('Welcome Back',style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16
                ),)
              ],
            ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0,top: 200),
              child: Column(
                spacing: 10,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: 'Username'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration( border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                      labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  viewModel.loading
                      ? CircularProgressIndicator()
                      : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.black54),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ))
                          ),
                            onPressed: () async {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => HomePage()),
                              );
                              String username = usernameController.text.trim();
                              String password = passwordController.text.trim();
                        
                              bool success = await viewModel.login(username, password);
                        
                              if (success) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => HomePage()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Login failed')),
                                );
                              }
                            },
                            child: Text(' LOGIN',style: TextStyle(color: Colors.white),)
                          ),
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