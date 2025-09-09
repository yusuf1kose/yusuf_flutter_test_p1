import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yusuf_flutter_test_p1/widgets/chat_widget.dart';
import 'package:yusuf_flutter_test_p1/widgets/jarvis_side_drawer.dart';
import 'package:yusuf_flutter_test_p1/state/providers.dart';
import '../widgets/jarvis_app_bar.dart';
import '../widgets/prompt_suggestion_card.dart';
import '../widgets/examples_list.dart';

class JarvisChatScreen extends ConsumerStatefulWidget {
  const JarvisChatScreen({super.key});

  @override
  ConsumerState<JarvisChatScreen> createState() => _JarvisChatScreenState();
}

class _JarvisChatScreenState extends ConsumerState<JarvisChatScreen> {
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(currentChatProvider);
    final shouldShowSuggestions = messages.isEmpty;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: JarvisSideDrawer(
        active: DrawerSection.chat,
        onNewChat: () {
          ref.read(currentChatProvider.notifier).clear();
        },
      ),
      appBar: _isSearching ? _buildSearchAppBar() : CustomAppBar(
        onSearchPressed: messages.isNotEmpty ? _toggleSearch : null,
      ),
      body: Column(
        children: [
          if (_isSearching && _searchQuery.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: cs.surface,
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: cs.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Searching for: "$_searchQuery"',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: cs.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (!_isSearching) const SizedBox(height: 20),
          if (shouldShowSuggestions && !_isSearching) ...[
            const PromptSuggestionCard(),
            const SizedBox(height: 50),
            const ExamplesList(),
            const SizedBox(height: 20),
          ],
          Expanded(
            child: ChatWidget(
              onTyping: () {},
              searchQuery: _isSearching ? _searchQuery : null,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    final cs = Theme.of(context).colorScheme;
    
    return AppBar(
      backgroundColor: cs.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: cs.onSurface),
        onPressed: _toggleSearch,
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: _onSearchChanged,
        style: GoogleFonts.poppins(color: cs.onSurface),
        decoration: InputDecoration(
          hintText: 'Search messages...',
          hintStyle: GoogleFonts.poppins(
            color: cs.onSurface.withOpacity(0.5),
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
      actions: [
        if (_searchController.text.isNotEmpty)
          IconButton(
            icon: Icon(Icons.clear, color: cs.onSurface),
            onPressed: () {
              _searchController.clear();
              _onSearchChanged('');
            },
          ),
      ],
    );
  }
}