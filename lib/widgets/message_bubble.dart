import 'package:flutter/material.dart';

import '../styles/layout.dart';

class MessageBubble extends StatelessWidget {
  final String userId;
  final String imageUrl;
  final String userName;
  final String message;
  final bool isMe;
  final Key msgKey;

  MessageBubble({
    required this.userId,
    required this.imageUrl,
    required this.userName,
    required this.message,
    required this.isMe,
    required this.msgKey,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(clipBehavior: Clip.none, children: [
      Row(mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.fromLTRB(
            Layout.SPACING / 2,
            Layout.SPACING * 1.5,
            Layout.SPACING / 2,
            Layout.SPACING,
          ),
          padding: const EdgeInsets.fromLTRB(
            Layout.SPACING / 2,
            Layout.SPACING,
            Layout.SPACING / 2,
            Layout.SPACING / 2,
          ),
          constraints: BoxConstraints(maxWidth: size.width * 0.60),
          decoration: BoxDecoration(
            color: isMe ? Theme.of(context).colorScheme.primaryContainer : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(Layout.RADIUS),
              topRight: const Radius.circular(Layout.RADIUS),
              bottomLeft: isMe ? const Radius.circular(Layout.RADIUS) : const Radius.circular(0.0),
              bottomRight: isMe ? const Radius.circular(0.0) : const Radius.circular(Layout.RADIUS),
            ),
          ),
          child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
            Text(
              userName,
              textWidthBasis: TextWidthBasis.longestLine,
              textAlign: isMe ? TextAlign.end : TextAlign.start,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isMe ? Theme.of(context).colorScheme.onPrimaryContainer : Colors.black,
                  ),
            ),
            Text(
              message,
              textWidthBasis: TextWidthBasis.longestLine,
              textAlign: isMe ? TextAlign.end : TextAlign.start,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: isMe ? Theme.of(context).colorScheme.onPrimaryContainer : Colors.black,
                  ),
            ),
          ]),
        ),
      ]),
      Positioned(
        top: -10,
        left: isMe ? null : 10,
        right: isMe ? 10 : null,
        child: CircleAvatar(
					radius: 25.0,
          backgroundImage: NetworkImage(imageUrl),
        ),
      ),
    ]);
  }
}
