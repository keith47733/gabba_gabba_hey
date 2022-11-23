import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/auth_form.dart';
import '../widgets/show_error_dialog.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;

  final auth = FirebaseAuth.instance;

  void submitAuthForm(
    File? userImage,
    String userEmail,
    String? userName,
    String userPassword,
    bool isLoginMode,
    BuildContext ctx,
  ) {
    if (isLoginMode) {
      login(ctx, userEmail, userPassword);
    } else {
      signup(ctx, userImage, userEmail, userName, userPassword);
    }
  }

  void login(ctx, userEmail, userPassword) async {
    try {
      setState(() {
        isLoading = true;
      });
      await auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
    } on FirebaseAuthException catch (error) {
      var message = 'Please try again later.';
      if (error.message != null) {
        message = error.message!;
      }
      showErrorDialog(ctx, 'Login error', message);
    } catch (error) {
      showErrorDialog(ctx, 'Error', error);
    }
  }

  void signup(ctx, userImage, userEmail, userName, userPassword) async {
    UserCredential authResult;
    try {
      setState(() {
        isLoading = true;
      });

      authResult = await auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      final ref = FirebaseStorage.instance.ref().child('user_images').child('${authResult.user!.uid}.jpg');
      await ref.putFile(userImage);
      final userImageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set({
				'image_url': userImageUrl,
        'email': userEmail,
        'username': userName,
      });

    } on FirebaseAuthException catch (error) {
      var message = 'Please try again later.';
      if (error.message != null) {
        message = error.message!;
      }
      showErrorDialog(ctx, 'Signup error', message);
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      showErrorDialog(ctx, 'Error', error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AuthForm(submitAuthForm, isLoading),
    );
  }
}
