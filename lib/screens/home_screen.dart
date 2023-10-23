import 'package:flutter/material.dart';
import 'package:orthoscan2/widgets/category_item.dart';
import 'package:orthoscan2/widgets/side_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const routeName='/home-screen';
  HomeScreen(
    this.toggleAppTheme,
    this.themeBrightness,
    );
  Brightness themeBrightness;
  void Function() toggleAppTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "OrthoScan",
            ),
          actions: [
              IconButton(
                onPressed: toggleAppTheme,
                icon: Icon(
                  themeBrightness == Brightness.dark ?
                  Icons.dark_mode :
                  Icons.light_mode,
                  ),
                ),
          ],  
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
            Expanded(              
              flex: 1,
              child: Container(
                // constraints: const BoxConstraints(
                //   maxHeight: 270,
                //   minHeight: 150,
                //   maxWidth: 900,
                //   minWidth: 300,
                // ),
                // height: 150,
                // width: 300,
                padding: const EdgeInsets.all(10),
                child: PageView(
                  // padEnds: false,
                  pageSnapping: true,
                  controller: PageController(viewportFraction: 0.9),
                  // scrollDirection: Axis.horizontal,
                  children: [
                   _pageViewItem(
                      imageUrl: "https://i0.wp.com/post.medicalnewstoday.com/wp-content/uploads/sites/3/2021/11/plantar_fasciitis_GettyImages1305836714_Thumb-732x549.jpg?w=756&h=567",
                      titleText: "Discover Your Foot Health",
                      subtitleText: "Identify and Improve Your Feet's Condition"
                      ),
                   _pageViewItem(
                      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfBGRaAjqmWVTH5pEsPL36lNriPVJ5JCHkg9MeXXdHcdpOJkKZND5GumBq_fF4gqjAB5w&usqp=CAU",
                      titleText: "Flat Feet? Find Out Now!",
                      subtitleText: "Assess Your Foot Arch with our Advanced Tool"
                      ),
                   _pageViewItem(
                      imageUrl: "https://images.ctfassets.net/hjcv6wdwxsdz/1AKTXAJYcLZuM2oOzQIfM4/651a435fa19bd30cc91cc2bac81620aa/Man-touching-his-toes-while-stretching-his-leg-sitting-on-yoga-mat.jpg?w=2048&h=1366&fl=progressive&q=50&fm=jpg",
                      titleText: "Are Your Knees Aligned?",
                      subtitleText: "Evaluate Your Knee Alignment Instantly"
                      ),
                   _pageViewItem(
                      imageUrl: "https://assets.poplar.studio/wp-content/uploads/2021/10/15105559/unnamed-54.png",
                      titleText: "Exercise in Augmented Reality",
                      subtitleText: "Experience Engaging Workouts Anywhere, Anytime"
                      ),
                   _pageViewItem(
                      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS15bTAi8me4zhJV9899xIBGwg3S8urDk8ULg&usqp=CAU",
                      titleText: "Monitor Your Health Journey",
                      subtitleText: "Visualize Your Improvement Over Time"
                      ),
                  ],                 
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    CategoryItem(
                      "https://i.pinimg.com/564x/55/1f/82/551f82e73017b0f640bf424c91dc6571.jpg",
                      "Flat Feet Detection",
                    ),
                    const SizedBox(height: 7,),
                    CategoryItem(
                      "https://i.pinimg.com/564x/b9/24/4d/b9244d2a676bd6841d4c8918b5148236.jpg",
                      "Knock Knee Detection",
                    ),
                    const SizedBox(height: 7,),
                    CategoryItem(
                      "https://i.pinimg.com/736x/ed/4a/57/ed4a57e908434b2b53f9f2c8fcbb7ded.jpg",
                      "Interactive Exercises",
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )
              )
        
          ],),
        )
      );
  }
}

class _pageViewItem extends StatelessWidget {
 _pageViewItem(
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
                  opacity: 0.2,
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