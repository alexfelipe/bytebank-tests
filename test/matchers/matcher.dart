import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';

bool featureItemMatcher(
    Widget widget,
    String name,
    IconData icon,
    ) {
  if (widget is FeatureItem) {
    return widget.name == name && widget.icon == icon;
  }
  return false;
}

bool textFieldMatcher(Widget widget, String labelText) {
  if (widget is TextField) {
    return widget.decoration.labelText == labelText;
  }
  return false;
}

bool contactItemMatcher(
    Widget widget,
    String name,
    int accountNumber,
    ) {
  if (widget is ContactItem) {
    final contact = widget.contact;
    return contact.name == name && contact.accountNumber == accountNumber;
  }
  return false;
}