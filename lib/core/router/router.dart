import 'package:flutter/material.dart';
import 'package:myid_scan/view/authentication/login.dart';
import 'package:myid_scan/view/authentication/register.dart';
import 'package:myid_scan/view/home/home.dart';
import 'package:myid_scan/view/home/views/create_card.dart';
import 'package:myid_scan/view/home/views/preview.dart';
import 'package:myid_scan/view/home/views/profile.dart';
import 'package:myid_scan/view/home/views/save_cards.dart';
import 'package:myid_scan/view/home/views/scan.dart';
import 'package:myid_scan/view/home/views/templates.dart';
import 'package:myid_scan/view/home/views/view_template.dart';
import 'package:myid_scan/view/splash/get_started.dart';

class AppRouter {
  static const String signUp = '/signup';
  static const String login = '/login';
  static const String home = '/home';
  static const String getStarted = '/getStarted';
  static const String createCard = '/createCard';
  static const String templates = 'template';
  static const String viewTemp = 'viewtemplates';
  static const String preview = 'preview';
  static const String scan = 'scan';
  static const String profile = 'profile';
  static const String savedCards = 'savedCards';
  static final Map<String, Widget Function(BuildContext)> _routes = {
    signUp: (context) => const Register(),
    login: (context) => const Login(),
    getStarted: (context) => const GetStarted(),
    home: (context) => const Home(),
    scan: (context) => const Scan(),
    createCard: (context) => const CreateCard(),
    preview: (context) => const PreviewCard(),
    templates: (context) => const Templates(),
    viewTemp: (context) => const ViewTemplate(),
    profile: (context) => const Profile(),
    savedCards: (context) => const SaveCards(),
  };

  static Map<String, Widget Function(BuildContext)> get routes => _routes;
}
