///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Notes'
	String get app_name => 'Notes';

	late final Translations$home_screen$en home_screen = Translations$home_screen$en._(_root);
	late final Translations$note_card$en note_card = Translations$note_card$en._(_root);
	late final Translations$add_note_sheet$en add_note_sheet = Translations$add_note_sheet$en._(_root);
	late final Translations$note_detail_screen$en note_detail_screen = Translations$note_detail_screen$en._(_root);
	late final Translations$settings_screen$en settings_screen = Translations$settings_screen$en._(_root);
	late final Translations$about_app_screen$en about_app_screen = Translations$about_app_screen$en._(_root);
}

// Path: home_screen
class Translations$home_screen$en {
	Translations$home_screen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notes'
	String get app_bar_title => 'Notes';

	/// en: 'Search notes...'
	String get search_hint => 'Search notes...';

	/// en: 'You have no notes. Create a new one!'
	String get no_notes_empty_state => 'You have no notes. Create a new one!';

	/// en: 'No notes found matching "{searchText}"'
	String get no_notes_found_search => 'No notes found matching "{searchText}"';

	/// en: 'Create Note'
	String get create_note_button => 'Create Note';
}

// Path: note_card
class Translations$note_card$en {
	Translations$note_card$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Created at: {date}'
	String get created_at => 'Created at: {date}';

	/// en: 'Confirm Deletion'
	String get delete_confirm_title => 'Confirm Deletion';

	/// en: 'Are you sure you want to delete this note?'
	String get delete_confirm_content => 'Are you sure you want to delete this note?';

	/// en: 'Cancel'
	String get cancel_button => 'Cancel';

	/// en: 'Delete'
	String get delete_button => 'Delete';

	/// en: 'Note deleted!'
	String get note_deleted_snackbar => 'Note deleted!';
}

// Path: add_note_sheet
class Translations$add_note_sheet$en {
	Translations$add_note_sheet$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create Note'
	String get add_note_title => 'Create Note';

	/// en: 'Title'
	String get title_label => 'Title';

	/// en: 'Example: Weekend plan'
	String get title_hint => 'Example: Weekend plan';

	/// en: 'Content'
	String get content_label => 'Content';

	/// en: 'Example: Go shopping, exercise, read book...'
	String get content_hint => 'Example: Go shopping, exercise, read book...';

	/// en: 'Save Note'
	String get save_note_button => 'Save Note';

	/// en: 'Title cannot be empty.'
	String get title_empty_error => 'Title cannot be empty.';
}

// Path: note_detail_screen
class Translations$note_detail_screen$en {
	Translations$note_detail_screen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit Note'
	String get edit_note_title => 'Edit Note';

	/// en: 'Title'
	String get title_label => 'Title';

	/// en: 'Enter note title...'
	String get title_hint => 'Enter note title...';

	/// en: 'Content:'
	String get content_label => 'Content:';

	/// en: 'Enter note content...'
	String get content_hint => 'Enter note content...';

	/// en: 'Created at: {date}'
	String get created_at => 'Created at: {date}';

	/// en: 'Nothing here ¯⁠\⁠_⁠(⁠ツ⁠)⁠_⁠/⁠¯'
	String get no_content_placeholder => 'Nothing here ¯⁠\⁠_⁠(⁠ツ⁠)⁠_⁠/⁠¯';

	/// en: 'Title cannot be empty!'
	String get title_empty_error_snackbar => 'Title cannot be empty!';

	/// en: 'Changes saved!'
	String get changes_saved_snackbar => 'Changes saved!';

	/// en: 'Reminder'
	String get dialog_title => 'Reminder';

	/// en: 'Are you sure you want to save these changes?'
	String get dialog_content_save_confirm => 'Are you sure you want to save these changes?';

	/// en: 'Are you sure you want to save these changes?'
	String get dialog_content_exit_confirm => 'Are you sure you want to save these changes?';

	/// en: 'Cancel'
	String get dialog_cancel_button => 'Cancel';

	/// en: 'Don't Save'
	String get dialog_discard_button => 'Don\'t Save';

	/// en: 'OK'
	String get dialog_ok_button => 'OK';
}

// Path: settings_screen
class Translations$settings_screen$en {
	Translations$settings_screen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get app_bar_title => 'Settings';

	/// en: 'Appearance'
	String get section_appearance => 'Appearance';

	/// en: 'Theme'
	String get theme_title => 'Theme';

	/// en: 'System Default'
	String get theme_system => 'System Default';

	/// en: 'Light'
	String get theme_light => 'Light';

	/// en: 'Dark'
	String get theme_dark => 'Dark';

