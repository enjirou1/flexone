import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/data/models/room_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/screens/room/edit_room_screen.dart';
import 'package:flexone/widgets/card/room_card.dart';
import 'package:flexone/widgets/dialog/confirmation_dialog.dart';
import 'package:flexone/widgets/edittext/search_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyRoomScreen extends StatefulWidget {
  const MyRoomScreen({ Key? key }) : super(key: key);

  @override
  State<MyRoomScreen> createState() => _MyRoomScreenState();
}

class _MyRoomScreenState extends State<MyRoomScreen> {
  final TextEditingController _controller2 = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Room> _rooms = [];
  String _keywords = "";
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('my_rooms').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SearchEditText(
              controller: _controller2,
              onSubmitted: (String value) {
                _keywords = value;
                _rooms.clear();
                _hasReachedMax = false;
                setState(() {});
              },
              onChanged: (String value) {
                _keywords = value;
                setState(() {});
              },
              onClear: () {
                if (_keywords != "") {
                  _controller2.text = "";
                  _keywords = "";
                }
                _rooms.clear();
                _hasReachedMax = false;
                setState(() {});
              },
            ),
            Expanded(
              child: FutureBuilder<List<Room>>(
                future: Room.getJoinedRooms(_provider.user!.userId!, _rooms.length, 20, _keywords),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<Room> data = snapshot.data!;
            
                    if (_rooms.isEmpty) {
                      Future.delayed(Duration.zero, () {
                        _rooms.addAll(data);
                        data = [];
                        setState(() {});
                      });
                    }
            
                    if (data.isEmpty) {
                      Future.delayed(Duration.zero, () {
                        _hasReachedMax = true;
                        data = [];
                        setState(() {});
                      });
                    }
            
                    _scrollController.addListener(() {
                      double currentScroll = _scrollController.position.pixels;
                      double maxScroll = _scrollController.position.maxScrollExtent;
            
                      if (currentScroll == maxScroll) {
                        if (!_hasReachedMax) {
                          List<Room> temp = [];
                          temp.addAll(_rooms);
                          _rooms.clear();
                          _rooms.addAll([...temp, ...data]);
                          data.clear();
                          setState(() {});
                        }
                      }
                    });
                  }
            
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ListView.separated(
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return (index < _rooms.length)
                            ? RoomCard(
                                room: _rooms[index], 
                                isOwner: _rooms[index].user.id == _provider.user!.userId!,
                                onRemoved: () {
                                  showDialog(
                                    context: context, 
                                    builder: (context) => ConfirmationDialog(
                                      title: 'confirmation.delete_room.title',
                                      buttonText: 'delete', 
                                      onCancel: () {
                                        Navigator.pop(context);
                                      }, 
                                      onPressed: () async {
                                        await Room.deleteRoom(_rooms[index].id);
                                        _rooms.removeAt(index);
                                        Navigator.pop(context);
                                        setState(() {});
                                      }
                                    )
                                  );
                                },
                                onPressed: () async {
                                  final result = await Get.to(EditRoomScreen(room: _rooms[index]));
                                  if (result != null) {
                                    _rooms.clear();
                                    _hasReachedMax = false;
                                    setState(() {});
                                    Get.snackbar(
                                      tr('success'), tr('success_detail.update_room'),
                                      snackPosition: SnackPosition.BOTTOM,
                                      animationDuration: const Duration(milliseconds: 300),
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      icon: const Icon(Icons.check, color: Colors.white),
                                      duration: const Duration(seconds: 1)
                                    );
                                  }
                                },
                              )
                            : const Center(
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                        },
                        itemCount: (_hasReachedMax || _rooms.isEmpty) ? _rooms.length : _rooms.length + 1,
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                }
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.toNamed('/add_room');
          if (result != null) {
            _rooms.clear();
            _hasReachedMax = false;
            setState(() {});
            Get.snackbar(
              tr('success'), tr('success_detail.create_room'),
              snackPosition: SnackPosition.BOTTOM,
              animationDuration: const Duration(milliseconds: 300),
              backgroundColor: Colors.green,
              colorText: Colors.white,
              icon: const Icon(Icons.check, color: Colors.white),
              duration: const Duration(seconds: 1)
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}