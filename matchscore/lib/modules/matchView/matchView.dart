import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matchscore/modules/matchScreen/TeamOne/team_one_cubit.dart';
import 'package:matchscore/modules/matchScreen/TeamTwo/team_two_cubit.dart';
import 'package:matchscore/modules/widgets/teamItem.dart';
import 'package:matchscore/utils/constants.dart';

class MatchView extends StatelessWidget {
  const MatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TeamOneCubit>(create: (context) => TeamOneCubit()),
        BlocProvider<TeamTwoCubit>(create: (context) => TeamTwoCubit())
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Match',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<TeamOneCubit, TeamOneState>(
                    builder: (context, state) {
                      var cubit = TeamOneCubit.get(context);
                      return TeamItem(
                        score: cubit.score,
                        yellowCard: cubit.yellow,
                        redCard: cubit.red,
                        substitution: cubit.substitution,
                        teams: Teams.barcelona,
                        redOnTap: context.read<TeamOneCubit>().redCard,
                        yellowOnTap: context.read<TeamOneCubit>().yellowCard,
                        scoreOnTap: context.read<TeamOneCubit>().goalScore,
                        subOnTap: context.read<TeamOneCubit>().substitutionMade,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  height: 360,
                  width: 3,
                  color: Colors.grey,
                ),
                Expanded(
                  child: BlocBuilder<TeamTwoCubit, TeamTwoState>(
                    builder: (context, state) {
                      var cubit = TeamTwoCubit.get(context);
                      return TeamItem(
                        score: cubit.score,
                        yellowCard: cubit.yellow,
                        redCard: cubit.red,
                        substitution: cubit.substitution,
                        teams: Teams.realMadrid,
                        redOnTap: context.read<TeamTwoCubit>().redCard,
                        yellowOnTap: context.read<TeamTwoCubit>().yellowCard,
                        scoreOnTap: context.read<TeamTwoCubit>().goalScore,
                        subOnTap: context.read<TeamTwoCubit>().substitutionMade,
                      );
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 70,
            ),
            BlocBuilder<TeamOneCubit, TeamOneState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<TeamOneCubit>().resetAll();
                    context.read<TeamTwoCubit>().resetAll();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
