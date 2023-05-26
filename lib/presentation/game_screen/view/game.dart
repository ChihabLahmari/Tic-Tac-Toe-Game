// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:xo_game/presentation/resources/app_size.dart';
import 'package:xo_game/presentation/resources/app_strings.dart';
import 'package:xo_game/presentation/resources/assets_manager.dart';
import 'package:xo_game/presentation/resources/color_manager.dart';

class GameView extends StatefulWidget {
  String playerName1;
  String playerName2;

  GameView({
    Key? key,
    required this.playerName1,
    required this.playerName2,
  }) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(milliseconds: 800));
  }

  bool xTurn = true;
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];
  List<int> matchIndexes = [];
  bool firstGame = true;

  String resultDeclaration = '';
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  bool winnerFound = false;

  static const maxSeconds = 30;
  int seconds = 30;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    resetTimer();
  }

  void resetTimer() {
    seconds = maxSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorManager.lightPurple,
                    ColorManager.darkPurple,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s15, vertical: AppSize.s50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(
                      height: kBottomNavigationBarHeight,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        scoreContainer(IconsAssets.xIcon, xScore, widget.playerName1),
                        scoreContainer(IconsAssets.oIcon, oScore, widget.playerName2),
                      ],
                    ),
                    const SizedBox(height: AppSize.s20),
                    resultDeclaration.isNotEmpty
                        ? Column(
                            children: [
                              Text(
                                resultDeclaration,
                                style: const TextStyle(
                                  color: ColorManager.white,
                                  fontSize: AppSize.s30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          )
                        : const SizedBox(),
                    SizedBox(
                      width: double.infinity,
                      child: (timer == null ? false : timer!.isActive)
                          ? Center(
                              child: xTurn
                                  ? const Text(
                                      AppStrings.playerXturn,
                                      style: TextStyle(
                                        color: ColorManager.white,
                                        fontSize: AppSize.s30,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    )
                                  : const Text(
                                      AppStrings.playerOturn,
                                      style: TextStyle(
                                        color: ColorManager.white,
                                        fontSize: AppSize.s30,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                            )
                          : const SizedBox(),
                    ),
                    const SizedBox(height: AppSize.s20),
                    Expanded(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        // scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          // crossAxisSpacing: 10,
                          // mainAxisSpacing: 10,
                          // childAspectRatio: 1,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _tapped(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                // width: double.infinity,
                                // height: double.infinity,
                                decoration: BoxDecoration(
                                  color: matchIndexes.contains(index)
                                      ? ColorManager.white
                                      : ColorManager.darkPurple,
                                  borderRadius: BorderRadius.circular(AppSize.s20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSize.s25),
                                  child: displayXO[index] == AppStrings.x
                                      ? Image.asset(IconsAssets.xIcon)
                                      : displayXO[index] == AppStrings.o
                                          ? Image.asset(IconsAssets.oIcon)
                                          : const SizedBox(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSize.s20),
                    _buildTimer(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            colors: const [
              ColorManager.darkPurple,
              ColorManager.lightPurple,
              ColorManager.yellow,
              ColorManager.purple,
              ColorManager.white,
            ],
            blastDirection: -pi / 2,
            emissionFrequency: 0.1,
            numberOfParticles: 25,
            blastDirectionality: BlastDirectionality.explosive,
          ),
        )
      ],
    );
  }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;
    setState(() {
      if (!winnerFound && isRunning) {
        if (xTurn && displayXO[index] == '') {
          displayXO[index] = AppStrings.x;
          filledBoxes++;
        } else if (!xTurn && displayXO[index] == '') {
          displayXO[index] = AppStrings.o;
          filledBoxes++;
        }
        xTurn = !xTurn;

        _checkWinner();
      }
    });
  }

  void _checkWinner() {
    // Check 1st row
    if (displayXO[0] == displayXO[1] && displayXO[0] == displayXO[2] && displayXO[0] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[0].toUpperCase()} Wins";
        matchIndexes.addAll([0, 1, 2]);
        _updateScore(displayXO[0]);
        startConfetti();
      });
    }

    // Check 2nd row
    if (displayXO[3] == displayXO[4] && displayXO[3] == displayXO[5] && displayXO[3] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[3].toUpperCase()} Wins";
        matchIndexes.addAll([3, 4, 5]);

        _updateScore(displayXO[3]);
        startConfetti();
      });
    }

    // Check 3rd row
    if (displayXO[6] == displayXO[7] && displayXO[6] == displayXO[8] && displayXO[6] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[6].toUpperCase()} Wins";
        matchIndexes.addAll([6, 7, 8]);

        _updateScore(displayXO[6]);
        startConfetti();
      });
    }

    // Check 1st column
    if (displayXO[0] == displayXO[3] && displayXO[0] == displayXO[6] && displayXO[0] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[0].toUpperCase()} Wins";
        matchIndexes.addAll([0, 3, 6]);

        _updateScore(displayXO[0]);
        startConfetti();
      });
    }

    // Check 2nd column
    if (displayXO[1] == displayXO[4] && displayXO[1] == displayXO[7] && displayXO[1] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[1].toUpperCase()} Wins";
        matchIndexes.addAll([1, 4, 7]);

        _updateScore(displayXO[1]);
        startConfetti();
      });
    }

    // Check 3rd column
    if (displayXO[2] == displayXO[5] && displayXO[2] == displayXO[8] && displayXO[2] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[2].toUpperCase()} Wins";
        matchIndexes.addAll([2, 5, 8]);

        _updateScore(displayXO[2]);
        startConfetti();
      });
    }

    // Check 1st diagonal
    if (displayXO[0] == displayXO[4] && displayXO[0] == displayXO[8] && displayXO[0] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[0].toUpperCase()} Wins";
        matchIndexes.addAll([0, 4, 8]);

        _updateScore(displayXO[0]);
        startConfetti();
      });
    }

    // Check 2nd diagonal
    if (displayXO[2] == displayXO[4] && displayXO[2] == displayXO[6] && displayXO[2] != '') {
      setState(() {
        resultDeclaration = "Player ${displayXO[2].toUpperCase()} Wins";
        matchIndexes.addAll([2, 4, 6]);

        _updateScore(displayXO[2]);
        startConfetti();
      });
    }
    if (filledBoxes == 9 && !winnerFound) {
      setState(() {
        resultDeclaration = 'Nobody Wins';
        stopTimer();
      });
    }
  }

  void _updateScore(String winner) {
    if (winner == AppStrings.x) {
      xScore++;
      xTurn = false;
    } else if (winner == AppStrings.o) {
      oScore++;
      xTurn = true;
    }
    stopTimer();
    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      for (var i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
      resultDeclaration = "";
      filledBoxes = 0;
      winnerFound = false;
      matchIndexes = [];
    });
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;

    return isRunning
        ? SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  valueColor: const AlwaysStoppedAnimation(ColorManager.white),
                  strokeWidth: 8,
                  backgroundColor: ColorManager.yellow,
                ),
                Center(
                  child: Text(
                    '$seconds',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: AppSize.s40,
                    ),
                  ),
                ),
              ],
            ),
          )
        : startGameButtom();
  }

  Widget startGameButtom() {
    return InkWell(
      onTap: () {
        startTimer();
        _clearBoard();
        firstGame = false;
        matchIndexes = [];
      },
      child: Container(
        height: AppSize.s60,
        width: AppSize.s250,
        decoration: BoxDecoration(
          color: ColorManager.yellow,
          borderRadius: BorderRadius.circular(AppSize.s50),
        ),
        child: Center(
          child: Text(
            firstGame == true ? AppStrings.startGame : AppStrings.playAgain,
            style: const TextStyle(
              color: ColorManager.darkPurple,
              fontSize: AppSize.s30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  Widget scoreContainer(String image, int score, String name) {
    return Container(
      height: AppSize.s150,
      width: AppSize.s170,
      decoration: BoxDecoration(
        color: ColorManager.darkPurple,
        borderRadius: BorderRadius.circular(AppSize.s20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSize.s5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: AppSize.s100,
              width: AppSize.s50,
              child: Image.asset(image),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  name.isEmpty
                      ? AppStrings.player
                      : name.length > 7
                          ? name.substring(0, 6)
                          : name,
                  style: const TextStyle(
                    color: ColorManager.white,
                    fontSize: AppSize.s25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$score",
                  style: const TextStyle(
                    color: ColorManager.white,
                    fontSize: AppSize.s25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void startConfetti() {
    _confettiController.play();
  }
}
