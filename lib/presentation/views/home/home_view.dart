import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/handlers/navigation_handler.dart';
import 'package:storiez/presentation/resources/app_assets.dart';
import 'package:storiez/presentation/resources/palette.dart';
import 'package:storiez/presentation/routes/routes.dart';
import 'package:storiez/presentation/shared/shared.dart';
import 'package:storiez/presentation/views/home/home_view_model.dart';
import 'package:storiez/presentation/views/home/widgets/drawer.dart';
import 'package:storiez/presentation/views/home/widgets/indicator_row.dart';
import 'package:storiez/presentation/views/story/story_view.dart';
import 'package:storiez/utils/utils.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final _logger = Logger(_HomeViewState);
  late final _pageController = PageController();
  late final ValueNotifier<int> _currentIndex = ValueNotifier(0);
  late final ValueNotifier<bool> _pageViewRenderStatus = ValueNotifier(false);
  Timer? _timer;

  void _checkPageViewRenderStatus() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_pageController.hasClients) {
          _pageViewRenderStatus.value = true;
          timer.cancel();
        }
      },
    );
  }

  void _listenToPageChange() {
    try {
      _currentIndex.value = _pageController.page!.round();
    } catch (e) {
      _logger.log(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_listenToPageChange);
    _checkPageViewRenderStatus();
  }

  @override
  void dispose() {
    _pageController.removeListener(_listenToPageChange);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      onWillPop: () {
        locator<NavigationHandler>().exitApp();
      },
      backgroundColor: Palette.primaryColor,
      appBar: AppBar(
        title: const Text("Storiez"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8) +
                const EdgeInsets.only(right: 8),
            child: Consumer(builder: (_, ref, __) {
              return FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(Icons.add),
                onPressed: () async {
                  await Navigator.of(context).pushNamed(
                    Routes.imagePickerViewRoute,
                  );
                  ref.read(homeViewModelProvider).subscribeToStoriesStream();
                },
              );
            }),
          ),
        ],
      ),
      drawer: const HomeDrawer(),
      builder: (size) {
        return SizedBox.expand(
          child: Consumer(
            builder: (_, ref, __) {
              final stories = ref.watch(homeViewModelProvider).stories;
              final loading = ref.watch(homeViewModelProvider).loading;

              if (loading && stories.isEmpty) {
                return Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor:
                        Platform.isAndroid ? null : Palette.primaryColorLight,
                    valueColor: const AlwaysStoppedAnimation(
                      Palette.primaryColorLight,
                    ),
                  ),
                );
              }
              if (!loading && stories.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.maleMemoji.assetName,
                      height: 80,
                      width: 80,
                    ),
                    const Gap(8),
                    CustomText.regular(
                      text: "Nothing to see here.",
                      color: Palette.primaryColorLight,
                    ),
                    CustomText.regular(
                      text: "Add a story!",
                      color: Palette.primaryColorLight,
                    ),
                    const Gap(80),
                  ],
                );
              }
              return Stack(
                children: [
                  ValueListenableBuilder<bool>(
                      valueListenable: _pageViewRenderStatus,
                      builder: (_, isPageViewBuilt, __) {
                        if (!isPageViewBuilt) return const SizedBox();
                        return ValueListenableBuilder<int>(
                          valueListenable: _currentIndex,
                          builder: (_, activeIndex, __) {
                            return IndicatorRow(
                              length: stories.length,
                              activeIndex: activeIndex,
                            );
                          },
                        );
                      }),
                  PageView.builder(
                    controller: _pageController,
                    itemCount: stories.length,
                    itemBuilder: (_, index) {
                      return StoryView(story: stories[index]);
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
