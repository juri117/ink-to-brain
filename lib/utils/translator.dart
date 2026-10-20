import 'dart:io';

import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class JournalTranslator {
  static bool get isAvailable => Platform.isAndroid || Platform.isIOS;

  OnDeviceTranslator? _practiceToPrimary;
  OnDeviceTranslator? _primaryToPractice;
  TranslateLanguage? _practiceLang;
  TranslateLanguage? _primaryLang;
  bool _modelsReady = false;

  Future<void> ensureReady({
    required String practiceBcp,
    required String primaryBcp,
  }) async {
    if (!isAvailable) return;

    final practice =
        TranslateLanguage.values.bcp47(practiceBcp) ?? TranslateLanguage.vietnamese;
    final primary =
        TranslateLanguage.values.bcp47(primaryBcp) ?? TranslateLanguage.german;

    if (_practiceToPrimary != null &&
        _primaryToPractice != null &&
        _practiceLang == practice &&
        _primaryLang == primary &&
        _modelsReady) {
      return;
    }

    await close();

    _practiceLang = practice;
    _primaryLang = primary;

    final manager = OnDeviceTranslatorModelManager();
    await manager.downloadModel(practice.bcpCode);
    await manager.downloadModel(primary.bcpCode);
    _modelsReady = true;

    _practiceToPrimary = OnDeviceTranslator(
      sourceLanguage: practice,
      targetLanguage: primary,
    );
    _primaryToPractice = OnDeviceTranslator(
      sourceLanguage: primary,
      targetLanguage: practice,
    );
  }

  Future<String> translatePracticeToPrimary(String text) async {
    if (!isAvailable || _practiceToPrimary == null) return '';
    final trimmed = text.trim();
    if (trimmed.isEmpty) return '';
    return _practiceToPrimary!.translateText(trimmed);
  }

  Future<String> translatePrimaryToPractice(String text) async {
    if (!isAvailable || _primaryToPractice == null) return '';
    final trimmed = text.trim();
    if (trimmed.isEmpty) return '';
    return _primaryToPractice!.translateText(trimmed);
  }

  Future<void> close() async {
    await _practiceToPrimary?.close();
    await _primaryToPractice?.close();
    _practiceToPrimary = null;
    _primaryToPractice = null;
    _practiceLang = null;
    _primaryLang = null;
    _modelsReady = false;
  }
}

extension _BcpLookup on List<TranslateLanguage> {
  TranslateLanguage? bcp47(String code) {
    for (final lang in this) {
      if (lang.bcpCode == code) return lang;
    }
    return null;
  }
}
