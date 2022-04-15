import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/merchandise_result.dart';
import 'package:flexone/widgets/card_with_header.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MerchandiseDetailScreen extends StatefulWidget {
  Merchandise merchandise;

  MerchandiseDetailScreen({ Key? key, required this.merchandise }) : super(key: key);

  @override
  State<MerchandiseDetailScreen> createState() => _MerchandiseDetailScreenState();
}

class _MerchandiseDetailScreenState extends State<MerchandiseDetailScreen> {
  ScrollController _scrollController = ScrollController();
  bool _isExpanded = false;

  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {
        _isExpanded = _scrollController.hasClients && _scrollController.offset > (200 - kToolbarHeight);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                expandedHeight: 300,
                forceElevated: isScrolled,
                flexibleSpace: (!_isExpanded) ?
                  GestureDetector(
                    onTap: () => (widget.merchandise.photo != null && widget.merchandise.photo != "") ? Get.to(PreviewImage(image: widget.merchandise.photo!, detail: null)) : null,
                    child: FlexibleSpaceBar(
                      background: (widget.merchandise.photo != null && widget.merchandise.photo != "") ? Image.network(widget.merchandise.photo!, fit: BoxFit.cover) : Image.asset('assets/images/photo-icon.png', fit: BoxFit.contain),
                      title: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), 
                        width: double.infinity, 
                        color: Colors.black87.withOpacity(0.6), 
                        child: Text(widget.merchandise.name, style: poppinsTheme.bodyText2)
                      ),
                      titlePadding: EdgeInsets.zero,
                    ),
                  )
                :
                  FlexibleSpaceBar(
                    background: (widget.merchandise.photo != null && widget.merchandise.photo != "") ? Image.network(widget.merchandise.photo!, fit: BoxFit.cover) : Image.asset('assets/images/photo-icon.png', fit: BoxFit.contain),
                    title: SizedBox(
                      width: double.infinity,
                      child: Text(widget.merchandise.name, overflow: TextOverflow.ellipsis)
                    ),
                  )
              ),
            ),
          ];
        },
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: AppBar().preferredSize.height),
                CardWithHeader(
                  headerText: 'detail', 
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text("description", style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)).tr(),
                      ),
                      Text(widget.merchandise.description ?? "-"),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 8),
                        child: Text("price", style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)).tr(),
                      ),
                      Text(tr("points", args: [NumberFormat.decimalPattern(context.locale == const Locale('id') ? 'id' : 'en_US').format(widget.merchandise.price)])),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 8),
                        child: Text("stock", style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)).tr(),
                      ),
                      Text(NumberFormat.decimalPattern(context.locale == const Locale('id') ? 'id' : 'en_US').format(widget.merchandise.stock))
                    ],
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}