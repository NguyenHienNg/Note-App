import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../i18n/strings.g.dart';

class RestoreSelectScreen extends StatefulWidget {
  final List<Note> notes;

  const RestoreSelectScreen({super.key, required this.notes});

  @override
  State<RestoreSelectScreen> createState() => _RestoreSelectScreenState();
}

class _RestoreSelectScreenState extends State<RestoreSelectScreen> {
  final Set<int> _selectedIndices = {};

  bool get _allSelected =>
      widget.notes.isNotEmpty && _selectedIndices.length == widget.notes.length;

  void _toggleSelectAll() {
    setState(() {
      if (_allSelected) {
        _selectedIndices.clear();
      } else {
        _selectedIndices.addAll(List.generate(widget.notes.length, (i) => i));
      }
    });
  }

  void _onRestore() {
    final selected = _selectedIndices.toList()..sort();
    final notesToRestore = selected.map((i) => widget.notes[i]).toList();

    if (notesToRestore.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.settings_screen.restore_no_selection)),
      );
      return;
    }

    // Chuyển sang RestoreConfirmScreen để bắt đầu tiến hành khôi phục
    context.pushReplacement(
      '/settings/advanced/restore/confirm',
      extra: notesToRestore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.settings_screen.restore_select_notes)),
      body: widget.notes.isEmpty
          ? Center(child: Text(t.settings_screen.restore_no_notes))
          : Column(
              children: [
                // Header: count + select all
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${_selectedIndices.length}/${widget.notes.length}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _toggleSelectAll,
                        child: Text(
                          _allSelected
                              ? t.settings_screen.backup_deselect_all
                              : t.settings_screen.backup_select_all,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Note list
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.notes.length,
                    itemBuilder: (context, index) {
                      final note = widget.notes[index];
                      final isSelected = _selectedIndices.contains(index);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedIndices.add(index);
                            } else {
                              _selectedIndices.remove(index);
                            }
                          });
                        },
                        title: Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          DateFormat.yMMMd(
                            LocaleSettings.currentLocale.languageCode,
                          ).add_jm().format(note.createdAt),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        secondary: const Icon(Icons.note_outlined),
                      );
                    },
                  ),
                ),
              ],
            ),
      // Nút Khôi phục ở dưới cùng
      bottomNavigationBar: widget.notes.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FilledButton.icon(
                  onPressed: _selectedIndices.isEmpty ? null : _onRestore,
                  icon: const Icon(Icons.restore),
                  label: Text(t.settings_screen.restore_btn_restore),
                ),
              ),
            ),
    );
  }
}
