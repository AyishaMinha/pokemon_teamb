import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:app/shared/providers/auth_state_provider.dart';
import 'package:app/shared/providers/credits_provider.dart';
import 'package:app/shared/utils/spacer.dart';
import 'package:app/shared/widgets/primary_elevated_button.dart';
import 'package:app/theme/dark/dark_theme.dart';
import 'package:app/theme/light/light_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:app/modules/home/home_page_store.dart';
import 'package:app/shared/ui/widgets/animated_pokeball.dart';
import 'package:app/shared/ui/widgets/drawer_menu/widgets/drawer_menu_item.dart';
import 'package:app/shared/utils/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerMenuWidget extends StatefulWidget {
  const DrawerMenuWidget({Key? key}) : super(key: key);

  @override
  State<DrawerMenuWidget> createState() => _DrawerMenuWidgetState();
}

class _DrawerMenuWidgetState extends State<DrawerMenuWidget>
    with TickerProviderStateMixin {
  final HomePageStore _homeStore = GetIt.instance<HomePageStore>();

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

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
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(AppConstants.backgroundPlainImage),
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Logged in as",
                    style: textTheme.bodySmall!.copyWith(
                      color: Colors.white.withOpacity(0.75),
                      fontFamily: 'Circular',
                    ),
                  ),
                  Text(
                    '@${context.read<AuthProvider>().username}',
                    style: textTheme.bodySmall!.copyWith(
                      fontSize: 30.sp,
                      height: 0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Circular',
                    ),
                  ),
                  Divider(color: Colors.white.withOpacity(0.25)),
                  hSpace(25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AnimatedPokeballWidget(
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Pokedex",
                        style: textTheme.titleSmall!.copyWith(
                          color: Colors.white,
                          fontFamily: 'Circular',
                        ),
                      ),
                    ],
                  ),
                  hSpace(5),
                  Text(
                    "Pokemon Project By Team B",
                    style: textTheme.bodySmall!.copyWith(
                      color: Colors.white.withOpacity(0.75),
                      fontFamily: 'Circular',
                    ),
                  ),
                ],
              ),
              hSpace(10),
              GridView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.25,
                ),
                children: [
                  DrawerMenuItemWidget(
                    icon: Icons.grid_4x4,
                    text: "Pokedex",
                    onTap: () {
                      Navigator.pop(context);

                      _homeStore.setPage(HomePageType.pokemonGrid);
                    },
                  ),
                  DrawerMenuItemWidget(
                    width: 300,
                    icon: Icons.list,
                    text: "Items",
                    onTap: () {
                      Navigator.pop(context);

                      _homeStore.setPage(HomePageType.items);
                    },
                  ),
                  DrawerMenuItemWidget(
                    icon: Icons.favorite,
                    text: "Favourites",
                    onTap: () {
                      Navigator.pop(context);

                      _homeStore.setPage(HomePageType.favourites);
                    },
                  ),
                  DrawerMenuItemWidget(
                    icon: Icons.newspaper,
                    text: "News",
                    onTap: () {
                      Navigator.pop(context);
                      _homeStore.setPage(HomePageType.news);
                    },
                  ),
                  DrawerMenuItemWidget(
                    icon: Icons.play_arrow,
                    text: "Videos",
                    onTap: () {
                      Navigator.pop(context);
                      _homeStore.setPage(HomePageType.videos);
                    },
                  ),
                  DrawerMenuItemWidget(
                    icon: Icons.check_box,
                    text: "Check In",
                    onTap: () {
                      Navigator.pop(context);
                      _homeStore.setPage(HomePageType.checkIn);
                    },
                  ),
                  DrawerMenuItemWidget(
                    icon: Icons.shopping_cart,
                    text: "Merch",
                    onTap: () {
                      Navigator.pop(context);
                      _homeStore.setPage(HomePageType.merchandise);
                    },
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
              hSpace(10),
              hSpace(10),
              ThemeSwitcher(
                builder: (context) => InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () async {
                    ThemeSwitcher.of(context).changeTheme(
                      theme: Theme.of(context).brightness == Brightness.light
                          ? darkTheme
                          : lightTheme,
                    );

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    prefs
                        .setBool(
                      "darkTheme",
                      !(Theme.of(context).brightness == Brightness.dark),
                    )
                        .then((value) {
                      Scaffold.of(context).closeEndDrawer();
                    });
                  },
                  child: CustomElevatedButton(
                    icon: Icon(
                      Theme.of(context).colorScheme.brightness ==
                              Brightness.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                    label: Theme.of(context).colorScheme.brightness ==
                            Brightness.dark
                        ? 'DARK MODE'
                        : 'LIGHT MODE',
                    onPressed: () async {
                      ThemeSwitcher.of(context).changeTheme(
                        theme: Theme.of(context).brightness == Brightness.light
                            ? darkTheme
                            : lightTheme,
                      );

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      prefs
                          .setBool(
                        "darkTheme",
                        !(Theme.of(context).brightness == Brightness.dark),
                      )
                          .then((value) {
                        Scaffold.of(context).closeEndDrawer();
                      });
                    },
                  ),
                ),
              ),
              hSpace(10),
              Consumer<CreditsProvider>(
                builder: (context, prov, _) => Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.money_dollar_circle_fill,
                      color: Colors.white,
                      size: 25.sp,
                    ),
                    Text(
                      ' ${prov.credits.toString()}',
                      style: TextStyle(
                        fontSize: 25.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
          Positioned(
            bottom: 10.h,
            left: 0,
            child: SizedBox(
              width: 150,
              child: DrawerMenuItemWidget(
                icon: CupertinoIcons.return_icon,
                text: "Logout",
                contentAlignment: MainAxisAlignment.center,
                onTap: () {
                  _homeStore.setPage(HomePageType.pokemonGrid);
                  Provider.of<AuthProvider>(context, listen: false)
                      .logout(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
