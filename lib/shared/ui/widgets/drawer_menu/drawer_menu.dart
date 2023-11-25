import 'package:app/theme/light/app_colors_light.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:app/modules/home/home_page_store.dart';
import 'package:app/shared/ui/widgets/animated_pokeball.dart';
import 'package:app/shared/ui/widgets/drawer_menu/widgets/drawer_menu_item.dart';
import 'package:app/shared/utils/app_constants.dart';
import 'package:app/theme/app_theme.dart';

class DrawerMenuWidget extends StatefulWidget {
  const DrawerMenuWidget({Key? key}) : super(key: key);

  @override
  State<DrawerMenuWidget> createState() => _DrawerMenuWidgetState();
}

class _DrawerMenuWidgetState extends State<DrawerMenuWidget> with TickerProviderStateMixin {
  final HomePageStore _homeStore = GetIt.instance<HomePageStore>();

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/bg/login_bg.png'),
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                    AppConstants.pokedexIcon,
                    width: 100,
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AnimatedPokeballWidget(color: Colors.white, size: 26),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Pokedex",
                        style: textTheme.headline1!.copyWith(
                          color: Colors.white,
                          fontFamily: 'Circular',
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Pokemon Project By Team B",
                    style: textTheme.bodyMedium!.copyWith(
                      color: Colors.white.withOpacity(0.75),
                      fontFamily: 'Circular',
                    ),
                  ),
                ],
              ),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 70),
                children: [
                  DrawerMenuItemWidget(
                    icon: Icons.grid_4x4,
                    text: "Pokedex",
                    onTap: () {
                      Navigator.pop(context);

                      _homeStore.setPage(HomePageType.POKEMON_GRID);
                    },
                  ),
                  DrawerMenuItemWidget(
                    icon: Icons.list,
                    text: "Items",
                    onTap: () {
                      Navigator.pop(context);

                      _homeStore.setPage(HomePageType.ITEMS);
                    },
                  ),
                  DrawerMenuItemWidget(
                    icon: Icons.favorite,
                    text: "Favourites",
                    onTap: () {
                      Navigator.pop(context);

                      _homeStore.setPage(HomePageType.FAVOURITES);
                    },
                  ),
                  DrawerMenuItemWidget(
                    icon: Icons.newspaper,
                    text: "News",
                    onTap: () {
                      Navigator.pop(context);
                      _homeStore.setPage(HomePageType.FAVOURITES);
                    },
                  ),
                  DrawerMenuItemWidget(
                    icon: Icons.play_arrow,
                    text: "Videos",
                    // onTap: () {
                    //   Navigator.pop(context);
                    //   _homeStore.setPage(HomePageType.FAVOURITES);
                    // },
                  ),
                  DrawerMenuItemWidget(
                    icon: Icons.chat_bubble,
                    text: "Live Chat",
                    // onTap: () {
                    //   Navigator.pop(context);
                    //   _homeStore.setPage(HomePageType.FAVOURITES);
                    // },
                  ),
                  // DrawerMenuItemWidget(
                  //   color: AppTheme.getColors(context).pokemonItem('Fighting'),
                  //   text: "Moves",
                  //   // onTap: () {},
                  // ),
                  // DrawerMenuItemWidget(
                  //     color: AppTheme.getColors(context).drawerAbilities, text: "Abilities"),
                  // DrawerMenuItemWidget(
                  //     color: AppTheme.getColors(context).drawerTypeCharts, text: "Type Charts"),
                  // DrawerMenuItemWidget(
                  //     color: AppTheme.getColors(context).drawerLocations, text: "Locations"),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Lottie.asset(
              AppConstants.diglettLottie,
              height: 200.0,
            ),
          ),
        ],
      ),
    );
  }
}
