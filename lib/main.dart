import 'package:flutter/material.dart';
import 'package:flutter_bingo/common/localization/app_localizations.dart';
import 'package:flutter_bingo/common/localization/app_localizations_delegate.dart';
import 'package:flutter_bingo/common/style/style.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_bingo/common/redux/app_state.dart';
import 'package:flutter_bingo/pages/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  return runApp(new FlutterReduxApp());
}

class FlutterReduxApp extends StatelessWidget {
  final store = new Store<AppState>(appReducer,
      initialState: new AppState(
          themeData: new ThemeData(primarySwatch: AppColors.primarySwatch),
          locale: Locale('zh', 'CH'))); //Locale('zh', 'CH')

  FlutterReduxApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 通过 StoreProvider 应用 store
    return new StoreProvider(
        store: store,
        child: new StoreBuilder<AppState>(builder: (context, store) {
          return new MaterialApp(
            ///多语言实现代理
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              AppLocalizationsDelegate.delegate,
            ],
            locale: store.state.locale,
            supportedLocales: [store.state.locale],
            title: 'Bingo',
            theme: store.state.themeData,
            /*routes: {
                HomePage.sName: (context) {
                  ///通过 Localizations.override 包裹一层。---这里
                  return new AppLocalizations(
                    child: new HomePage(),
                  );
                },
              }*/

            home: new AppLocalizations(child: new HomePage()),
          );
        }));
  }
}