	/// en: 'Select Theme'
	String get theme_selection_sheet_title => 'Select Theme';

	/// en: 'Language'
	String get language_title => 'Language';

	/// en: 'Select Language'
	String get language_selection_sheet_title => 'Select Language';

	/// en: 'System Default'
	String get language_system => 'System Default';

	/// en: 'Tiếng Việt (Vietnamese)'
	String get language_vietnamese => 'Tiếng Việt (Vietnamese)';

	/// en: 'English'
	String get language_english => 'English';

	/// en: 'About'
	String get section_about => 'About';

	/// en: 'View Source Code'
	String get view_source_title => 'View Source Code';

	/// en: 'The source code for this application is available for reading on GitHub. You can also send us your improvement and bug fix requests.'
	String get view_source_subtitle => 'The source code for this application is available for reading on GitHub. You can also send us your improvement and bug fix requests.';

	/// en: 'About App'
	String get about_app_title => 'About App';

	/// en: 'Could not launch URL: {url}'
	String get url_launch_error => 'Could not launch URL: {url}';

	/// en: 'unknown'
	String get unknown => 'unknown';

	/// en: 'Advanced Options'
	String get section_advanced => 'Advanced Options';

	/// en: 'Advanced Options'
	String get advanced_settings_app_bar => 'Advanced Options';

	/// en: 'Animation'
	String get animations_title => 'Animation';

	/// en: 'Disable screen animation if device feels low-end'
	String get animations_subtitle => 'Disable screen animation if device feels low-end';

	/// en: 'Theme Color'
	String get theme_color_title => 'Theme Color';

	/// en: 'Select Theme Color'
	String get theme_color_selection_title => 'Select Theme Color';

	/// en: 'Red'
	String get color_red => 'Red';

	/// en: 'Green'
	String get color_green => 'Green';

	/// en: 'Blue'
	String get color_blue => 'Blue';

	/// en: 'Brown'
	String get color_brown => 'Brown';

	/// en: 'Purple'
	String get color_purple => 'Purple';

	/// en: 'Yellow'
	String get color_yellow => 'Yellow';

	/// en: 'Orange'
	String get color_orange => 'Orange';

	/// en: 'System Color (Android 12+)'
	String get color_system => 'System Color (Android 12+)';

	/// en: 'Backup Data'
	String get backup_title => 'Backup Data';

	/// en: 'Select and export notes as backup file'
	String get backup_subtitle => 'Select and export notes as backup file';

	/// en: 'Select notes to backup'
	String get backup_select_notes => 'Select notes to backup';

	/// en: 'Select All'
	String get backup_select_all => 'Select All';

	/// en: 'Deselect All'
	String get backup_deselect_all => 'Deselect All';

	/// en: 'You have no notes to backup.'
	String get backup_no_notes => 'You have no notes to backup.';

	/// en: 'Export backup file'
	String get backup_export_tooltip => 'Export backup file';

	/// en: 'Backup file exported successfully!'
	String get backup_success => 'Backup file exported successfully!';

	/// en: 'Please select at least one note.'
	String get backup_no_selection => 'Please select at least one note.';

	/// en: 'Restore Data'
	String get restore_title => 'Restore Data';

	/// en: 'Import backup file to restore notes'
	String get restore_subtitle => 'Import backup file to restore notes';

	/// en: 'Select notes to restore'
	String get restore_select_notes => 'Select notes to restore';

	/// en: 'Restore Notes'
	String get restore_screen_title => 'Restore Notes';

	/// en: 'Do you want to restore this note?'
	String get restore_confirm_message => 'Do you want to restore this note?';

	/// en: 'Replace'
	String get restore_btn_replace => 'Replace';

	/// en: 'Rename'
	String get restore_btn_rename => 'Rename';

	/// en: 'Yes'
	String get restore_btn_confirm => 'Yes';

	/// en: 'Cancel'
	String get restore_btn_cancel => 'Cancel';

	/// en: 'Notes restored successfully!'
	String get restore_success => 'Notes restored successfully!';

	/// en: 'Cannot read backup file!'
	String get restore_file_error => 'Cannot read backup file!';

	/// en: 'No notes found in the backup file.'
	String get restore_no_notes => 'No notes found in the backup file.';

	/// en: 'Invalid backup code or wrong data structure!'
	String get restore_invalid_json => 'Invalid backup code or wrong data structure!';

	/// en: 'Restore'
	String get restore_btn_restore => 'Restore';

	/// en: 'Please select at least one note.'
	String get restore_no_selection => 'Please select at least one note.';

	/// en: 'Reminder'
	String get restore_cancel_dialog_title => 'Reminder';

