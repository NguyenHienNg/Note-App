///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
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
	String get app_name => 'Notes';
	late final TranslationsHomeScreenEn home_screen = TranslationsHomeScreenEn._(_root);
	late final TranslationsNoteCardEn note_card = TranslationsNoteCardEn._(_root);
	late final TranslationsAddNoteSheetEn add_note_sheet = TranslationsAddNoteSheetEn._(_root);
	late final TranslationsNoteDetailScreenEn note_detail_screen = TranslationsNoteDetailScreenEn._(_root);
	late final TranslationsSettingsScreenEn settings_screen = TranslationsSettingsScreenEn._(_root);
	late final TranslationsAboutAppScreenEn about_app_screen = TranslationsAboutAppScreenEn._(_root);
}

// Path: home_screen
class TranslationsHomeScreenEn {
	TranslationsHomeScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get app_bar_title => 'Notes';
	String get search_hint => 'Search notes...';
	String get no_notes_empty_state => 'You have no notes. Create a new one!';
	String get no_notes_found_search => 'No notes found matching "{searchText}"';
	String get create_note_button => 'Create Note';
}

// Path: note_card
class TranslationsNoteCardEn {
	TranslationsNoteCardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get created_at => 'Created at: {date}';
	String get delete_confirm_title => 'Confirm Deletion';
	String get delete_confirm_content => 'Are you sure you want to delete this note?';
	String get cancel_button => 'Cancel';
	String get delete_button => 'Delete';
	String get note_deleted_snackbar => 'Note deleted!';
}

// Path: add_note_sheet
class TranslationsAddNoteSheetEn {
	TranslationsAddNoteSheetEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get add_note_title => 'Create Note';
	String get title_label => 'Title';
	String get title_hint => 'Example: Weekend plan';
	String get content_label => 'Content';
	String get content_hint => 'Example: Go shopping, exercise, read book...';
	String get save_note_button => 'Save Note';
	String get title_empty_error => 'Title cannot be empty.';
}

// Path: note_detail_screen
class TranslationsNoteDetailScreenEn {
	TranslationsNoteDetailScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get edit_note_title => 'Edit Note';
	String get title_label => 'Title';
	String get title_hint => 'Enter note title...';
	String get content_label => 'Content:';
	String get content_hint => 'Enter note content...';
	String get created_at => 'Created at: {date}';
	String get no_content_placeholder => 'Nothing here ¯\_(ツ)_/¯';
	String get title_empty_error_snackbar => 'Title cannot be empty!';
	String get changes_saved_snackbar => 'Changes saved!';
	String get dialog_title => 'Reminder';
	String get dialog_content_save_confirm => 'Are you sure you want to save these changes?';
	String get dialog_content_exit_confirm => 'Are you sure you want to save these changes?';
	String get dialog_cancel_button => 'Cancel';
	String get dialog_discard_button => 'Don\'t Save';
	String get dialog_ok_button => 'OK';
}

// Path: settings_screen
class TranslationsSettingsScreenEn {
	TranslationsSettingsScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get app_bar_title => 'Settings';
	String get section_settings => 'Settings';
	String get theme_title => 'Theme';
	String get theme_system => 'System Default';
	String get theme_light => 'Light';
	String get theme_dark => 'Dark';
	String get theme_selection_sheet_title => 'Select Theme';
	String get language_title => 'Language';
	String get language_selection_sheet_title => 'Select Language';
	String get language_vietnamese => 'Tiếng Việt';
	String get language_english => 'English';
	String get section_about => 'About';
	String get view_source_title => 'View Source Code';
	String get view_source_subtitle => 'The source code for this application is available for reading on GitHub. You can also send us your improvement and bug fix requests.';
	String get help_translate_title => 'Help us translate!';
	String get help_translate_subtitle => 'If you like this apps, you should consider translating this app for your language.';
	String get report_bug_title => 'Report a Bug';
	String get report_bug_subtitle => 'If you have any suggestions or problems, please report them to our project on GitHub.';
	String get about_app_title => 'About App';
	String get url_launch_error => 'Could not launch URL: {url}';
	String get unknown => 'unknown';
}

