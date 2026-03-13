import 'package:flutter/material.dart';

extension EmptySpace on num {
  /// Returns vertical space based on a fraction of screen height
  SizedBox height(BuildContext context) => SizedBox(
    height: MediaQuery.of(context).size.height * this,
  );

  /// Returns horizontal space based on a fraction of screen width
  SizedBox width(BuildContext context) => SizedBox(
    width: MediaQuery.of(context).size.width * this,
  );
}