	/// en: 'Are you sure you want to cancel this process?'
	String get restore_cancel_dialog_content => 'Are you sure you want to cancel this process?';

	/// en: 'Diagnostics Log'
	String get diagnostics_title => 'Diagnostics Log';

	/// en: 'View system activity logs'
	String get diagnostics_subtitle => 'View system activity logs';

	/// en: 'This feature has been disabled by the developer.'
	String get diagnostics_disabled => 'This feature has been disabled by the developer.';

	/// en: 'System Logs'
	String get diagnostics_app_bar => 'System Logs';

	/// en: 'No activity logs available yet.'
	String get diagnostics_empty => 'No activity logs available yet.';

	/// en: 'Clear Logs'
	String get diagnostics_clear => 'Clear Logs';

	/// en: 'Copy'
	String get diagnostics_copy => 'Copy';

	/// en: 'Diagnostics logs copied!'
	String get diagnostics_copied => 'Diagnostics logs copied!';

	/// en: 'These options will be added in the official release'
	String get advanced_footer_note => 'These options will be added in the official release';

	/// en: 'Tips'
	String get tooltip_title => 'Tips';

	/// en: 'You can customize '
	String get tooltip_prefix => 'You can customize ';

	/// en: 'Theme, Language '
	String get tooltip_highlight => 'Theme, Language ';

	/// en: 'and Advanced options right here.'
	String get tooltip_suffix => 'and Advanced options right here.';

	/// en: 'Got it'
	String get tooltip_btn_got_it => 'Got it';
}

// Path: about_app_screen
class Translations$about_app_screen$en {
	Translations$about_app_screen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'About App'
	String get app_bar_title => 'About App';

	/// en: 'Notes'
	String get app_name_fallback => 'Notes';

