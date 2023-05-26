import 'package:flutter/material.dart';
import 'package:xo_game/presentation/enter_players_name_screen/enter_players_name_screen.dart';
import 'package:xo_game/presentation/resources/app_size.dart';
import 'package:xo_game/presentation/resources/app_strings.dart';
import 'package:xo_game/presentation/resources/assets_manager.dart';

import '../resources/color_manager.dart';

class NewGameScreen extends StatelessWidget {
  const NewGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.symmetric(horizontal: AppSize.s15, vertical: AppSize.s60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppStrings.tictactoe,
                style: TextStyle(
                  fontSize: AppSize.s50,
                  fontWeight: FontWeight.w800,
                  color: ColorManager.yellow,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: AppSize.s300,
                    width: AppSize.s150,
                    child: Image.asset(IconsAssets.xIcon),
                  ),
                  const SizedBox(
                    width: AppSize.s30,
                  ),
                  SizedBox(
                    height: AppSize.s300,
                    width: AppSize.s150,
                    child: Image.asset(IconsAssets.oIcon),
                  ),
                ],
              ),
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
                        builder: (context) => const EnterPlayersNameScreen(),
                      ),
                    );
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
              const SizedBox(
                height: AppSize.s15,
              ),
              Container(
                height: AppSize.s60,
                width: AppSize.s250,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSize.s50),
                    border: Border.all(
                      color: ColorManager.yellow,
                      width: AppSize.s4,
                    )),
                child: const Center(
                  child: Text(
                    AppStrings.scores,
                    style: TextStyle(
                      color: ColorManager.white,
                      fontSize: AppSize.s30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
