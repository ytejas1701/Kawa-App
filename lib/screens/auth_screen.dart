import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kawa_app/models/customer.dart';

import 'dart:math';

import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/auth_bg.jpg"), fit: BoxFit.cover)),
          child: Center(child: _AuthCard())),
    );
  }
}

class _AuthCard extends StatefulWidget {
  @override
  State<_AuthCard> createState() => __AuthCardState();
}

class __AuthCardState extends State<_AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _auth = FirebaseAuth.instance;

  final _passwordController = TextEditingController();
  var _email = '';
  var _username = '';
  var _password = '';
  var _isLogin = true;
  var _isLoading = false;

  void _authenticate() async {
    var authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (_isLogin) {
        await Provider.of<Customer>(context, listen: false)
            .login(_email, _password);
      } else {
        await Provider.of<Customer>(context, listen: false)
            .signup(_email, _password, _username);
        // authResult = await _auth.createUserWithEmailAndPassword(
        //     email: _email, password: _password);
        // String userid = FirebaseAuth.instance.currentUser!.uid;

        // CollectionReference user =
        //     FirebaseFirestore.instance.collection(userid);
        // try {
        //   var stats = await user.doc('statistics').set({
        //     'username': _username,
        //     'email': _email,
        //   });
        // } catch (error) {
        //   rethrow;
        // }
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: error.message != null
              ? Text(error.message as String)
              : const Text('Oops! An error ocurred.')));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _submitForm() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      _authenticate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
          maxHeight: min(deviceSize.height * 0.9, 600),
          maxWidth: min(deviceSize.width * 0.9, 400)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.background),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
            decoration: const InputDecoration(
                label: Text('email'), border: OutlineInputBorder()),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            onSaved: (value) {
              _email = value as String;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
                label: Text('password'), border: OutlineInputBorder()),
            validator: (value) {
              if (value!.isEmpty || value.length < 8) {
                return 'Passwords should be at least 8 characters long';
              }
              return null;
            },
            onSaved: (value) {
              _password = value as String;
            },
          ),
          const SizedBox(height: 10),
          if (!_isLogin)
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  label: Text('confirm password'),
                  border: OutlineInputBorder()),
              validator: (value) {
                if (value!.isEmpty || value != _passwordController.text) {
                  return "Password doesn't match";
                }
                return null;
              },
              onSaved: (_) {},
            ),
          const SizedBox(height: 10),
          if (!_isLogin)
            TextFormField(
              decoration: const InputDecoration(
                  label: Text('username'), border: OutlineInputBorder()),
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return 'Please enter a valid username';
                }
                return null;
              },
              onSaved: (value) {
                _username = value as String;
              },
            ),
          const SizedBox(height: 20),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (!_isLoading)
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  primary: Colors.transparent,
                  onSurface: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: _submitForm,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.8)),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    child: _isLogin
                        ? const Text('Sign in')
                        : const Text('Create Account'))),
          const SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _isLogin
                ? const Text("Don't have an account?")
                : const Text("Already have an account?"),
            TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: _isLogin
                    ? const Text(
                        'Sign up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : const Text('Sign in',
                        style: TextStyle(fontWeight: FontWeight.bold)))
          ])
        ])),
      ),
    );
  }
}
