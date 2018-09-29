import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bingo/common/redux/app_state.dart';
import 'package:flutter_bingo/common/utils/common.dart';
import 'package:flutter_bingo/pages/play_sort.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'dart:math' show Random;
import 'package:flutter/cupertino.dart';

class PlayPage extends StatefulWidget {
  @override
  _PlayPageState createState() => new _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  BuildContext _context;
  double _screenWidth;
  double _screenHeight;
  Store<AppState> _store;
  List<Widget> _newItemList = [];
  String _currentItemValue;
  final List<int> _itemValueList =
      new List<int>.generate(75, (int index) => index + 1);
  Color _currentItemColor;
  List<BingoItem> _bingoItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _getNewItemValue(int length) {
    Random random = new Random();
    num index = random.nextInt(length);
    return index;
  }

  void _newItem() {
    if (_itemValueList.length > 0) {
      int index = _getNewItemValue(_itemValueList.length);
      _currentItemValue = _itemValueList[index].toString();
      _currentItemColor = commonGetItemColor(_itemValueList[index]);
      Widget item = new Container(
          width: _screenWidth * 0.22,
          height: _screenWidth * 0.22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: _currentItemColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(_screenWidth * 0.12))),
          child: new Text(_currentItemValue,
              style: TextStyle(fontSize: 36.0, color: Colors.white)));
      BingoItem bingoItem =
          BingoItem(index: _itemValueList[index], widget: item);
      _bingoItems.insert(0, bingoItem);
      setState(() {
        _newItemList.insert(0, _bingoItems[0].widget);
        _itemValueList.removeAt(index);
      });
    } else {
      setState(() {
        _currentItemValue = commonGetLocale(context).gameOver;
      });
    }
  }

  Widget _build() {
    if (_currentItemValue == null) {
      _currentItemValue = commonGetLocale(context).clickStart;
    }
    if (_currentItemColor == null) {
      _currentItemColor = _store.state.themeData.primaryColor;
    }
    return new Container(
        width: _screenWidth,
        height: _screenHeight,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new InkWell(
                onTap: _newItem,
                child: new Container(
                  width: _screenWidth * 0.6,
                  height: _screenWidth * 0.6,
                  margin: EdgeInsets.all(12.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: _currentItemColor,
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2.0,
                          spreadRadius: 2.0,
                          // offset: Offset(-2.0, 0.0),
                        ),
                      ],
                      borderRadius: BorderRadius.all(
                          Radius.circular(_screenWidth * 0.4))),
                  child: new Text(_currentItemValue,
                      style: TextStyle(fontSize: 50.0, color: Colors.white)),
                )),
            new Container(
                width: _screenWidth,
                height: 10.0,
                color: Colors.grey[300],
                margin: EdgeInsets.only(bottom: _screenWidth * 0.02)),
            new Expanded(child: new LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return new SingleChildScrollView(
                  child: new ConstrainedBox(
                      constraints: new BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: new Wrap(
                        spacing: _screenWidth * 0.02,
                        runSpacing: _screenWidth * 0.02,
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        children: _newItemList,
                      )));
            }))
          ],
        ));
  }

  /// showPromptDialog 退出应用弹出框
  void _prompt() {
    Widget content = new Text(commonGetLocale(context).whetherToBack,
        style: new TextStyle(fontSize: 18.0));
    commonPromptDialog(context, '', content).then((int value) {
      if (value == 1) {
        Navigator.of(context).pop();
      }
    });
  }

  void _navigator() {
    if (_newItemList.isNotEmpty) {
      _bingoItems.sort((a, b) => a.index.compareTo(b.index));
      print(_bingoItems[0].index);
      commonNavigatorWithTransitions(
          _context, new PlaySortPage(bingoItems: _bingoItems));
    } else {
      Scaffold.of(_context).showSnackBar(new SnackBar(
          content: new Text(commonGetLocale(context).sortExceptionHint)));
    }
  }

  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    Future<bool> _onWillPop() {
      if (Theme.of(context).platform == TargetPlatform.android) {
        _prompt();
      }
      return new Future.value(false); // false 点击物理返回按键 禁止页面返回
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: new StoreBuilder<AppState>(builder: (context, store) {
          _store = store;
          return new Scaffold(
              backgroundColor: Color.fromARGB(255, 242, 242, 245),
              appBar: new AppBar(
                  automaticallyImplyLeading: false,
                  title: new Text('Bingo'),
                  elevation: 2.0,
                  actions: <Widget>[
                    new CupertinoButton(
                      child: new Text(commonGetLocale(context).sort,
                          style: TextStyle(color: Colors.white)),
                      onPressed: _navigator,
                    )
                  ]),
              body: new Builder(builder: (BuildContext context) {
                _context = context;
                return _build();
              }));
        }));
  }
}
