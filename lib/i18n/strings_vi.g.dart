///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsVi implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsVi({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.vi,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <vi>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsVi _root = this; // ignore: unused_field

	@override 
	TranslationsVi $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsVi(meta: meta ?? this.$meta);

	// Translations
	@override String get app_name => 'Ghi chú';
	@override late final _TranslationsHomeScreenVi home_screen = _TranslationsHomeScreenVi._(_root);
	@override late final _TranslationsNoteCardVi note_card = _TranslationsNoteCardVi._(_root);
	@override late final _TranslationsAddNoteSheetVi add_note_sheet = _TranslationsAddNoteSheetVi._(_root);
	@override late final _TranslationsNoteDetailScreenVi note_detail_screen = _TranslationsNoteDetailScreenVi._(_root);
	@override late final _TranslationsSettingsScreenVi settings_screen = _TranslationsSettingsScreenVi._(_root);
	@override late final _TranslationsAboutAppScreenVi about_app_screen = _TranslationsAboutAppScreenVi._(_root);
}

// Path: home_screen
class _TranslationsHomeScreenVi implements TranslationsHomeScreenEn {
	_TranslationsHomeScreenVi._(this._root);

	final TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get app_bar_title => 'Ghi chú';
	@override String get search_hint => 'Tìm kiếm ghi chú...';
	@override String get no_notes_empty_state => 'Bạn không có ghi chú nào. Hãy tạo một ghi chú mới!';
	@override String get no_notes_found_search => 'Không tìm thấy ghi chú nào phù hợp với "{searchText}"';
	@override String get create_note_button => 'Tạo ghi chú';
}

// Path: note_card
class _TranslationsNoteCardVi implements TranslationsNoteCardEn {
	_TranslationsNoteCardVi._(this._root);

	final TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get created_at => 'Tạo lúc: {date}';
	@override String get delete_confirm_title => 'Xác nhận xóa';
	@override String get delete_confirm_content => 'Bạn có chắc chắn muốn xóa ghi chú này không?';
	@override String get cancel_button => 'Hủy';
	@override String get delete_button => 'Xóa';
	@override String get note_deleted_snackbar => 'Đã xóa ghi chú!';
}

// Path: add_note_sheet
class _TranslationsAddNoteSheetVi implements TranslationsAddNoteSheetEn {
	_TranslationsAddNoteSheetVi._(this._root);

	final TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get add_note_title => 'Tạo ghi chú';
	@override String get title_label => 'Tiêu đề';
	@override String get title_hint => 'Ví dụ: Lên kế hoạch cuối tuần';
	@override String get content_label => 'Nội dung';
	@override String get content_hint => 'Ví dụ: Đi siêu thị, tập thể dục, đọc sách...';
	@override String get save_note_button => 'Lưu ghi chú';
	@override String get title_empty_error => 'Tiêu đề không được để trống.';
}

// Path: note_detail_screen
class _TranslationsNoteDetailScreenVi implements TranslationsNoteDetailScreenEn {
	_TranslationsNoteDetailScreenVi._(this._root);

	final TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get edit_note_title => 'Chỉnh sửa ghi chú';
	@override String get title_label => 'Tiêu đề';
	@override String get title_hint => 'Nhập tiêu đề ghi chú...';
	@override String get content_label => 'Nội dung:';
	@override String get content_hint => 'Nhập nội dung ghi chú...';
	@override String get created_at => 'Tạo lúc: {date}';
	@override String get no_content_placeholder => 'Chẳng có gì ¯⁠\⁠_⁠(⁠ツ⁠)⁠_⁠/⁠¯';
	@override String get title_empty_error_snackbar => 'Tiêu đề không được để trống!';
	@override String get changes_saved_snackbar => 'Đã lưu thay đổi!';
	@override String get dialog_title => 'Nhắc nhở';
	@override String get dialog_content_save_confirm => 'Bạn chắc chắn muốn lưu thay đổi này không?';
	@override String get dialog_content_exit_confirm => 'Bạn có chắc muốn lưu thay đổi này không?';
	@override String get dialog_cancel_button => 'Hủy';
	@override String get dialog_discard_button => 'Không lưu';
	@override String get dialog_ok_button => 'OK';
}

