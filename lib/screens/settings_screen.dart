import 'package:flutter/material.dart';
import '../widgets/app_colors.dart';
import '../data/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settings = SettingsProvider();

  @override
  Widget build(BuildContext context) {
    final dark = _settings.darkMode;
    final bgColor = dark ? const Color(0xFF1A1A2E) : AppColors.bg;
    final cardColor = dark ? const Color(0xFF16213E) : AppColors.card;
    final textColor = dark ? Colors.white : AppColors.txt;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionTitle('المظهر', textColor),
                _buildCard(cardColor, [
                  _switchTile(
                    icon: Icons.dark_mode_rounded,
                    title: 'الوضع الداكن',
                    subtitle: 'تغيير مظهر التطبيق للداكن',
                    value: _settings.darkMode,
                    textColor: textColor,
                    onChanged: (v) async {
                      await _settings.setDarkMode(v);
                      setState(() {});
                    },
                  ),
                ]),
                const SizedBox(height: 16),
                _sectionTitle('حجم الخط', textColor),
                _buildCard(cardColor, [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                          style: TextStyle(
                            fontFamily: 'Hafs',
                            fontSize: _settings.fontSize,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.text_decrease, color: AppColors.primary, size: 18),
                            Expanded(
                              child: Slider(
                                value: _settings.fontSize,
                                min: 16,
                                max: 36,
                                divisions: 10,
                                activeColor: AppColors.primary,
                                onChanged: (v) async {
                                  await _settings.setFontSize(v);
                                  setState(() {});
                                },
                              ),
                            ),
                            const Icon(Icons.text_increase, color: AppColors.primary, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                _sectionTitle('عن التطبيق', textColor),
                _buildCard(cardColor, [
                  _infoTile(Icons.info_outline_rounded, 'الإصدار', '1.0.0', textColor),
                  _divider(),
                  _infoTile(Icons.book_rounded, 'المصدر', 'API القرآن الكريم', textColor),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 12),
              const Text('الإعدادات',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Tajawal')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color textColor) => Padding(
    padding: const EdgeInsets.only(bottom: 8, right: 4),
    child: Text(title,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textColor.withOpacity(0.5), fontFamily: 'Tajawal')),
  );

  Widget _buildCard(Color color, List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.07), blurRadius: 8, offset: const Offset(0,2))],
    ),
    child: Column(children: children),
  );

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color textColor,
    required ValueChanged<bool> onChanged,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor, fontFamily: 'Tajawal')),
              Text(subtitle, style: TextStyle(fontSize: 11, color: textColor.withOpacity(0.5), fontFamily: 'Tajawal')),
            ],
          ),
        ),
        Switch(activeColor: AppColors.primary, value: value, onChanged: onChanged),
      ],
    ),
  );

  Widget _infoTile(IconData icon, String title, String value, Color textColor) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor, fontFamily: 'Tajawal'))),
        Text(value, style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.5), fontFamily: 'Tajawal')),
      ],
    ),
  );

  Widget _divider() => Divider(height: 1, indent: 64, color: AppColors.primary.withOpacity(0.08));
}
