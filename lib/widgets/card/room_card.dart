import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/room_result.dart';
import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  Room room;
  bool isOwner;
  Function()? onRemoved;
  Function()? onPressed;

  RoomCard({ Key? key, required this.room, required this.isOwner, this.onRemoved, this.onPressed }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            (room.photo != null && room.photo != "")
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: NetworkImage(room.photo), 
                    fit: BoxFit.cover
                  )
                ),
              )
            : Container(
                width: 40,
                height: 40,
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
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(room.name, style: poppinsTheme.caption!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Icon(room.status == "public" ? Icons.public : Icons.shield, size: 15)
                  ],
                ),
                Text(
                  '${room.totalMembers}/${room.maxSlot}', 
                  style: poppinsTheme.caption!.copyWith(fontSize: 11)
                ),
              ],
            )
          ]
        ),
        const SizedBox(height: 10),
        Text(
          room.description == "" ? "-" : room.description, 
          style: poppinsTheme.bodyText2,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
        ),
        if (isOwner) ...[
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: onRemoved, 
                icon: const Icon(Icons.delete_rounded),
                style: ElevatedButton.styleFrom(primary: Colors.red[800]),
                label: Text('delete', style: poppinsTheme.caption).tr()
              ),
              const SizedBox(width: 5),
              ElevatedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.edit),
                label: Text('edit', style: poppinsTheme.caption).tr(),
              ),
            ],
          ),
        ]
      ],
    );
  }
}