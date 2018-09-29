import 'package:flutter/material.dart';
import 'package:flutter_bingo/common/redux/theme_redux.dart';
import 'package:flutter_bingo/common/redux/local_redux.dart';

///全局Redux store 的对象，保存State数据
class AppState {
  /// 主题
  ThemeData themeData;

  ///语言
  Locale locale;

  ///当前手机平台默认语言
  Locale platformLocale;
  AppState({this.themeData, this.locale});
}

AppState appReducer(AppState state, action) {
  return AppState(
    themeData: ThemeDataReducer(state.themeData, action),

    ///通过 LocaleReducer 将 AppState 内的 locale 和 action 关联在一起
    locale: LocaleReducer(state.locale, action),
  );
}
