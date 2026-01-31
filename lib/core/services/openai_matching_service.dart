import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_matching_service.dart';

/// Service de matching IA avancé utilisant l'API OpenAI
/// Ce service peut être utilisé pour des analyses plus sophistiquées
class OpenAIMatchingService {
  final String? apiKey;
  final String baseUrl;
  
  OpenAIMatchingService({
    this.apiKey,
    this.baseUrl = 'https://api.openai.com/v1',
  });

  /// Analyser la compatibilité entre deux profils avec GPT
  Future<AIMatchResult> analyzeCompatibilityWithAI(
    UserProfile user1,
    UserProfile user2,
  ) async {
    // Si pas de clé API, utiliser l'algorithme local
    if (apiKey == null || apiKey!.isEmpty) {
      final localService = AIMatchingService();
      return localService.calculateCompatibility(user1, user2);
    }

    try {
      final prompt = _buildCompatibilityPrompt(user1, user2);
      final response = await _callOpenAI(prompt);
      return _parseAIResponse(response, user2.id);
    } catch (e) {
      // Fallback vers l'algorithme local en cas d'erreur
      final localService = AIMatchingService();
      return localService.calculateCompatibility(user1, user2);
    }
  }

  /// Générer des suggestions de conversation basées sur les profils
  Future<List<String>> generateConversationStarters(
    UserProfile user1,
    UserProfile user2,
    String language,
  ) async {
    if (apiKey == null || apiKey!.isEmpty) {
      return _getDefaultConversationStarters(user1, user2, language);
    }

    try {
      final prompt = _buildConversationPrompt(user1, user2, language);
      final response = await _callOpenAI(prompt);
      return _parseConversationStarters(response);
    } catch (e) {
      return _getDefaultConversationStarters(user1, user2, language);
    }
  }

  /// Analyser la personnalité basée sur la bio
  Future<Map<String, dynamic>> analyzePersonality(
    String bio,
    List<String> interests,
    String language,
  ) async {
    if (apiKey == null || apiKey!.isEmpty) {
      return _getDefaultPersonalityAnalysis(interests, language);
    }

    try {
      final prompt = _buildPersonalityPrompt(bio, interests, language);
      final response = await _callOpenAI(prompt);
      return _parsePersonalityAnalysis(response);
    } catch (e) {
      return _getDefaultPersonalityAnalysis(interests, language);
    }
  }

  /// Construire le prompt pour l'analyse de compatibilité
  String _buildCompatibilityPrompt(UserProfile user1, UserProfile user2) {
    return '''
Analyze the compatibility between these two dating profiles and provide a JSON response.

Profile 1:
- Age: ${user1.age}
- Bio: ${user1.bio}
- Interests: ${user1.interests.join(', ')}
- Personality: ${user1.personality}
- Lifestyle: ${user1.lifestyle}
- Looking for: ${user1.lookingFor}

Profile 2:
- Age: ${user2.age}
- Bio: ${user2.bio}
- Interests: ${user2.interests.join(', ')}
- Personality: ${user2.personality}
- Lifestyle: ${user2.lifestyle}

Respond with a JSON object containing:
{
  "compatibilityScore": (0.0 to 1.0),
  "commonInterests": ["list", "of", "common", "interests"],
  "personalityAnalysis": "Brief analysis of personality compatibility",
  "lifestyleCompatibility": "Brief analysis of lifestyle compatibility",
  "matchReasons": ["reason1", "reason2", "reason3"],
  "aiSuggestion": "A personalized suggestion for starting a conversation"
}
''';
  }

  /// Construire le prompt pour les suggestions de conversation
  String _buildConversationPrompt(UserProfile user1, UserProfile user2, String language) {
    final langInstruction = language == 'fr' 
        ? 'Respond in French.' 
        : 'Respond in English.';
    
    return '''
Generate 5 conversation starters for a dating app based on these profiles.
$langInstruction

User's interests: ${user1.interests.join(', ')}
Match's interests: ${user2.interests.join(', ')}
Match's bio: ${user2.bio}

Provide creative, engaging, and respectful conversation starters as a JSON array of strings.
''';
  }

  /// Construire le prompt pour l'analyse de personnalité
  String _buildPersonalityPrompt(String bio, List<String> interests, String language) {
    final langInstruction = language == 'fr' 
        ? 'Respond in French.' 
        : 'Respond in English.';
    
    return '''
Analyze this dating profile and provide personality insights.
$langInstruction

Bio: $bio
Interests: ${interests.join(', ')}

Respond with a JSON object containing:
{
  "personalityType": "one word description",
  "traits": ["trait1", "trait2", "trait3"],
  "compatibleWith": ["type1", "type2"],
  "summary": "Brief personality summary"
}
''';
  }

