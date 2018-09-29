import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bingo/common/config/config.dart';
import 'package:flutter_bingo/common/localization/default_localizations.dart';
import 'package:flutter_bingo/common/redux/app_state.dart';
import 'package:flutter_bingo/common/redux/local_redux.dart';
import 'package:flutter_bingo/common/storage/storage.dart';
import 'package:flutter_bingo/common/style/string_base.dart';
import 'package:flutter_bingo/common/style/style.dart';
import 'package:redux/redux.dart';

/// Dialog 枚举变量
enum DialogAction {
  cancel,
  confirm,
}

StringBase commonGetLocale(BuildContext context) {
  return DefaultLocalization.of(context).currentLocalized;
}

List<Color> commonGetThemeListColor() {
  return [
    AppColors.primarySwatch,
    Colors.brown,
    Colors.blue,
    Colors.teal,
    Colors.amber,
    Colors.blueGrey,
    Colors.deepOrange,
  ];
}

Color commonGetItemColor(int value) {
  Color color;
  if (value > 0 && value <= 10) {
    color = commonGetThemeListColor()[0];
  } else if (value > 10 && value <= 20) {
    color = commonGetThemeListColor()[1];
  } else if (value > 20 && value <= 30) {
    color = commonGetThemeListColor()[2];
  } else if (value > 30 && value <= 40) {
    color = commonGetThemeListColor()[3];
  } else if (value > 40 && value <= 50) {
    color = commonGetThemeListColor()[4];
  } else if (value > 50 && value <= 60) {
    color = commonGetThemeListColor()[5];
  } else {
    color = commonGetThemeListColor()[6];
  }
  return color;
}

class AppFlexButton extends StatelessWidget {
  final String text;

  final Color color;

  final Color textColor;

  final VoidCallback onPress;

  final double fontSize;
  final int maxLines;

  final MainAxisAlignment mainAxisAlignment;

  AppFlexButton(
      {Key key,
      this.text,
      this.color,
      this.textColor,
      this.onPress,
      this.fontSize = 20.0,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
        padding: new EdgeInsets.only(
            left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
        textColor: textColor,
        color: color,
        child: new Flex(
          mainAxisAlignment: mainAxisAlignment,
          direction: Axis.horizontal,
          children: <Widget>[
            new Text(text,
                style: new TextStyle(fontSize: fontSize),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis)
          ],
        ),
        onPressed: () {
          this.onPress?.call();
        });
  }
}

/// 切换语言
commonChangeLocale(Store<AppState> store, int index) {
  Locale locale = store.state.platformLocale;
  switch (index) {
    case 1:
      locale = Locale('zh', 'CH');
      break;
    case 2:
      locale = Locale('en', 'US');
      break;
  }
  store.dispatch(RefreshLocaleAction(locale));
}

commonShowLanguageDialog(BuildContext context, Store store) {
  List<String> list = [
    commonGetLocale(context).languageDefault,
    commonGetLocale(context).languageZh,
    commonGetLocale(context).languageEn,
  ];
  commonShowCommitOptionDialog(context, list, (index) {
    commonChangeLocale(store, index);
    LocalStorage.save(Config.local, index.toString());
  }, height: 150.0);
}

Future<Null> commonShowCommitOptionDialog(
  BuildContext context,
  List<String> commitMaps,
  ValueChanged<int> onTap, {
  width = 250.0,
  height = 400.0,
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

/// 动态导航，附带转场效果
commonNavigatorWithTransitions(BuildContext context, Widget targetPage) {
  Navigator.of(context).push(new PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return targetPage;
    },
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return new SlideTransition(
        position: new Tween<Offset>(
          begin: Theme.of(context).platform == TargetPlatform.android
              ? const Offset(0.0, 0.5)
              : const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  ));
}

/// 提示框.
///
/// [title] =''为无标题提示框
///
/// return 0 取消 1 确认
Future<int> commonPromptDialog(
    BuildContext context, String title, Widget content,
    [onlyPrompt = false]) {
  Future<int> showPromptDialog<T>({BuildContext context, Widget child}) async {
    var result;
    await showDialog<T>(context: context, child: child).then<Null>((T value) {
      if (value != null) {
        print(value);
        if (value == DialogAction.confirm) {
          result = 1;
        } else {
          result = 0;
        }
      }
    });
    return result;
  }

  var res = title == ''
      ? showPromptDialog<DialogAction>(
//无title
          context: context,
          child: new AlertDialog(content: content, actions: <Widget>[
            !onlyPrompt
                ? new FlatButton(
                    child: Text(commonGetLocale(context).cancel),
                    onPressed: () {
                      Navigator.pop(context, DialogAction.cancel);
                    })
                : new Container(),
            new FlatButton(
                child: Text(commonGetLocale(context).confirm),
                onPressed: () {
                  Navigator.pop(context, DialogAction.confirm);
                })
          ]))
      : showPromptDialog<DialogAction>(
//有title
          context: context,
          child: new AlertDialog(
              title: new Text(title),
              content: content,
              actions: <Widget>[
                new FlatButton(
                    child: Text(commonGetLocale(context).cancel),
                    onPressed: () {
                      Navigator.pop(context, DialogAction.cancel);
                    }),
                new FlatButton(
                    child: Text(commonGetLocale(context).confirm),
                    onPressed: () {
                      Navigator.pop(context, DialogAction.confirm);
                    })
              ]));
  return res;
}

class BingoItem {
  final int index;
  final Widget widget;
  BingoItem({this.index, this.widget});
}
