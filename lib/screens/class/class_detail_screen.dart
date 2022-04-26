import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ClassDetailScreen extends StatefulWidget {
  Class classModel;

  ClassDetailScreen({ Key? key, required this.classModel }) : super(key: key);

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  QuillController? _controller = QuillController.basic();
  
  @override
  void initState() {
    final content = jsonDecode(widget.classModel.description!);
    if (content != "") {
      _controller = QuillController(
        document: Document.fromJson(jsonDecode(content)), 
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final _preferenceProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _fontColor = _preferenceProvider.isDarkTheme ? Colors.white : Colors.black;

    return Theme(
      data: _preferenceProvider.isDarkTheme ? 
        darkTheme.copyWith(
          dialogTheme: DialogTheme(
            backgroundColor: Colors.indigo[200]
          ),
        ) : lightTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.classModel.name, style: poppinsTheme.bodyText1),
        ),
        body: RawKeyboardListener(
          focusNode: FocusNode(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (widget.classModel.photo != null && widget.classModel.photo != "")
                      ? Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            image: DecorationImage(
                              image: NetworkImage(widget.classModel.photo!), 
                              fit: BoxFit.cover
                            )
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white,
                            image: DecorationImage(
                              image: AssetImage('assets/images/photo-icon.png'),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(widget.classModel.name, style: poppinsTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 5),
                            InkWell(
                              onTap: () => Get.toNamed('/user/detail?id=${widget.classModel.expert!.userId}'),
                              child: Row(
                                children: [
                                  (widget.classModel.expert!.photo != null && widget.classModel.expert!.photo != "")
                                  ? Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black),
                                        image: DecorationImage(
                                          image: NetworkImage(widget.classModel.expert!.photo!), 
                                          fit: BoxFit.cover
                                        )
                                      ),
                                    )
                                  : Container(
                                      width: 25,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/profile-icon.png'),
                                          fit: BoxFit.cover
                                        )
                                      ),
                                    ),
                                  const SizedBox(width: 5),
                                  Text(widget.classModel.expert!.name),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.people, size: 20),
                                const SizedBox(width: 5),
                                Text(widget.classModel.totalParticipants.toString(), style: poppinsTheme.caption),
                                const SizedBox(width: 15),
                                const FaIcon(FontAwesomeIcons.clock, size: 15),
                                const SizedBox(width: 5),
                                Text('hours_wp', style: poppinsTheme.caption).tr(args: [widget.classModel.estimatedTime.toString()]),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.classModel.rating.toDouble(),
                                  unratedColor: Colors.grey,
                                  itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 15,
                                  direction: Axis.horizontal,
                                ),
                                const SizedBox(width: 5),
                                Text(widget.classModel.rating.toString(), style: poppinsTheme.caption!.copyWith(fontSize: 13, color: Colors.amber)),
                                const SizedBox(width: 5),
                                Text('(${widget.classModel.totalRatings})', style: poppinsTheme.caption!.copyWith(fontSize: 12))
                              ],
                            ),
                            const SizedBox(height: 5),
                            if (widget.classModel.discountPrice > 0) ...[
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Row(
                                  children: [
                                    Text(
                                      convertToRupiah(widget.classModel.price),
                                      style: poppinsTheme.caption!.copyWith(
                                        fontSize: 11,
                                        decoration: TextDecoration.lineThrough
                                      )
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: Colors.indigo
                                      ),
                                      child: Text(
                                        getDiscount(widget.classModel.price, widget.classModel.discountPrice),
                                        style: poppinsTheme.caption!.copyWith(
                                          fontSize: 11,
                                          color: Colors.white
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Text(
                                  convertToRupiah(widget.classModel.discountPrice),
                                  style: poppinsTheme.bodyText2!.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              )
                            ]
                            else ...[
                              Text(
                                convertToRupiah(widget.classModel.price), 
                                style: poppinsTheme.bodyText2!.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                            const SizedBox(height: 5),
                            if (_provider.user == null) ...[
                              ElevatedButton(
                                onPressed: () => Get.toNamed('/login'), 
                                child: const Text('Login')
                              )
                            ],
                            if (_provider.user?.userId != widget.classModel.expert!.userId && widget.classModel.joined == false && _provider.user != null) ...[
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await Class.joinClass(widget.classModel.id, _provider.user!.userId!);
                                  } catch (e) {
                                    Get.snackbar(tr('failed'), tr('already_added_in_cart'),
                                      snackPosition: SnackPosition.BOTTOM,
                                      colorText: Colors.white,
                                      backgroundColor: Colors.red,
                                      animationDuration: const Duration(milliseconds: 300),
                                      duration: const Duration(seconds: 2)
                                    );
                                  }
                                }, 
                                child: const Text('join').tr()
                              )
                            ]
                          ],
                        ),
                      )
                    ]
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(tr('subject'))
                          ),
                          Expanded(
                            child: Text(
                              widget.classModel.subject!.name, 
                              style: poppinsTheme.bodyText2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(tr('grade'))
                          ),
                          Expanded(
                            child: Text(
                              widget.classModel.grade!.name, 
                              style: poppinsTheme.bodyText2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(tr('total_modules'))
                          ),
                          Expanded(
                            child: Text(
                              widget.classModel.totalModules.toString(), 
                              style: poppinsTheme.bodyText2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(tr('created_at'))
                          ),
                          Text(
                            convertToDateFormat('dd/MM/y', widget.classModel.createdAt), 
                            style: poppinsTheme.bodyText2,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  QuillEditor(
                    showCursor: false, 
                    controller: _controller!, 
                    focusNode: FocusNode(), 
                    scrollController: ScrollController(), 
                    scrollable: true, 
                    padding: EdgeInsets.zero, 
                    autoFocus: true, 
                    readOnly: true, 
                    expands: false
                  )
                ]
              )
            ),
          ),
        ),
      ),
    );
  }
}