import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/merchandise_result.dart';
import 'package:flutter/material.dart';

class MerchandiseListTile extends StatelessWidget {
  MerchandiseHistory history;

  MerchandiseListTile({ Key? key, required this.history }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: (history.merchandise.photo != null && history.merchandise.photo != "") ? 
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              image: DecorationImage(
                image: NetworkImage(history.merchandise.photo!), 
                fit: BoxFit.cover
              )
            )
          )
        :
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
              image: const DecorationImage(
                image: AssetImage('assets/images/photo-icon.png'), 
                fit: BoxFit.contain
              )
            )
          ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              history.merchandise.name, 
              style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Row(
              children: [
                const Icon(Icons.local_shipping_rounded, size: 20),
                const SizedBox(width: 10),
                Text(history.courier == "" ? "-" : history.courier, style: poppinsTheme.caption),
              ],
            ),
            Text("bought_at".tr(args: [DateFormat('d MMMM y h:m').format(DateTime.parse(history.boughtAt))]), style: poppinsTheme.caption!.copyWith(fontSize: 10)),
          ],
        ),
        trailing: Text(history.status, style: poppinsTheme.overline),
      ),
    );
  }
}