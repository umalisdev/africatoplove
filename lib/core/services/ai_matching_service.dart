import 'dart:convert';
import 'dart:math';

/// Modèle représentant un profil utilisateur pour le matching IA
class UserProfile {
  final String id;
  final String name;
  final int age;
  final String bio;
  final List<String> interests;
  final String personality;
  final String lifestyle;
  final String lookingFor;
  final Map<String, dynamic> preferences;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    this.bio = '',
    this.interests = const [],
    this.personality = '',
    this.lifestyle = '',
    this.lookingFor = '',
    this.preferences = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'bio': bio,
    'interests': interests,
    'personality': personality,
    'lifestyle': lifestyle,
    'lookingFor': lookingFor,
    'preferences': preferences,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    age: json['age'] ?? 0,
    bio: json['bio'] ?? '',
    interests: List<String>.from(json['interests'] ?? []),
    personality: json['personality'] ?? '',
    lifestyle: json['lifestyle'] ?? '',
    lookingFor: json['lookingFor'] ?? '',
    preferences: json['preferences'] ?? {},
  );
}

/// Résultat du matching IA
class AIMatchResult {
  final String matchedUserId;
  final double compatibilityScore; // 0.0 à 1.0
  final List<String> commonInterests;
  final String personalityAnalysis;
  final String lifestyleCompatibility;
  final List<String> matchReasons;
  final String aiSuggestion;

  AIMatchResult({
    required this.matchedUserId,
    required this.compatibilityScore,
    this.commonInterests = const [],
    this.personalityAnalysis = '',
    this.lifestyleCompatibility = '',
    this.matchReasons = const [],
    this.aiSuggestion = '',
  });

  /// Obtenir le niveau de compatibilité en texte
  String get compatibilityLevel {
    if (compatibilityScore >= 0.8) return 'highly_compatible';
    if (compatibilityScore >= 0.6) return 'compatible';
    return 'moderately_compatible';
  }

  /// Score en pourcentage
  int get scorePercentage => (compatibilityScore * 100).round();
}

/// Service de matching intelligent basé sur l'IA
class AIMatchingService {
  // Poids pour les différents critères de matching
  static const double _interestWeight = 0.35;
  static const double _personalityWeight = 0.25;
  static const double _lifestyleWeight = 0.20;
  static const double _ageCompatibilityWeight = 0.10;
  static const double _bioSimilarityWeight = 0.10;

  // Catégories d'intérêts pour l'analyse
  static const Map<String, List<String>> _interestCategories = {
    'creative': ['Art', 'Music', 'Photography', 'Writing', 'Design', 'Dancing'],
    'outdoor': ['Hiking', 'Travel', 'Camping', 'Sports', 'Fitness', 'Running'],
    'intellectual': ['Reading', 'Tech', 'Science', 'History', 'Philosophy', 'Learning'],
    'social': ['Cooking', 'Wine', 'Coffee', 'Food', 'Parties', 'Networking'],
    'wellness': ['Yoga', 'Meditation', 'Health', 'Wellness', 'Mindfulness', 'Spa'],
    'entertainment': ['Movies', 'Gaming', 'Netflix', 'Concerts', 'Theater', 'Comedy'],
  };

  // Types de personnalité
  static const List<String> _personalityTypes = [
    'adventurous', 'calm', 'creative', 'analytical', 
    'social', 'introverted', 'ambitious', 'laid-back'
  ];

  // Styles de vie
  static const List<String> _lifestyleTypes = [
    'active', 'homebody', 'traveler', 'workaholic',
    'balanced', 'spontaneous', 'organized', 'flexible'
  ];

