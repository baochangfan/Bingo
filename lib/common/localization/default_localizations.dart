import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bingo/common/style/string_base.dart';
import 'package:flutter_bingo/common/style/string_en.dart';
import 'package:flutter_bingo/common/style/string_zh.dart';

///自定义多语言实现
class DefaultLocalization {
  final Locale locale;

  DefaultLocalization(this.locale);

  ///根据不同 locale.languageCode 加载不同语言对应
  ///GSYStringEn和GSYStringZh都继承了GSYStringBase
  static Map<String, StringBase> _localizedValues = {
    'en': new StringEn(),
    'zh': new StringZh(),
  };

  StringBase get currentLocalized {
    return _localizedValues[locale.languageCode];
  }

  ///通过 Localizations 加载当前的 GSYLocalizations
  ///获取对应的 GSYStringBase
  static DefaultLocalization of(BuildContext context) {
    return Localizations.of(context, DefaultLocalization);
  }
}
