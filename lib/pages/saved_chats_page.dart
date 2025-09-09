import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yusuf_flutter_test_p1/models/chat_models.dart';
import 'package:yusuf_flutter_test_p1/pages/jarvis_chat_screen.dart';
import 'package:yusuf_flutter_test_p1/widgets/Dialogs/chat_dialog.dart';
import 'package:yusuf_flutter_test_p1/widgets/jarvis_side_drawer.dart';
import '../state/providers.dart';
import '../widgets/menu_button.dart';

class SavedChatsPage extends ConsumerStatefulWidget {
  const SavedChatsPage({super.key});

  @override
  ConsumerState<SavedChatsPage> createState() => _SavedChatsPageState();
}

class _SavedChatsPageState extends ConsumerState<SavedChatsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _search = TextEditingController();
  bool _editMode = false;
  bool _deleteMode = false;
  final Set<String> _selected = {};

  static const brand = Color(0xFF1FA774);

  bool _busy = false; 
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sessions = ref.watch(chatSessionsProvider);
    final query = _search.text.trim().toLowerCase();
    final filtered = sessions.where((s) => s.title.toLowerCase().contains(query)).toList();

    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          drawer: const JarvisSideDrawer(active: DrawerSection.saved),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _buildTopBar(context, cs),
          body: Column(
            children: [
         
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Saved Chats',
                              style: GoogleFonts.poppins(
                                fontSize: 22, fontWeight: FontWeight.w800, color: cs.onSurface,
                              )),
                          const SizedBox(height: 10),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 260),
                            child: _SearchField(controller: _search, onChanged: (_) => setState(() {})),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 55),
                    if (!_editMode && !_deleteMode) ...[
                      _ActionCard(
                        label: 'Edit',
                        icon: Icons.edit,
                        accent: brand,
                        onTap: () => setState(() {
                          _editMode = true;
                          _deleteMode = false;
                        }),
                      ),
                      const SizedBox(width: 12),
                      _ActionCard(
                        label: 'Delete',
                        icon: Icons.delete_outline,
                        accent: const Color(0xFFE84F73),
                        onTap: () => setState(() {
                          _deleteMode = true;
                          _editMode = false;
                          _selected.clear();
                        }),
                      ),
                    ],
                    if (_editMode || _deleteMode)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 6),
                        child: TextButton(
                          onPressed: () => setState(() {
                            _editMode = false;
                            _deleteMode = false;
                            _selected.clear();
                          }),
                          child: Text('Cancel', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Divider(height: 1),

              Expanded(
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final s = filtered[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      leading: const Icon(Icons.folder_open, color: brand),
                      title: Text(
                        s.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600, color: cs.onSurface,
                        ),
                      ),
                      trailing: Text(
                        _formatTime(s.createdAt),
                        style: GoogleFonts.poppins(
                         
                          fontSize: 12, color: cs.onSurface.withOpacity(.65), fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () async {
                        if (_deleteMode) {
                          setState(() {
                            if (_selected.contains(s.id)) {
                              _selected.remove(s.id);
                            } else {
                              _selected.add(s.id);
                            }
                          });
                          return;
                        }
                        if (_editMode) {
                          final newTitle = await showJarvisTextDialog(
                            context,
                            title: "Change this chat’s title?",
                            hint: 'Enter a Title…',
                            confirmLabel: 'SAVE',
                            initial: s.title,
                          );
                          if (newTitle != null) {
                            await _doAsync(() async {
                              await ref.read(chatSessionsProvider.notifier).rename(s.id, newTitle);
                            }, errorToast: 'Rename failed. Please try again.');
                          }
                          return;
                        }

                        // Restore and open
                        await _doAsync(() async {
                          final store = ref.read(chatStoreProvider);
                          final session = await store.getById(s.id);
                          if (session == null) {
                            throw Exception('Saved chat not found');
                          }

                          final authUser = ref.read(authStateProvider).asData?.value;
                          final currentUser = ChatUser(
                            id: authUser?.uid ?? 'guest',
                            firstName: authUser?.displayName ?? 'You',
                          );
                          final jarvis = ChatUser(id: '1', firstName: 'Jarvis');

                          final restored = session.messages
                              .map((m) => m.toChatMessage(currentUser, jarvis))
                              .toList()
                              .reversed
                              .toList();

                          final chat = ref.read(currentChatProvider.notifier);
                          chat.clear();
                          chat.addAllAtTop(restored);

                          if (!mounted) return;
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const JarvisChatScreen()),
                          );
                        }, errorToast: 'Could not open this chat.');
                      },
                    );
                  },
                ),
              ),

              if (_deleteMode)
                _DeleteBar(
                  count: _selected.length,
                  onDelete: _handleDeleteSelected,
                ),
            ],
          ),
        ),

        if (_busy)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                color: Colors.black.withOpacity(0.15),
                child: const Center(
                  child: SizedBox(
                    width: 28, height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _handleDeleteSelected() async {
    if (_selected.isEmpty) return;
    final ok = await showJarvisConfirmDialog(
      context,
      title: 'Delete chat(s)?',
      message: 'Once conversations have been deleted you cannot recover them.',
      confirmLabel: 'DELETE',
    );
    if (!ok) return;

    await _doAsync(() async {
      await ref.read(chatSessionsProvider.notifier).deleteMany(_selected);
      setState(() {
        _selected.clear();
        _deleteMode = false;
      });
    }, errorToast: 'Delete failed. Please try again.');
  }

  Future<void> _doAsync(Future<void> Function() action, {String? errorToast}) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorToast ?? 'Something went wrong: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  PreferredSizeWidget _buildTopBar(BuildContext context, ColorScheme cs) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 60,
      leading: Builder(
        builder: (ctx) => IconButton(
          onPressed: () => Scaffold.of(ctx).openDrawer(),
          icon: const Padding(
            padding: EdgeInsets.only(left: 18),
            child: MenuButton(),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/jarvis_appbar_logo.png', height: 40),
          const SizedBox(width: 8),
          const Text('Jarvis',
              style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w800, color: brand,
              )),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final mm = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$mm $ampm';
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search…',
          hintStyle: GoogleFonts.poppins(color: cs.onSurface.withOpacity(.6)),
          filled: true,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor
              ?? (Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF232327)
                  : const Color(0xFFF2F3F7)),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.search, color: Color(0xFF1FA774)),
          ),
          suffixIconConstraints: const BoxConstraints(minWidth: 40),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: cs.outline.withOpacity(.25)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: cs.outline.withOpacity(.25)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            borderSide: BorderSide(color: Color(0xFF1FA774), width: 1.3),
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
    this.width = 70,
    this.height = 100,
    this.iconSize = 20,
    this.hPad = 10,
    this.vPad = 8,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  final double width;
  final double height;
  final double iconSize;
  final double hPad;
  final double vPad;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: width, height: height),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent.withOpacity(.35)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, color: cs.onSurface,
              )),
              const SizedBox(height: 6),
              Container(
                width: 24, height: 3,
                decoration: BoxDecoration(
                  color: cs.onSurface.withOpacity(.12),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),
              Icon(icon, color: accent, size: iconSize),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteBar extends StatelessWidget {
  const _DeleteBar({required this.count, required this.onDelete});
  final int count;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? .3 : .06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text('$count selected', style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          ElevatedButton(
            onPressed: onDelete,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE84F73),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
}
