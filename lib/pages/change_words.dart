import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/utils/get_remaining_words.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/banner_ad_widget.dart';
import 'package:hang7/widgets/check_remaining_words.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeWordPack extends StatefulWidget {
  const ChangeWordPack({Key? key}) : super(key: key);

  @override
  State<ChangeWordPack> createState() => _ChangeWordPackState();
}

class _ChangeWordPackState extends State<ChangeWordPack> {
  List<String> myWordPacks = ["WordPack 1"];
  List<String> availablePacks = [];
  BannerAdContainer bannerAdContainer = const BannerAdContainer();
  late SharedPreferences prefs;

  List<String> wordPacks = [
    "WordPack 2",
    "WordPack 3",
    "WordPack 4",
    "WordPack 5",
    "WordPack 6",
    "WordPack 7",
    "WordPack 8",
    "WordPack 9",
    "WordPack 10",
  ];

  int coins = 0;
  final myWordScrollController = ScrollController();
  final wordScrollController = ScrollController();

  selectWordPack(int index) {
    var settProv = Provider.of<SettingsProvider>(context, listen: false);
    setState(() {
      settProv.setWordPack(availablePacks[index]);
      if (!myWordPacks.contains(availablePacks[index])) {
        myWordPacks.add(availablePacks[index]);
        settProv.setMyWordPacks(myWordPacks);
      }
      remainingWords = getMyWordPackRemainingWords(context);
    });
  }

  List<String> remainingWords = [];

  getSPInstance() async {
    prefs = await SharedPreferences.getInstance();
  }

  getData(BuildContext context) {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    coins = settingsProvider.coins;
    debugPrint("change_words: coins $coins");
    myWordPacks = settingsProvider.myWordPacks as List<String>;
    debugPrint(myWordPacks.toString());
    availablePacks =
        wordPacks.where((element) => !myWordPacks.contains(element)).toList();
  }