// Path: settings_screen
class _TranslationsSettingsScreenVi implements TranslationsSettingsScreenEn {
	_TranslationsSettingsScreenVi._(this._root);

	final TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get app_bar_title => 'Cài đặt';
	@override String get section_appearance => 'Giao diện';
	@override String get theme_title => 'Chủ đề';
	@override String get theme_system => 'Mặc định hệ thống';
	@override String get theme_light => 'Sáng';
	@override String get theme_dark => 'Tối';
	@override String get theme_selection_sheet_title => 'Chọn Chủ đề';
	@override String get language_title => 'Ngôn ngữ';
	@override String get language_selection_sheet_title => 'Chọn Ngôn ngữ';
	@override String get language_system => 'Mặc định hệ thống';
	@override String get language_vietnamese => 'Tiếng Việt (Vietnamese)';
	@override String get language_english => 'English (US)';
	@override String get section_about => 'Thông tin';
	@override String get view_source_title => 'Xem mã nguồn';
	@override String get view_source_subtitle => 'Mã nguồn của ứng dụng này có sẵn để đọc trên GitHub. Ngoài ra bạn có thể gửi yêu cầu cho chúng tôi về những cải tiến và sửa lỗi của bạn.';
	@override String get help_translate_title => 'Giúp chúng tôi dịch!';
	@override String get help_translate_subtitle => 'Nếu bạn thích ứng dụng này, bạn nên cân nhắc dịch ứng dụng này cho ngôn ngữ của bạn.';
	@override String get report_bug_title => 'Báo cáo lỗi';
	@override String get report_bug_subtitle => 'Nếu bạn có bất kỳ gợi ý hay vấn đề nào, vui lòng báo cáo chúng vào dự án của chúng tôi tại GitHub.';
	@override String get about_app_title => 'Về ứng dụng';
	@override String get url_launch_error => 'Không thể mở liên kết: {url}';
	@override String get unknown => 'Không xác định';
}

// Path: about_app_screen
class _TranslationsAboutAppScreenVi implements TranslationsAboutAppScreenEn {
	_TranslationsAboutAppScreenVi._(this._root);

