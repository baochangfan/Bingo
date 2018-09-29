import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bingo/common/localization/default_localizations.dart';

class AppLocalizationsDelegate
    extends LocalizationsDelegate<DefaultLocalization> {
  AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    ///支持中文和英语
    return ['en', 'zh'].contains(locale.languageCode);
  }

  ///根据locale，创建一个对象用于提供当前locale下的文本显示
  @override
  Future<DefaultLocalization> load(Locale locale) {
    return new SynchronousFuture<DefaultLocalization>(
        new DefaultLocalization(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<DefaultLocalization> old) {
    return false;
  }

  ///全局静态的代理
  static AppLocalizationsDelegate delegate = new AppLocalizationsDelegate();
}
