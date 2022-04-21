import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/data/models/room_result.dart';
import 'package:flexone/data/providers/room.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/widgets/dialog/confirmation_dialog.dart';
import 'package:flexone/widgets/listtile/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MemberScreen extends StatefulWidget {
  MemberScreen({ Key? key }) : super(key: key);

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  List<User> _users = [];

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final _roomProvider = Provider.of<RoomProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('members').tr(),
      ),
      body: FutureBuilder<List<User>>(
        future: Room.getMembers(_roomProvider.room!.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<User> data = snapshot.data!;

            if (_users.isEmpty) {
              Future.delayed(Duration.zero, () {
                _users.addAll(data);
                data = [];
                setState(() {});
              });
            }
          }

          if (snapshot.hasData) { 
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return (_roomProvider.room!.user.id == _provider.user!.userId!) ? 
                    UserListTile(
                      image: snapshot.data![index].photo,
                      name: snapshot.data![index].name,
                      id: snapshot.data![index].id,
                      email: snapshot.data![index].email,
                      trailing: (snapshot.data![index].id != _roomProvider.room!.user.id) ? 
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.xmark, color: Colors.red),
                          onPressed: () async {
                            showDialog(
                              context: context, 
                              builder: (context) => ConfirmationDialog(
                                title: 'confirmation.remove_member.title',
                                buttonText: 'Ok', 
                                onCancel: () {
                                  Navigator.pop(context);
                                }, 
                                onPressed: () async {
                                  await Room.removeMember(_roomProvider.room!.id, snapshot.data![index].id);
                                  _roomProvider.removeMember();
                                  _users.clear();
                                  Navigator.pop(context);
                                  setState(() {});
                                }
                              )
                            );
                          },
                        )
                      : 
                        const Text('Owner').tr(),
                    )
                  :
                     UserListTile(
                      image: snapshot.data![index].photo,
                      name: snapshot.data![index].name,
                      id: snapshot.data![index].id,
                      email: snapshot.data![index].email,
                      trailing: (snapshot.data![index].id == _roomProvider.room!.user.id) ? const Text('owner').tr() : null,
                    );
                },
                itemCount: snapshot.data!.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}