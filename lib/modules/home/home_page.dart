// ignore_for_file: unused_field

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:app/modules/daily_checkin/daily_checkin_page.dart';
import 'package:app/modules/favourites/favourites_page.dart';
import 'package:app/modules/home/home_page_store.dart';
import 'package:app/modules/items/items_page.dart';

import 'package:app/modules/news/news_page.dart';
import 'package:app/modules/pokemon_grid/pokemon_grid_page.dart';
import 'package:app/modules/merch/tshirts_page.dart';

import 'package:app/shared/providers/credits_provider.dart';

import 'package:app/shared/stores/item_store/item_store.dart';
import 'package:app/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:app/shared/ui/widgets/app_bar.dart';
import 'package:app/shared/ui/widgets/drawer_menu/drawer_menu.dart';
import 'package:app/shared/utils/app_constants.dart';
import 'package:app/modules/videos/video_page.dart';

import 'package:app/theme/app_layout.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _backgroundAnimationController;
  late Animation<double> _blackBackgroundOpacityAnimation;

  late AnimationController _fabAnimationRotationController;
  late AnimationController _fabAnimationOpenController;
  late Animation<double> _fabRotateAnimation;
  late Animation<double> _fabSizeAnimation;

  late PokemonStore _pokemonStore;
  late ItemStore _itemStore;
  late HomePageStore _homeStore;
  late PanelController _panelController;

  late List<ReactionDisposer> reactionDisposer = [];

  @override
  void initState() {
    super.initState();
    context.read<CreditsProvider>().getCredits();

    _pokemonStore = GetIt.instance<PokemonStore>();
    _itemStore = GetIt.instance<ItemStore>();
    _homeStore = GetIt.instance<HomePageStore>();
    _panelController = PanelController();

    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _blackBackgroundOpacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_backgroundAnimationController);

    _fabAnimationRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fabAnimationOpenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fabRotateAnimation = Tween(begin: 180.0, end: 0.0).animate(CurvedAnimation(
        curve: Curves.easeOut, parent: _fabAnimationRotationController));

    _fabSizeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.4), weight: 80.0),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 20.0),
    ]).animate(_fabAnimationRotationController);

    reactionDisposer.add(
      reaction((_) => _homeStore.isFilterOpen, (_) {
        if (_homeStore.isFilterOpen) {
          _panelController.open();
          _homeStore.showBackgroundBlack();
          _homeStore.hideFloatActionButton();
        } else {
          _panelController.close();
          _homeStore.hideBackgroundBlack();
          _homeStore.showFloatActionButton();
        }
      }),
    );

    reactionDisposer.add(
      reaction((_) => _homeStore.isBackgroundBlack, (_) {
        if (_homeStore.isBackgroundBlack) {
          _backgroundAnimationController.forward();
        } else {
          _backgroundAnimationController.reverse();
        }
      }),
    );

    reactionDisposer.add(
      reaction((_) => _homeStore.isFabVisible, (_) {
        if (_homeStore.isFabVisible) {
          _fabAnimationRotationController.forward();
        } else {
          _fabAnimationRotationController.reverse();
        }
      }),
    );

    _fabAnimationRotationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            extendBodyBehindAppBar: false,
            key: const Key('home_page'),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            endDrawer: const Drawer(
              child: DrawerMenuWidget(),
            ),
            body: Stack(
              children: [
                SafeArea(
                  bottom: false,
                  child: CustomScrollView(
                    slivers: [
                      
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppLayouts.horizontalPagePadding,
                          vertical: 10,
                        ),
                        sliver: Observer(
                          builder: (_) => AppBarWidget(
                            title: _homeStore.page.description,
                            lottiePath: AppConstants.pikachuTurnLottie,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) {
                          switch (_homeStore.page) {
                            case HomePageType.pokemonGrid:
                              return const PokemonGridPage();
                            case HomePageType.items:
                              return const ItemsPage();
                            case HomePageType.favourites:
                              return const FavouritesPage();
                            case HomePageType.news:
                              return const NewsPage();
                            case HomePageType.videos:
                              return const VideoPage();
                            case HomePageType.checkIn:
                              return const DailyCheckinPage();
                            case HomePageType.merchandise:
                              return const TShirtsPage();
                            default:
                              return const PokemonGridPage();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
