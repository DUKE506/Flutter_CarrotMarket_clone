import 'package:carrot_market_clone/page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _App();
}

class _App extends State<App> {
  late List<Map<String, String>> datas;
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
  }

  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return Home();
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return Container();
      case 4:
        return Container();
    }
    return Container();
  }

  //botton nav 요소
  BottomNavigationBarItem _bottomNavigationBarItem(
      String iconPath, String label) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: SvgPicture.asset(
            'assets/svg/${iconPath}_off.svg',
            width: 22,
          ),
        ),
        activeIcon: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: SvgPicture.asset(
            'assets/svg/${iconPath}_on.svg',
            width: 22,
          ),
        ),
        label: label);
  }

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int index) => {
        setState(() {
          _currentPageIndex = index;
        })
      },
      selectedFontSize: 12,
      currentIndex: _currentPageIndex,
      items: [
        _bottomNavigationBarItem('home', '홈'),
        _bottomNavigationBarItem('notes', '동네 생활'),
        _bottomNavigationBarItem('location', '내 근처'),
        _bottomNavigationBarItem('chat', '채팅'),
        _bottomNavigationBarItem('user', '나의 당근'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}
