import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Colors.grey.shade400,
        child: Container(
          padding:const EdgeInsets.all(10),
          margin:const EdgeInsets.all(10),
          width: size.width*0.8,
          height: size.width*0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
             
          ),
        ));
  }
}