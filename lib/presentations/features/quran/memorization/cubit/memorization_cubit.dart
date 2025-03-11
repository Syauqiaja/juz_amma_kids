import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:juz_amma_kids/core/model/lesson.dart';
import 'package:juz_amma_kids/core/services/database_service.dart';

part 'memorization_state.dart';

class MemorizationCubit extends Cubit<MemorizationState> {
  MemorizationCubit() : super(MemorizationInitial());

  DatabaseService _databaseService = DatabaseService();

  late int currentAya;
  late List<int> ayahs;
  Map<int, List<bool>> recognizedWords = {}; // key is aya, value is words from remote
  late Surah surah;

  init(Surah lesson) async {
    this.surah = lesson;
    ayahs = lesson.words.map((e) => e.aya).toSet().toList();
    currentAya = ayahs.first;
  }

  void reset() {  
    currentAya = ayahs.first;
    recognizedWords.clear();
    emit(MemorizationInitial());
  } 

  submit(File audioFile, int aya) async {
    emit(MemorizationLoading());

    print("Audio file : ${audioFile.path}");

    final url = "https://qrecitationpk.onrender.com/verify-ayah";
    try {
      final multipartRequest = http.MultipartRequest("POST", Uri.parse(url));
      multipartRequest.headers["Accept"] = "application/json";

      multipartRequest.files.add(await http.MultipartFile.fromPath(
        'audio',
        audioFile.path,
        filename: audioFile.uri.pathSegments.last,
      ));

      multipartRequest.fields['sora'] = surah.soraIndex.toString();
      multipartRequest.fields['Aya'] = aya.toString();
      multipartRequest.fields['AyaCount'] = '1';
      print("fields ${multipartRequest.fields}");
      print("Audio path ${audioFile.path}");
      print("Audio file name ${audioFile.uri.pathSegments.last}");

      final streamedResponse = await multipartRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      final body = jsonDecode(response.body);
      print(body);

      List<Map<dynamic, dynamic>> words = (body['results'][0]['words'] as List<dynamic>).map((e) => e as Map<dynamic, dynamic>).toList();
      List<bool> allWords = surah.words.where((e) => e.aya == aya).map((e) => false).toList();
      allWords.removeAt(0);
      words.forEach((e){
        allWords[(e['index'] as int) - 1] = e["status"] == "correct";
        print(allWords[(e['index'] as int) - 1]);
      });

      recognizedWords[aya] = allWords;
      print(allWords);

      if (!recognizedWords[aya]!.contains(false)) {
        _databaseService.insertMemorizedAya(surah: surah, ayaIndex: currentAya, value: true);
        if (currentAya == ayahs.last) {
          emit(MemorizationDone());
          return;
        } else {
          currentAya++;
          emit(MemorizationWithData());
        }
      } else {
        _databaseService.insertMemorizedAya(surah: surah, ayaIndex: currentAya, value: false);
        emit(MemorizationWithData(message: "Incorrect"));
      }
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s);
      emit(MemorizationInitial(message: "Sorry, we don't hear anything"));
    }
  }

  submitForWeb(XFile audioFile, int aya) async {
    emit(MemorizationLoading());

    print("Audio file : ${audioFile.path}");

    final url = "https://qrecitationpk.onrender.com/verify-ayah";
    try {
      final multipartRequest = http.MultipartRequest("POST", Uri.parse(url));
      multipartRequest.headers["Accept"] = "application/json";

      final bytes = await audioFile.readAsBytes();

      multipartRequest.files.add(http.MultipartFile.fromBytes(
        'audio',
        bytes,
        filename: audioFile.path.split('/').last,
      ));

      multipartRequest.fields['sora'] = surah.soraIndex.toString();
      multipartRequest.fields['Aya'] = aya.toString();
      multipartRequest.fields['AyaCount'] = '1';
      print("fields ${multipartRequest.fields}");
      print("Audio path ${audioFile.path}");
      print("Audio file name ${audioFile.path.split('/').last}");

      final streamedResponse = await multipartRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      final body = jsonDecode(response.body);
      print(body);

      List<Map<dynamic, dynamic>> words = (body['results'][0]['words'] as List<dynamic>).map((e) => e as Map<dynamic, dynamic>).toList();
      List<bool> allWords = surah.words.where((e) => e.aya == aya).map((e) => false).toList();
      allWords.removeAt(0);
      words.forEach((e){
        allWords[(e['index'] as int) - 1] = e["status"] == "correct";
        print(allWords[(e['index'] as int) - 1]);
      });

      recognizedWords[aya] = allWords;
      print(allWords);

      if (!recognizedWords[aya]!.contains(false)) {
        _databaseService.insertMemorizedAya(surah: surah, ayaIndex: currentAya, value: true);
        if (currentAya == ayahs.last) {
          emit(MemorizationDone());
          return;
        } else {
          currentAya++;
          emit(MemorizationWithData());
        }
      } else {
        _databaseService.insertMemorizedAya(surah: surah, ayaIndex: currentAya, value: false);
        emit(MemorizationWithData(message: "Incorrect"));
      }
    } catch (e, s) {
      print(e);
      debugPrintStack(stackTrace: s, label: "Memorization cubit web");
      emit(MemorizationInitial(message: "Sorry, we don't hear anything"));
    }
  }
}
