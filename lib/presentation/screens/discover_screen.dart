import 'package:dating_app/core/constants/app_colors.dart';
import 'package:dating_app/core/localization/localization_manager.dart';
import 'package:dating_app/core/services/ai_matching_service.dart';
import 'package:dating_app/data/models/users/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  final AIMatchingService _aiService = AIMatchingService();
  late List<User> _profiles;
  int _currentIndex = 0;
  AIMatchResult? _currentMatchResult;
  bool _isAnalyzing = false;

  // Profil utilisateur actuel (simulé)
  final UserProfile _currentUser = UserProfile(
    id: 'current_user',
    name: 'Vous',
    age: 28,
    bio: 'Passionné de voyages et de photographie',
    interests: ['Travel', 'Photography', 'Coffee', 'Music', 'Art'],
    personality: 'adventurous',
    lifestyle: 'active',
    lookingFor: 'relationship',
    preferences: {'minAge': 22, 'maxAge': 35},
  );

  @override
  void initState() {
    super.initState();
    _profiles = _generateMockProfiles();
    _analyzeCurrentProfile();
  }

  List<User> _generateMockProfiles() {
    return [
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
        name: 'Lucas',
        age: 29,
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
        bio: 'Ingénieur logiciel | Photographe amateur 📸',
        distance: 3.1,
        interests: ['Tech', 'Photography', 'Hiking', 'Music'],
      ),
      User(
        id: '3',
        name: 'Emma',
        age: 24,
        photoUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=500',
        bio: 'Étudiante en médecine | Prof de yoga 🧘‍♀️',
        distance: 1.2,
        interests: ['Yoga', 'Health', 'Reading', 'Travel'],
      ),
      User(
        id: '4',
        name: 'Thomas',
        age: 31,
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500',
        bio: 'Chef cuisinier & Blogueur food 🍳',
        distance: 4.7,
        interests: ['Cooking', 'Travel', 'Wine', 'Photography'],
      ),
      User(
        id: '5',
        name: 'Léa',
        age: 27,
        photoUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500',
        bio: 'Coach bien-être | Passionnée de nature 🌿',
        distance: 0.8,
        interests: ['Fitness', 'Meditation', 'Health', 'Hiking'],
      ),
    ];
  }

  Future<void> _analyzeCurrentProfile() async {
    if (_currentIndex >= _profiles.length) return;

    setState(() => _isAnalyzing = true);

    final currentProfile = _profiles[_currentIndex];
    final userProfile = UserProfile(
      id: currentProfile.id,
      name: currentProfile.name,
      age: currentProfile.age,
      bio: currentProfile.bio,
      interests: currentProfile.interests,
      personality: 'creative',
      lifestyle: 'balanced',
    );

    final result = await _aiService.calculateCompatibility(
      _currentUser,
      userProfile,
    );

    if (mounted) {
      setState(() {
        _currentMatchResult = result;
        _isAnalyzing = false;
      });
    }
  }

  void _onSwipeLeft() {
    if (_currentIndex < _profiles.length - 1) {
      setState(() {
        _currentIndex++;
        _currentMatchResult = null;
      });
      _analyzeCurrentProfile();
    } else {
      setState(() {
        _currentIndex = _profiles.length;
      });
    }
  }

  void _onSwipeRight() {
    _showMatchDialog();
    if (_currentIndex < _profiles.length - 1) {
      setState(() {
        _currentIndex++;
        _currentMatchResult = null;
      });
      _analyzeCurrentProfile();
    } else {
      setState(() {
        _currentIndex = _profiles.length;
      });
    }
  }

  void _onSuperLike() {
    _showMatchDialog(isSuperLike: true);
    if (_currentIndex < _profiles.length - 1) {
      setState(() {
        _currentIndex++;
        _currentMatchResult = null;
      });
      _analyzeCurrentProfile();
    } else {
      setState(() {
        _currentIndex = _profiles.length;
      });
    }
  }

  void _showMatchDialog({bool isSuperLike = false}) {
    final localization = Provider.of<LocalizationManager>(context, listen: false);
    final profile = _profiles[_currentIndex];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, color: Color(0xFFFE3C72), size: 60),
              const SizedBox(height: 16),
              Text(
                localization.tr('its_a_match'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFE3C72),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${localization.tr('matched_with')} ${profile.name}!',
                style: const TextStyle(fontSize: 16),
              ),
              if (_currentMatchResult != null) ...[
                const SizedBox(height: 16),
                _buildCompatibilityBadge(_currentMatchResult!),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(localization.tr('back')),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(localization.tr('send_message')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompatibilityBadge(AIMatchResult result) {
    final localization = Provider.of<LocalizationManager>(context, listen: false);
    
    Color badgeColor;
    if (result.compatibilityScore >= 0.8) {
      badgeColor = Colors.green;
    } else if (result.compatibilityScore >= 0.6) {
      badgeColor = Colors.orange;
    } else {
      badgeColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, color: badgeColor, size: 20),
          const SizedBox(width: 8),
          Text(
            '${result.scorePercentage}% ${localization.tr(result.compatibilityLevel)}',
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Color(0xFFFE3C72),
              size: 32,
            ),
            const SizedBox(width: 8),
            Text(
              localization.tr('app_name'),
              style: const TextStyle(
                color: Color(0xFFFE3C72),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          LanguageToggleButton(localizationManager: localization),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: _currentIndex >= _profiles.length
          ? _buildEmptyState(localization)
          : _buildProfileCard(localization),
    );
  }

  Widget _buildEmptyState(LocalizationManager localization) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text(
            localization.tr('no_more_profiles'),
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
              localization.tr('check_back_later'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _currentIndex = 0;
                _profiles = _generateMockProfiles();
              });
              _analyzeCurrentProfile();
            },
            icon: const Icon(Icons.refresh),
            label: Text(localization.tr('refresh')),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(LocalizationManager localization) {
    final profile = _profiles[_currentIndex];

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  _onSwipeRight();
                } else if (details.primaryVelocity! < 0) {
                  _onSwipeLeft();
                }
              },
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      profile.photoUrl,
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
                        child: const Icon(Icons.person, size: 100, color: Colors.grey),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    if (_currentMatchResult != null && !_isAnalyzing)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: _buildAIScoreBadge(localization),
                      ),
                    if (_isAnalyzing)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                localization.tr('ai_analyzing'),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${profile.name}, ${profile.age}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.verified, color: Colors.blue, size: 24),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${profile.distance} ${localization.tr('km_away')}',
                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profile.bio,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: profile.interests.take(4).map((interest) {
                                final isCommon = _currentMatchResult?.commonInterests
                                    .contains(interest) ?? false;
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isCommon
                                        ? const Color(0xFFFE3C72).withOpacity(0.3)
                                        : Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: isCommon
                                        ? Border.all(color: const Color(0xFFFE3C72))
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isCommon)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 4),
                                          child: Icon(Icons.star, color: Color(0xFFFE3C72), size: 14),
                                        ),
                                      Text(
                                        interest,
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            if (_currentMatchResult != null && 
                                _currentMatchResult!.aiSuggestion.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _currentMatchResult!.aiSuggestion,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.close,
                color: Colors.red,
                size: 60,
                onTap: _onSwipeLeft,
                tooltip: localization.tr('dislike'),
              ),
              _buildActionButton(
                icon: Icons.star,
                color: Colors.blue,
                size: 50,
                onTap: _onSuperLike,
                tooltip: localization.tr('super_like'),
              ),
              _buildActionButton(
                icon: Icons.favorite,
                color: const Color(0xFFFE3C72),
                size: 60,
                onTap: _onSwipeRight,
                tooltip: localization.tr('like'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAIScoreBadge(LocalizationManager localization) {
    final result = _currentMatchResult!;
    
    Color badgeColor;
    IconData badgeIcon;
    
    if (result.compatibilityScore >= 0.8) {
      badgeColor = Colors.green;
      badgeIcon = Icons.favorite;
    } else if (result.compatibilityScore >= 0.6) {
      badgeColor = Colors.orange;
      badgeIcon = Icons.thumb_up;
    } else {
      badgeColor = Colors.blue;
      badgeIcon = Icons.psychology;
    }

    return GestureDetector(
      onTap: () => _showAIAnalysisDialog(localization),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: badgeColor.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(badgeIcon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              '${result.scorePercentage}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.info_outline, color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }

  void _showAIAnalysisDialog(LocalizationManager localization) {
    if (_currentMatchResult == null) return;
    
    final result = _currentMatchResult!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
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
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFFFE3C72), size: 28),
                  const SizedBox(width: 12),
                  Text(
                    localization.tr('ai_match_score'),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: result.compatibilityScore,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey[200],
                            color: result.compatibilityScore >= 0.8
                                ? Colors.green
                                : result.compatibilityScore >= 0.6
                                    ? Colors.orange
                                    : Colors.blue,
                          ),
                        ),
                        Text(
                          '${result.scorePercentage}%',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localization.tr(result.compatibilityLevel),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: result.compatibilityScore >= 0.8
                            ? Colors.green
                            : result.compatibilityScore >= 0.6
                                ? Colors.orange
                                : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                localization.tr('why_you_match'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...result.matchReasons.map((reason) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text(reason)),
                  ],
                ),
              )),
              const SizedBox(height: 24),
              if (result.commonInterests.isNotEmpty) ...[
                Text(
                  localization.tr('common_interests'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: result.commonInterests.map((interest) => Chip(
                    avatar: const Icon(Icons.star, size: 18, color: Color(0xFFFE3C72)),
                    label: Text(interest),
                    backgroundColor: const Color(0xFFFE3C72).withOpacity(0.1),
                  )).toList(),
                ),
                const SizedBox(height: 24),
              ],
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFE3C72).withOpacity(0.1),
                      Colors.purple.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        result.aiSuggestion,
                        style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
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

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Icon(icon, color: color, size: size * 0.5),
        ),
      ),
    );
  }
}
