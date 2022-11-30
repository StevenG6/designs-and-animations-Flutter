import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PinterestButton {
  final Function() onPressed;
  final IconData icon;

  PinterestButton({required this.onPressed, required this.icon});
}

class PinterestMenu extends StatelessWidget {
  PinterestMenu({super.key, this.showMenu = true});

  final bool showMenu;

  final List<PinterestButton>  items = [
    PinterestButton(onPressed: () => debugPrint('Icon pie_chart'), icon: Icons.pie_chart),
    PinterestButton(onPressed: () => debugPrint('Icon search'), icon: Icons.search),
    PinterestButton(onPressed: () => debugPrint('Icon notifications'), icon: Icons.notifications),
    PinterestButton(onPressed: () => debugPrint('Icon supervised_user_circle'), icon: Icons.supervised_user_circle),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _MenuModel(),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: showMenu ? 1 : 0,
        child: _PinterestMenuBackground(
          child: _MenuItems(items),
        ),
      ),
    );
  }
}

class _PinterestMenuBackground extends StatelessWidget {
  const _PinterestMenuBackground({ 
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            spreadRadius: -5
          )
        ]
      ),
      child: child,
    );
  }
}

class _MenuItems extends StatelessWidget {
  const _MenuItems(this.menuItems);

  final List<PinterestButton> menuItems;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(menuItems.length, (index) => _PinterestMenuButton(index, menuItems[index])),
    );
  }
}

class _PinterestMenuButton extends StatelessWidget {
  const _PinterestMenuButton(this.index, this.item);

  final int index;
  final PinterestButton item;

  @override
  Widget build(BuildContext context) {
    final itemSelected = Provider.of<_MenuModel>(context).indexSelected;

    return GestureDetector(
      onTap: () {
        Provider.of<_MenuModel>(context, listen: false).indexSelected = index;
        item.onPressed();
      },
      behavior: HitTestBehavior.translucent,
      child: Icon(
        item.icon,
        size: itemSelected == index ? 35 : 25,
        color: itemSelected == index ? Colors.black : Colors.blueGrey,
      ),
    );
  }
}

class _MenuModel with ChangeNotifier {
  int _indexSelected = 0;

  int get indexSelected => _indexSelected;

  set indexSelected(int index) {
    _indexSelected = index;
    notifyListeners();
  }
}
