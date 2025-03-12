import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:juz_amma_kids/core/model/surah.dart';
import 'package:juz_amma_kids/core/model/memorization_model.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/main.dart';
import 'package:juz_amma_kids/presentations/features/select_surah/cubit/select_sora_cubit.dart';
import 'package:juz_amma_kids/presentations/modals/button_scalable.dart';
import 'package:juz_amma_kids/route/app_routes.dart';
import 'package:juz_amma_kids/utils/audio_player_ext.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

class SoraItem extends StatefulWidget {
  final Surah? surah;
  final bool? isSelected;
  final Function? onTap;
  const SoraItem({super.key, required this.surah, this.isSelected, this.onTap});

  @override
  State<SoraItem> createState() => _SoraItemState();
}

class _SoraItemState extends State<SoraItem> {
  late SelectSoraCubit _selectSoraCubit;
  @override
  void initState() {
    _selectSoraCubit = context.read<SelectSoraCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.surah != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSlide(
                offset:
                    widget.isSelected == true ? Offset(0, 1.9) : Offset(0, 1),
                duration: Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: widget.isSelected == true ? 1 : 0,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      ButtonScalable(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(Assets.bookSmall,
                                  height: 24, width: 24),
                              const SizedBox(width: 4),
                              Text(
                                "Read",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.quran,
                                    arguments: widget.surah)
                                .then((_) {
                              if (context.mounted) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _selectSoraCubit
                                      .refresh();
                                });
                              }
                            });
                          }),
                      const SizedBox(height: 8),
                      ButtonScalable(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Assets.starSmall,
                                height: 24, width: 24),
                            const SizedBox(width: 4),
                            Text(
                              "Practice",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        onTap: () async {
                          final micPermission =
                              await Permission.microphone.request();
                          if (!micPermission.isGranted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Please provide microphone permisson")));
                            return;
                          }

                          audioPlayerEffect?.playOpenPanel();
                          if (context.mounted) {
                            Navigator.of(context)
                                .pushNamed(
                                  AppRoutes.memorization,
                                  arguments: widget.surah,
                                )
                                .then((_) {});
                            if (context.mounted) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _selectSoraCubit
                                    .refresh();
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSlide(
                offset: widget.isSelected == true
                    ? Offset(0, -0.5)
                    : Offset(0, -0.2),
                duration: Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: GestureDetector(
                  onTap: () {
                    widget.onTap?.call();
                  },
                  child: Container(
                    width: 200,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0XFFF7FAFE),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 80,
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0XFF94CAD0),
                          ),
                          child: SvgPicture.asset(
                            widget.surah!.imageAsset,
                            fit: BoxFit.fitHeight,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.surah!.title,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF77759A)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${widget.surah!.totalAya} Ayah",
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF77759A)),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.grey.withAlpha(100))),
                          padding: EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(Assets.starSmall),
                                  const SizedBox(width: 4),
                                  Text(
                                      '${((widget.surah?.memorizationModel?.memorizedPercentage() ?? 0) * 100).floor()}%')
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(Assets.bookSmall),
                                  const SizedBox(width: 4),
                                  Text(
                                      '${((widget.surah?.memorizationModel?.readPercentage() ?? 0) * 100).floor()}%')
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : _buildLoadingLayout();
  }

  Widget _buildLoadingLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSlide(
          offset: widget.isSelected == true ? Offset(0, 1.9) : Offset(0, 1),
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: widget.isSelected == true ? 1 : 0,
            child: Column(
              children: [
                const SizedBox(height: 8),
                ButtonScalable(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Assets.bookSmall, height: 24, width: 24),
                        const SizedBox(width: 4),
                        Text(
                          "Read",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    onTap: () {}),
                const SizedBox(height: 8),
                ButtonScalable(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Assets.starSmall, height: 24, width: 24),
                        const SizedBox(width: 4),
                        Text(
                          "Practice",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    onTap: () {}),
              ],
            ),
          ),
        ),
        AnimatedSlide(
          offset: widget.isSelected == true ? Offset(0, -0.5) : Offset(0, -0.2),
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: GestureDetector(
            onTap: null,
            child: Container(
              width: 200,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0XFFF7FAFE),
              ),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0XFF94CAD0),
                    ),
                    child: Center(
                      child: const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      color: Colors.grey,
                      width: 64,
                      height: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      color: Colors.grey,
                      width: 64,
                      height: 15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.withAlpha(100))),
                    padding: EdgeInsets.all(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(Assets.starSmall),
                            const SizedBox(width: 4),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                color: Colors.grey,
                                width: 48,
                                height: 15,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(Assets.bookSmall),
                            const SizedBox(width: 4),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                color: Colors.grey,
                                width: 48,
                                height: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
