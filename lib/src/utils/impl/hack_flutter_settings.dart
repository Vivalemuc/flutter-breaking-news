/*
    MIT License

    Copyright (c) 2020 Boris-Wilfried Nyasse
    [ https://gitlab.com/bwnyasse | https://github.com/bwnyasse ]

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
*/

import 'package:flutter/material.dart';
import 'package:flutter_settings/list/items/selection_item_factory.dart';
import 'package:flutter_settings/models/settings_list_item.dart';
import 'package:flutter_settings/util/SettingsConstants.dart';
import 'package:flutter_settings/widgets/SettingsButton.dart';
import 'package:flutter_settings/widgets/SettingsIcon.dart';

class SettingsSelectionList2<T> extends SettingsButton {
  final List<SettingsSelectionItem<T>> items;
  SimpleSelectionDialog2 dialog;
  int chosenItemIndex;

  SettingsSelectionList2({
    this.chosenItemIndex = 0,
    @required BuildContext context,
    @required this.items,
    @required String title,
    String dialogTitle,
    String dismissTitle,
    String caption,
    TextStyle titleStyle,
    TextStyle captionStyle,
    SettingsIcon icon,
    @required Function onSelect,
    WidgetDirection direction = WidgetDirection.ltr,
  }) : super(
            titleStyle: titleStyle,
            captionStyle: captionStyle,
            icon: icon,
            title: title,
            caption: caption,
            direction: direction,
            onPressed: null) {
    dialog = SimpleSelectionDialog2(
      direction: direction,
      dialogTitle: dialogTitle ?? title,
      items: items,
      onSelect: onSelect,
      chosenItemIndex: chosenItemIndex,
      dismissText: dismissTitle ?? "Cancel",
    );
    this.onPressed = () {
      showDialog<SettingsSelectionItem>(
          context: context, builder: (BuildContext context) => dialog);
    };
  }
}

class SimpleSelectionDialog2 extends StatelessWidget {
  final String dialogTitle;
  final String dismissText;
  final List<SettingsSelectionItem> items;
  final Function onSelect;
  final WidgetDirection direction;
  final SelectionDialog selectionDialog;
  int chosenItemIndex;

  SimpleSelectionDialog2(
      {Key key,
      this.items,
      this.onSelect,
      this.chosenItemIndex,
      @required this.dialogTitle,
      this.direction,
      this.dismissText,
      this.selectionDialog = SelectionDialog.SimpleCheck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Choose the country news",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 24.0),
            Container(
              height: 250,
              child: SingleChildScrollView(
                child: Column(
                  children: items
                      .map((item) => SelectionItemFactory.createSelectionItem(
                              selectionDialog,
                              direction,
                              item.text,
                              items.indexOf(item) == chosenItemIndex, () {
                            this.chosenItemIndex = items.indexOf(item);
                            onSelect(item, chosenItemIndex);
                            Navigator.of(context).pop();
                          }))
                      .toList(),
                ),
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.all(12.0),
                child: Text(
                  dismissText,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
