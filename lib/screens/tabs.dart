import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/providers/filters_provider.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // 좌측 상단 서랍버튼 눌렀을때 관련있는 함수
  void _setScreen(String identifier) async {
    Navigator.of(context).pop(); // 열린 서랍 닫는 코드
    if (identifier == 'filters') { // 서랍에서 누른게 'filter'일 때
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(), // 결국, 열린서랍 닫으면서 Filter 화면 Stack에 추가(화면이동)
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);
    Widget activePage = Container();
    var activePageTitle = '';

    // 하단 탭 default로 'Categories'화면
    if (_selectedPageIndex == 0) { // <- 원래 없던코드인데 이렇게하면 불필요한 리소스 낭비를 최소화할 수 있지않을까
      activePage = CategoriesScreen(
        availableMeals: availableMeals,
      );
      activePageTitle = 'Categories';
    }

    // _selectedPageIndex : 위에서 setState에 의해 재빌드의 키가 되는 값
    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer( // drawer 설정시 좌측 상단 서랍 아이콘 생성 (Drawer 위젯 사용)
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage, // setState()로 "_selectedPageIndex" 값 변경해주는 함수
        currentIndex: _selectedPageIndex, // 활성화시킬 버튼의 Index
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
