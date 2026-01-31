import 'package:dating_app/core/constants/app_colors.dart';
import 'package:dating_app/core/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.tr('profile')),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context, localization),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Photo de profil
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFE3C72),
                      width: 3,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=500',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFE3C72),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Nom et âge
            const Text(
              'Alex Martin, 28',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Paris, France',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Badge vérifié
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified, color: Colors.blue, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    localization.tr('verified'),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bouton modifier le profil
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: Text(localization.tr('edit_profile')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFE3C72),
                  side: const BorderSide(color: Color(0xFFFE3C72)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Section À propos
            _buildSection(
              title: localization.tr('about_me'),
              icon: Icons.person,
              child: Text(
                localization.currentLanguage == AppLanguage.french
                    ? 'Passionné de voyages et de photographie. J\'aime découvrir de nouvelles cultures et capturer des moments uniques. Toujours partant pour une aventure !'
                    : 'Passionate about travel and photography. I love discovering new cultures and capturing unique moments. Always up for an adventure!',
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),
            const SizedBox(height: 16),

            // Section Intérêts
            _buildSection(
              title: localization.tr('interests'),
              icon: Icons.favorite,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Travel',
                  'Photography',
                  'Coffee',
                  'Music',
                  'Art',
                  'Hiking',
                  'Reading',
                ].map((interest) => Chip(
                  label: Text(interest),
                  backgroundColor: const Color(0xFFFE3C72).withOpacity(0.1),
                  labelStyle: const TextStyle(color: Color(0xFFFE3C72)),
                )).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Section Je recherche
            _buildSection(
              title: localization.tr('looking_for'),
              icon: Icons.search,
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Color(0xFFFE3C72), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    localization.currentLanguage == AppLanguage.french
                        ? 'Une relation sérieuse'
                        : 'A serious relationship',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Section Langue
            _buildSection(
              title: localization.tr('language'),
              icon: Icons.language,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        localization.currentLanguage.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        localization.currentLanguage.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => localization.toggleLanguage(),
                    child: Text(
                      localization.currentLanguage == AppLanguage.french
                          ? 'Switch to English'
                          : 'Passer en français',
                      style: const TextStyle(color: Color(0xFFFE3C72)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Statistiques
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(
                  value: '156',
                  label: localization.tr('matches'),
                  icon: Icons.favorite,
                ),
                _buildStatCard(
                  value: '42',
                  label: localization.tr('messages'),
                  icon: Icons.message,
                ),
                _buildStatCard(
                  value: '89%',
                  label: 'Score IA',
                  icon: Icons.auto_awesome,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Bouton Premium
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFE3C72), Colors.purple],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium, color: Colors.white, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    localization.tr('go_premium'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localization.currentLanguage == AppLanguage.french
                        ? 'Débloquez toutes les fonctionnalités'
                        : 'Unlock all features',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFE3C72),
                    ),
                    child: Text(localization.tr('subscribe_now')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bouton déconnexion
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.red),
              label: Text(
                localization.tr('logout'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFFFE3C72)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFE3C72), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, LocalizationManager localization) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              localization.tr('settings'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Sélecteur de langue
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(localization.tr('language')),
              trailing: LanguageSelector(
                localizationManager: localization,
                showFlag: true,
                showName: true,
              ),
            ),
            const Divider(),
            
            // Notifications
            ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(localization.tr('notifications')),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: const Color(0xFFFE3C72),
              ),
            ),
            const Divider(),
            
            // Mode sombre
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Text(localization.tr('dark_mode')),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                activeColor: const Color(0xFFFE3C72),
              ),
            ),
            const Divider(),
            
            // Confidentialité
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: Text(localization.tr('privacy')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(),
            
            // Aide
            ListTile(
              leading: const Icon(Icons.help),
              title: Text(localization.tr('help_support')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
