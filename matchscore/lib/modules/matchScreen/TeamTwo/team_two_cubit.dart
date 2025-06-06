import 'package:meta/meta.dart';
// make sure to install 'bloc' first!
import 'package:flutter_bloc/flutter_bloc.dart';

part 'team_two_state.dart';

class TeamTwoCubit extends Cubit<TeamTwoState> {
  TeamTwoCubit() : super(TeamTwoInitial());
  static TeamTwoCubit get(context) => BlocProvider.of(context);

  int score = 0;
  int yellow = 0;
  int red = 0;
  int substitution = 0;

  void goalScore(){
    score++;
    emit(IncrementScore());
  }

  void yellowCard(){
    yellow++;
    emit(IncrementYellow());
  }

  void redCard(){
    red++;
    emit(IncrementRed());
  }

  void substitutionMade(){
    substitution++;
    emit(IncrementSub());
  }

  void resetAll(){
    score = yellow = red = substitution = 0;
    emit(Reset());
  }
}
