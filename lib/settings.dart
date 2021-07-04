import 'package:flutter/material.dart';
import 'package:zbll_algs/dbhelper.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ListTile(
            title: Text("Order algorithms by favourite"),
            subtitle: Text(
                "changes SQL statement to order algorithms by the in_use property"),
            trailing: Switch.adaptive(
                value: DBHelper.algOrdering,
                onChanged: (value) {
                  setState(() {
                    DBHelper.algOrdering = value;
                  });
                }),
          ),
        ),
        Card(
          child: ListTile(
            title: Text("Test option"),
            subtitle: Text("this is a test"),
            trailing: Switch.adaptive(value: false, onChanged: (value) {}),
          ),
        ),
      ],
    );
  }
}
