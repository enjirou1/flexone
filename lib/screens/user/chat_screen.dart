import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/user_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/widgets/bubble_chat.dart';
import 'package:flexone/widgets/chat_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  UserModel receiver;
  bool followed;

  ChatScreen({ Key? key, required this.receiver, required this.followed }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference _messages = _firestore.collection('messages');

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (widget.receiver.photo != null && widget.receiver.photo != "")
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                    image: DecorationImage(
                        image: NetworkImage(widget.receiver.photo!), fit: BoxFit.cover)),
              )
            : Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/profile-icon.png'),
                        fit: BoxFit.cover)),
              ),
            const SizedBox(width: 15),
            Text('${widget.receiver.fullname!}#${widget.receiver.userId}', style: poppinsTheme.bodyText1)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messages
                .where('receiver.id', isEqualTo: widget.receiver.userId)
                .where('sender.id', isEqualTo: _provider.user!.userId)
                .snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: _messages
                      .where('receiver.id', isEqualTo: _provider.user!.userId)
                      .where('sender.id', isEqualTo: widget.receiver.userId)
                      .snapshots(),
                    builder: (_, snapshot2) {
                      final documents = [...?snapshot.data?.docs, ...?snapshot2.data?.docs];
                      documents.sort(((a, b) {
                        final date1 = ((a.data() as Map<String, dynamic>)['sent_at'] as Timestamp).toDate();
                        final date2 = ((b.data() as Map<String, dynamic>)['sent_at'] as Timestamp).toDate();
                        return date1.compareTo(date2);
                      }));
                      WidgetsBinding.instance!.addPostFrameCallback((_){
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        }
                      });
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                            return BubbleChat(text: data['text'], status: data['sender']['id'] == _provider.user!.userId, date: data['sent_at']);
                          },
                        ),
                      );
                    }
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              },
            )
          ),
          if (!widget.followed)
          Container(
            width: double.infinity,
            color: Colors.indigo.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(child: const Text('error.follow.not_followed').tr()),
            ),
          ),
          ChatEditText(
            controller: _controller, 
            followed: widget.followed,
            onSubmit: () {
              if (_controller.text.isNotEmpty) {
                _messages.add({
                  "sender": {
                    "avatar": _provider.user!.photo,
                    "id": _provider.user!.userId,
                    "name": _provider.user!.fullname,
                  },
                  "receiver": {
                    "avatar": widget.receiver.photo,
                    "id": widget.receiver.userId,
                    "name": widget.receiver.fullname,
                  },
                  "text": _controller.text,
                  "sent_at": Timestamp.now()
                });
                _controller.clear();
              }
            }
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}