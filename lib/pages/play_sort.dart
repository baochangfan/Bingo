import 'package:flutter/material.dart';
import 'package:flutter_bingo/common/utils/common.dart';

class PlaySortPage extends StatelessWidget {
  final List<BingoItem> bingoItems;
  PlaySortPage({@required this.bingoItems});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    List<Widget> newItemList = [];
    for (var item in bingoItems) {
      newItemList.add(item.widget);
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(commonGetLocale(context).sort),
      ),
      body: new Center(
          child: new Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: new LayoutBuilder(builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return new SingleChildScrollView(
                    child: new ConstrainedBox(
                        constraints: new BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                        ),
                        child: new Wrap(
                          spacing: screenWidth * 0.02,
                          runSpacing: screenWidth * 0.02,
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          children: newItemList,
                        )));
              }))),
    );
  }
}
