import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_layout_and_menu/widgets/pinterest_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {    
    return ChangeNotifierProvider(
      create: (_) => _MenuModel(),
      child: Scaffold(
        body: Stack(
          children: const [
            _PinterestGrid(),
            _PinterestMenu(),
          ],
        ),
      ),
    );
  }
}

class _PinterestMenu extends StatelessWidget {
  const _PinterestMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showMenu = Provider.of<_MenuModel>(context).showMenu;

    return Positioned(
      bottom: 30,
      child: SizedBox(
        width: screenWidth,
        child: Align(
          child: PinterestMenu(
            showMenu: showMenu,
          )
        ),
      )
    );
  }
}

class _PinterestGrid extends StatefulWidget {
  const _PinterestGrid();

  @override
  State<_PinterestGrid> createState() => _PinterestGridState();
}

class _PinterestGridState extends State<_PinterestGrid> {
  final List<int> items = List.generate(200, (index) => index);
  ScrollController scrollController = ScrollController();
  double lastScrollOffset = 0;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset > lastScrollOffset) {
        Provider.of<_MenuModel>(context, listen: false).showMenu = false;
      } else {
        Provider.of<_MenuModel>(context, listen: false).showMenu = true;
      }

      lastScrollOffset = scrollController.offset;
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      controller: scrollController,
      crossAxisCount: 4,
      itemCount: items.length,
      itemBuilder: (context, index) => _PinterestItem(index: index),
      staggeredTileBuilder: (index) => StaggeredTile.count(2, index.isEven ? 2 : 3),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}

class _PinterestItem extends StatelessWidget {
  const _PinterestItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      child: Center(
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text('$index'),
        ),
      ),
    );
  }
}

class _MenuModel with ChangeNotifier {
  bool _showMenu = true;

  bool get showMenu => _showMenu;

  set showMenu(bool show) {
    _showMenu = show;
    notifyListeners();
  }
}
