import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../styles/form_field_decoration.dart';
import '../styles/layout.dart';

class NewMessage extends StatefulWidget {
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final newMessageController = TextEditingController();
  String enteredMessage = '';

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
		final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'created_at': Timestamp.now(),
      'text': enteredMessage,
      'user_id': user.uid,
			'username': userData['username'],
			'image_url': userData['image_url'],
    });
    newMessageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      margin: const EdgeInsets.only(top: Layout.SPACING),
      padding: const EdgeInsets.all(Layout.SPACING / 2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: newMessageController,
              decoration: formFieldDecoration(context).copyWith(
                labelText: 'Send a message',
              ),
              onChanged: (value) {
                setState(() {
                  enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: enteredMessage.trim().isEmpty ? null : sendMessage,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
