import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:orthoscan2/knock_knee_detection/vision_detector_views/pose_detector_view.dart';
import 'package:orthoscan2/screens/exercise_screen.dart';
import 'package:orthoscan2/screens/problem_detection_screen.dart';
import 'package:orthoscan2/utils/exercise_type.dart';
import 'package:orthoscan2/widgets/banner_item.dart';
import 'package:orthoscan2/widgets/category_item.dart';
import 'package:orthoscan2/widgets/side_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';
  HomeScreen(this.toggleAppTheme, this.themeBrightness, {super.key});
  Brightness themeBrightness;
  void Function() toggleAppTheme;
  final bannerItemsList = [
    // BannerItem(
    //     imageUrl:
    //         "https://i0.wp.com/post.medicalnewstoday.com/wp-content/uploads/sites/3/2021/11/plantar_fasciitis_GettyImages1305836714_Thumb-732x549.jpg?w=756&h=567",
    //     titleText: "Discover Your Foot Health",
    //     subtitleText: "Identify and Improve Your Feet's Condition"),
    // BannerItem(
    //     imageUrl:
    //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfBGRaAjqmWVTH5pEsPL36lNriPVJ5JCHkg9MeXXdHcdpOJkKZND5GumBq_fF4gqjAB5w&usqp=CAU",
    //     titleText: "Flat Feet? Find Out Now!",
    //     subtitleText: "Assess Your Foot Arch with our Advanced Tool"),
    BannerItem(
        imageUrl:
            "https://images.ctfassets.net/hjcv6wdwxsdz/1AKTXAJYcLZuM2oOzQIfM4/651a435fa19bd30cc91cc2bac81620aa/Man-touching-his-toes-while-stretching-his-leg-sitting-on-yoga-mat.jpg?w=2048&h=1366&fl=progressive&q=50&fm=jpg",
        titleText: "Are Your Knees Aligned?",
        subtitleText: "Evaluate Your Knee Alignment Instantly"),
    BannerItem(
        imageUrl:
            "https://assets.poplar.studio/wp-content/uploads/2021/10/15105559/unnamed-54.png",
        titleText: "Exercise in Augmented Reality",
        subtitleText: "Experience Engaging Workouts Anywhere, Anytime"),
    BannerItem(
        imageUrl:
            "https://www.solutionanalysts.com/blog/wp-content/uploads/2021/05/users-of-health-and-fitness-apps.jpg",
        titleText: "Monitor Your Health Journey",
        subtitleText: "Visualize Your Improvement Over Time"),
    BannerItem(
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzIDRmrWalJ3Aj-KOSKr9OcOecSuICNJ6c5_e6-QNLVQ&s",
        titleText: "Correct Your Knock Knees",
        subtitleText: "Achieve Proper Alignment with Interactive Exercises"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const SideDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo/logo_orthoScan.png",
                height: 40,
              ),
              const Text(
                "OrthoScan",
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: toggleAppTheme,
              icon: Icon(
                themeBrightness == Brightness.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: ListView(
            children: [
              Container(
                  // constraints: const BoxConstraints(
                  //   maxHeight: 270,
                  //   minHeight: 150,
                  //   maxWidth: 900,
                  //   minWidth: 300,
                  // ),
                  height: MediaQuery.of(context).size.height * 0.30,
                  padding: const EdgeInsets.all(10),
                  child: CarouselSlider(
                    items: bannerItemsList,
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 1.8,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                  )
                  // PageView(
                  //   pageSnapping: true,
                  //   controller: PageController(viewportFraction: 0.9),
                  //   children: bannerItemsList,
                  // ),
                  ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    // GestureDetector(
                    //   onTap: () => Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //         builder: (context) => PoseDetectorView()),
                    //   )
                    //   // Navigator.pushNamed(
                    //   //   context,
                    //   //   ProblemDetectionScreen.routeName,
                    //   //   arguments:"Flat Feet Detection",
                    //   //   );
                    //   ,
                    //   child: CategoryItem(
                    //     "https://i.pinimg.com/564x/55/1f/82/551f82e73017b0f640bf424c91dc6571.jpg",
                    //     "Flat Feet Detection",
                    //   ),
                    // // ),
                    // const SizedBox(
                    //   height: 7,
                    // ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PoseDetectorView(
                              isExercise: false,
                              title: "Knock Knee Detection",
                              exerciseType: ExcerciseType.notSelected,
                            ),
                          ),
                        );
                      },
                      child: const CategoryItem(
                        "https://i.pinimg.com/564x/b9/24/4d/b9244d2a676bd6841d4c8918b5148236.jpg",
                        "Knock Knee Detection",
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ExerciseScreen()));
                      },
                      child: const CategoryItem(
                        "https://i.pinimg.com/736x/ed/4a/57/ed4a57e908434b2b53f9f2c8fcbb7ded.jpg",
                        "Interactive Exercises",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