	/// en: '©2026 NguyenHienNg'
	String get copyright => '©2026 NguyenHienNg';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app_name' => 'Notes',
			'home_screen.app_bar_title' => 'Notes',
			'home_screen.search_hint' => 'Search notes...',
			'home_screen.no_notes_empty_state' => 'You have no notes. Create a new one!',
			'home_screen.no_notes_found_search' => 'No notes found matching "{searchText}"',
			'home_screen.create_note_button' => 'Create Note',
			'note_card.created_at' => 'Created at: {date}',
			'note_card.delete_confirm_title' => 'Confirm Deletion',
			'note_card.delete_confirm_content' => 'Are you sure you want to delete this note?',
			'note_card.cancel_button' => 'Cancel',
			'note_card.delete_button' => 'Delete',
			'note_card.note_deleted_snackbar' => 'Note deleted!',
			'add_note_sheet.add_note_title' => 'Create Note',
			'add_note_sheet.title_label' => 'Title',
			'add_note_sheet.title_hint' => 'Example: Weekend plan',
			'add_note_sheet.content_label' => 'Content',
			'add_note_sheet.content_hint' => 'Example: Go shopping, exercise, read book...',
			'add_note_sheet.save_note_button' => 'Save Note',
			'add_note_sheet.title_empty_error' => 'Title cannot be empty.',
			'note_detail_screen.edit_note_title' => 'Edit Note',
			'note_detail_screen.title_label' => 'Title',
			'note_detail_screen.title_hint' => 'Enter note title...',
			'note_detail_screen.content_label' => 'Content:',
			'note_detail_screen.content_hint' => 'Enter note content...',
			'note_detail_screen.created_at' => 'Created at: {date}',
			'note_detail_screen.no_content_placeholder' => 'Nothing here ¯⁠\⁠_⁠(⁠ツ⁠)⁠_⁠/⁠¯',
			'note_detail_screen.title_empty_error_snackbar' => 'Title cannot be empty!',
			'note_detail_screen.changes_saved_snackbar' => 'Changes saved!',
			'note_detail_screen.dialog_title' => 'Reminder',
			'note_detail_screen.dialog_content_save_confirm' => 'Are you sure you want to save these changes?',
			'note_detail_screen.dialog_content_exit_confirm' => 'Are you sure you want to save these changes?',
			'note_detail_screen.dialog_cancel_button' => 'Cancel',
			'note_detail_screen.dialog_discard_button' => 'Don\'t Save',
			'note_detail_screen.dialog_ok_button' => 'OK',
			'settings_screen.app_bar_title' => 'Settings',
			'settings_screen.section_appearance' => 'Appearance',
			'settings_screen.theme_title' => 'Theme',
			'settings_screen.theme_system' => 'System Default',
			'settings_screen.theme_light' => 'Light',
			'settings_screen.theme_dark' => 'Dark',
			'settings_screen.theme_selection_sheet_title' => 'Select Theme',
			'settings_screen.language_title' => 'Language',
			'settings_screen.language_selection_sheet_title' => 'Select Language',
			'settings_screen.language_system' => 'System Default',
			'settings_screen.language_vietnamese' => 'Tiếng Việt (Vietnamese)',
			'settings_screen.language_english' => 'English',
			'settings_screen.section_about' => 'About',
			'settings_screen.view_source_title' => 'View Source Code',
			'settings_screen.view_source_subtitle' => 'The source code for this application is available for reading on GitHub. You can also send us your improvement and bug fix requests.',
			'settings_screen.about_app_title' => 'About App',
			'settings_screen.url_launch_error' => 'Could not launch URL: {url}',
			'settings_screen.unknown' => 'unknown',
			'settings_screen.section_advanced' => 'Advanced Options',
			'settings_screen.advanced_settings_app_bar' => 'Advanced Options',
			'settings_screen.animations_title' => 'Animation',
			'settings_screen.animations_subtitle' => 'Disable screen animation if device feels low-end',
			'settings_screen.theme_color_title' => 'Theme Color',
			'settings_screen.theme_color_selection_title' => 'Select Theme Color',
			'settings_screen.color_red' => 'Red',
			'settings_screen.color_green' => 'Green',
			'settings_screen.color_blue' => 'Blue',
			'settings_screen.color_brown' => 'Brown',
			'settings_screen.color_purple' => 'Purple',
			'settings_screen.color_yellow' => 'Yellow',
			'settings_screen.color_orange' => 'Orange',
			'settings_screen.color_system' => 'System Color (Android 12+)',
			'settings_screen.backup_title' => 'Backup Data',
			'settings_screen.backup_subtitle' => 'Select and export notes as backup file',
			'settings_screen.backup_select_notes' => 'Select notes to backup',
			'settings_screen.backup_select_all' => 'Select All',
			'settings_screen.backup_deselect_all' => 'Deselect All',
			'settings_screen.backup_no_notes' => 'You have no notes to backup.',
			'settings_screen.backup_export_tooltip' => 'Export backup file',
			'settings_screen.backup_success' => 'Backup file exported successfully!',
			'settings_screen.backup_no_selection' => 'Please select at least one note.',
			'settings_screen.restore_title' => 'Restore Data',
			'settings_screen.restore_subtitle' => 'Import backup file to restore notes',
			'settings_screen.restore_select_notes' => 'Select notes to restore',
			'settings_screen.restore_screen_title' => 'Restore Notes',
			'settings_screen.restore_confirm_message' => 'Do you want to restore this note?',
			'settings_screen.restore_btn_replace' => 'Replace',
			'settings_screen.restore_btn_rename' => 'Rename',
			'settings_screen.restore_btn_confirm' => 'Yes',
			'settings_screen.restore_btn_cancel' => 'Cancel',
			'settings_screen.restore_success' => 'Notes restored successfully!',
			'settings_screen.restore_file_error' => 'Cannot read backup file!',
			'settings_screen.restore_no_notes' => 'No notes found in the backup file.',
			'settings_screen.restore_invalid_json' => 'Invalid backup code or wrong data structure!',
			'settings_screen.restore_btn_restore' => 'Restore',
			'settings_screen.restore_no_selection' => 'Please select at least one note.',
			'settings_screen.restore_cancel_dialog_title' => 'Reminder',
			'settings_screen.restore_cancel_dialog_content' => 'Are you sure you want to cancel this process?',
			'settings_screen.diagnostics_title' => 'Diagnostics Log',
			'settings_screen.diagnostics_subtitle' => 'View system activity logs',
			'settings_screen.diagnostics_disabled' => 'This feature has been disabled by the developer.',
			'settings_screen.diagnostics_app_bar' => 'System Logs',
			'settings_screen.diagnostics_empty' => 'No activity logs available yet.',
			'settings_screen.diagnostics_clear' => 'Clear Logs',
			'settings_screen.diagnostics_copy' => 'Copy',
			'settings_screen.diagnostics_copied' => 'Diagnostics logs copied!',
			'settings_screen.advanced_footer_note' => 'These options will be added in the official release',
			'settings_screen.tooltip_title' => 'Tips',
			'settings_screen.tooltip_prefix' => 'You can customize ',
			'settings_screen.tooltip_highlight' => 'Theme, Language ',
			'settings_screen.tooltip_suffix' => 'and Advanced options right here.',
			'settings_screen.tooltip_btn_got_it' => 'Got it',
			'about_app_screen.app_bar_title' => 'About App',
			'about_app_screen.app_name_fallback' => 'Notes',
			'about_app_screen.copyright' => '©2026 NguyenHienNg',
			_ => null,
		};
	}
}
