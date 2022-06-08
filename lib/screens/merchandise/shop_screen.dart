import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/merchandise_result.dart';
import 'package:flexone/data/models/user_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/utils/format.dart';
import 'package:flexone/widgets/dialog/confirmation_dialog.dart';
import 'package:flexone/widgets/card/merchandise_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({ Key? key }) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Merchandise> _merchandises = [];
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('shop').tr(),
      ),
      body: FutureBuilder<List<Merchandise>>(
        future: Merchandise.getMerchandises(_merchandises.length, 10, "", 0, 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Merchandise> data = snapshot.data!;

            if (_merchandises.isEmpty) {
              Future.delayed(Duration.zero, () {
                _merchandises.addAll(data);
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
                  List<Merchandise> temp = [];
                  temp.addAll(_merchandises);
                  _merchandises.clear();
                  _merchandises.addAll([...temp, ...data]);
                  data.clear();
                  setState(() {});
                }
              }
            });
          }

          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 3, bottom: 15, top: 5, right: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('my_points', style: poppinsTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold)).tr(args: [convertToDecimalPattern(context.locale == const Locale('id') ? 'id' : 'en_US', _provider.user!.point!)]),
                        ElevatedButton.icon(
                          onPressed: () => Get.toNamed('/merchandise-history'),
                          icon: const Icon(Icons.history),
                          label: const Text('History'),
                          style: ElevatedButton.styleFrom(primary: Colors.indigo),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return (index < _merchandises.length)
                          ? MerchandiseCard(
                              merchandise: _merchandises[index],
                              onPressed: () {
                                if (_provider.user!.point! - _merchandises[index].price >= 0) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ConfirmationDialog(
                                      title: tr('confirmation.buy_merchandise.title', args: [_merchandises[index].name]), 
                                      content: tr('confirmation.buy_merchandise.content'), 
                                      buttonText: 'buy', 
                                      onCancel: () => Navigator.pop(context), 
                                      onPressed: () async {
                                        if (_provider.user!.address!.isNotEmpty) {
                                          await Merchandise.buyMerchandise(_merchandises[index].id, _provider.user!.userId!);
                                          await UserModel.getUserByEmail(_provider.user!.email).then((value) {
                                            _provider.setUser(value!);
                                          });
                                          _merchandises[index].stock--;
                                          setState(() {});
                                          Navigator.pop(context);
                                          Get.snackbar(
                                            tr('success'), tr('success_detail.buy_merchandise', args: [_merchandises[index].name]),
                                            snackPosition: SnackPosition.BOTTOM,
                                            animationDuration: const Duration(milliseconds: 300),
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            icon: const Icon(Icons.check, color: Colors.white),
                                            duration: const Duration(seconds: 1)
                                          );
                                        } else {
                                          Get.snackbar(
                                            tr('failed'), tr('error.buy_merchandise.address'),
                                            snackPosition: SnackPosition.BOTTOM,
                                            animationDuration: const Duration(milliseconds: 300),
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            duration: const Duration(seconds: 2)
                                          );
                                        }
                                      }
                                    ),
                                  );
                                } else {
                                  Get.snackbar(tr('failed'), tr('error.point.not_enough'),
                                    snackPosition: SnackPosition.BOTTOM,
                                    animationDuration: const Duration(milliseconds: 300),
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 2)
                                  );
                                }
                              },
                            )
                          : const Center(child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator()));
                      },
                      itemCount: (_hasReachedMax || _merchandises.isEmpty) ? _merchandises.length : _merchandises.length + 1, 
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 0.7
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      )
    );
  }
}