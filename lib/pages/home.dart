import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bingo/common/config/config.dart';
import 'package:flutter_bingo/common/storage/storage.dart';
import 'package:flutter_bingo/common/style/style.dart';
import 'package:flutter_bingo/common/utils/common.dart';
import 'package:flutter_bingo/pages/play.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_bingo/common/redux/theme_redux.dart';
import 'package:flutter_bingo/common/redux/app_state.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  num _screenHeight;
  num _screenWidth;
  Store<AppState> _store;
  Timer _timer;
  bool _showAd = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(microseconds: 200), () {
      LocalStorage.get(Config.local).then((value) {
        print(value);
        if (value != null && _store != null) {
          commonChangeLocale(_store, int.parse(value));
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void _pushTheme(Store store, int index) {
    ThemeData themeData;
    List<Color> colors = commonGetThemeListColor();
    print(index);
    themeData = new ThemeData(primarySwatch: colors[index]);
    store.dispatch(new RefreshThemeDataAction(themeData));
  }

  Future<Null> _showCommitOptionDialog(
    BuildContext context,
    List<String> commitMaps,
    ValueChanged<int> onTap, {
    width = 250.0,
    height = 300.0,
    List<Color> colorList,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: new Container(
              width: width,
              height: height,
              padding: new EdgeInsets.all(4.0),
              margin: new EdgeInsets.all(20.0),
              decoration: new BoxDecoration(
                color: Color(AppColors.white),
                //用一个BoxDecoration装饰器提供背景图片
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: new ListView.builder(
                  itemCount: commitMaps.length,
                  itemBuilder: (context, index) {
                    return AppFlexButton(
                      maxLines: 2,
                      mainAxisAlignment: MainAxisAlignment.start,
                      fontSize: 14.0,
                      color: colorList != null
                          ? colorList[index]
                          : Theme.of(context).primaryColor,
                      text: commitMaps[index],
                      textColor: Color(AppColors.white),
                      onPress: () {
                        Navigator.pop(context);
                        onTap(index);
                      },
                    );
                  }),
            ),
          );
        });
  }

  showThemeDialog(BuildContext context, Store store) {
    List<String> list = [
      'Theme1',
      'Theme2',
      'Theme3',
      'Theme4',
      'Theme5',
      'Theme6',
    ];
    _showCommitOptionDialog(context, list, (index) {
      _pushTheme(store, index);
    }, colorList: commonGetThemeListColor());
  }

  Widget _buildAd() {
    return new Stack(
      children: <Widget>[
        new Container(
            width: _screenWidth * 0.25,
            height: _screenHeight * 0.25,
            margin: EdgeInsets.only(
                top: _screenHeight * 0.75, left: _screenWidth * 0.75),
            color: Colors.white,
            child: new InkWell(
              onTap: () {
                final updateUrl = 'https://ognib.taobao.com/';
                launch(updateUrl);
              },
              child: new Image(
                  image: AssetImage('assets/images/ad.jpg'), fit: BoxFit.cover),
            )),
        new Positioned(
            right: 1.0,
            top: _screenHeight * 0.75,
            child: new InkWell(
                child: new Icon(
                  Icons.close,
                  color: Colors.grey[400],
                ),
                onTap: () {
                  setState(() {
                    _showAd = false;
                  });
                }))
      ],
    );
  }

  Widget _build(Store<AppState> store) {
    return Container(
        margin: EdgeInsets.only(top: _screenHeight * 0.1),
        alignment: Alignment.center,
        child: new Column(children: <Widget>[
          new Container(
              height: _screenHeight * 0.28,

              ///默认背景
              //color: store.state.themeData.primaryColor,
              child: new Image(
                  image: new AssetImage('assets/images/bingoinsight.png'),
                  fit: BoxFit.cover)),
          new Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: new OutlineButton(
                  borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
                  child: FadeAnimatedTextKit(
                    onTap: null,
                    duration: Duration(milliseconds: 1500),
                    text: [commonGetLocale(context).gameStart],
                    textStyle: TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () {
                    commonNavigatorWithTransitions(context, new PlayPage());
                  })),
          /*new Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: new OutlineButton(
                      borderSide:
                          BorderSide(color: Colors.grey[500], width: 1.0),
                      child: new Text(commonGetLocale(context).setting),
                      onPressed: () {})),*/
          new Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: new OutlineButton(
                  borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
                  child: new Text(commonGetLocale(context).themeSwitch),
                  onPressed: () {
                    showThemeDialog(context, store);
                  })),
          new Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: new OutlineButton(
                  borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
                  child: new Text(commonGetLocale(context).languageSwitch),
                  onPressed: () {
                    commonShowLanguageDialog(context, store);
                  })),
          new Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: new OutlineButton(
                  borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
                  child: new Text(commonGetLocale(context).exit),
                  onPressed: () {
                    SystemNavigator.pop();
                  })),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return new StoreBuilder<AppState>(builder: (context, store) {
      _store = store;
      return new Scaffold(
          backgroundColor: store.state.themeData
              .primaryColor, //Color.fromARGB(255, 242, 242, 245),
          body: new Stack(
            children: <Widget>[
              _build(store),
              new Offstage(offstage: !_showAd, child: _buildAd())
            ],
          ));
    });
  }
}
