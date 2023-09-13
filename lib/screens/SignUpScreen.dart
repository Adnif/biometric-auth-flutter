import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

class SignUpScreen extends ConsumerWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //SvgPicture.asset("assets/logo.svg"),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Masukan Username',
                  ),
                  validator: (username) {
                    if (username!.isEmpty) {
                      return "Username harus diisi";
                    }

                    if (username.length > 20) {
                      return "Username maksimal 20 karakter";
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Masukan Email',
                  ),
                  validator: (email) {
                    if (email!.isEmpty) {
                      return "Email harus diisi";
                    }
                    if (!EmailValidator.validate(email)) {
                      return "Masukan Email yang valid";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Masukan Password',
                  ),
                  validator: (password) {
                    if (password!.isEmpty) {
                      return "Password harus diisi";
                    }

                    if (password.length < 8) {
                      return "Password minimal 8 karakter";
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                  ),
                  validator: (password) {
                    if (password!.isEmpty) {
                      return "Password harus dikonfirmasi";
                    }

                    if (password != passwordController.text) {
                      return "Maaf, password belum sama";
                    }

                    return null;
                  },
                ),
                ElevatedButton(
                  child: Text('Sign Up'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