	final TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get app_bar_title => 'Về ứng dụng';
	@override String get app_name_fallback => 'Notes (Ghi chú)';
	@override String get copyright => '©2025 NguyenHienNg';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsVi {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app_name': return 'Ghi chú';
			case 'home_screen.app_bar_title': return 'Ghi chú';
			case 'home_screen.search_hint': return 'Tìm kiếm ghi chú...';
			case 'home_screen.no_notes_empty_state': return 'Bạn không có ghi chú nào. Hãy tạo một ghi chú mới!';
			case 'home_screen.no_notes_found_search': return 'Không tìm thấy ghi chú nào phù hợp với "{searchText}"';
			case 'home_screen.create_note_button': return 'Tạo ghi chú';
			case 'note_card.created_at': return 'Tạo lúc: {date}';
			case 'note_card.delete_confirm_title': return 'Xác nhận xóa';
			case 'note_card.delete_confirm_content': return 'Bạn có chắc chắn muốn xóa ghi chú này không?';
			case 'note_card.cancel_button': return 'Hủy';
			case 'note_card.delete_button': return 'Xóa';
			case 'note_card.note_deleted_snackbar': return 'Đã xóa ghi chú!';
			case 'add_note_sheet.add_note_title': return 'Tạo ghi chú';
			case 'add_note_sheet.title_label': return 'Tiêu đề';
			case 'add_note_sheet.title_hint': return 'Ví dụ: Lên kế hoạch cuối tuần';
			case 'add_note_sheet.content_label': return 'Nội dung';
			case 'add_note_sheet.content_hint': return 'Ví dụ: Đi siêu thị, tập thể dục, đọc sách...';
			case 'add_note_sheet.save_note_button': return 'Lưu ghi chú';
			case 'add_note_sheet.title_empty_error': return 'Tiêu đề không được để trống.';
			case 'note_detail_screen.edit_note_title': return 'Chỉnh sửa ghi chú';
			case 'note_detail_screen.title_label': return 'Tiêu đề';
			case 'note_detail_screen.title_hint': return 'Nhập tiêu đề ghi chú...';
			case 'note_detail_screen.content_label': return 'Nội dung:';
			case 'note_detail_screen.content_hint': return 'Nhập nội dung ghi chú...';
			case 'note_detail_screen.created_at': return 'Tạo lúc: {date}';
			case 'note_detail_screen.no_content_placeholder': return 'Chẳng có gì ¯⁠\⁠_⁠(⁠ツ⁠)⁠_⁠/⁠¯';
			case 'note_detail_screen.title_empty_error_snackbar': return 'Tiêu đề không được để trống!';
			case 'note_detail_screen.changes_saved_snackbar': return 'Đã lưu thay đổi!';
			case 'note_detail_screen.dialog_title': return 'Nhắc nhở';
			case 'note_detail_screen.dialog_content_save_confirm': return 'Bạn chắc chắn muốn lưu thay đổi này không?';
			case 'note_detail_screen.dialog_content_exit_confirm': return 'Bạn có chắc muốn lưu thay đổi này không?';
			case 'note_detail_screen.dialog_cancel_button': return 'Hủy';
			case 'note_detail_screen.dialog_discard_button': return 'Không lưu';
			case 'note_detail_screen.dialog_ok_button': return 'OK';
			case 'settings_screen.app_bar_title': return 'Cài đặt';
			case 'settings_screen.section_appearance': return 'Giao diện';
			case 'settings_screen.theme_title': return 'Chủ đề';
			case 'settings_screen.theme_system': return 'Mặc định hệ thống';
			case 'settings_screen.theme_light': return 'Sáng';
			case 'settings_screen.theme_dark': return 'Tối';
			case 'settings_screen.theme_selection_sheet_title': return 'Chọn Chủ đề';
			case 'settings_screen.language_title': return 'Ngôn ngữ';
			case 'settings_screen.language_selection_sheet_title': return 'Chọn Ngôn ngữ';
			case 'settings_screen.language_system': return 'Mặc định hệ thống';
			case 'settings_screen.language_vietnamese': return 'Tiếng Việt (Vietnamese)';
			case 'settings_screen.language_english': return 'English (US)';
			case 'settings_screen.section_about': return 'Thông tin';
			case 'settings_screen.view_source_title': return 'Xem mã nguồn';
			case 'settings_screen.view_source_subtitle': return 'Mã nguồn của ứng dụng này có sẵn để đọc trên GitHub. Ngoài ra bạn có thể gửi yêu cầu cho chúng tôi về những cải tiến và sửa lỗi của bạn.';
			case 'settings_screen.help_translate_title': return 'Giúp chúng tôi dịch!';
			case 'settings_screen.help_translate_subtitle': return 'Nếu bạn thích ứng dụng này, bạn nên cân nhắc dịch ứng dụng này cho ngôn ngữ của bạn.';
			case 'settings_screen.report_bug_title': return 'Báo cáo lỗi';
			case 'settings_screen.report_bug_subtitle': return 'Nếu bạn có bất kỳ gợi ý hay vấn đề nào, vui lòng báo cáo chúng vào dự án của chúng tôi tại GitHub.';
			case 'settings_screen.about_app_title': return 'Về ứng dụng';
			case 'settings_screen.url_launch_error': return 'Không thể mở liên kết: {url}';
			case 'settings_screen.unknown': return 'Không xác định';
			case 'about_app_screen.app_bar_title': return 'Về ứng dụng';
			case 'about_app_screen.app_name_fallback': return 'Notes (Ghi chú)';
			case 'about_app_screen.copyright': return '©2025 NguyenHienNg';
			default: return null;
		}
	}
}

