import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/room_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/data/services/upload_service.dart';
import 'package:flexone/widgets/bubble/bubble_room_chat.dart';
import 'package:flexone/widgets/edittext/chat_edit_text.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RoomChatScreen extends StatefulWidget {
  Room room;

  RoomChatScreen({ Key? key, required this.room }) : super(key: key);

  @override
  State<RoomChatScreen> createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _image = "";
  XFile? _file;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference _messages = _firestore.collection('room-chats');

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (widget.room.photo != null && widget.room.photo != "")
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(widget.room.photo), 
                    fit: BoxFit.cover
                  )
                ),
              )
            : Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/images/room-icon.png'),
                    fit: BoxFit.cover
                  )
                ),
              ),
            const SizedBox(width: 15),
            Text(widget.room.name, style: poppinsTheme.bodyText1)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messages
                .where('room', isEqualTo: widget.room.id)
                .orderBy('sent_at', descending: false)
                .snapshots(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final documents = snapshot.data!.docs;

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
                          return BubbleRoomChat(
                            avatar: data['sender']['avatar'], 
                            name: data['sender']['name'], 
                            id: data['sender']['id'], 
                            status: data['sender']['id'] == _provider.user!.userId!, 
                            text: data['text'],
                            image: data['image'],
                            date: data['sent_at']
                          );
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              },
            )
          ),
          ChatEditText(
            controller: _controller,
            onSubmit: () {
              if (_controller.text.isNotEmpty) {
                _messages.add({
                  "sender": {
                    "avatar": _provider.user!.photo,
                    "id": _provider.user!.userId,
                    "name": _provider.user!.fullname,
                  },
                  "room": widget.room.id,
                  "image": null,
                  "text": _controller.text,
                  "sent_at": Timestamp.now()
                });
                _controller.clear();
              }
            },
            onPickImage: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actions: [
                    ListTile(
                      title: const Text("open_camera").tr(),
                      tileColor: Colors.white,
                      textColor: Colors.black,
                      onTap: () async {
                        try {
                          _file = await UploadService.getImage(0);
                          Navigator.pop(context);
                          _image = await UploadService.uploadImage(
                            _file!, 
                            "room-chat", 
                            _provider.user!.userId! + widget.room.id
                          );
                          _messages.add({
                            "sender": {
                              "avatar": _provider.user!.photo,
                              "id": _provider.user!.userId,
                              "name": _provider.user!.fullname,
                            },
                            "room": widget.room.id,
                            "image": _image,
                            "text": null,
                            "sent_at": Timestamp.now()
                          });
                        } on FirebaseException catch (e) {
                          print(e.message!);
                        } catch (e) {
                          print(e.toString());
                        }
                        setState(() {});
                      },
                    ),
                    ListTile(
                      title: const Text("select_photo").tr(),
                      tileColor: Colors.white,
                      textColor: Colors.black,
                      onTap: () async {
                        try {
                          _file = await UploadService.getImage(1);
                          Navigator.pop(context);
                          _image = await UploadService.uploadImage(
                            _file!, 
                            "room-chat", 
                            _provider.user!.userId! + widget.room.id
                          );
                          _messages.add({
                            "sender": {
                              "avatar": _provider.user!.photo,
                              "id": _provider.user!.userId,
                              "name": _provider.user!.fullname,
                            },
                            "room": widget.room.id,
                            "image": _image,
                            "text": null,
                            "sent_at": Timestamp.now()
                          });
                        } on FirebaseException catch (e) {
                          print(e.message!);
                        } catch (e) {
                          print(e.toString());
                        }
                        setState(() {});
                      },
                    ),
                  ],
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}