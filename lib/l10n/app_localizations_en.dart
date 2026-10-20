// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ink to brain';

  @override
  String get startWorkout => 'start workout';

  @override
  String get allQuestions => 'all questions';

  @override
  String get addQuestions => 'add questions';

  @override
  String get writeJournal => 'write journal';

  @override
  String get journal => 'journal';

  @override
  String get settingsTooltip => 'settings';

  @override
  String get syncTooltip => 'sync.';

  @override
  String get total => 'total';

  @override
  String get mastered => 'mastered';

  @override
  String get statNew => 'new';

  @override
  String get practicedToday => 'practiced today';

  @override
  String get leftForToday => 'left for today';

  @override
  String revCount(int count) {
    return 'rev: $count';
  }

  @override
  String get yeahDone => 'Yeah, you are done!';

  @override
  String correctStat(int count) {
    return 'correct: $count';
  }

  @override
  String mistakesStat(int count) {
    return 'mistakes: $count';
  }

  @override
  String skippedStat(int count) {
    return 'skipped: $count';
  }

  @override
  String get anotherRound => 'another round';

  @override
  String get iAmDone => 'I am done';

  @override
  String wordsLeft(int count) {
    return '$count left';
  }

  @override
  String scoreLabel(int count) {
    return 'score: $count';
  }

  @override
  String get workoutTitle => 'Workout';

  @override
  String get skip => 'skip';

  @override
  String get solution => 'solution';

  @override
  String get wrong => 'wrong';

  @override
  String get correct => 'correct';

  @override
  String get listTitle => 'list';

  @override
  String get search => 'search';

  @override
  String get added => 'added';

  @override
  String get question => 'question';

  @override
  String get answer => 'answer';

  @override
  String get asked => 'asked';

  @override
  String get resetScore => 'reset score';

  @override
  String get forceStartLearning => 'force start learning';

  @override
  String get edit => 'edit';

  @override
  String get never => 'never';

  @override
  String get delete => 'delete';

  @override
  String get save => 'save';

  @override
  String get translationUnavailable =>
      'translation unavailable on this platform';

  @override
  String get downloadingLanguageModels => 'downloading language models…';

  @override
  String get editJournal => 'edit journal';

  @override
  String journalField(String lang) {
    return 'journal ($lang)';
  }

  @override
  String translationField(String lang) {
    return 'translation ($lang)';
  }

  @override
  String lookupField(String from, String to) {
    return 'lookup ($from → $to)';
  }

  @override
  String translationSetupFailed(String error) {
    return 'translation setup failed: $error';
  }

  @override
  String translateFailed(String error) {
    return 'translate failed: $error';
  }

  @override
  String get refresh => 'refresh';

  @override
  String get noJournalEntries => 'no journal entries yet';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appLanguage => 'App language';

  @override
  String get nextcloudLogin => 'nextcloud login';

  @override
  String get hostHint => 'host.url';

  @override
  String get hostLabel => 'host-url/ip';

  @override
  String get userHint => 'user';

  @override
  String get username => 'username';

  @override
  String get pwHint => 'pw';

  @override
  String get password => 'password';

  @override
  String get journalLanguages => 'journal languages';

  @override
  String get practiceLanguage => 'practice language';

  @override
  String get primaryLanguage => 'primary language (translation)';

  @override
  String get offlineTranslationNote =>
      'Offline translation uses Android ML Kit. Language models download on demand when you open the journal.';

  @override
  String get misc => 'misc.';

  @override
  String get useTextIfExisting => 'use text if existing (not the doodle)';

  @override
  String get storeSettings => 'store settings';

  @override
  String get questionNote => 'Question Note';

  @override
  String get answerNote => 'Answer Note';

  @override
  String get next => 'next';

  @override
  String get back => 'back';

  @override
  String get reverse => 'reverse';

  @override
  String get legacy => 'legacy';

  @override
  String get all => 'all';

  @override
  String get cancel => 'cancel';

  @override
  String get go => 'GO';

  @override
  String get done => 'done';

  @override
  String get syncDatabase => 'sync. database with nextcloud';

  @override
  String get downloadOverwrite => 'download, overwrite db';

  @override
  String get uploadLocalDb => 'upload local db';

  @override
  String get loading => 'loading...';

  @override
  String uploadResult(String result) {
    return 'upload: $result';
  }

  @override
  String downloadResult(String result) {
    return 'download: $result';
  }

  @override
  String get empty => 'empty';

  @override
  String get disableEraser => 'Disable eraser';

  @override
  String get enableEraser => 'Enable eraser';

  @override
  String get undo => 'Undo';

  @override
  String get clear => 'Clear';

  @override
  String get reload => 'reload';

  @override
  String get notiTitle => 'Time to study!';

  @override
  String get notiBody => 'Do it now!';
}
