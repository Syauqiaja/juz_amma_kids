import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:juz_amma_kids/core/model/lesson.dart';
import 'package:juz_amma_kids/core/model/surah_word.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/presentations/features/quran/bloc/quran_bloc.dart';
import 'package:juz_amma_kids/presentations/features/quran/memorization/cubit/memorization_cubit.dart';
import 'package:juz_amma_kids/theme/quranic_theme.dart';
import 'package:juz_amma_kids/utils/context_ext.dart';
import 'package:sizer/sizer.dart';

class MemorizationMushafBox extends StatefulWidget {
  final ScrollController scrollController;
  final Surah surah;
  final List<SurahWord> disabledWords;
  const MemorizationMushafBox({super.key, required this.scrollController, required this.surah, this.disabledWords = const []});

  @override
  State<MemorizationMushafBox> createState() => _MemorizationMushafBoxState();
}

class _MemorizationMushafBoxState extends State<MemorizationMushafBox> {
  late MemorizationCubit _memorizationCubit;
  late bool isLargeScreen;

  late QuranBloc _quranBloc;

  List<Widget> _buildAyahSpans(int selectedAyahIndex) {
    List<Widget> widgets = [];
    int lineIndex = _quranBloc.surahWords.first.line;
    List<InlineSpan> _line = [];

    List<int> ayas = widget.surah.words.map((e) => e.aya).toSet().toList();
    Map<int, SurahWord> points = {};
    ayas.forEach((val) {
      points[val] = widget.surah.words.lastWhere((e) => e.aya == val);
    });

    int currentWord = 0;
    int currentAya = ayas.first;

    List<SurahWord> words = widget.surah.words;
    if(widget.disabledWords.isNotEmpty && !words.contains(widget.disabledWords.first)){
      words.insertAll(0, widget.disabledWords);
    }

    words.forEach((word) {
      if (word.line != lineIndex) {
        lineIndex++;
        widgets.add(Text.rich(TextSpan(
          children: [..._line],
        )));
        _line.clear();
      }

      bool? isCorrect = null;
      if (word == points[word.aya]) { //Check if current word is aya pointer
        currentWord = 0;
        currentAya++;
      } else {
        if (word.aya == currentAya && _memorizationCubit.recognizedWords[currentAya] != null) {
          if (_memorizationCubit.recognizedWords[currentAya]![currentWord]) {
            isCorrect = true;
          } else {
            isCorrect = false;
          }
        }
        currentWord++;
      }

      BorderRadius border = BorderRadius.all(Radius.zero);

      final bool isSelected = word.aya == selectedAyahIndex;
      WidgetSpan widgetSpan = WidgetSpan(
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? QuranicTheme.highlightColor : Colors.transparent,
            borderRadius: border,
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          child: AutoSizeText(
            word.word,
            style: TextStyle(
              fontSize: context.isTablet() ? 36 : 18.5,
              fontFamily: 'QCF2${word.page.toString().padLeft(3, '0')}',
              color: (word.sora == widget.surah.soraIndex) ? word == points[word.aya]!
                  ? Colors.black
                  : isCorrect == null
                      ? Colors.transparent
                      : isCorrect
                          ? Colors.green
                          : Colors.red : Colors.grey.shade400,
            ),
            locale: Locale('ar'),
          ),
        ),
      );

      _line.insert(0, widgetSpan);
    });

    widgets.add(Text.rich(TextSpan(
      children: [..._line],
    )));
    return widgets;
  }

  @override
  void initState() {
    _quranBloc = BlocProvider.of<QuranBloc>(context);
    _memorizationCubit = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isLargeScreen = MediaQuery.of(context).size.height > 650;
    return Container(
      // width: MediaQuery.of(context).size.width * (context.isTablet() ? 0.8 : isLargeScreen ? 0.6 : 0.7),
      // height: MediaQuery.of(context).size.height * (context.isTablet() ? 0.68 : 0.75),
      padding: context.isTablet() 
                ? const EdgeInsets.only(top: 50, right: 50, left: 50, bottom: 50) 
                : const EdgeInsets.only(top: 30, right: 30, left: 30, bottom: 30),      
        color: Colors.transparent, // Ensure the background is transparent
      child: BlocBuilder<QuranBloc, QuranState>(
        buildWhen: (previous, current) => previous is QuranInitial || previous is QuranLoading,
        builder: (context, state) {
          if (state is QuranIdle) {
            return SingleChildScrollView(
              controller: widget.scrollController,
              physics: ClampingScrollPhysics(),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          Assets.borderTitle,
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                        Positioned(
                          left: 0,
                          child: Padding(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06),
                            child: Center(
                              child: Container(),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.all(2.h),
                            child: SvgPicture.asset(
                              'assets/titles/${widget.surah.soraIndex}.svg',
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24, right: 24),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: BlocBuilder<MemorizationCubit, MemorizationState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                if(_quranBloc.surah.soraIndex != 1)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    ' ',
                                    style: TextStyle(
                                      fontSize: context.isTablet() ? 36 : 18.5,                                      
                                      fontFamily: 'testfont',
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                ..._buildAyahSpans(_memorizationCubit.currentAya),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
