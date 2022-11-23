import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (ctx1, user) {
          if (user.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('chat').orderBy('created_at', descending: true).snapshots(),
              builder: (ctx2, chat) {
                if (chat.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final chatDocs = chat.data!.docs;
                return ListView.builder(
                    reverse: true,
                    itemCount: chatDocs.length,
                    itemBuilder: (ctx3, index) {
                      return MessageBubble(
                        userId: chatDocs[index]['user_id'],
												imageUrl: chatDocs[index]['image_url'],
												userName: chatDocs[index]['username'],
                        message: chatDocs[index]['text'],
                        isMe: chatDocs[index]['user_id'] == user.data!.uid,
                        msgKey: ValueKey(chatDocs[index].id),
                      );
                    });
              });
        });
  }
}
