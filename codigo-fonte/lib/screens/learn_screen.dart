import 'package:flutter/material.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _selectedCategory = 'Todos';

  final List<String> _categories = [
    'Todos',
    'Reciclagem',
    'Água',
    'Energia',
    'Biodiversidade',
    'Clima',
  ];

  final List<Map<String, dynamic>> _contents = [
    {
      'title': 'Por que reciclar é tão importante?',
      'description':
          'Descubra como a reciclagem reduz o impacto ambiental e contribui para uma economia circular sustentável.',
      'category': 'Reciclagem',
      'readTime': '5 min',
      'xp': 30,
      'emoji': '♻️',
      'color': const Color(0xFF4CAF50),
      'tag': 'Artigo',
      'liked': false,
    },
    {
      'title': 'A Crise da Água no Brasil',
      'description':
          'Entenda os desafios hídricos enfrentados pelo país e como cada um pode ajudar a preservar esse recurso essencial.',
      'category': 'Água',
      'readTime': '8 min',
      'xp': 50,
      'emoji': '💧',
      'color': const Color(0xFF2196F3),
      'tag': 'Vídeo',
      'liked': true,
    },
    {
      'title': 'Energias Renováveis: o futuro chegou',
      'description':
          'Solar, eólica e hidrelétrica: conheça as fontes de energia limpa que estão transformando nossa matriz energética.',
      'category': 'Energia',
      'readTime': '6 min',
      'xp': 40,
      'emoji': '⚡',
      'color': const Color(0xFFFF9800),
      'tag': 'Artigo',
      'liked': false,
    },
    {
      'title': 'Biodiversidade da Amazônia',
      'description':
          'A maior floresta tropical do mundo abriga milhões de espécies. Saiba por que sua preservação é urgente.',
      'category': 'Biodiversidade',
      'readTime': '10 min',
      'xp': 60,
      'emoji': '🌿',
      'color': const Color(0xFF8BC34A),
      'tag': 'Quiz',
      'liked': false,
    },
    {
      'title': 'Mudanças Climáticas: o que os dados dizem',
      'description':
          'Uma análise baseada em evidências científicas sobre as mudanças no clima global e seus impactos no Brasil.',
      'category': 'Clima',
      'readTime': '12 min',
      'xp': 70,
      'emoji': '🌍',
      'color': const Color(0xFF9C27B0),
      'tag': 'Artigo',
      'liked': false,
    },
    {
      'title': 'Compostagem em casa: guia prático',
      'description':
          'Transforme restos de alimentos em adubo rico em nutrientes. Aprenda o passo a passo para compostar no seu lar.',
      'category': 'Reciclagem',
      'readTime': '7 min',
      'xp': 45,
      'emoji': '🌱',
      'color': const Color(0xFF795548),
      'tag': 'Tutorial',
      'liked': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredContents {
    if (_selectedCategory == 'Todos') return _contents;
    return _contents
        .where((c) => c['category'] == _selectedCategory)
        .toList();
  }

  Color _tagColor(String tag) {
    switch (tag) {
      case 'Vídeo':
        return const Color(0xFFE91E63);
      case 'Quiz':
        return const Color(0xFFFF9800);
      case 'Tutorial':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF2196F3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFF2D7A3E),
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B5E20), Color(0xFF2D7A3E)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '📚 Aprender',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Conteúdos sobre sustentabilidade',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: const Text('Aprender'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: Container(
                color: const Color(0xFF2D7A3E),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = category),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF2D7A3E)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),

          // Busca
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar conteúdos...',
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF888888)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          // Destaque
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2D7A3E), Color(0xFF4CAF50)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2D7A3E).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '⭐ DESTAQUE',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Semana do Meio Ambiente',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Conteúdos especiais e missões extras disponíveis esta semana!',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Explorar →',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D7A3E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('🌍', style: TextStyle(fontSize: 56)),
                  ],
                ),
              ),
            ),
          ),

          // Lista de conteúdos
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _filteredContents[index];
                  return _ContentCard(
                    item: item,
                    tagColor: _tagColor(item['tag'] as String),
                    onLike: () {
                      setState(() {
                        _contents[_contents.indexOf(item)]['liked'] =
                            !(item['liked'] as bool);
                      });
                    },
                  );
                },
                childCount: _filteredContents.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Color tagColor;
  final VoidCallback onLike;

  const _ContentCard({
    required this.item,
    required this.tagColor,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header colorido
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: (item['color'] as Color).withOpacity(0.12),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Text(
                item['emoji'] as String,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tagColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['tag'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: tagColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['category'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D7A3E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '+${item['xp']} XP',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D7A3E),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['description'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: Color(0xFF888888),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item['readTime'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888888),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onLike,
                      child: Row(
                        children: [
                          Icon(
                            (item['liked'] as bool)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 18,
                            color: (item['liked'] as bool)
                                ? const Color(0xFFE91E63)
                                : const Color(0xFF888888),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Salvar',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D7A3E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Ler',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
