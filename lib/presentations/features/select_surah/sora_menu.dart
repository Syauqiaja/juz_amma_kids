import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juz_amma_kids/presentations/features/select_surah/cubit/select_sora_cubit.dart';
import 'package:juz_amma_kids/presentations/features/select_surah/widgets/sora_section.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SurahMenuPage extends StatefulWidget {
  @override
  _SurahMenuPageState createState() => _SurahMenuPageState();
}

class _SurahMenuPageState extends State<SurahMenuPage> {
  late SelectSoraCubit _selectSoraCubit;

  ScrollController _scrollController = ScrollController();
  final List<int> years = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  final List<double> sectionsBottomPadding = [4, -24, 40, 0, 40, 32, 40, 40, 40, 40, 40, 16];

  @override
  void initState() {
    super.initState();
    _selectSoraCubit = BlocProvider.of(context);

    if (_selectSoraCubit.state is! SelectSoraWithData) {
      _selectSoraCubit.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              reverse: true,
              child: BlocBuilder<SelectSoraCubit, SelectSoraState>(
                builder: (context, state) {
                  if (state is SelectSoraWithData) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      reverse: true,
                      itemCount: sectionsBottomPadding.length,
                      itemBuilder: (context, index) {
                        return SoraSection(section: index + 1, bottomPadding: sectionsBottomPadding[index], lessons: state.surahs);
                      },
                      shrinkWrap: true,
                    );
                  } else {
                    return SoraSection(
                      section: 1,
                      bottomPadding: 4,
                      lessons: [],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
