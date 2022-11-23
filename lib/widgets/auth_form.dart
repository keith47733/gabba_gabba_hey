import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gabba_gabba_hey/widgets/show_error_dialog.dart';

import '../styles/form_field_decoration.dart';
import '../styles/layout.dart';
import 'user_image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitAuthForm, this.isLoading);

  final bool isLoading;
  final void Function(
		File? userImage,
    String userEmail,
    String? userName,
    String userPassword,
    bool isLoadingMode,
    BuildContext ctx,
  ) submitAuthForm;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> formKey = GlobalKey();

  bool isLoginMode = true;

  File? userImage;
  String? userEmail;
  String? userName;
  String? userPassword;

  void trySubmitAuthForm(ctx) {
    FocusScope.of(context).unfocus();
    if (formKey.currentState == null) {
      return;
    }
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (!isLoginMode && userImage == null) {
			showErrorDialog(ctx, 'Error', 'Please pick a user image.');
      return;
    }
    formKey.currentState!.save();
    widget.submitAuthForm(
			userImage,
			userEmail!,
      userName,
      userPassword!,
      isLoginMode,
      ctx,
    );
  }

  void imagePick(File image) {
    userImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(Layout.SPACING * 2),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Layout.SPACING),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!isLoginMode) UserImagePicker(imagePick),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: formFieldDecoration(context).copyWith(
                      labelText: 'Email address',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter your email address';
                      }
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      userEmail = newValue!.trim();
                    },
                  ),
                  const SizedBox(height: Layout.SPACING),
                  if (!isLoginMode)
                    TextFormField(
                      key: const ValueKey('username'),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: formFieldDecoration(context).copyWith(
                        labelText: 'User name',
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter your user name';
                        }
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter a minimum of 4 characters';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        userName = newValue!.trim();
                      },
                    ),
                  if (!isLoginMode) const SizedBox(height: Layout.SPACING),
                  TextFormField(
                    key: const ValueKey('password'),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: formFieldDecoration(context).copyWith(
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter your password';
                      }
                      if (value.isEmpty || value.length < 6) {
                        return 'Please enter a minimum of 6 characters';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      userPassword = newValue!.trim();
                    },
                  ),
                  const SizedBox(height: Layout.SPACING),
                  if (widget.isLoading) const Center(child: CircularProgressIndicator()),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: () => trySubmitAuthForm(context),
                      child: Text(
                        isLoginMode ? 'Login' : 'Create Account',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          isLoginMode = !isLoginMode;
                        });
                      },
                      child: Text(
                        isLoginMode ? 'I need to create a new account' : 'I already have an account',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
