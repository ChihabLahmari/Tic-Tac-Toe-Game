import 'package:flutter/material.dart';
import 'package:xo_game/presentation/game_screen/view/game.dart';
import 'package:xo_game/presentation/resources/assets_manager.dart';

import '../resources/app_size.dart';
import '../resources/app_strings.dart';
import '../resources/color_manager.dart';

class EnterPlayersNameScreen extends StatelessWidget {
  const EnterPlayersNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController player1NameController = TextEditingController();
    TextEditingController player2NameController = TextEditingController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSize.s15, vertical: AppSize.s60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    AppStrings.enterPlayersName,
                    style: TextStyle(
                      fontSize: AppSize.s30,
                      fontWeight: FontWeight.w700,
                      color: ColorManager.yellow,
                    ),
                  ),
                  const SizedBox(height: AppSize.s60),
                  addPlayerName(player1NameController, IconsAssets.xIcon, 1),
                  addPlayerName(player2NameController, IconsAssets.oIcon, 2),
                  Container(
                    height: AppSize.s60,
                    width: AppSize.s250,
                    decoration: BoxDecoration(
                      color: ColorManager.yellow,
                      borderRadius: BorderRadius.circular(AppSize.s50),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameView(
                                playerName1: player1NameController.text.isNotEmpty
                                    ? player1NameController.text
                                    : "Player 1",
                                playerName2: player2NameController.text.isNotEmpty
                                    ? player2NameController.text
                                    : "Player 1",
                              ),
                            ));
                      },
                      child: const Center(
                        child: Text(
                          AppStrings.newGame,
                          style: TextStyle(
                            color: ColorManager.darkPurple,
                            fontSize: AppSize.s30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column addPlayerName(TextEditingController player1NameController, String icon, int playerId) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: AppSize.s60),
            SizedBox(
              height: 50,
              width: 50,
              child: Image.asset(icon),
            ),
            const SizedBox(
              width: AppSize.s15,
            ),
            Text(
              playerId == 1 ? AppStrings.player1 : AppStrings.player2,
              style: const TextStyle(
                color: ColorManager.white,
                fontSize: AppSize.s25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSize.s15),
        SizedBox(
          height: AppSize.s100,
          width: AppSize.s200,
          child: TextField(
            controller: player1NameController,
            decoration: const InputDecoration(
              filled: true,
              fillColor: ColorManager.white,
              border: InputBorder.none,
              hintText: "Name",
            ),
          ),
        )
      ],
    );
  }
}
