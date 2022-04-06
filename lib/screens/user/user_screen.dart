import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/data/models/user_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<UserModel> _users = [];
  String _keywords = "";
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: _controller,
            onSubmitted: (String value) {
              _keywords = value;
              _users.clear();
              setState(() {});
            },
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: "search".tr()),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: FutureBuilder<List<UserModel>>(
          future: UserModel.getUsers(
              _provider.user!.userId!, _keywords, _users.length, 20),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<UserModel> data = snapshot.data!;

              if (_users.isEmpty) {
                Future.delayed(Duration.zero, () {
                  _users.addAll(data);
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
                    List<UserModel> temp = [];
                    temp.addAll(_users);
                    _users.clear();
                    _users.addAll([...temp, ...data]);
                    data.clear();
                    setState(() {});
                  }
                }
              });
            }

            if (snapshot.hasData) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: ListView.separated(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return (index < _users.length)
                        ? UserListTile(
                            image: _users[index].photo,
                            name: _users[index].fullname,
                            id: _users[index].userId,
                            email: _users[index].email,
                            followed: _users[index].followed)
                        : const Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(),
                            ),
                          );
                  },
                  itemCount: _hasReachedMax ? _users.length : _users.length + 1,
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
          }),
    ));
  }
}
