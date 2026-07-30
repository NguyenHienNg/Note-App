///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsVi with BaseTranslations<AppLocale, Translations> implements Translations {
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
	@override late final _Translations$home_screen$vi home_screen = _Translations$home_screen$vi._(_root);
	@override late final _Translations$note_card$vi note_card = _Translations$note_card$vi._(_root);
	@override late final _Translations$add_note_sheet$vi add_note_sheet = _Translations$add_note_sheet$vi._(_root);
	@override late final _Translations$note_detail_screen$vi note_detail_screen = _Translations$note_detail_screen$vi._(_root);
	@override late final _Translations$settings_screen$vi settings_screen = _Translations$settings_screen$vi._(_root);
	@override late final _Translations$about_app_screen$vi about_app_screen = _Translations$about_app_screen$vi._(_root);
	@override late final _Translations$update_screen$vi update_screen = _Translations$update_screen$vi._(_root);
}

// Path: home_screen
class _Translations$home_screen$vi implements Translations$home_screen$en {
	_Translations$home_screen$vi._(this._root);

	final TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get app_bar_title => 'Ghi chú';
	@override String get search_hint => 'Tìm kiếm ghi chú...';
	@override String get no_notes_empty_state => 'Bạn không có ghi chú nào. Hãy tạo một ghi chú mới!';
	@override String get no_notes_found_search => 'Không tìm thấy ghi chú nào phù hợp với "{searchText}"';
	@override String get create_note_button => 'Tạo ghi chú';
	@override String get settings_tooltip => 'Cài đặt';
}

// Path: note_card
class _Translations$note_card$vi implements Translations$note_card$en {
	_Translations$note_card$vi._(this._root);

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
class _Translations$add_note_sheet$vi implements Translations$add_note_sheet$en {
	_Translations$add_note_sheet$vi._(this._root);

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
class _Translations$note_detail_screen$vi implements Translations$note_detail_screen$en {
	_Translations$note_detail_screen$vi._(this._root);

