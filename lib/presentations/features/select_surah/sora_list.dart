import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:juz_amma_kids/core/model/surah.dart';
import 'package:juz_amma_kids/core/services/sora_names_const.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/main.dart';
import 'package:juz_amma_kids/presentations/features/select_display_mode/widgets/hole_painter.dart';
import 'package:juz_amma_kids/presentations/features/select_surah/cubit/select_sora_cubit.dart';
import 'package:juz_amma_kids/presentations/features/select_surah/widgets/sora_item.dart';
import 'package:juz_amma_kids/presentations/modals/frame_panel.dart';
import 'package:juz_amma_kids/presentations/modals/frame_title.dart';
import 'package:juz_amma_kids/presentations/modals/normal_button.dart';
import 'package:juz_amma_kids/route/app_routes.dart';
import 'package:juz_amma_kids/theme/quranic_theme.dart';
import 'package:juz_amma_kids/utils/audio_player_ext.dart';
import 'package:juz_amma_kids/utils/context_ext.dart';
import 'package:juz_amma_kids/utils/utilities.dart';
import 'package:permission_handler/permission_handler.dart';

class SoraList extends StatefulWidget {
  const SoraList({super.key});

  @override
  State<SoraList> createState() => _SoraListState();
}

class _SoraListState extends State<SoraList>
    with SingleTickerProviderStateMixin {
  late SelectSoraCubit _selectSoraCubit;
  final ScrollController _scrollController = ScrollController();
  int? _selectedIndex;

  Size _size = Size.zero;
  late AnimationController _animationController;
  late Animation<double> _splashAnimation =
      Tween<double>(begin: 0, end: 10).animate(_animationController);
  bool isPlayAnimation = false;

  @override
  void initState() {
    _selectSoraCubit = context.read<SelectSoraCubit>();
    _selectSoraCubit.load();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _scrollController.addListener(() {
      if (_selectedIndex != null) {
        setState(() {
          _selectedIndex = null;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Scaffold(
            body: Container(
              color: QuranicTheme.scaffoldColor,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      Assets.bgMountain,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              NormalButton(
                                  // Button home
                                  height: context.isTablet() ? 64 : 48,
                                  width: context.isTablet() ? 64 : 48,
                                  onTap: () async {
                                    await audioPlayerEffect?.playClosePanel();
                                    Navigator.of(context).pop();
                                  },
                                  imageAsset: Assets.icHome),
                            ],
                          ),
                        ),
                        Expanded(
                          child: BlocListener<SelectSoraCubit, SelectSoraState>(
                            listenWhen: (previous, current) {
                              return (previous is SelectSoraLoading) &&
                                  (current is SelectSoraWithData);
                            },
                            listener: (context, state) {
                              setState(() {});
                            },
                            child:
                                BlocBuilder<SelectSoraCubit, SelectSoraState>(
                              builder: (context, state) {
                                if (state is SelectSoraWithData) {
                                  print("Updating selectsorawithdata builder");
                                  return ListView.builder(
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.surahs.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: index == 0
                                            ? EdgeInsets.only(left: 48)
                                            : index == state.surahs.length - 1
                                                ? EdgeInsets.only(right: 48)
                                                : EdgeInsets.all(0),
                                        child: SoraItem(
                                          surah: state.surahs[index],
                                          isSelected: index == _selectedIndex,
                                          onTap: () {
                                            setState(() {
                                              if (_selectedIndex == index) {
                                                _selectedIndex = null;
                                              } else {
                                                _selectedIndex = index;
                                              }
                                            });
                                          },
                                          onTapRead: (surah) async {
                                            Navigator.of(context)
                                                .pushNamed(AppRoutes.quran,
                                                    arguments: surah)
                                                .then((_) {
                                              if (context.mounted) {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _selectSoraCubit.refresh();
                                                });
                                              }
                                            });
                                          },
                                          onTapPractice: (surah) async {
                                            final micPermission =
                                                await Permission.microphone
                                                    .request();
                                            if (!micPermission.isGranted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Please provide microphone permisson")));
                                              return;
                                            }

                                            audioPlayerEffect?.playOpenPanel();

                                            if (context.mounted) {
                                              Navigator.of(context)
                                                  .pushNamed(
                                                AppRoutes.memorization,
                                                arguments: surah,
                                              )
                                                  .then((_) {
                                                if (context.mounted) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    _selectSoraCubit.refresh();
                                                  });
                                                }
                                              });
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  );
                                } else if (state is SelectSoraError) {
                                  return Center(
                                    child: Text(state.message),
                                  );
                                } else {
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: index == 0
                                            ? EdgeInsets.only(left: 48)
                                            : index == 4
                                                ? EdgeInsets.only(right: 48)
                                                : EdgeInsets.all(0),
                                        child: SoraItem(
                                          surah: null,
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isPlayAnimation)
          Container(
            height: double.infinity,
            width: double.infinity,
            child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: HolePainter(
                        color: Colors.black,
                        holeSize: _splashAnimation.value * _size.width),
                  );
                }),
          ),
      ],
    );
  }

  Widget _buildItem(Surah lesson) {
    return Container();
  }
}
