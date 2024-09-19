import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum Teams {
  barcelona(
    teamName: 'Fc Barcelona',
    logo: Const.barcelonaLogo,
    teamColor: Colors.red,
  ),
  realMadrid(
    teamName: 'Real Madrid',
    logo: Const.realMadridLogo,
    teamColor: Colors.white,
  );

  const Teams({
    required this.teamName,
    required this.logo,
    required this.teamColor,
  });
  final String teamName;
  final String logo;
  final Color teamColor;
}

class Const {
  static const barcelonaLogo = 'assets/logos/FC_Barcelona_logo.png';
  static const realMadridLogo = 'assets/logos/real-madrid-cf-logo.png';
  static const redCardSvg = 'assets/svg/amonestation-football-red.svg';
  static const yellowCardSvg = 'assets/svg/amonestation-football-yellow.svg';
  static const substitutionSvg = 'assets/svg/football-game-player-soccer-subsitutions.svg';
}
