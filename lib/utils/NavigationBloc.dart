import 'package:bloc/bloc.dart';
import 'package:colfunding/src/projects/views/ListProjectsProcess.dart';
import 'package:colfunding/src/projects/views/MyInvestments.dart';
import 'package:colfunding/src/projects/views/SupportedProjects.dart';
import 'package:colfunding/src/projects/views/myProjects.dart';
import 'package:colfunding/src/users/views/ChangePassword.dart';
import 'package:colfunding/src/users/views/UpdateUser.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  EditProfileClickedEvent,
  ChangePasswordClickedEvent,
  MyInvestmentsClikedEvent,
  MyProjectsClickedEvent,
  MyActivityClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => MyHome();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield MyHome();
        break;
      case NavigationEvents.EditProfileClickedEvent:
        yield UpdateUser();
        break;
      case NavigationEvents.ChangePasswordClickedEvent:
        yield PageChangePassword();
        break;
      case NavigationEvents.MyInvestmentsClikedEvent:
        yield MyInvestments();
        break;
      case NavigationEvents.MyProjectsClickedEvent:
        yield MyProjects();
        break;
      case NavigationEvents.MyActivityClickedEvent:
        yield SupportedProjects();
        break;
    }
  }
}