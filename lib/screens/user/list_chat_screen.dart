import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/widgets/listtile/message_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListChatScreen extends StatelessWidget {
  const ListChatScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference _messages = _firestore.collection('messages');
    return Scaffold(
      appBar: AppBar(
        title: Text('messages'.tr()),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _messages
          .where('sender.id', isEqualTo: _provider.user!.userId)
          .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<QuerySnapshot>(
              stream: _messages
                .where('receiver.id', isEqualTo: _provider.user!.userId)
                .snapshots(),
              builder: (_, snapshot2) {
                Iterable<Map<String, dynamic>>? docs1 = snapshot.data?.docs.map((doc) {
                  return {
                    "id": (doc.data() as Map<String, dynamic>)['receiver']['id'],
                    "name": (doc.data() as Map<String, dynamic>)['receiver']['name'],
                    "avatar": (doc.data() as Map<String, dynamic>)['receiver']['avatar'],
                    "text": (doc.data() as Map<String, dynamic>)['text'],
                    "sent_at": (doc.data() as Map<String, dynamic>)['sent_at']
                  };
                });

                Iterable<Map<String, dynamic>>? docs2 = snapshot2.data?.docs.map((doc) {
                  return {
                    "id": (doc.data() as Map<String, dynamic>)['sender']['id'],
                    "name": (doc.data() as Map<String, dynamic>)['sender']['name'],
                    "avatar": (doc.data() as Map<String, dynamic>)['sender']['avatar'],
                    "text": (doc.data() as Map<String, dynamic>)['text'],
                    "sent_at": (doc.data() as Map<String, dynamic>)['sent_at']
                  };
                });

                final documents = [...?docs1, ...?docs2];
                documents.sort((a, b) {
                  final date1 = (a['sent_at'] as Timestamp).toDate();
                  final date2 = (b['sent_at'] as Timestamp).toDate();
                  return -date1.compareTo(date2);
                });

                List<Map<String, dynamic>> messages = [];
                documents.forEach((document) {
                  final res = messages.where((msg) => msg['id'] == document['id']);
                  if (res.isEmpty) {
                    messages.add(document);
                  }
                });
                
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return MessageListTile(id: messages[index]['id'], image: messages[index]['avatar'], name: messages[index]['name'], text: messages[index]['text']);
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
    );
  }
}