  /// Calculer le score de compatibilité entre deux profils
  Future<AIMatchResult> calculateCompatibility(
    UserProfile currentUser,
    UserProfile potentialMatch,
  ) async {
    // Simuler un délai d'analyse IA
    await Future.delayed(const Duration(milliseconds: 500));

    // Calculer les différents scores
    final interestScore = _calculateInterestScore(
      currentUser.interests, 
      potentialMatch.interests
    );
    
    final personalityScore = _calculatePersonalityScore(
      currentUser.personality, 
      potentialMatch.personality
    );
    
    final lifestyleScore = _calculateLifestyleScore(
      currentUser.lifestyle, 
      potentialMatch.lifestyle
    );
    
    final ageScore = _calculateAgeCompatibility(
      currentUser.age, 
      potentialMatch.age,
      currentUser.preferences,
    );
    
    final bioScore = _calculateBioSimilarity(
      currentUser.bio, 
      potentialMatch.bio
    );

    // Score final pondéré
    final totalScore = 
      (interestScore * _interestWeight) +
      (personalityScore * _personalityWeight) +
      (lifestyleScore * _lifestyleWeight) +
      (ageScore * _ageCompatibilityWeight) +
      (bioScore * _bioSimilarityWeight);

    // Trouver les intérêts communs
    final commonInterests = currentUser.interests
        .where((i) => potentialMatch.interests.contains(i))
        .toList();

    // Générer l'analyse
    final matchReasons = _generateMatchReasons(
      interestScore, 
      personalityScore, 
      lifestyleScore,
      commonInterests,
    );

    final aiSuggestion = _generateAISuggestion(
      currentUser, 
      potentialMatch, 
      totalScore,
      commonInterests,
    );

    return AIMatchResult(
      matchedUserId: potentialMatch.id,
      compatibilityScore: totalScore.clamp(0.0, 1.0),
      commonInterests: commonInterests,
      personalityAnalysis: _analyzePersonalityMatch(
        currentUser.personality, 
        potentialMatch.personality
      ),
      lifestyleCompatibility: _analyzeLifestyleMatch(
        currentUser.lifestyle, 
        potentialMatch.lifestyle
      ),
      matchReasons: matchReasons,
      aiSuggestion: aiSuggestion,
    );
  }

  /// Calculer le score basé sur les intérêts communs
  double _calculateInterestScore(List<String> interests1, List<String> interests2) {
    if (interests1.isEmpty || interests2.isEmpty) return 0.5;

    final set1 = interests1.toSet();
    final set2 = interests2.toSet();
    
    // Coefficient de Jaccard
    final intersection = set1.intersection(set2).length;
    final union = set1.union(set2).length;
    
    final jaccardScore = union > 0 ? intersection / union : 0.0;

    // Bonus pour les catégories similaires
    double categoryBonus = 0.0;
    for (final category in _interestCategories.entries) {
      final cat1 = interests1.where((i) => category.value.contains(i)).length;
      final cat2 = interests2.where((i) => category.value.contains(i)).length;
      if (cat1 > 0 && cat2 > 0) {
        categoryBonus += 0.1;
      }
    }

    return (jaccardScore + categoryBonus.clamp(0.0, 0.3)).clamp(0.0, 1.0);
  }

  /// Calculer la compatibilité de personnalité
  double _calculatePersonalityScore(String personality1, String personality2) {
    if (personality1.isEmpty || personality2.isEmpty) return 0.6;

    // Matrice de compatibilité simplifiée
    const compatibilityMatrix = {
      'adventurous': ['adventurous', 'social', 'spontaneous'],
      'calm': ['calm', 'introverted', 'organized'],
      'creative': ['creative', 'adventurous', 'social'],
      'analytical': ['analytical', 'calm', 'organized'],
      'social': ['social', 'adventurous', 'creative'],
      'introverted': ['introverted', 'calm', 'creative'],
      'ambitious': ['ambitious', 'analytical', 'organized'],
      'laid-back': ['laid-back', 'calm', 'flexible'],
    };

    final compatible = compatibilityMatrix[personality1.toLowerCase()] ?? [];
    if (compatible.contains(personality2.toLowerCase())) {
      return 0.85;
    }
    if (personality1.toLowerCase() == personality2.toLowerCase()) {
      return 0.95;
    }
    return 0.5;
  }

  /// Calculer la compatibilité de style de vie
  double _calculateLifestyleScore(String lifestyle1, String lifestyle2) {
    if (lifestyle1.isEmpty || lifestyle2.isEmpty) return 0.6;

    const compatibilityMatrix = {
      'active': ['active', 'traveler', 'spontaneous'],
      'homebody': ['homebody', 'organized', 'balanced'],
      'traveler': ['traveler', 'active', 'spontaneous'],
      'workaholic': ['workaholic', 'ambitious', 'organized'],
      'balanced': ['balanced', 'flexible', 'homebody'],
      'spontaneous': ['spontaneous', 'active', 'traveler'],
      'organized': ['organized', 'balanced', 'workaholic'],
      'flexible': ['flexible', 'balanced', 'spontaneous'],
    };

    final compatible = compatibilityMatrix[lifestyle1.toLowerCase()] ?? [];
    if (compatible.contains(lifestyle2.toLowerCase())) {
      return 0.85;
    }
    if (lifestyle1.toLowerCase() == lifestyle2.toLowerCase()) {
      return 0.95;
    }
    return 0.5;
  }

