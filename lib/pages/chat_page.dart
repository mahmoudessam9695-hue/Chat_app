import 'package:chat_app/consts.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';

  ChatPage({super.key});

  final ScrollController _controller = ScrollController();
  final TextEditingController controller = TextEditingController();

  CollectionReference messages = FirebaseFirestore.instance.collection(
    kmessages,
  );

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kcreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModal> messagesList = [];

          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(MessageModal.fromjson(snapshot.data!.docs[i]));
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(klogo, height: 40),
                  const SizedBox(width: 10),
                  const Text(
                    'Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            body: Column(
              children: [
                /// 💬 Messages
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBubble(message: messagesList[index])
                          : ChatBubbleForFriend(message: messagesList[index]);
                    },
                  ),
                ),

                /// ✉️ Input
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    right: 10,
                    left: 10,
                    top: 5,
                  ),
                  child: TextField(
                    controller: controller,

                    /// Enter send
                    onSubmitted: (data) {
                      sendMessage(email);
                    },

                    decoration: InputDecoration(
                      hintText: 'Send message...',
                      filled: true,
                      fillColor: Colors.white,

                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: kPrimaryColor),

                        /// Button send
                        onPressed: () {
                          sendMessage(email);
                        },
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(30),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('Loading...'));
        }
      },
    );
  }

  /// 🚀 Send Message Function
  void sendMessage(var email) {
    if (controller.text.trim().isEmpty) return;

    messages.add({
      kmessages: controller.text,
      kcreatedAt: DateTime.now(),
      'id': email,
    });

    controller.clear();

    _controller.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }
}
