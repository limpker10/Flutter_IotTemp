import 'package:flutter/material.dart';
import '../screens/message_screen.dart';
import '../screens/histories_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {

    final screens = [const MqttScreen(),const HistoryView()];

    return Scaffold(

      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.background,
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.person_3_outlined),
            activeIcon: Icon(Icons.person_3),
            label: 'Mqtt',
          ),BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            activeIcon: Icon(Icons.bar_chart),
            label: 'History',
          ),
        ],
      ),
    );
  }
}