  /// Appeler l'API OpenAI
  Future<String> _callOpenAI(String prompt) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4.1-mini',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a helpful dating app assistant that analyzes profiles and provides compatibility insights. Always respond with valid JSON.'
          },
          {
            'role': 'user',
            'content': prompt
          }
        ],
        'temperature': 0.7,
        'max_tokens': 500,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('OpenAI API error: ${response.statusCode}');
    }
  }

  /// Parser la réponse IA pour le matching
  AIMatchResult _parseAIResponse(String response, String matchedUserId) {
    try {
      final data = jsonDecode(response);
      return AIMatchResult(
        matchedUserId: matchedUserId,
        compatibilityScore: (data['compatibilityScore'] as num).toDouble(),
        commonInterests: List<String>.from(data['commonInterests'] ?? []),
        personalityAnalysis: data['personalityAnalysis'] ?? '',
        lifestyleCompatibility: data['lifestyleCompatibility'] ?? '',
        matchReasons: List<String>.from(data['matchReasons'] ?? []),
        aiSuggestion: data['aiSuggestion'] ?? '',
      );
    } catch (e) {
      // Retourner un résultat par défaut en cas d'erreur de parsing
      return AIMatchResult(
        matchedUserId: matchedUserId,
        compatibilityScore: 0.7,
        commonInterests: [],
        personalityAnalysis: 'Analysis unavailable',
        lifestyleCompatibility: 'Analysis unavailable',
        matchReasons: ['Potential connection detected'],
        aiSuggestion: 'Start with a friendly hello!',
      );
    }
  }

  /// Parser les suggestions de conversation
  List<String> _parseConversationStarters(String response) {
    try {
      final data = jsonDecode(response);
      if (data is List) {
        return List<String>.from(data);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Parser l'analyse de personnalité
  Map<String, dynamic> _parsePersonalityAnalysis(String response) {
    try {
      return jsonDecode(response);
    } catch (e) {
      return {};
    }
  }

  /// Suggestions de conversation par défaut
  List<String> _getDefaultConversationStarters(
    UserProfile user1,
    UserProfile user2,
    String language,
  ) {
    final commonInterests = user1.interests
        .where((i) => user2.interests.contains(i))
        .toList();

    if (language == 'fr') {
      if (commonInterests.isNotEmpty) {
        return [
          'Salut ! J\'ai vu que tu aimes aussi ${commonInterests.first}. Qu\'est-ce qui te passionne le plus ?',
          'Hey ! On dirait qu\'on a des goûts similaires. Tu pratiques ${commonInterests.first} depuis longtemps ?',
          'Coucou ! J\'adore ton profil. Tu as un endroit préféré pour ${commonInterests.first} ?',
        ];
      }
      return [
        'Salut ! Ton profil m\'a intrigué. Qu\'est-ce qui te passionne en ce moment ?',
        'Hey ! J\'aimerais en savoir plus sur toi. Quel est ton meilleur souvenir récent ?',
        'Coucou ! Si tu pouvais voyager n\'importe où demain, où irais-tu ?',
      ];
    } else {
      if (commonInterests.isNotEmpty) {
        return [
          'Hi! I noticed you\'re also into ${commonInterests.first}. What do you enjoy most about it?',
          'Hey! Looks like we have similar interests. How long have you been into ${commonInterests.first}?',
          'Hello! Love your profile. Do you have a favorite spot for ${commonInterests.first}?',
        ];
      }
      return [
        'Hi! Your profile caught my attention. What are you passionate about right now?',
        'Hey! I\'d love to know more about you. What\'s your best recent memory?',
        'Hello! If you could travel anywhere tomorrow, where would you go?',
      ];
    }
  }

  /// Analyse de personnalité par défaut
  Map<String, dynamic> _getDefaultPersonalityAnalysis(
    List<String> interests,
    String language,
  ) {
    String personalityType = 'balanced';
    List<String> traits = [];
    
    // Déterminer le type basé sur les intérêts
    final creativeInterests = ['Art', 'Music', 'Photography', 'Writing', 'Design'];
    final outdoorInterests = ['Hiking', 'Travel', 'Sports', 'Fitness', 'Camping'];
    final intellectualInterests = ['Reading', 'Tech', 'Science', 'History'];
    
    int creativeCount = interests.where((i) => creativeInterests.contains(i)).length;
    int outdoorCount = interests.where((i) => outdoorInterests.contains(i)).length;
    int intellectualCount = interests.where((i) => intellectualInterests.contains(i)).length;

    if (creativeCount > outdoorCount && creativeCount > intellectualCount) {
      personalityType = language == 'fr' ? 'créatif' : 'creative';
      traits = language == 'fr' 
          ? ['Artistique', 'Imaginatif', 'Expressif']
          : ['Artistic', 'Imaginative', 'Expressive'];
    } else if (outdoorCount > creativeCount && outdoorCount > intellectualCount) {
      personalityType = language == 'fr' ? 'aventurier' : 'adventurous';
      traits = language == 'fr'
          ? ['Actif', 'Énergique', 'Curieux']
          : ['Active', 'Energetic', 'Curious'];
    } else if (intellectualCount > creativeCount && intellectualCount > outdoorCount) {
      personalityType = language == 'fr' ? 'intellectuel' : 'intellectual';
      traits = language == 'fr'
          ? ['Réfléchi', 'Analytique', 'Curieux']
          : ['Thoughtful', 'Analytical', 'Curious'];
    } else {
      personalityType = language == 'fr' ? 'équilibré' : 'balanced';
      traits = language == 'fr'
          ? ['Polyvalent', 'Adaptable', 'Ouvert']
          : ['Versatile', 'Adaptable', 'Open-minded'];
    }

    return {
      'personalityType': personalityType,
      'traits': traits,
      'compatibleWith': language == 'fr'
          ? ['Créatif', 'Aventurier', 'Équilibré']
          : ['Creative', 'Adventurous', 'Balanced'],
      'summary': language == 'fr'
          ? 'Une personnalité $personalityType avec des intérêts variés.'
          : 'A $personalityType personality with varied interests.',
    };
  }
}
