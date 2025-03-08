import 'package:amazon_clone/constants/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Stars extends StatelessWidget {
  final double rating;

  const Stars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      itemCount: 5,
      rating: rating,
      direction: Axis.horizontal,
      itemSize: 15,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: GlobalVariables.secondaryColor,
      ),
    );
  }
}
