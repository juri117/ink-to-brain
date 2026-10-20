// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'ink to brain';

  @override
  String get startWorkout => 'bắt đầu luyện tập';

  @override
  String get allQuestions => 'tất cả câu hỏi';

  @override
  String get addQuestions => 'thêm câu hỏi';

  @override
  String get writeJournal => 'viết nhật ký';

  @override
  String get journal => 'nhật ký';

  @override
  String get settingsTooltip => 'cài đặt';

  @override
  String get syncTooltip => 'đồng bộ';

  @override
  String get total => 'tổng';

  @override
  String get mastered => 'đã thuộc';

  @override
  String get statNew => 'mới';

  @override
  String get practicedToday => 'đã luyện hôm nay';

  @override
  String get leftForToday => 'còn lại hôm nay';

  @override
  String revCount(int count) {
    return 'ngược: $count';
  }

  @override
  String get yeahDone => 'Xong rồi!';

  @override
  String correctStat(int count) {
    return 'đúng: $count';
  }

  @override
  String mistakesStat(int count) {
    return 'sai: $count';
  }

  @override
  String skippedStat(int count) {
    return 'bỏ qua: $count';
  }

  @override
  String get anotherRound => 'vòng nữa';

  @override
  String get iAmDone => 'xong';

  @override
  String wordsLeft(int count) {
    return 'còn $count';
  }

  @override
  String scoreLabel(int count) {
    return 'điểm: $count';
  }

  @override
  String get workoutTitle => 'Luyện tập';

  @override
  String get skip => 'bỏ qua';

  @override
  String get solution => 'đáp án';

  @override
  String get wrong => 'sai';

  @override
  String get correct => 'đúng';

  @override
  String get listTitle => 'danh sách';

  @override
  String get search => 'tìm kiếm';

  @override
  String get added => 'đã thêm';

  @override
  String get question => 'câu hỏi';

  @override
  String get answer => 'câu trả lời';

  @override
  String get asked => 'đã hỏi';

  @override
  String get resetScore => 'đặt lại điểm';

  @override
  String get forceStartLearning => 'bắt đầu học lại';

  @override
  String get edit => 'sửa';

  @override
  String get never => 'chưa bao giờ';

  @override
  String get delete => 'xóa';

  @override
  String get save => 'lưu';

  @override
  String get translationUnavailable => 'không dịch được trên nền tảng này';

  @override
  String get downloadingLanguageModels => 'đang tải mô hình ngôn ngữ…';

  @override
  String get editJournal => 'sửa nhật ký';

  @override
  String journalField(String lang) {
    return 'nhật ký ($lang)';
  }

  @override
  String translationField(String lang) {
    return 'bản dịch ($lang)';
  }

  @override
  String lookupField(String from, String to) {
    return 'tra từ ($from → $to)';
  }

  @override
  String translationSetupFailed(String error) {
    return 'thiết lập dịch thất bại: $error';
  }

  @override
  String translateFailed(String error) {
    return 'dịch thất bại: $error';
  }

  @override
  String get refresh => 'làm mới';

  @override
  String get noJournalEntries => 'chưa có nhật ký';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get appLanguage => 'Ngôn ngữ ứng dụng';

  @override
  String get nextcloudLogin => 'đăng nhập nextcloud';

  @override
  String get hostHint => 'host.url';

  @override
  String get hostLabel => 'url/ip máy chủ';

  @override
  String get userHint => 'người dùng';

  @override
  String get username => 'tên đăng nhập';

  @override
  String get pwHint => 'mk';

  @override
  String get password => 'mật khẩu';

  @override
  String get journalLanguages => 'ngôn ngữ nhật ký';

  @override
  String get practiceLanguage => 'ngôn ngữ luyện tập';

  @override
  String get primaryLanguage => 'ngôn ngữ chính (bản dịch)';

  @override
  String get offlineTranslationNote =>
      'Dịch ngoại tuyến dùng Android ML Kit. Mô hình ngôn ngữ được tải khi bạn mở nhật ký.';

  @override
  String get misc => 'khác';

  @override
  String get useTextIfExisting => 'dùng chữ nếu có (không dùng hình vẽ)';

  @override
  String get storeSettings => 'lưu cài đặt';

  @override
  String get questionNote => 'ghi chú câu hỏi';

  @override
  String get answerNote => 'ghi chú câu trả lời';

  @override
  String get next => 'tiếp';

  @override
  String get back => 'quay lại';

  @override
  String get reverse => 'ngược';

  @override
  String get legacy => 'cũ';

  @override
  String get all => 'tất cả';

  @override
  String get cancel => 'hủy';

  @override
  String get go => 'BẮT ĐẦU';

  @override
  String get done => 'xong';

  @override
  String get syncDatabase => 'đồng bộ cơ sở dữ liệu với nextcloud';

  @override
  String get downloadOverwrite => 'tải xuống, ghi đè dữ liệu';

  @override
  String get uploadLocalDb => 'tải dữ liệu lên';

  @override
  String get loading => 'đang tải...';

  @override
  String uploadResult(String result) {
    return 'tải lên: $result';
  }

  @override
  String downloadResult(String result) {
    return 'tải xuống: $result';
  }

  @override
  String get empty => 'trống';

  @override
  String get disableEraser => 'tắt tẩy';

  @override
  String get enableEraser => 'bật tẩy';

  @override
  String get undo => 'hoàn tác';

  @override
  String get clear => 'xóa hết';

  @override
  String get reload => 'tải lại';

  @override
  String get notiTitle => 'thời gian để học tiếng Việt!';

  @override
  String get notiBody => 'bây giờ, nhanh đi!';
}
