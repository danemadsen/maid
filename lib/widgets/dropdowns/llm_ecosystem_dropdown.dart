part of 'package:maid/main.dart';

class LlmEcosystemDropdown extends StatefulWidget {
  const LlmEcosystemDropdown({super.key});

  @override
  State<LlmEcosystemDropdown> createState() => _LlmEcosystemDropdownState();
}

class _LlmEcosystemDropdownState extends State<LlmEcosystemDropdown> {
  bool open = false;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      buildTitle(),
      buildDropDownRow()
    ]
  );

  Widget buildTitle() => Text(
    'Llm Ecosystem',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 16
    )
  );

  Widget buildDropDownRow() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(width: 8),
      Selector<ArtificialIntelligence, LlmEcosystem>(
        selector: (context, settings) => settings.ecosystem,
        builder: buildOverrideText
      ),
      buildPopupButton()
    ]
  );

  Widget buildOverrideText(BuildContext context, LlmEcosystem ecosystem, Widget? child) => Text(
    ecosystem.name.titleize,
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 16
    )
  );

  Widget buildPopupButton() => PopupMenuButton<LlmEcosystem>(
    tooltip: 'Select Llm Ecosystem',
    icon: Icon(
      open ? Icons.arrow_drop_up : Icons.arrow_drop_down,
      color: Theme.of(context).colorScheme.onSurface,
      size: 24,
    ),
    offset: const Offset(0, 40),
    itemBuilder: itemBuilder,
    onOpened: () => setState(() => open = true),
    onCanceled: () => setState(() => open = false),
    onSelected: (ecosystem) {
      ArtificialIntelligence.of(context).ecosystem = ecosystem;
      setState(() => open = false);
    }
  );

  List<PopupMenuEntry<LlmEcosystem>> itemBuilder(BuildContext context) => [
    PopupMenuItem(
      padding: EdgeInsets.all(8),
      value: LlmEcosystem.llamaCPP,
      child: const Text('LlamaCpp')
    ),
    PopupMenuItem(
      padding: EdgeInsets.all(8),
      value: LlmEcosystem.ollama,
      child: const Text('Ollama')
    ),
    PopupMenuItem(
      padding: EdgeInsets.all(8),
      value: LlmEcosystem.openAI,
      child: const Text('Open AI')
    )
  ];
}