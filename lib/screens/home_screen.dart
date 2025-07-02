import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
// THAY ĐỔI: Đã loại bỏ import '../providers/theme_provider.dart';
import '../widgets/add_note_sheet.dart';
import '../widgets/note_card.dart';
import 'settings.dart';

// Chuyển HomeScreen thành StatefulWidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false; // Trạng thái để biết có đang tìm kiếm hay không
  final TextEditingController _searchController = TextEditingController();
  String _searchText = ""; // Từ khóa tìm kiếm hiện tại

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text; // Cập nhật từ khóa tìm kiếm khi người dùng gõ
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy NoteProvider để có thể lọc ghi chú
    final noteProvider = Provider.of<NoteProvider>(context);

    // Lọc danh sách ghi chú dựa trên từ khóa tìm kiếm (chỉ tìm trong tiêu đề)
    final filteredNotes = _searchText.isEmpty
        ? noteProvider.notes
        : noteProvider.notes.where((note) {
            return note.title.toLowerCase().contains(_searchText.toLowerCase());
          }).toList();

    return Scaffold(
      appBar: AppBar(
        // Hiển thị TextField khi đang tìm kiếm, ngược lại hiển thị tiêu đề
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true, // Tự động focus khi mở tìm kiếm
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm ghi chú...',
                  border: InputBorder.none, // Bỏ đường viền
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18),
                onChanged: (value) {
                  // _searchText đã được cập nhật bởi listener của _searchController
                  // Không cần setState ở đây vì listener đã làm điều đó
                },
              )
            : const Text('Ghi chú'),
        actions: [
          // Nút tìm kiếm / Đóng tìm kiếm
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear(); // Xóa từ khóa khi đóng tìm kiếm
                  _searchText = ""; // Đảm bảo từ khóa tìm kiếm được reset
                  FocusScope.of(context).unfocus(); // Ẩn bàn phím
                }
              });
            },
          ),
          // Nút Cài đặt (vẫn giữ nguyên)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          if (noteProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Sử dụng filteredNotes thay vì noteProvider.notes
          if (filteredNotes.isEmpty) {
            // Hiển thị thông báo khác nhau tùy thuộc vào trạng thái tìm kiếm
            return Center(
              child: Text(
                _searchText.isEmpty
                    ? 'Bạn không có ghi chú nào. Hãy tạo một ghi chú mới!'
                    : 'Không tìm thấy ghi chú nào phù hợp với "$_searchText"',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              final note = filteredNotes[index];
              return NoteCard(note: note);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddNoteSheet(context),
        label: const Text('Tạo ghi chú'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}