	final TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get edit_note_title => 'Chỉnh sửa ghi chú';
	@override String get title_label => 'Tiêu đề';
	@override String get title_hint => 'Nhập tiêu đề ghi chú...';
	@override String get content_label => 'Nội dung:';
	@override String get content_hint => 'Nhập nội dung ghi chú...';
	@override String get created_at => 'Tạo lúc: {date}';
	@override String get no_content_placeholder => 'Chẳng có gì ¯\\⁠_⁠(⁠ツ⁠)⁠_⁠/⁠¯';
	@override String get title_empty_error_snackbar => 'Tiêu đề không được để trống!';
	@override String get changes_saved_snackbar => 'Đã lưu thay đổi!';
	@override String get dialog_title => 'Nhắc nhở';
	@override String get dialog_content_save_confirm => 'Bạn chắc chắn muốn lưu thay đổi này không?';
	@override String get dialog_content_exit_confirm => 'Bạn có chắc muốn lưu thay đổi này không?';
	@override String get dialog_cancel_button => 'Hủy';
	@override String get dialog_discard_button => 'Không lưu';
	@override String get dialog_ok_button => 'OK';
	@override String get save_btn => 'Lưu';
	@override String get edit_btn => 'Chỉnh sửa';
	@override String get cancel_edit_btn => 'Hủy chỉnh sửa';
}

// Path: settings_screen
class _Translations$settings_screen$vi implements Translations$settings_screen$en {
	_Translations$settings_screen$vi._(this._root);

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
	@override String get language_english => 'English';
	@override String get section_about => 'Thông tin';
	@override String get view_source_title => 'Xem mã nguồn';
	@override String get view_source_subtitle => 'Mã nguồn của ứng dụng này có sẵn để đọc trên GitHub. Ngoài ra bạn có thể gửi yêu cầu cho chúng tôi về những cải tiến và sửa lỗi của bạn.';
	@override String get about_app_title => 'Về ứng dụng';
	@override String get url_launch_error => 'Không thể mở liên kết: {url}';
	@override String get unknown => 'Không xác định';
	@override String get section_advanced => 'Tùy chọn nâng cao';
	@override String get advanced_settings_app_bar => 'Tùy chọn nâng cao';
	@override String get animations_title => 'Hoạt ảnh';
	@override String get animations_subtitle => 'Tắt hoạt ảnh màn hình nếu thiết bị quá yếu';
	@override String get theme_color_title => 'Màu chủ đề';
	@override String get theme_color_selection_title => 'Chọn Màu chủ đề';
	@override String get color_red => 'Đỏ';
	@override String get color_green => 'Xanh lá';
	@override String get color_blue => 'Xanh dương';
	@override String get color_brown => 'Nâu';
	@override String get color_purple => 'Tím';
	@override String get color_yellow => 'Vàng';
	@override String get color_orange => 'Cam';
	@override String get color_system => 'Màu hệ thống (Android 12+)';
	@override String get backup_title => 'Sao lưu dữ liệu';
	@override String get backup_subtitle => 'Chọn và xuất ghi chú dưới dạng file sao lưu';
	@override String get backup_select_notes => 'Chọn ghi chú để sao lưu';
	@override String get backup_select_all => 'Chọn tất cả';
	@override String get backup_deselect_all => 'Bỏ chọn tất cả';
	@override String get backup_no_notes => 'Bạn không có ghi chú nào để sao lưu.';
	@override String get backup_export_tooltip => 'Xuất file sao lưu';
	@override String get backup_success => 'Đã xuất file sao lưu thành công!';
	@override String get backup_no_selection => 'Vui lòng chọn ít nhất một ghi chú.';
	@override String get restore_title => 'Khôi phục dữ liệu';
	@override String get restore_subtitle => 'Nhập file sao lưu để khôi phục ghi chú';
	@override String get restore_select_notes => 'Chọn ghi chú để khôi phục';
	@override String get restore_screen_title => 'Khôi phục ghi chú';
	@override String get restore_confirm_message => 'Bạn muốn khôi phục ghi chú này chứ?';
	@override String get restore_btn_replace => 'Thay thế';
	@override String get restore_btn_rename => 'Đổi tên';
	@override String get restore_btn_confirm => 'Đúng';
	@override String get restore_btn_cancel => 'Hủy';
	@override String get restore_success => 'Khôi phục ghi chú thành công!';
	@override String get restore_file_error => 'Không thể đọc file sao lưu!';
	@override String get restore_no_notes => 'Không tìm thấy ghi chú nào trong file sao lưu.';
	@override String get restore_invalid_json => 'Mã sao lưu không hợp lệ hoặc sai cấu trúc dữ liệu!';
	@override String get restore_btn_restore => 'Khôi phục';
	@override String get restore_no_selection => 'Vui lòng chọn ít nhất một ghi chú.';
	@override String get restore_cancel_dialog_title => 'Nhắc nhở';
	@override String get restore_cancel_dialog_content => 'Bạn chắc chắn muốn hủy tiến trình này không?';
	@override String get diagnostics_title => 'Nhật ký chẩn đoán';
	@override String get diagnostics_subtitle => 'Xem lịch sử hoạt động hệ thống';
	@override String get diagnostics_disabled => 'Tính năng này đã bị tắt bởi nhà phát triển.';
	@override String get diagnostics_app_bar => 'Nhật ký hệ thống';
	@override String get diagnostics_empty => 'Chưa có nhật ký hoạt động nào.';
	@override String get diagnostics_clear => 'Xóa nhật ký';
	@override String get diagnostics_copy => 'Sao chép';
	@override String get diagnostics_copied => 'Đã sao chép nhật ký chẩn đoán!';
	@override String get advanced_footer_note => 'Các tùy chọn này sẽ được thêm vào trong bản phát hành chính thức';
	@override String get tooltip_title => 'Mẹo';
	@override String get tooltip_prefix => 'Bạn có thể tùy chỉnh ';
	@override String get tooltip_highlight => 'Chủ đề, Ngôn ngữ ';
	@override String get tooltip_suffix => 'và các cài đặt Nâng cao ngay tại đây.';
	@override String get tooltip_btn_got_it => 'Đã hiểu';
	@override String get check_update_title => 'Cập nhật ứng dụng';
}

// Path: about_app_screen
class _Translations$about_app_screen$vi implements Translations$about_app_screen$en {
	_Translations$about_app_screen$vi._(this._root);

