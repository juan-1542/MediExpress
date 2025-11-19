import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/locale_service.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';

class ConfiguracionesScreen extends StatefulWidget {
  const ConfiguracionesScreen({super.key});

  @override
  State<ConfiguracionesScreen> createState() => _ConfiguracionesScreenState();
}

class _ConfiguracionesScreenState extends State<ConfiguracionesScreen> {
  Locale? _selected;

  @override
  void initState() {
    super.initState();
    _selected = LocaleService.instance.locale.value;
  }

  void _changeLocale(Locale? locale) {
    setState(() => _selected = locale);
    LocaleService.instance.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 41, 87, 212), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.settings, color: Colors.white.withValues(alpha: 0.9), size: 24),
                    SizedBox(width: 8),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.white, Color(0xFFF0F8FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(t?.settingsTitle ?? 'Configuraciones',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ])),
                    ),
                  ],
                ),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white.withValues(alpha: 0.9), Colors.white.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(t?.languageSectionTitle ?? 'Idioma / Language',
                      style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FBFF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // Título con diseño moderno
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEEF7FF), Color(0xFFDCEEFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF4A90E2).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(Icons.language, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t?.languageSectionTitle ?? 'Idioma / Language',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF123A5A),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          t?.languageSubtitle ?? 'Selecciona tu idioma preferido',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Opciones de idioma con animación
            _buildLanguageOption(
              context: context,
              locale: null,
              icon: Icons.devices,
              title: t?.useSystemLanguage ?? 'Usar idioma del sistema',
              subtitle: t?.systemLanguageSubtitle ?? 'Detectar automáticamente',
              index: 0,
            ),
            _buildLanguageOption(
              context: context,
              locale: const Locale('es'),
              icon: Icons.flag,
              flag: '🇪🇸',
              title: t?.spanishLabel ?? 'Español',
              subtitle: 'Spanish',
              index: 1,
            ),
            _buildLanguageOption(
              context: context,
              locale: const Locale('en'),
              icon: Icons.flag,
              flag: '🇬🇧',
              title: t?.englishLabel ?? 'English',
              subtitle: 'Inglés',
              index: 2,
            ),
            _buildLanguageOption(
              context: context,
              locale: const Locale('pt'),
              icon: Icons.flag,
              flag: '🇧🇷',
              title: t?.portugueseLabel ?? 'Português',
              subtitle: 'Portuguese',
              index: 3,
            ),
            _buildLanguageOption(
              context: context,
              locale: const Locale('fr'),
              icon: Icons.flag,
              flag: '🇫🇷',
              title: t?.frenchLabel ?? 'Français',
              subtitle: 'French',
              index: 4,
            ),
            _buildLanguageOption(
              context: context,
              locale: const Locale('ja'),
              icon: Icons.flag,
              flag: '🇯🇵',
              title: t?.japaneseLabel ?? '日本語',
              subtitle: 'Japanese',
              index: 5,
            ),
            const SizedBox(height: 32),
            // Botón de confirmación moderno
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, v, child) {
                return Opacity(
                  opacity: v,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - v)),
                    child: child,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF4A90E2).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.white, size: 24),
                          SizedBox(width: 12),
                          Text(
                            t?.commonOk ?? 'Aplicar cambios',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required Locale? locale,
    required IconData icon,
    String? flag,
    required String title,
    required String subtitle,
    required int index,
  }) {
    final isSelected = _selected == locale;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) {
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - v)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Color(0xFFEEF7FF), Color(0xFFDCEEFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.white, Colors.white],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color(0xFF4A90E2) : Colors.grey.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Color(0xFF4A90E2).withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: isSelected ? 12 : 8,
              offset: Offset(0, isSelected ? 6 : 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _changeLocale(locale),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icono o bandera
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [Color(0xFFF0F0F0), Color(0xFFE0E0E0)],
                            ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: flag != null
                          ? Text(flag, style: TextStyle(fontSize: 24))
                          : Icon(
                              icon,
                              color: isSelected ? Colors.white : Colors.grey[600],
                              size: 24,
                            ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Color(0xFF123A5A) : Color(0xFF123A5A),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Radio indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Color(0xFF4A90E2) : Colors.grey[400]!,
                        width: 2,
                      ),
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                            )
                          : null,
                    ),
                    child: isSelected
                        ? Center(
                            child: Icon(Icons.check, color: Colors.white, size: 16),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
