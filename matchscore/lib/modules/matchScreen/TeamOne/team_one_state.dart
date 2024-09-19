part of 'team_one_cubit.dart';

@immutable
sealed class TeamOneState {}

final class TeamOneInitial extends TeamOneState {}

class IncrementScore extends TeamOneState{}

class IncrementYellow extends TeamOneState{}

class IncrementRed extends TeamOneState{}

class IncrementSub extends TeamOneState{}

class Reset extends TeamOneState{}