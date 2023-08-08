import 'package:flutter/material.dart';
import '../services/auth_state.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void signIn({required String email, required String password}) async {
    if (_formKey.currentState!.validate()) {
      String? message = await Auth()
          .signInUser(email: email.trim(), password: password.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 200,
          ),
          Text(
            'Sign In',
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the password';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text('Don\'t have an account? '),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign-up');
                        },
                        child: const Text(
                          'create one',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    signIn(
                        email: _emailController.text,
                        password: _passwordController.text);
                  },
                  child: const Text('Sign In'),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