  @override
  void initState() {
    super.initState();
    getSPInstance();

    getData(context);
    remainingWords = getMyWordPackRemainingWords(context);

    debugPrint("game initState  remainingWords $remainingWords");
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    debugPrint('currentPack: ${settingsProvider.wordPack}');
    debugPrint("change_words build remainaingWords $remainingWords");
    return OrientationBuilder(builder: (context, orientation) {
      return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.backgroundColor, AppColors.lightGray])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.lightGray,
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                  AppColors.lightGray,
                  AppColors.backgroundColor,
                ]))),
            toolbarHeight: SizeConfig.blockSizeVertical * 8,
            title: Text(
              "Change My Word Pack",
              style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: orientation == Orientation.portrait
                      ? SizeConfig.blockSizeHorizontal * 7
                      : SizeConfig.blockSizeVertical * 6),
            ),
          ),
          body: Consumer<Controller>(builder: (_, notifier, __) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("My Word Packs:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: notifier.isPhone
                              ? SizeConfig.blockSizeVertical * 4
                              : orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeVertical * 5
                                  : SizeConfig.blockSizeVertical * 4,
                        )),
                  ),
                  Text(
                    "Default (WordPack 1) and all purchased packs.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: notifier.isPhone
                          ? SizeConfig.blockSizeVertical * 2
                          : orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 3
                              : SizeConfig.blockSizeVertical * 2,
                    ),
                  ),
                  Text(
                    "Current WordPack is outlined.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: notifier.isPhone
                          ? SizeConfig.blockSizeVertical * 2
                          : orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 3
                              : SizeConfig.blockSizeVertical * 2,
                    ),
                  ),
                  Text(
                    "Once all the words are used, repurchase for 100 coins.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: notifier.isPhone
                          ? SizeConfig.blockSizeVertical * 2
                          : orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 3
                              : SizeConfig.blockSizeVertical * 2,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 2)),
                    height: orientation == Orientation.portrait
                        ? SizeConfig.blockSizeVertical * 13
                        : SizeConfig.blockSizeVertical * 12,
                    alignment: Alignment.center,
                    child: Scrollbar(
                      controller: myWordScrollController,
                      thumbVisibility: true,
                      thickness: 3,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          controller: myWordScrollController,
                          itemCount: myWordPacks.length,
                          itemBuilder: (context, index) {
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppColors.green,
                                        AppColors.lightGray,
                                        AppColors.green
                                      ]),
                                  borderRadius: BorderRadius.circular(6),
                                  border: settingsProvider.wordPack ==
                                          myWordPacks[index]
                                      ? Border.all(
                                          color: AppColors.darkBlue, width: 3)
                                      : Border.all(
                                          color: Colors.transparent, width: 2),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          int r =
                                              int.parse(remainingWords[index]);
                                          if (r == 0) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: coins >= 100
                                                        ? Text(
                                                            "You have used all the words in this pack. Reset for 100 coins?",
                                                            style: TextStyle(
                                                              fontSize: orientation ==
                                                                      Orientation
                                                                          .portrait
                                                                  ? SizeConfig
                                                                          .blockSizeVertical *
                                                                      2
                                                                  : SizeConfig
                                                                          .blockSizeVertical *
                                                                      3,
                                                            ),
                                                          )
                                                        : Text(
                                                            "You need 100 coins to reset this pack.",
                                                            style: TextStyle(
                                                              fontSize: orientation ==
                                                                      Orientation
                                                                          .portrait
                                                                  ? SizeConfig
                                                                          .blockSizeVertical *
                                                                      2
                                                                  : SizeConfig
                                                                          .blockSizeVertical *
                                                                      3,
                                                            ),
                                                          ),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              if (coins >=
                                                                  100) {
                                                                coins =
                                                                    coins - 100;
                                                                settingsProvider
                                                                    .setCoins(
                                                                        coins);
                                                                resetMyWordPackRemainingWords(
                                                                    context,
                                                                    myWordPacks[
                                                                        index]);
                                                                settingsProvider
                                                                    .setWordPack(
                                                                        myWordPacks[
                                                                            index]);
                                                                remainingWords =
                                                                    getMyWordPackRemainingWords(
                                                                        context);
                                                              }
                                                            });

                                                            Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                pageBuilder: (c,
                                                                        a1,
                                                                        a2) =>
                                                                    const ChangeWordPack(),
                                                                transitionsBuilder: (c,
                                                                        anim,
                                                                        a2,
                                                                        child) =>
                                                                    FadeTransition(
                                                                        opacity:
                                                                            anim,
                                                                        child:
                                                                            child),
                                                                transitionDuration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            50),
                                                              ),
                                                            );
                                                          },
                                                          child: Text(
                                                            "OK",
                                                            style: TextStyle(
                                                              fontSize: orientation ==
                                                                      Orientation
                                                                          .portrait
                                                                  ? SizeConfig
                                                                          .blockSizeVertical *
                                                                      2
                                                                  : SizeConfig
                                                                          .blockSizeVertical *
                                                                      3,
                                                            ),
                                                          )),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                              fontSize: orientation ==
                                                                      Orientation
                                                                          .portrait
                                                                  ? SizeConfig
                                                                          .blockSizeVertical *
                                                                      2
                                                                  : SizeConfig
                                                                          .blockSizeVertical *
                                                                      3,
                                                            ),
                                                          ))
                                                    ],
                                                  );
                                                });
                                          } else {
                                            settingsProvider.setWordPack(
                                                myWordPacks[index]);
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              myWordPacks[index],
                                              style: TextStyle(
                                                fontSize: orientation ==
                                                        Orientation.portrait
                                                    ? SizeConfig
                                                            .blockSizeVertical *
                                                        2
                                                    : SizeConfig
                                                            .blockSizeVertical *
                                                        3,
                                              ),
                                            ),
                                            if (remainingWords.length ==
                                                myWordPacks.length)
                                              Text(
                                                "${remainingWords[index]} words left",
                                                style: TextStyle(
                                                  fontSize: orientation ==
                                                          Orientation.portrait
                                                      ? SizeConfig
                                                              .blockSizeVertical *
                                                          1.75
                                                      : SizeConfig
                                                              .blockSizeVertical *
                                                          1.5,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("Available WordPacks",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: notifier.isPhone
                              ? SizeConfig.blockSizeVertical * 4
                              : orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeVertical * 5
                                  : SizeConfig.blockSizeVertical * 5,
                        )),
                  ),
                  Text(
                    "Each word pack contains 50 random words.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: notifier.isPhone
                          ? SizeConfig.blockSizeVertical * 2
                          : orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 3
                              : SizeConfig.blockSizeVertical * 3,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Purchase for 500 coins.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: notifier.isPhone
                            ? SizeConfig.blockSizeVertical * 2
                            : orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 3
                                : SizeConfig.blockSizeVertical * 3,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 12,
                    child: Scrollbar(
                      controller: wordScrollController,
                      thumbVisibility: true,
                      thickness: 3,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: wordScrollController,
                          itemCount: availablePacks.length,
                          itemBuilder: ((context, index) {
                            return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (() {
                                    debugPrint("tapped index: $index");

                                    myWordPacks.contains(availablePacks[index])
                                        ? null
                                        : showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: coins > 500
                                                    ? Text(
                                                        "Buy ${availablePacks[index]} for 500 coins?",
                                                        style: TextStyle(
                                                          fontSize: notifier
                                                                  .isPhone
                                                              ? SizeConfig
                                                                      .blockSizeHorizontal *
                                                                  6
                                                              : orientation ==
                                                                      Orientation
                                                                          .portrait
                                                                  ? SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      4
                                                                  : SizeConfig
                                                                          .blockSizeVertical *
                                                                      4,
                                                        ),
                                                      )
                                                    : Text(
                                                        "You don't have enough coins! Keep playing to win more.",
                                                        style: TextStyle(
                                                          fontSize: notifier
                                                                  .isPhone
                                                              ? SizeConfig
                                                                      .blockSizeHorizontal *
                                                                  6
                                                              : orientation ==
                                                                      Orientation
                                                                          .portrait
                                                                  ? SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      4
                                                                  : SizeConfig
                                                                          .blockSizeVertical *
                                                                      4,
                                                        ),
                                                      ),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: coins >= 500
                                                          ? () {
                                                              setState(() {
                                                                coins =
                                                                    coins - 500;
                                                                settingsProvider
                                                                    .setCoins(
                                                                        coins);

                                                                selectWordPack(
                                                                    index);
                                                              });
                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  pageBuilder: (c,
                                                                          a1,
                                                                          a2) =>
                                                                      const ChangeWordPack(),
                                                                  transitionsBuilder: (c,
                                                                          anim,
                                                                          a2,
                                                                          child) =>
                                                                      FadeTransition(
                                                                          opacity:
                                                                              anim,
                                                                          child:
                                                                              child),
                                                                  transitionDuration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              50),
                                                                ),
                                                              );
                                                            }
                                                          : () {
                                                              // Go Back
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                      child: coins >= 500
                                                          ? Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                fontSize: notifier
                                                                        .isPhone
                                                                    ? SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        4
                                                                    : orientation ==
                                                                            Orientation
                                                                                .portrait
                                                                        ? SizeConfig.blockSizeHorizontal *
                                                                            3
                                                                        : SizeConfig.blockSizeVertical *
                                                                            3,
                                                              ),
                                                            )
                                                          : Text(
                                                              "OK",
                                                              style: TextStyle(
                                                                fontSize: notifier
                                                                        .isPhone
                                                                    ? SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        4
                                                                    : orientation ==
                                                                            Orientation
                                                                                .portrait
                                                                        ? SizeConfig.blockSizeHorizontal *
                                                                            3
                                                                        : SizeConfig.blockSizeVertical *
                                                                            3,
                                                              ),
                                                            )),
                                                  OutlinedButton(
                                                      onPressed: () {
                                                        // Go Back
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          fontSize: notifier
                                                                  .isPhone
                                                              ? SizeConfig
                                                                      .blockSizeHorizontal *
                                                                  4
                                                              : orientation ==
                                                                      Orientation
                                                                          .portrait
                                                                  ? SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      3
                                                                  : SizeConfig
                                                                          .blockSizeVertical *
                                                                      3,
                                                        ),
                                                      ))
                                                ],
                                              );
                                            });
                                  }),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.darkBlue,
                                                width: 1),
                                            gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  AppColors.green,
                                                  AppColors.lightGray,
                                                  AppColors.green,
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        width: notifier.isPhone
                                            ? SizeConfig.blockSizeHorizontal *
                                                28
                                            : SizeConfig.blockSizeHorizontal *
                                                20,
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Text(
                                            availablePacks[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: orientation ==
                                                        Orientation.portrait
                                                    ? SizeConfig
                                                            .blockSizeVertical *
                                                        2
                                                    : SizeConfig
                                                            .blockSizeVertical *
                                                        3),
                                          ),
                                        ))),
                                  ),
                                ));
                          })),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 5),
                      height: SizeConfig.blockSizeVertical * 8,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/images/BasketOfCoins.png"),
                        fit: BoxFit.scaleDown,
                      )),
                      child: Center(
                          child: Text(
                        coins.toString(),
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 6,
                        ),
                      ))),
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 10,
                              padding: EdgeInsets.all(
                                notifier.isPhone
                                    ? SizeConfig.blockSizeHorizontal * 2
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 2
                                        : SizeConfig.blockSizeVertical * 2,
                              ),
                            ),
                            onPressed: () {
                              settingsProvider.withAnimation
                                  ? Navigator.push(context,
                                      SlideLeftRoute(page: const Options()))
                                  : Navigator.push(context,
                                      FadeRoute(page: const Options()));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.blockSizeHorizontal * 3),
                              child: Text(
                                "Back to Options",
                                style: TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical * 3),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 10,
                              padding: EdgeInsets.all(
                                notifier.isPhone
                                    ? SizeConfig.blockSizeHorizontal * 2
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 2
                                        : SizeConfig.blockSizeVertical * 2,
                              ),
                            ),
                            onPressed: () {
                              checkRemainingWords(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.blockSizeHorizontal * 3),
                              child: Text(
                                "Play",
                                style: TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical * 3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
          bottomNavigationBar: bannerAdContainer,
          // bottomNavigationBar: Container(
          //   decoration: const BoxDecoration(
          //       color: Colors.transparent,
          //       border: Border(
          //           top: BorderSide(color: Colors.transparent, width: 2))),
          //   height: 60,
          // )
        ),
      );
    });
  }
}
