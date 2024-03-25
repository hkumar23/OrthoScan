import 'package:flutter/material.dart';

class BannerItem extends StatelessWidget {
 BannerItem(
    {
      required this.imageUrl,
      required this.titleText,
      required this.subtitleText,
    }
  );
  final String imageUrl;
  final String titleText;
  final String subtitleText;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 7,vertical: 5),
      child: Container(   
        padding: const EdgeInsets.all(10),  
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                  alignment: Alignment.bottomCenter
              )
        ),                                                       
        width: double.infinity,
        child: Column(                          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleText,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                // color: Theme.of(context).colorScheme.,
              ),                              
            ),
            Text(
              subtitleText,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                // fontWeight: FontWeight.bold,
                // color: Theme.of(context).colorScheme.,
              ),
            )
        ]),
        // alignment: Alignment.center,
      ),
    );
  }
}