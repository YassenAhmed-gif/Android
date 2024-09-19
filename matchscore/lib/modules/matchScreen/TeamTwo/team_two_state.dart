part of 'team_two_cubit.dart';

@immutable
sealed class TeamTwoState {}

final class TeamTwoInitial extends TeamTwoState {}

class IncrementScore extends TeamTwoState {}

class IncrementYellow extends TeamTwoState {}

class IncrementRed extends TeamTwoState {}

class IncrementSub extends TeamTwoState {}

class Reset extends TeamTwoState {}