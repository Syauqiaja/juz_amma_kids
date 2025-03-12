import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juz_amma_kids/core/model/surah.dart';
import 'package:juz_amma_kids/core/services/sora_names_const.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/main.dart';
import 'package:juz_amma_kids/presentations/features/select_surah/cubit/select_sora_cubit.dart';
import 'package:juz_amma_kids/presentations/modals/frame_panel.dart';
import 'package:juz_amma_kids/presentations/modals/frame_title.dart';
import 'package:juz_amma_kids/presentations/modals/normal_button.dart';
import 'package:juz_amma_kids/route/app_routes.dart';
import 'package:juz_amma_kids/theme/quranic_theme.dart';
import 'package:juz_amma_kids/utils/audio_player_ext.dart';
import 'package:juz_amma_kids/utils/utilities.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SoraListMemorization extends StatefulWidget {
  const SoraListMemorization({super.key});

  @override
  State<SoraListMemorization> createState() => _SoraListMemorizationState();
}

class _SoraListMemorizationState extends State<SoraListMemorization> {
  late AppLocalizations _localization;
  late SelectSoraCubit _selectSoraCubit;
  late PageController _pageController;
  int _currentPage = 0;
  final List<int> years = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  @override
  void initState() {
    _selectSoraCubit = BlocProvider.of(context);
    _selectSoraCubit.load();
    _pageController = PageController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        color: QuranicTheme.scaffoldColor,
        width: double.infinity,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  Assets.mountainView,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: BlocBuilder<SelectSoraCubit, SelectSoraState>(
                      builder: (context, state) {
                        print("CUrrent page : $_currentPage");
                        if (state is SelectSoraWithData) {
                          return ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PageView.builder(
                                  itemCount: 1,
                                  controller: _pageController,
                                  onPageChanged: (value) {
                                    setState(() {
                                      _currentPage = value;
                                    });
                                  },
                                  itemBuilder: (context, index) {

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            top: 32,
                                            child: FramePanel(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 32, vertical: 32),
                                              child: ListView.builder(
                                                itemCount: state.surahs.length,
                                                itemBuilder: (context, index) {
                                                  final Surah lesson = state
                                                      .surahs[index];
                                                  return InkWell(
                                                    onTap: () async {
                                                      final micPermission =
                                                          await Permission
                                                              .microphone
                                                              .request();
                                                      if (!micPermission
                                                          .isGranted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "Please provide microphone permisson")));
                                                        return;
                                                      }

                                                      audioPlayerEffect
                                                          ?.playOpenPanel();
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                        AppRoutes.memorization,
                                                        arguments: lesson,
                                                      )
                                                          .then((_) {
                                                        SystemChrome
                                                            .setPreferredOrientations([
                                                          DeviceOrientation
                                                              .portraitDown,
                                                          DeviceOrientation
                                                              .portraitUp,
                                                        ]);
                                                      });
                                                    },
                                                    child: Card(
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          children: [
                                                            Column(
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  SoraNamesConstant
                                                                          .cSoraNames[
                                                                      lesson.soraIndex -
                                                                          1],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                Text(_localization.ayah_range(
                                                                    convertToArabicNumbers(
                                                                        lesson
                                                                            .startAya,
                                                                        locale: _localization
                                                                            .code),
                                                                    convertToArabicNumbers(
                                                                        lesson
                                                                            .endAya,
                                                                        locale:
                                                                            _localization.code))),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                              child: FrameTitle(
                                                width: 180,
                                                child: Text(
                                                  _localization.year_index(
                                                      convertToArabicNumbers(
                                                          1,
                                                          locale: _localization
                                                              .code)),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        } else if (state is SelectSoraError) {
                          return Center(
                            child: Text(state.message),
                          );
                        } else {
                          return Center(
                            child: SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
