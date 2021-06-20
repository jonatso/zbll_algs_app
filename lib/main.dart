import 'package:flutter/material.dart';
import 'algset.dart';
import 'cases.dart';
import 'dbhelper.dart';

void main() => runApp(MaterialApp(
      home: ZBLLApp(),
    ));

class ZBLLApp extends StatefulWidget {
  @override
  _ZBLLAppState createState() => _ZBLLAppState();
}

class _ZBLLAppState extends State<ZBLLApp> {
  int _selectedIndex = 0;
  Algset _chosenSet = Algset(0, "Choose algset");
  bool showChoice = true;

  List<String> _pageNames = ['Algorithms', 'Settings'];

  final tabs = [
    Cases(),
    Center(child: Text('Settings page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      showChoice = index == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_pageNames[_selectedIndex]),
          backgroundColor: Colors.red,
          actions: [
            if (showChoice)
              FutureBuilder(
                  future: DBHelper.getAlgsets(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return Text(snapshot.error);

                    if (snapshot.hasData) {
                      return DropdownButtonFormField(
                        decoration: InputDecoration(icon: Icon(Icons.language)),
                        value: _chosenSet,
                        items: snapshot.data
                            .map((algset) => DropdownMenuItem<Algset>(
                                  value: algset,
                                  child: Text(algset.algset_name),
                                ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() => _chosenSet = newValue);
                        },
                      );
                    }
                    return CircularProgressIndicator();
                  }),
          ]),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_in_ar),
            label: 'Algorithms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedFontSize: 12, // was bigger :o
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey[700],
        onTap: _onItemTapped,
      ),
    );
  }
}
