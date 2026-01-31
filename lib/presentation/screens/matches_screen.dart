import 'package:dating_app/core/localization/localization_manager.dart';
import 'package:dating_app/data/models/users/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationManager>(context);
    
    // Données de démonstration
    final List<User> matches = [
      User(
        id: '1',
        name: 'Sophie',
        age: 26,
        photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500',
        bio: 'Artiste digitale | Amoureuse du café ☕',
        distance: 2.5,
        interests: ['Art', 'Coffee', 'Travel', 'Photography'],
      ),
      User(
        id: '2',
        name: 'Emma',
        age: 24,
        photoUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=500',
        bio: 'Étudiante en médecine | Prof de yoga 🧘‍♀️',
        distance: 1.2,
        interests: ['Yoga', 'Health', 'Reading', 'Travel'],
      ),
      User(
        id: '3',
        name: 'Léa',
        age: 27,
        photoUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500',
        bio: 'Coach bien-être | Passionnée de nature 🌿',
        distance: 0.8,
        interests: ['Fitness', 'Meditation', 'Health', 'Hiking'],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.tr('your_matches')),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: matches.isEmpty
          ? _buildEmptyState(localization)
          : _buildMatchesList(matches, localization),
    );
  }

  Widget _buildEmptyState(LocalizationManager localization) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            localization.tr('no_matches_yet'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              localization.tr('start_swiping'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.explore),
            label: Text(localization.tr('discover')),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFE3C72),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesList(List<User> matches, LocalizationManager localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Nouveaux matchs
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFFFE3C72), size: 20),
              const SizedBox(width: 8),
              Text(
                localization.tr('new_matches'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFE3C72),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${matches.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Grille de matchs
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              return _buildMatchCard(context, matches[index], localization);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMatchCard(BuildContext context, User user, LocalizationManager localization) {
    // Score IA simulé
    final int aiScore = 75 + (user.interests.length * 5);
    
    return GestureDetector(
      onTap: () => _showMatchDetails(context, user, localization, aiScore),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Photo
              Image.network(
                user.photoUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
              ),
              
              // Gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
              
              // Badge IA
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: aiScore >= 85 ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '$aiScore%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Informations
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${user.name}, ${user.age}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.verified, color: Colors.blue, size: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          '${user.distance} ${localization.tr('km_away')}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Bouton message
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.message, size: 16),
                        label: Text(
                          localization.tr('send_message'),
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFE3C72),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMatchDetails(BuildContext context, User user, LocalizationManager localization, int aiScore) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Photo et infos
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Photo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFE3C72), width: 3),
                        image: DecorationImage(
                          image: NetworkImage(user.photoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Nom
                    Text(
                      '${user.name}, ${user.age}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Score IA
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: (aiScore >= 85 ? Colors.green : Colors.orange).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: aiScore >= 85 ? Colors.green : Colors.orange,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: aiScore >= 85 ? Colors.green : Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$aiScore% ${localization.tr(aiScore >= 85 ? 'highly_compatible' : 'compatible')}',
                            style: TextStyle(
                              color: aiScore >= 85 ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Bio
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, size: 20, color: Color(0xFFFE3C72)),
                              const SizedBox(width: 8),
                              Text(
                                localization.tr('about_me'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(user.bio, style: const TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Intérêts
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.favorite, size: 20, color: Color(0xFFFE3C72)),
                              const SizedBox(width: 8),
                              Text(
                                localization.tr('interests'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: user.interests.map((interest) => Chip(
                              label: Text(interest),
                              backgroundColor: const Color(0xFFFE3C72).withOpacity(0.1),
                              labelStyle: const TextStyle(color: Color(0xFFFE3C72)),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Boutons d'action
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                            label: Text(localization.tr('unmatch')),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.message),
                            label: Text(localization.tr('send_message')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFE3C72),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
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
        ),
      ),
    );
  }
}