// Path: about_app_screen
class TranslationsAboutAppScreenEn {
	TranslationsAboutAppScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get app_bar_title => 'Information';
	String get app_name_fallback => 'Note';
	String get copyright => '©2025 NguyenHienNg';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app_name': return 'Notes';
			case 'home_screen.app_bar_title': return 'Notes';
			case 'home_screen.search_hint': return 'Search notes...';
			case 'home_screen.no_notes_empty_state': return 'You have no notes. Create a new one!';
			case 'home_screen.no_notes_found_search': return 'No notes found matching "{searchText}"';
			case 'home_screen.create_note_button': return 'Create Note';
			case 'note_card.created_at': return 'Created at: {date}';
			case 'note_card.delete_confirm_title': return 'Confirm Deletion';
			case 'note_card.delete_confirm_content': return 'Are you sure you want to delete this note?';
			case 'note_card.cancel_button': return 'Cancel';
			case 'note_card.delete_button': return 'Delete';
			case 'note_card.note_deleted_snackbar': return 'Note deleted!';
			case 'add_note_sheet.add_note_title': return 'Create Note';
			case 'add_note_sheet.title_label': return 'Title';
			case 'add_note_sheet.title_hint': return 'Example: Weekend plan';
			case 'add_note_sheet.content_label': return 'Content';
			case 'add_note_sheet.content_hint': return 'Example: Go shopping, exercise, read book...';
			case 'add_note_sheet.save_note_button': return 'Save Note';
			case 'add_note_sheet.title_empty_error': return 'Title cannot be empty.';
			case 'note_detail_screen.edit_note_title': return 'Edit Note';
			case 'note_detail_screen.title_label': return 'Title';
			case 'note_detail_screen.title_hint': return 'Enter note title...';
			case 'note_detail_screen.content_label': return 'Content:';
			case 'note_detail_screen.content_hint': return 'Enter note content...';
			case 'note_detail_screen.created_at': return 'Created at: {date}';
			case 'note_detail_screen.no_content_placeholder': return 'Nothing here ¯\_(ツ)_/¯';
			case 'note_detail_screen.title_empty_error_snackbar': return 'Title cannot be empty!';
			case 'note_detail_screen.changes_saved_snackbar': return 'Changes saved!';
			case 'note_detail_screen.dialog_title': return 'Reminder';
			case 'note_detail_screen.dialog_content_save_confirm': return 'Are you sure you want to save these changes?';
			case 'note_detail_screen.dialog_content_exit_confirm': return 'Are you sure you want to save these changes?';
			case 'note_detail_screen.dialog_cancel_button': return 'Cancel';
			case 'note_detail_screen.dialog_discard_button': return 'Don\'t Save';
			case 'note_detail_screen.dialog_ok_button': return 'OK';
			case 'settings_screen.app_bar_title': return 'Settings';
			case 'settings_screen.section_settings': return 'Settings';
			case 'settings_screen.theme_title': return 'Theme';
			case 'settings_screen.theme_system': return 'System Default';
			case 'settings_screen.theme_light': return 'Light';
			case 'settings_screen.theme_dark': return 'Dark';
			case 'settings_screen.theme_selection_sheet_title': return 'Select Theme';
			case 'settings_screen.language_title': return 'Language';
			case 'settings_screen.language_selection_sheet_title': return 'Select Language';
			case 'settings_screen.language_vietnamese': return 'Tiếng Việt';
			case 'settings_screen.language_english': return 'English';
			case 'settings_screen.section_about': return 'About';
			case 'settings_screen.view_source_title': return 'View Source Code';
			case 'settings_screen.view_source_subtitle': return 'The source code for this application is available for reading on GitHub. You can also send us your improvement and bug fix requests.';
			case 'settings_screen.help_translate_title': return 'Help us translate!';
			case 'settings_screen.help_translate_subtitle': return 'If you like this apps, you should consider translating this app for your language.';
			case 'settings_screen.report_bug_title': return 'Report a Bug';
			case 'settings_screen.report_bug_subtitle': return 'If you have any suggestions or problems, please report them to our project on GitHub.';
			case 'settings_screen.about_app_title': return 'About App';
			case 'settings_screen.url_launch_error': return 'Could not launch URL: {url}';
			case 'settings_screen.unknown': return 'unknown';
			case 'about_app_screen.app_bar_title': return 'Information';
			case 'about_app_screen.app_name_fallback': return 'Note';
			case 'about_app_screen.copyright': return '©2025 NguyenHienNg';
			default: return null;
		}
	}
}