  /// Calculer la compatibilité d'âge
  double _calculateAgeCompatibility(int age1, int age2, Map<String, dynamic> preferences) {
    final minAge = preferences['minAge'] ?? (age1 - 10);
    final maxAge = preferences['maxAge'] ?? (age1 + 10);

    if (age2 >= minAge && age2 <= maxAge) {
      // Plus proche de l'âge, meilleur score
      final ageDiff = (age1 - age2).abs();
      return (1.0 - (ageDiff / 20)).clamp(0.5, 1.0);
    }
    return 0.3;
  }

  /// Calculer la similarité des bios (analyse textuelle simplifiée)
  double _calculateBioSimilarity(String bio1, String bio2) {
    if (bio1.isEmpty || bio2.isEmpty) return 0.5;

    final words1 = bio1.toLowerCase().split(RegExp(r'\s+')).toSet();
    final words2 = bio2.toLowerCase().split(RegExp(r'\s+')).toSet();

    // Mots-clés significatifs communs
    final commonWords = words1.intersection(words2);
    final significantWords = commonWords.where((w) => w.length > 3).length;

    return (significantWords / 10).clamp(0.3, 0.9);
  }

  /// Générer les raisons du match
  List<String> _generateMatchReasons(
    double interestScore,
    double personalityScore,
    double lifestyleScore,
    List<String> commonInterests,
  ) {
    final reasons = <String>[];

    if (interestScore > 0.6) {
      reasons.add('Vous partagez ${commonInterests.length} intérêts communs');
    }
    if (personalityScore > 0.7) {
      reasons.add('Vos personnalités sont très compatibles');
    }
    if (lifestyleScore > 0.7) {
      reasons.add('Vos styles de vie s\'harmonisent bien');
    }
    if (commonInterests.isNotEmpty) {
      reasons.add('Vous aimez tous les deux: ${commonInterests.take(3).join(", ")}');
    }

    if (reasons.isEmpty) {
      reasons.add('L\'IA détecte un potentiel de connexion intéressant');
    }

    return reasons;
  }

  /// Générer une suggestion IA personnalisée
  String _generateAISuggestion(
    UserProfile user1,
    UserProfile user2,
    double score,
    List<String> commonInterests,
  ) {
    if (score >= 0.8) {
      if (commonInterests.isNotEmpty) {
        return 'Excellente compatibilité ! Pourquoi ne pas discuter de ${commonInterests.first} pour briser la glace ?';
      }
      return 'Vous semblez très compatibles ! N\'hésitez pas à engager la conversation.';
    } else if (score >= 0.6) {
      return 'Bonne compatibilité détectée. Explorez vos points communs !';
    } else {
      return 'Les opposés s\'attirent parfois ! Découvrez ce qui vous différencie.';
    }
  }

  /// Analyser la compatibilité de personnalité
  String _analyzePersonalityMatch(String p1, String p2) {
    if (p1.isEmpty || p2.isEmpty) return 'Analyse en cours...';
    
    if (p1.toLowerCase() == p2.toLowerCase()) {
      return 'Vous avez des personnalités similaires, ce qui facilite la compréhension mutuelle.';
    }
    return 'Vos personnalités différentes peuvent créer une dynamique enrichissante.';
  }

  /// Analyser la compatibilité de style de vie
  String _analyzeLifestyleMatch(String l1, String l2) {
    if (l1.isEmpty || l2.isEmpty) return 'Analyse en cours...';
    
    if (l1.toLowerCase() == l2.toLowerCase()) {
      return 'Vos styles de vie sont alignés, facilitant le quotidien ensemble.';
    }
    return 'Vos styles de vie différents peuvent apporter équilibre et nouvelles perspectives.';
  }

  /// Trier les profils par score de compatibilité
  Future<List<AIMatchResult>> rankProfiles(
    UserProfile currentUser,
    List<UserProfile> potentialMatches,
  ) async {
    final results = <AIMatchResult>[];
    
    for (final match in potentialMatches) {
      final result = await calculateCompatibility(currentUser, match);
      results.add(result);
    }

    // Trier par score décroissant
    results.sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));
    
    return results;
  }

  /// Obtenir les suggestions IA pour améliorer le profil
  List<String> getProfileSuggestions(UserProfile profile) {
    final suggestions = <String>[];

    if (profile.interests.length < 3) {
      suggestions.add('Ajoutez plus d\'intérêts pour améliorer vos matchs');
    }
    if (profile.bio.length < 50) {
      suggestions.add('Une bio plus détaillée attire plus de profils compatibles');
    }
    if (profile.personality.isEmpty) {
      suggestions.add('Définissez votre type de personnalité pour des matchs plus précis');
    }
    if (profile.lifestyle.isEmpty) {
      suggestions.add('Indiquez votre style de vie pour trouver des personnes similaires');
    }

    return suggestions;
  }
}
