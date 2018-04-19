// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:arabicchurch/admin_screen.dart';
import 'package:arabicchurch/leader_screen.dart';
import 'package:arabicchurch/model/user.dart';
import 'package:arabicchurch/model/user_preferences.dart';
import 'package:arabicchurch/settings_screen.dart';
import 'package:arabicchurch/notifications.dart';
import 'package:arabicchurch/services/data_service.dart';
import 'package:arabicchurch/welcome_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

//TODO import 'package:arabicchurch/ccb.dart';
//TODO import 'package:arabicchurch/services/web_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class DrawerItem {
  String title;
  IconData icon;
  bool forManager;
  bool forAdmin;
  Widget widget;
  Function onTap;

  DrawerItem(this.title, this.icon,
      {this.widget,
      this.forManager = false,
      this.forAdmin = false,
      this.onTap});
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _analytics = new FirebaseAnalytics();
  final _dataService = new DataService();
  final Map<String, Widget> userImages = {
    User.newUserEmail: const CircleAvatar(child: const Icon(Icons.person))
  };

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

  List<DrawerItem> _accountDrawerItems;
  List<DrawerItem> _drawerItems;
  List<ListTile> _accountDrawerOptions;
  List<ListTile> _drawerOptions;

  UserAccountsDrawerHeader _userHeader;
  int _selectedDrawerIndex = 0;
  bool _showDrawerContents = false;

  _getDrawerItemWidget(int pos) => _drawerItems[pos].widget;

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);

    // Close the drawer.
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    _dataService.initialize().then((_) {
      _dataService.loadComplete.future.then(_updateUserHeader).catchError(() =>
          _analytics.logEvent(
              name: 'login_error',
              parameters: {'username': _dataService.userPreferences.userName}));
    });

    _createDrawerOptions();
    _createAccountDrawerItems();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateUserHeader([UserPreferences user]) {
    setState(() {
      User user = _dataService.user;
      var otherAccountImages = userImages.keys
          .where((email) => email != user.email)
          .map((email) => userImages[email])
          .toList();
      if (!user.isNewUser) {
        userImages.putIfAbsent(
          user.email,
          () => new GestureDetector(
                onTap: () {
                  _onOtherAccountsTap(context);
                },
                child: new Semantics(
                  label: 'Switch to ${user.email}',
                  child: new CircleAvatar(
                      backgroundImage: new NetworkImage(user.photoUrl)),
                ),
              ),
        );
      }

      _userHeader = new UserAccountsDrawerHeader(
        accountName: new Text(user.displayName),
        accountEmail: new Text(user.email),
        currentAccountPicture: userImages[user.email],
        otherAccountsPictures: otherAccountImages,
        onDetailsPressed: () {
          _showDrawerContents = !_showDrawerContents;
          if (_showDrawerContents) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateUserHeader();
    _createDrawerItems();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            _userHeader,
            new MediaQuery.removePadding(
              context: context,
              // DrawerHeader consumes top MediaQuery padding.
              removeTop: true,
              child: new Expanded(
                child: new ListView(
                  padding: const EdgeInsets.only(top: 8.0),
                  children: <Widget>[
                    new Stack(
                      children: <Widget>[
                        // The initial contents of the drawer.
                        new FadeTransition(
                          opacity: _drawerContentsOpacity,
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: _drawerOptions,
                          ),
                        ),
                        // The drawer's "details" view.
                        new SlideTransition(
                          position: _drawerDetailsPosition,
                          child: new FadeTransition(
                            opacity:
                                new ReverseAnimation(_drawerContentsOpacity),
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: _accountDrawerOptions,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

  _createDrawerOptions() {
    _drawerItems = [
      new DrawerItem("Home", Icons.home, widget: new WelcomeScreen()),
      new DrawerItem("Favorite news", Icons.group, widget: new Notifications()),
      new DrawerItem("Manage", Icons.edit,
          widget: new LeaderScreen(), forManager: true),
      new DrawerItem("Admin", Icons.supervisor_account,
          widget: new AdminScreen(), forAdmin: true),
      new DrawerItem("Settings", Icons.settings, widget: new SettingsScreen()),

      //TODO new DrawerItem("Add a person", Icons.person_add),
      //TODO new DrawerItem("Manage", Icons.supervisor_account),
      //TODO new DrawerItem("Information", Icons.info, new Text("Info")),
      //TODO new DrawerItem("Help", Icons.help, new Text("Help")),
      //TODO new DrawerItem("Contact us", Icons.email, new Text("Contact us")),
    ];

    _accountDrawerItems = [
      new DrawerItem("Login", Icons.person, onTap: () async {
        await _dataService.signIn();
        setState(() {
          _updateUserHeader();
        });
      }),
      new DrawerItem("Sign out", Icons.help, widget: new Text("Sign out"),
          onTap: () async {
        await _dataService.signOut();
        setState(() {
          _updateUserHeader();
        });
      }),
    ];
  }

  _createAccountDrawerItems() {
    _accountDrawerOptions = [];

    for (var i = 0; i < _accountDrawerItems.length; i++) {
      var d = _accountDrawerItems[i];
      if ((d.forManager != true || _dataService.userPreferences.isManager) &&
          (d.forAdmin != true || _dataService.userPreferences.isAdmin)) {
        _accountDrawerOptions.add(new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => d.onTap == null ? _onSelectItem(i) : d.onTap(),
        ));
      }
    }
  }

  _createDrawerItems() {
    setState(() {
      _drawerOptions = [];

      for (var i = 0; i < _drawerItems.length; i++) {
        var d = _drawerItems[i];
        if ((d.forManager != true || _dataService.userPreferences.isManager) &&
            (d.forAdmin != true || _dataService.userPreferences.isAdmin)) {
          _drawerOptions.add(new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => d.onTap == null ? _onSelectItem(i) : d.onTap(),
          ));
        }
      }
    });
  }

  void _onOtherAccountsTap(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text('Account switching not implemented.'),
          actions: <Widget>[
            new FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
