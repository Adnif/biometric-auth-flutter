import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends ConsumerWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              //SvgPicture.asset("assets/logo.svg"),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Masukan Username',
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Masukan Email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Masukan Password',
                ),
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                ),
              ),
              ElevatedButton(
                child: Text('Sign Up'),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
