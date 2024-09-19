import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matchscore/utils/constants.dart';

class TeamItem extends StatelessWidget {
  const TeamItem({
    super.key,
    required this.teams,
    this.redCard = 0,
    this.score = 0,
    this.yellowCard = 0,
    this.substitution = 0,
    required this.redOnTap,
    required this.yellowOnTap,
    required this.scoreOnTap,
    required this.subOnTap,
  });
  final Teams teams;
  final int yellowCard;
  final int redCard;
  final int substitution;
  final int score;
  final VoidCallback scoreOnTap;
  final VoidCallback yellowOnTap;
  final VoidCallback redOnTap;
  final VoidCallback subOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 70,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              teams.logo,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          teams.teamName,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Center(
          child: Text(
            score.toString(),
            style: TextStyle(
                fontSize: 38, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Expanded(
              child: buildIcons(
                  svgUrl: Const.yellowCardSvg,
                  value: yellowCard,
                  iconFunction: yellowOnTap),
            ),
            Expanded(
              child: buildIcons(
                svgUrl: Const.redCardSvg,
                value: redCard,
                iconFunction: redOnTap,
              ),
            ),
            Expanded(
              child: buildIcons(
                svgUrl: Const.substitutionSvg,
                value: substitution,
                iconFunction: subOnTap,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        ElevatedButton(
          onPressed: scoreOnTap,
          style: ElevatedButton.styleFrom(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: teams.teamColor,
            foregroundColor: Colors.white,
          ),
          child: Text(
            'New Goal',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }

  Row buildIcons({
    required String svgUrl,
    required int value,
    required VoidCallback iconFunction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: IconButton(
            icon: SvgPicture.asset(
              svgUrl,
              height: 40,
              width: 40,
            ),
            onPressed: iconFunction,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
