import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/app.dart';

class AppDependencies extends InheritedWidget {
  final ContactDao contactDao;

  AppDependencies({
    @required this.contactDao,
    @required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(AppDependencies oldWidget) {
    return contactDao != oldWidget.contactDao;
  }
}
