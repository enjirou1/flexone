import 'package:flexone/common/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ReviewListTile extends StatelessWidget {
  String image;
  String name;
  String id;
  int rating;
  String review;

  ReviewListTile({ Key? key, required this.image, required this.name, required this.id, required this.rating, required this.review }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () => Get.toNamed('/user/detail?id=$id'),
        child: (image != null && image != "")
        ? Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
              image: DecorationImage(
                image: NetworkImage(image), 
                fit: BoxFit.cover
              )
            ),
          )
        : Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/profile-icon.png'),
                fit: BoxFit.cover
              )
            ),
          ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Text(
            '$name #$id',
            style: poppinsTheme.caption!.copyWith(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          RatingBarIndicator(
            rating: rating.toDouble(),
            unratedColor: Colors.grey,
            itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 15,
            direction: Axis.horizontal,
          ),
          const SizedBox(height: 5),
          Text(review, style: poppinsTheme.caption)
        ]
      ),
    );
  }
}