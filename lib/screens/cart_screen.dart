import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/transaction_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/utils/format.dart';
import 'package:flexone/utils/launcher.dart';
import 'package:flexone/widgets/card/class_item_card.dart';
import 'package:flexone/widgets/card/consultation_item_card.dart';
import 'package:flexone/widgets/dialog/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({ Key? key }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    Cart? _cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('cart').tr(),
      ),
      body: (_provider.user != null) ? 
        FutureBuilder<Cart?>(
          future: Cart.getCart(_provider.user!.userId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (_cart == null) {
                Future.delayed(Duration.zero, () {
                  _cart = snapshot.data!;
                  setState(() {});
                });
              }
            }
      
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text('INVOICE', style: poppinsTheme.bodyText1)
                          ),
                          Expanded(
                            child: Text(snapshot.data!.invoice, style: poppinsTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold))
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text('TOTAL', style: poppinsTheme.bodyText1)
                          ),
                          Expanded(
                            child: Text(convertToRupiah(snapshot.data!.total), style: poppinsTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold))
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              String url = await Cart.checkout(snapshot.data!.invoice);
                              await Launcher.launchInWebView(url);
                              _cart = null;
                              setState(() {});
                            } catch (e) {
                              Get.snackbar(tr('failed'), e.toString(),
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,
                                animationDuration: const Duration(milliseconds: 300),
                                duration: const Duration(seconds: 2)
                              );
                            }
                          },
                          child: const Text('pay_now').tr()
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text('consultations', style: poppinsTheme.headline6).tr(),
                      const SizedBox(height: 15),
                      ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ConsultationItemCard(
                            consultation: snapshot.data!.consultationItems[index],
                            onRemoved: () {
                              showDialog(
                                context: context, 
                                builder: (context) => ConfirmationDialog(
                                  title: 'confirmation.remove_consultation.title',
                                  buttonText: 'delete', 
                                  onCancel: () {
                                    Navigator.pop(context);
                                  }, 
                                  onPressed: () async {
                                    await Cart.removeItem(_provider.user!.userId!, 'consultation', snapshot.data!.consultationItems[index].itemId!);
                                    Navigator.pop(context);
                                    _cart = null;
                                    setState(() {});
                                  }
                                )
                              );
                            },
                          );
                        },
                        itemCount: snapshot.data!.consultationItems.length,
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                      const SizedBox(height: 15),
                      Text('classes', style: poppinsTheme.headline6).tr(),
                      const SizedBox(height: 15),
                      ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ClassItemCard(
                            classModel: snapshot.data!.classItems[index],
                            onRemoved: () {
                              showDialog(
                                context: context, 
                                builder: (context) => ConfirmationDialog(
                                  title: 'confirmation.remove_class.title',
                                  buttonText: 'delete', 
                                  onCancel: () {
                                    Navigator.pop(context);
                                  }, 
                                  onPressed: () async {
                                    await Cart.removeItem(_provider.user!.userId!, 'class', snapshot.data!.classItems[index].itemId!);
                                    Navigator.pop(context);
                                    _cart = null;
                                    setState(() {});
                                  }
                                )
                              );
                            },
                          );
                        },
                        itemCount: snapshot.data!.classItems.length,
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                    ],
                  )
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.cartPlus, size: 70),
                    const SizedBox(height: 10),
                    Text('cart_is_empty', style: poppinsTheme.headline6).tr(),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }
        )
        :
        Center(
          child: ElevatedButton.icon(
            onPressed: () => Get.toNamed('/login'),
            icon: const Icon(Icons.login),
            label: Text('Login', style: poppinsTheme.headline6),
          ),
        )
    );
  }
}