	final TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get app_bar_title => 'Về ứng dụng';
	@override String get app_name_fallback => 'Notes (Ghi chú)';
	@override String get copyright => '©2026 NguyenHienNg';
}

// Path: update_screen
class _Translations$update_screen$vi implements Translations$update_screen$en {
	_Translations$update_screen$vi._(this._root);

	final TranslationsVi _root; // ignore: unused_field

	// Translations
	@override String get app_bar_title => 'Cập nhật ứng dụng';
	@override String get channel_title => 'Kênh phiên bản';
	@override String get channel_stable => 'Chính thức';
	@override String get channel_beta => 'Thử nghiệm (Beta)';
	@override String get check_and_update_title => 'Kiểm tra & Cập nhật phiên bản';
	@override String get check_and_update_subtitle => 'Kiểm tra bản cập nhật mới nhất từ máy chủ';
	@override String get dialog_title_checking => 'Cập nhật...';
	@override String get dialog_checking_version => 'Đang kiểm tra phiên bản hiện tại:';
	@override String get dialog_connecting_server => 'Đang kết nối tới máy chủ:';
	@override String get sheet_new_version_available => 'Đã có phiên bản mới!';
	@override String get sheet_current_version => 'Phiên bản hiện tại';
	@override String get sheet_latest_version => 'Phiên bản mới nhất';
	@override String get sheet_changelog_title => 'Nhật ký thay đổi';
	@override String get sheet_update_now_btn => 'Cập nhật ngay';
	@override String get sheet_latest_already => 'Bạn ở phiên bản mới nhất ({version})';
	@override String get dialog_downloading_title => 'Đang tải về...';
	@override String get dialog_download_progress => 'Tiến trình {progress}% • Tốc độ mạng: {speed}';
	@override String get dialog_installing_title => 'Đang cài đặt...';
	@override String get dialog_permission_error => 'Yêu cầu quyền thất bại. Không thể hoàn tất cài đặt ứng dụng';
	@override String get permission_dialog_title => 'Cần cấp quyền cài đặt';
	@override String get permission_dialog_content => 'Để hoàn tất nâng cấp ứng dụng, bạn cần cấp quyền "Cài đặt ứng dụng không xác định" trong Cài đặt hệ thống.';
	@override String get permission_btn_settings => 'Mở Cài đặt';
	@override String get permission_btn_cancel => 'Hủy';
	@override String get delete_apk_title => 'Xóa file cài đặt';
	@override String get delete_apk_subtitle => 'Dọn dẹp file APK đã tải về ({size} MB)';
	@override String get delete_apk_success => 'Đã xóa file cài đặt!';
	@override String get error_check_failed => 'Không thể kiểm tra cập nhật: {error}';
}

/// The flat map containing all translations for locale <vi>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsVi {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app_name' => 'Ghi chú',
			'home_screen.app_bar_title' => 'Ghi chú',
			'home_screen.search_hint' => 'Tìm kiếm ghi chú...',
			'home_screen.no_notes_empty_state' => 'Bạn không có ghi chú nào. Hãy tạo một ghi chú mới!',
			'home_screen.no_notes_found_search' => 'Không tìm thấy ghi chú nào phù hợp với "{searchText}"',
			'home_screen.create_note_button' => 'Tạo ghi chú',
			'home_screen.settings_tooltip' => 'Cài đặt',
			'note_card.created_at' => 'Tạo lúc: {date}',
			'note_card.delete_confirm_title' => 'Xác nhận xóa',
			'note_card.delete_confirm_content' => 'Bạn có chắc chắn muốn xóa ghi chú này không?',
			'note_card.cancel_button' => 'Hủy',
			'note_card.delete_button' => 'Xóa',
			'note_card.note_deleted_snackbar' => 'Đã xóa ghi chú!',
			'add_note_sheet.add_note_title' => 'Tạo ghi chú',
			'add_note_sheet.title_label' => 'Tiêu đề',
			'add_note_sheet.title_hint' => 'Ví dụ: Lên kế hoạch cuối tuần',
			'add_note_sheet.content_label' => 'Nội dung',
			'add_note_sheet.content_hint' => 'Ví dụ: Đi siêu thị, tập thể dục, đọc sách...',
			'add_note_sheet.save_note_button' => 'Lưu ghi chú',
			'add_note_sheet.title_empty_error' => 'Tiêu đề không được để trống.',
			'note_detail_screen.edit_note_title' => 'Chỉnh sửa ghi chú',
			'note_detail_screen.title_label' => 'Tiêu đề',
			'note_detail_screen.title_hint' => 'Nhập tiêu đề ghi chú...',
			'note_detail_screen.content_label' => 'Nội dung:',
			'note_detail_screen.content_hint' => 'Nhập nội dung ghi chú...',
			'note_detail_screen.created_at' => 'Tạo lúc: {date}',
			'note_detail_screen.no_content_placeholder' => 'Chẳng có gì ¯\\⁠_⁠(⁠ツ⁠)⁠_⁠/⁠¯',
			'note_detail_screen.title_empty_error_snackbar' => 'Tiêu đề không được để trống!',
			'note_detail_screen.changes_saved_snackbar' => 'Đã lưu thay đổi!',
			'note_detail_screen.dialog_title' => 'Nhắc nhở',
			'note_detail_screen.dialog_content_save_confirm' => 'Bạn chắc chắn muốn lưu thay đổi này không?',
			'note_detail_screen.dialog_content_exit_confirm' => 'Bạn có chắc muốn lưu thay đổi này không?',
			'note_detail_screen.dialog_cancel_button' => 'Hủy',
			'note_detail_screen.dialog_discard_button' => 'Không lưu',
			'note_detail_screen.dialog_ok_button' => 'OK',
			'note_detail_screen.save_btn' => 'Lưu',
			'note_detail_screen.edit_btn' => 'Chỉnh sửa',
			'note_detail_screen.cancel_edit_btn' => 'Hủy chỉnh sửa',
			'settings_screen.app_bar_title' => 'Cài đặt',
			'settings_screen.section_appearance' => 'Giao diện',
			'settings_screen.theme_title' => 'Chủ đề',
			'settings_screen.theme_system' => 'Mặc định hệ thống',
			'settings_screen.theme_light' => 'Sáng',
			'settings_screen.theme_dark' => 'Tối',
			'settings_screen.theme_selection_sheet_title' => 'Chọn Chủ đề',
			'settings_screen.language_title' => 'Ngôn ngữ',
			'settings_screen.language_selection_sheet_title' => 'Chọn Ngôn ngữ',
			'settings_screen.language_system' => 'Mặc định hệ thống',
			'settings_screen.language_vietnamese' => 'Tiếng Việt (Vietnamese)',
			'settings_screen.language_english' => 'English',
			'settings_screen.section_about' => 'Thông tin',
			'settings_screen.view_source_title' => 'Xem mã nguồn',
			'settings_screen.view_source_subtitle' => 'Mã nguồn của ứng dụng này có sẵn để đọc trên GitHub. Ngoài ra bạn có thể gửi yêu cầu cho chúng tôi về những cải tiến và sửa lỗi của bạn.',
			'settings_screen.about_app_title' => 'Về ứng dụng',
			'settings_screen.url_launch_error' => 'Không thể mở liên kết: {url}',
			'settings_screen.unknown' => 'Không xác định',
			'settings_screen.section_advanced' => 'Tùy chọn nâng cao',
			'settings_screen.advanced_settings_app_bar' => 'Tùy chọn nâng cao',
			'settings_screen.animations_title' => 'Hoạt ảnh',
			'settings_screen.animations_subtitle' => 'Tắt hoạt ảnh màn hình nếu thiết bị quá yếu',
			'settings_screen.theme_color_title' => 'Màu chủ đề',
			'settings_screen.theme_color_selection_title' => 'Chọn Màu chủ đề',
			'settings_screen.color_red' => 'Đỏ',
			'settings_screen.color_green' => 'Xanh lá',
			'settings_screen.color_blue' => 'Xanh dương',
			'settings_screen.color_brown' => 'Nâu',
			'settings_screen.color_purple' => 'Tím',
			'settings_screen.color_yellow' => 'Vàng',
			'settings_screen.color_orange' => 'Cam',
			'settings_screen.color_system' => 'Màu hệ thống (Android 12+)',
			'settings_screen.backup_title' => 'Sao lưu dữ liệu',
			'settings_screen.backup_subtitle' => 'Chọn và xuất ghi chú dưới dạng file sao lưu',
			'settings_screen.backup_select_notes' => 'Chọn ghi chú để sao lưu',
			'settings_screen.backup_select_all' => 'Chọn tất cả',
			'settings_screen.backup_deselect_all' => 'Bỏ chọn tất cả',
			'settings_screen.backup_no_notes' => 'Bạn không có ghi chú nào để sao lưu.',
			'settings_screen.backup_export_tooltip' => 'Xuất file sao lưu',
			'settings_screen.backup_success' => 'Đã xuất file sao lưu thành công!',
			'settings_screen.backup_no_selection' => 'Vui lòng chọn ít nhất một ghi chú.',
			'settings_screen.restore_title' => 'Khôi phục dữ liệu',
			'settings_screen.restore_subtitle' => 'Nhập file sao lưu để khôi phục ghi chú',
			'settings_screen.restore_select_notes' => 'Chọn ghi chú để khôi phục',
			'settings_screen.restore_screen_title' => 'Khôi phục ghi chú',
			'settings_screen.restore_confirm_message' => 'Bạn muốn khôi phục ghi chú này chứ?',
			'settings_screen.restore_btn_replace' => 'Thay thế',
			'settings_screen.restore_btn_rename' => 'Đổi tên',
			'settings_screen.restore_btn_confirm' => 'Đúng',
			'settings_screen.restore_btn_cancel' => 'Hủy',
			'settings_screen.restore_success' => 'Khôi phục ghi chú thành công!',
			'settings_screen.restore_file_error' => 'Không thể đọc file sao lưu!',
			'settings_screen.restore_no_notes' => 'Không tìm thấy ghi chú nào trong file sao lưu.',
			'settings_screen.restore_invalid_json' => 'Mã sao lưu không hợp lệ hoặc sai cấu trúc dữ liệu!',
			'settings_screen.restore_btn_restore' => 'Khôi phục',
			'settings_screen.restore_no_selection' => 'Vui lòng chọn ít nhất một ghi chú.',
			'settings_screen.restore_cancel_dialog_title' => 'Nhắc nhở',
			'settings_screen.restore_cancel_dialog_content' => 'Bạn chắc chắn muốn hủy tiến trình này không?',
			'settings_screen.diagnostics_title' => 'Nhật ký chẩn đoán',
			'settings_screen.diagnostics_subtitle' => 'Xem lịch sử hoạt động hệ thống',
			'settings_screen.diagnostics_disabled' => 'Tính năng này đã bị tắt bởi nhà phát triển.',
			'settings_screen.diagnostics_app_bar' => 'Nhật ký hệ thống',
			'settings_screen.diagnostics_empty' => 'Chưa có nhật ký hoạt động nào.',
			'settings_screen.diagnostics_clear' => 'Xóa nhật ký',
			'settings_screen.diagnostics_copy' => 'Sao chép',
			'settings_screen.diagnostics_copied' => 'Đã sao chép nhật ký chẩn đoán!',
			'settings_screen.advanced_footer_note' => 'Các tùy chọn này sẽ được thêm vào trong bản phát hành chính thức',
			'settings_screen.tooltip_title' => 'Mẹo',
			'settings_screen.tooltip_prefix' => 'Bạn có thể tùy chỉnh ',
			'settings_screen.tooltip_highlight' => 'Chủ đề, Ngôn ngữ ',
			'settings_screen.tooltip_suffix' => 'và các cài đặt Nâng cao ngay tại đây.',
			'settings_screen.tooltip_btn_got_it' => 'Đã hiểu',
			'settings_screen.check_update_title' => 'Cập nhật ứng dụng',
			'about_app_screen.app_bar_title' => 'Về ứng dụng',
			'about_app_screen.app_name_fallback' => 'Notes (Ghi chú)',
			'about_app_screen.copyright' => '©2026 NguyenHienNg',
			'update_screen.app_bar_title' => 'Cập nhật ứng dụng',
			'update_screen.channel_title' => 'Kênh phiên bản',
			'update_screen.channel_stable' => 'Chính thức',
			'update_screen.channel_beta' => 'Thử nghiệm (Beta)',
			'update_screen.check_and_update_title' => 'Kiểm tra & Cập nhật phiên bản',
			'update_screen.check_and_update_subtitle' => 'Kiểm tra bản cập nhật mới nhất từ máy chủ',
			'update_screen.dialog_title_checking' => 'Cập nhật...',
			'update_screen.dialog_checking_version' => 'Đang kiểm tra phiên bản hiện tại:',
			'update_screen.dialog_connecting_server' => 'Đang kết nối tới máy chủ:',
			'update_screen.sheet_new_version_available' => 'Đã có phiên bản mới!',
			'update_screen.sheet_current_version' => 'Phiên bản hiện tại',
			'update_screen.sheet_latest_version' => 'Phiên bản mới nhất',
			'update_screen.sheet_changelog_title' => 'Nhật ký thay đổi',
			'update_screen.sheet_update_now_btn' => 'Cập nhật ngay',
			'update_screen.sheet_latest_already' => 'Bạn ở phiên bản mới nhất ({version})',
			'update_screen.dialog_downloading_title' => 'Đang tải về...',
			'update_screen.dialog_download_progress' => 'Tiến trình {progress}% • Tốc độ mạng: {speed}',
			'update_screen.dialog_installing_title' => 'Đang cài đặt...',
			'update_screen.dialog_permission_error' => 'Yêu cầu quyền thất bại. Không thể hoàn tất cài đặt ứng dụng',
			'update_screen.permission_dialog_title' => 'Cần cấp quyền cài đặt',
			'update_screen.permission_dialog_content' => 'Để hoàn tất nâng cấp ứng dụng, bạn cần cấp quyền "Cài đặt ứng dụng không xác định" trong Cài đặt hệ thống.',
			'update_screen.permission_btn_settings' => 'Mở Cài đặt',
			'update_screen.permission_btn_cancel' => 'Hủy',
			'update_screen.delete_apk_title' => 'Xóa file cài đặt',
			'update_screen.delete_apk_subtitle' => 'Dọn dẹp file APK đã tải về ({size} MB)',
			'update_screen.delete_apk_success' => 'Đã xóa file cài đặt!',
			'update_screen.error_check_failed' => 'Không thể kiểm tra cập nhật: {error}',
			_ => null,
		};
	}
}
