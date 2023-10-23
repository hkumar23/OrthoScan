import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  CategoryItem(
    this.imageUrl,
    this.titleText,
    );

  final String imageUrl;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Card(       
              elevation: 3,             
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Container(                      
                   // constraints: BoxConstraints(
                   //   maxHeight: 400,
                   //   maxWidth: 800,
                   // ),
                constraints: BoxConstraints(
                  maxHeight: 250,
                  minHeight: 200,
                  maxWidth: 800,
                  minWidth: 250,
                ),
                height: 200,
                width: 300,
                alignment: Alignment.center,
                child: Column(children: [
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: ClipRRect(      
                        borderRadius: BorderRadius.circular(12),                                                                                
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          ),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      titleText,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    )
                ],),
                ),
            );
  }
}