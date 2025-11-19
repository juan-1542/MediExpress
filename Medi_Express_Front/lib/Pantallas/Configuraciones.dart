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
      appBar: AppBar(
        title: Text(t?.settingsTitle ?? 'Configuraciones'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            t?.languageSectionTitle ?? 'Idioma / Language',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF123A5A)),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                RadioListTile<Locale?>(
                  value: null,
                  groupValue: _selected,
                  title: Text(t?.useSystemLanguage ?? 'Usar idioma del sistema'),
                  onChanged: _changeLocale,
                ),
                const Divider(height: 0),
                RadioListTile<Locale?>(
                  value: const Locale('es'),
                  groupValue: _selected,
                  title: Text(t?.spanishLabel ?? 'Español'),
                  onChanged: _changeLocale,
                ),
                const Divider(height: 0),
                RadioListTile<Locale?>(
                  value: const Locale('en'),
                  groupValue: _selected,
                  title: Text(t?.englishLabel ?? 'English'),
                  onChanged: _changeLocale,
                ),
                const Divider(height: 0),
                RadioListTile<Locale?>(
                  value: const Locale('pt'),
                  groupValue: _selected,
                  title: Text(t?.portugueseLabel ?? 'Português'),
                  onChanged: _changeLocale,
                ),
                const Divider(height: 0),
                RadioListTile<Locale?>(
                  value: const Locale('fr'),
                  groupValue: _selected,
                  title: Text(t?.frenchLabel ?? 'Français'),
                  onChanged: _changeLocale,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check),
              label: Text(t?.commonOk ?? 'OK'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
