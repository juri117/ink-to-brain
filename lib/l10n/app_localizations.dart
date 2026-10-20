import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ink to brain'**
  String get appTitle;

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'start workout'**
  String get startWorkout;

  /// No description provided for @allQuestions.
  ///
  /// In en, this message translates to:
  /// **'all questions'**
  String get allQuestions;

  /// No description provided for @addQuestions.
  ///
  /// In en, this message translates to:
  /// **'add questions'**
  String get addQuestions;

  /// No description provided for @writeJournal.
  ///
  /// In en, this message translates to:
  /// **'write journal'**
  String get writeJournal;

  /// No description provided for @journal.
  ///
  /// In en, this message translates to:
  /// **'journal'**
  String get journal;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'settings'**
  String get settingsTooltip;

  /// No description provided for @syncTooltip.
  ///
  /// In en, this message translates to:
  /// **'sync.'**
  String get syncTooltip;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get total;

  /// No description provided for @mastered.
  ///
  /// In en, this message translates to:
  /// **'mastered'**
  String get mastered;

  /// No description provided for @statNew.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get statNew;

  /// No description provided for @practicedToday.
  ///
  /// In en, this message translates to:
  /// **'practiced today'**
  String get practicedToday;

  /// No description provided for @leftForToday.
  ///
  /// In en, this message translates to:
  /// **'left for today'**
  String get leftForToday;

  /// No description provided for @revCount.
  ///
  /// In en, this message translates to:
  /// **'rev: {count}'**
  String revCount(int count);

  /// No description provided for @yeahDone.
  ///
  /// In en, this message translates to:
  /// **'Yeah, you are done!'**
  String get yeahDone;

  /// No description provided for @correctStat.
  ///
  /// In en, this message translates to:
  /// **'correct: {count}'**
  String correctStat(int count);

  /// No description provided for @mistakesStat.
  ///
  /// In en, this message translates to:
  /// **'mistakes: {count}'**
  String mistakesStat(int count);

  /// No description provided for @skippedStat.
  ///
  /// In en, this message translates to:
  /// **'skipped: {count}'**
  String skippedStat(int count);

  /// No description provided for @anotherRound.
  ///
  /// In en, this message translates to:
  /// **'another round'**
  String get anotherRound;

  /// No description provided for @iAmDone.
  ///
  /// In en, this message translates to:
  /// **'I am done'**
  String get iAmDone;

  /// No description provided for @wordsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String wordsLeft(int count);

  /// No description provided for @scoreLabel.
  ///
  /// In en, this message translates to:
  /// **'score: {count}'**
  String scoreLabel(int count);

  /// No description provided for @workoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workoutTitle;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'skip'**
  String get skip;

  /// No description provided for @solution.
  ///
  /// In en, this message translates to:
  /// **'solution'**
  String get solution;

  /// No description provided for @wrong.
  ///
  /// In en, this message translates to:
  /// **'wrong'**
  String get wrong;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'correct'**
  String get correct;

  /// No description provided for @listTitle.
  ///
  /// In en, this message translates to:
  /// **'list'**
  String get listTitle;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'search'**
  String get search;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'added'**
  String get added;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'question'**
  String get question;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'answer'**
  String get answer;

  /// No description provided for @asked.
  ///
  /// In en, this message translates to:
  /// **'asked'**
  String get asked;

  /// No description provided for @resetScore.
  ///
  /// In en, this message translates to:
  /// **'reset score'**
  String get resetScore;

  /// No description provided for @forceStartLearning.
  ///
  /// In en, this message translates to:
  /// **'force start learning'**
  String get forceStartLearning;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'edit'**
  String get edit;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'never'**
  String get never;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'save'**
  String get save;

  /// No description provided for @translationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'translation unavailable on this platform'**
  String get translationUnavailable;

  /// No description provided for @downloadingLanguageModels.
  ///
  /// In en, this message translates to:
  /// **'downloading language models…'**
  String get downloadingLanguageModels;

  /// No description provided for @editJournal.
  ///
  /// In en, this message translates to:
  /// **'edit journal'**
  String get editJournal;

  /// No description provided for @journalField.
  ///
  /// In en, this message translates to:
  /// **'journal ({lang})'**
  String journalField(String lang);

  /// No description provided for @translationField.
  ///
  /// In en, this message translates to:
  /// **'translation ({lang})'**
  String translationField(String lang);

  /// No description provided for @lookupField.
  ///
  /// In en, this message translates to:
  /// **'lookup ({from} → {to})'**
  String lookupField(String from, String to);

  /// No description provided for @translationSetupFailed.
  ///
  /// In en, this message translates to:
  /// **'translation setup failed: {error}'**
  String translationSetupFailed(String error);

  /// No description provided for @translateFailed.
  ///
  /// In en, this message translates to:
  /// **'translate failed: {error}'**
  String translateFailed(String error);

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'refresh'**
  String get refresh;

  /// No description provided for @noJournalEntries.
  ///
  /// In en, this message translates to:
  /// **'no journal entries yet'**
  String get noJournalEntries;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @nextcloudLogin.
  ///
  /// In en, this message translates to:
  /// **'nextcloud login'**
  String get nextcloudLogin;

  /// No description provided for @hostHint.
  ///
  /// In en, this message translates to:
  /// **'host.url'**
  String get hostHint;

  /// No description provided for @hostLabel.
  ///
  /// In en, this message translates to:
  /// **'host-url/ip'**
  String get hostLabel;

  /// No description provided for @userHint.
  ///
  /// In en, this message translates to:
  /// **'user'**
  String get userHint;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get username;

  /// No description provided for @pwHint.
  ///
  /// In en, this message translates to:
  /// **'pw'**
  String get pwHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @journalLanguages.
  ///
  /// In en, this message translates to:
  /// **'journal languages'**
  String get journalLanguages;

  /// No description provided for @practiceLanguage.
  ///
  /// In en, this message translates to:
  /// **'practice language'**
  String get practiceLanguage;

  /// No description provided for @primaryLanguage.
  ///
  /// In en, this message translates to:
  /// **'primary language (translation)'**
  String get primaryLanguage;

  /// No description provided for @offlineTranslationNote.
  ///
  /// In en, this message translates to:
  /// **'Offline translation uses Android ML Kit. Language models download on demand when you open the journal.'**
  String get offlineTranslationNote;

  /// No description provided for @misc.
  ///
  /// In en, this message translates to:
  /// **'misc.'**
  String get misc;

  /// No description provided for @useTextIfExisting.
  ///
  /// In en, this message translates to:
  /// **'use text if existing (not the doodle)'**
  String get useTextIfExisting;

  /// No description provided for @storeSettings.
  ///
  /// In en, this message translates to:
  /// **'store settings'**
  String get storeSettings;

  /// No description provided for @questionNote.
  ///
  /// In en, this message translates to:
  /// **'Question Note'**
  String get questionNote;

  /// No description provided for @answerNote.
  ///
  /// In en, this message translates to:
  /// **'Answer Note'**
  String get answerNote;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'back'**
  String get back;

  /// No description provided for @reverse.
  ///
  /// In en, this message translates to:
  /// **'reverse'**
  String get reverse;

  /// No description provided for @legacy.
  ///
  /// In en, this message translates to:
  /// **'legacy'**
  String get legacy;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get all;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// No description provided for @go.
  ///
  /// In en, this message translates to:
  /// **'GO'**
  String get go;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get done;

  /// No description provided for @syncDatabase.
  ///
  /// In en, this message translates to:
  /// **'sync. database with nextcloud'**
  String get syncDatabase;

  /// No description provided for @downloadOverwrite.
  ///
  /// In en, this message translates to:
  /// **'download, overwrite db'**
  String get downloadOverwrite;

  /// No description provided for @uploadLocalDb.
  ///
  /// In en, this message translates to:
  /// **'upload local db'**
  String get uploadLocalDb;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'loading...'**
  String get loading;

  /// No description provided for @uploadResult.
  ///
  /// In en, this message translates to:
  /// **'upload: {result}'**
  String uploadResult(String result);

  /// No description provided for @downloadResult.
  ///
  /// In en, this message translates to:
  /// **'download: {result}'**
  String downloadResult(String result);

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'empty'**
  String get empty;

  /// No description provided for @disableEraser.
  ///
  /// In en, this message translates to:
  /// **'Disable eraser'**
  String get disableEraser;

  /// No description provided for @enableEraser.
  ///
  /// In en, this message translates to:
  /// **'Enable eraser'**
  String get enableEraser;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'reload'**
  String get reload;

  /// No description provided for @notiTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to study!'**
  String get notiTitle;

  /// No description provided for @notiBody.
  ///
  /// In en, this message translates to:
  /// **'Do it now!'**
  String get notiBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
