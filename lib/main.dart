import 'package:arabicchurch/admin_screen.dart';
import 'package:arabicchurch/drawer.dart';
import 'package:arabicchurch/leader_screen.dart';
import 'package:arabicchurch/model/user_preferences.dart';
import 'package:arabicchurch/notifications.dart';
import 'package:arabicchurch/services/data_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Arabic church',
      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: new HomePage(),
//     TODO new HomeScreen(),
//     TODO     new DrawerDemo(),
    );
  }
}

//class HomeScreenRoute extends MaterialPageRoute<String> {
//  HomeScreenRoute()
//      : super(
//            fullscreenDialog: false,
//            builder: (BuildContext context) =>
//                new Card(child: new AdminScreen()));
//}
//
//class WelcomeScreenRoute extends MaterialPageRoute<String> {
//  WelcomeScreenRoute()
//      : super(
//            builder: (BuildContext context) =>
//                new Card(child: HomeScreenState.createWelcomeScreen()));
//}
//
//class HomeScreen extends StatefulWidget {
//  @override
//  State createState() => new HomeScreenState();
//}
//
//class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//  final _analytics = new FirebaseAnalytics();
//
//  //TODO static String _ccbText = '';
//
//  final Map<Tab, Widget> myTabs = {
//    new Tab(text: 'Welcome'): createWelcomeScreen(),
//    new Tab(text: 'Calendar'): new Center(child: new Notifications()),
//    //TODO new Tab(text: 'CCB'): new Center(child: new Text(_ccbText))
//  };
//
//  TabController _tabController;
//  TabBar _tabBar;
//
//  @override
//  void initState() {
//    super.initState();
//    _tabController = new TabController(vsync: this, length: myTabs.length);
//    _tabBar =
//        new TabBar(controller: _tabController, tabs: myTabs.keys.toList());
//
//    DataService service = new DataService();
//    service.initialize().then((_) {
//      service.loadComplete.future.then(_updateTabs).catchError(() => _analytics
//              .logEvent(name: 'login_error', parameters: {
//            'username': new DataService().userPreferences.userName
//          }));
//    });
//
//    /*TODO post().then((str) {
//      setState(() {
//        _ccbText = str;
//      });
//    });*/
//  }
//
//  void _updateTabs(UserPreferences user) {
//    int numTabs = myTabs.length;
//    setState(() {
//      var user = new DataService().userPreferences;
//
//      if (user.leadGroups.isNotEmpty) {
//        myTabs.putIfAbsent(new Tab(text: 'Leader'),
//            () => new Center(child: new LeaderScreen()));
//      }
//
//      if (user.isAdmin) {
//        myTabs.putIfAbsent(
//            new Tab(text: 'Admin'),
//            () =>
//                new Center(child: new Builder(builder: (BuildContext context) {
//                  return new Center(child: new AdminScreen());
//                })));
//      }
//
//      if (numTabs != myTabs.length) {
//        _tabController = new TabController(vsync: this, length: myTabs.length);
//        _tabBar =
//            new TabBar(controller: _tabController, tabs: myTabs.keys.toList());
//      }
//    });
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//  }
//
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        appBar: new AppBar(title: new Text('Arabic church'), bottom: _tabBar),
//        body: new Builder(builder: (BuildContext context) {
//          return new Center(
//              child: new TabBarView(
//                  controller: _tabController,
//                  children: myTabs.values.toList()));
//        }));
//  }
//
//}
