import 'package:dating_app/core/localization/localization_manager.dart';
import 'package:dating_app/core/services/ai_matching_service.dart';
import 'package:dating_app/data/models/users/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final AIMatchingService _aiService = AIMatchingService();
  RangeValues _ageRange = const RangeValues(18, 45);
  double _maxDistance = 50;
  String _showMe = 'everyone';

  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationManager>(context);
    final List<User> exploreUsers = _generateMockUsers();

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.tr('explore_nearby')),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context, localization),
          ),
        ],
      ),
      body: exploreUsers.isEmpty
          ? _buildEmptyState(localization)
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Section IA Suggestions
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFE3C72).withOpacity(0.1),
                          Colors.purple.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFE3C72).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFE3C72).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFFFE3C72),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localization.tr('ai_suggestions'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                localization.currentLanguage == AppLanguage.french
                                    ? 'Profils sélectionnés par notre IA pour vous'
                                    : 'Profiles selected by our AI for you',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Color(0xFFFE3C72)),
                      ],
                    ),
                  ),
                ),
                
                // Grille de profils
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildExploreCard(context, exploreUsers[index], localization),
                      childCount: exploreUsers.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<User> _generateMockUsers() {
    return [
      User(
        id: '1',
        name: 'Emma',
        age: 26,
        photoUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=500',
        bio: 'Digital Artist | Coffee Lover',
        distance: 2.5,
        interests: ['Art', 'Coffee', 'Travel'],
      ),
      User(
        id: '2',
        name: 'James',
        age: 29,
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
        bio: 'Software Engineer | Photographer',
        distance: 3.1,
        interests: ['Tech', 'Hiking', 'Photography'],
      ),
      User(
        id: '3',
        name: 'Sophia',
        age: 24,
        photoUrl: 'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=500',
        bio: 'Medical Student | Yoga Instructor',
        distance: 1.2,
        interests: ['Medicine', 'Yoga', 'Reading'],
      ),
      User(
        id: '4',
        name: 'Michael',
        age: 31,
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500',
        bio: 'Chef & Food Blogger',
        distance: 4.7,
        interests: ['Cooking', 'Travel', 'Wine'],
      ),
      User(
        id: '5',
        name: 'Olivia',
        age: 27,
        photoUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500',
        bio: 'Yoga Instructor | Wellness Coach',
        distance: 0.8,
        interests: ['Fitness', 'Meditation', 'Health'],
      ),
      User(
        id: '6',
        name: 'William',
        age: 30,
        photoUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500',
        bio: 'Entrepreneur | Travel Enthusiast',
        distance: 5.3,
        interests: ['Business', 'Skiing', 'Cars'],
      ),
    ];
  }

  Widget _buildExploreCard(BuildContext context, User user, LocalizationManager localization) {
    // Score IA simulé
    final int aiScore = 70 + (user.interests.length * 6);
    
    return GestureDetector(
      onTap: () => _showProfileDetail(context, user, localization, aiScore),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Photo
            Hero(
              tag: 'explore-${user.id}',
              child: Image.network(
                user.photoUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
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
            ),
            
            // Badge distance
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '${user.distance} ${localization.tr('km_away')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Badge IA
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: aiScore >= 85 ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '$aiScore%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Informations
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.verified, color: Colors.blue, size: 16),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.bio,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: user.interests.take(3).map((interest) => Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFE3C72).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            interest,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(LocalizationManager localization) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text(
            localization.tr('no_profiles_found'),
            style: TextStyle(
              fontSize: 22,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              localization.tr('adjust_filters'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
            label: Text(localization.tr('refresh')),
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

  void _showFilters(BuildContext context, LocalizationManager localization) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localization.tr('filters'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _ageRange = const RangeValues(18, 45);
                        _maxDistance = 50;
                        _showMe = 'everyone';
                      });
                    },
                    child: Text(
                      localization.tr('reset_filters'),
                      style: const TextStyle(color: Color(0xFFFE3C72)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Tranche d'âge
              Text(
                '${localization.tr('age_range')}: ${_ageRange.start.round()} - ${_ageRange.end.round()}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              RangeSlider(
                values: _ageRange,
                min: 18,
                max: 60,
                divisions: 42,
                activeColor: const Color(0xFFFE3C72),
                labels: RangeLabels(
                  _ageRange.start.round().toString(),
                  _ageRange.end.round().toString(),
                ),
                onChanged: (values) {
                  setModalState(() => _ageRange = values);
                },
              ),
              const SizedBox(height: 16),
              
              // Distance
              Text(
                '${localization.tr('distance_range')}: ${_maxDistance.round()} km',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Slider(
                value: _maxDistance,
                min: 1,
                max: 100,
                divisions: 99,
                activeColor: const Color(0xFFFE3C72),
                label: '${_maxDistance.round()} km',
                onChanged: (value) {
                  setModalState(() => _maxDistance = value);
                },
              ),
              const SizedBox(height: 16),
              
              // Me montrer
              Text(
                localization.tr('show_me'),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildShowMeOption(localization.tr('men'), 'men', setModalState, localization),
                  const SizedBox(width: 12),
                  _buildShowMeOption(localization.tr('women'), 'women', setModalState, localization),
                  const SizedBox(width: 12),
                  _buildShowMeOption(localization.tr('everyone'), 'everyone', setModalState, localization),
                ],
              ),
              const SizedBox(height: 32),
              
              // Bouton appliquer
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE3C72),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    localization.tr('apply_filters'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShowMeOption(String label, String value, StateSetter setModalState, LocalizationManager localization) {
    final isSelected = _showMe == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setModalState(() => _showMe = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFE3C72) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFFE3C72) : Colors.grey[300]!,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showProfileDetail(BuildContext context, User user, LocalizationManager localization, int aiScore) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              // Photo en haut
              Stack(
                children: [
                  Hero(
                    tag: 'explore-${user.id}',
                    child: Container(
                      height: 350,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        image: DecorationImage(
                          image: NetworkImage(user.photoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: aiScore >= 85 ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '$aiScore% ${localization.tr(aiScore >= 85 ? 'highly_compatible' : 'compatible')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Informations
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${user.name}, ${user.age}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.verified, color: Colors.blue, size: 28),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${user.distance} ${localization.tr('km_away')}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Bio
                    Text(
                      localization.tr('about_me'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.bio,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    
                    // Intérêts
                    Text(
                      localization.tr('interests'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                    const SizedBox(height: 32),
                    
                    // Boutons d'action
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                            label: Text(localization.tr('dislike')),
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
                            icon: const Icon(Icons.favorite),
                            label: Text(localization.tr('like')),
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
