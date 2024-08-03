import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maid/classes/providers/app_data.dart';
import 'package:maid/classes/providers/large_language_model.dart';
import 'package:maid/ui/mobile/layout/model_settings_app_bar.dart';
import 'package:maid/ui/mobile/parameter_widgets/api_key_parameter.dart';
import 'package:maid/ui/mobile/parameter_widgets/n_predict_parameter.dart';
import 'package:maid/ui/mobile/parameter_widgets/temperature_parameter.dart';
import 'package:maid/ui/mobile/parameter_widgets/top_k_parameter.dart';
import 'package:maid/ui/mobile/parameter_widgets/top_p_parameter.dart';
import 'package:maid/ui/shared/utilities/session_busy_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleGeminiPage extends StatelessWidget {
  const GoogleGeminiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ModelSettingsAppBar(title: "Google Gemini Parameters"),
      body: SessionBusyOverlay(
        child: Selector<AppData, LargeLanguageModel>(
          selector: (context, appData) => appData.model,
          builder: listViewBuilder
        ),
      )
    );
  }

  Widget listViewBuilder(BuildContext context, LargeLanguageModel model, Widget? child) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("google_gemini_model", json.encode(model.toMap()));
    });

    return ListView(
      children: [
        const ApiKeyParameter(),
        Divider(
          height: 20,
          indent: 10,
          endIndent: 10,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 20.0),
        const NPredictParameter(),
        const TopPParameter(),
        const TopKParameter(),
        const TemperatureParameter(),
      ]
    );
  }
}
