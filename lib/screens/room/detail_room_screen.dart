import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/room_result.dart';
import 'package:flexone/data/providers/room.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/screens/room/member_screen.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flexone/widgets/dialog/single_input_dialog.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DetailRoomScreen extends StatefulWidget {
  bool joined;

  DetailRoomScreen({ Key? key, required this.joined }) : super(key: key);

  @override
  State<DetailRoomScreen> createState() => _DetailRoomScreenState();
}

class _DetailRoomScreenState extends State<DetailRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _joined = false;

  @override
  void initState() {
    _joined = widget.joined;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final _roomProvider = Provider.of<RoomProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(_roomProvider.room!.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (_roomProvider.room!.photo != null && _roomProvider.room!.photo != "")
                  ? GestureDetector(
                      onTap: () => Get.to(PreviewImage(image: _roomProvider.room!.photo)),
                      child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            image: DecorationImage(
                              image: NetworkImage(_roomProvider.room!.photo), 
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage('assets/images/room-icon.png'),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_roomProvider.room!.name, style: poppinsTheme.headline6, overflow: TextOverflow.ellipsis, maxLines: 5,),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(_roomProvider.room!.status == "public" ? Icons.public : Icons.shield, size: 15),
                            const SizedBox(width: 5),
                            Text(_roomProvider.room!.status, style: poppinsTheme.bodyText2)
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text("${tr('members:')} ${_roomProvider.room!.totalMembers}/${_roomProvider.room!.maxSlot}", style: poppinsTheme.bodyText2)
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (!_joined) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_roomProvider.room!.status == "public") {
                            await Room.join(_roomProvider.room!.id, _provider.user!.userId!, "");
                            _roomProvider.addMember();
                            _joined = true;
                            setState(() {});
                          } else {
                            showDialog(
                              context: context, 
                              builder: (BuildContext context) {
                                InputValidation _validation = InputValidation(isValid: true, message: '');

                                return StatefulBuilder(
                                  builder: (context, setState) => SingleInputDialog(
                                    title: tr('enter_password'), 
                                    label: 'password', 
                                    buttonText: 'join', 
                                    controller: _controller, 
                                    inputValidation: _validation,
                                    inputType: TextInputType.text,
                                    obsecureText: true,
                                    onPressed: () async {
                                      setState(() {
                                        _validation = InputValidation(isValid: _controller.text.isNotEmpty, message: tr('error.password.empty'));
                                      });

                                      if (_controller.text.isNotEmpty) {
                                        try {
                                          await Room.join(_roomProvider.room!.id, _provider.user!.userId!, _controller.text);
                                          _roomProvider.addMember();
                                          _joined = true;
                                          Navigator.pop(context);
                                          this.setState(() {});
                                        } catch (e) {
                                          Get.snackbar('Failed', e.toString(),
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            animationDuration: const Duration(milliseconds: 300),
                                            duration: const Duration(seconds: 2)
                                          );
                                        }
                                      }
                                    })
                                );
                              }
                            );
                          }
                        }, 
                        icon: const FaIcon(FontAwesomeIcons.arrowRightToBracket, size: 15), 
                        label: Text("join", style: poppinsTheme.caption).tr()
                      ),
                    ),
                  ]
                  else 
                    if (_roomProvider.room!.user.id != _provider.user!.userId!) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Room.removeMember(_roomProvider.room!.id, _provider.user!.userId!);
                            _roomProvider.removeMember();
                            _joined = false;
                            setState(() {});
                          }, 
                          icon: const FaIcon(FontAwesomeIcons.rightFromBracket, size: 15), 
                          label: Text("leave", style: poppinsTheme.caption).tr()
                        ),
                      ),
                    ],
                  if (_joined) ...[
                    const SizedBox(width: 5),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                    
                        }, 
                        icon: const FaIcon(FontAwesomeIcons.envelope, size: 15), 
                        label: Text("Chat", style: poppinsTheme.caption)
                      ),
                    ),
                  ],
                  const SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.to(MemberScreen()), 
                      icon: const FaIcon(FontAwesomeIcons.userGroup, size: 15), 
                      label: Text("members", style: poppinsTheme.caption).tr()
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SelectableText(_roomProvider.room!.description == "" ? "-" : _roomProvider.room!.description, style: poppinsTheme.bodyText1),
            ],
          ),
        ),
      ),
    );
  }
}