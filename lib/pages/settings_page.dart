import 'package:flutter/material.dart';
import 'package:maid/model.dart';
import 'package:maid/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _openFileDialog() async {
    String ret = await model.openFile();
    // Use a local reference to context to avoid using it across an async gap.
    final localContext = context;
    // Ensure that the context is still valid before attempting to show the dialog.
    if (localContext.mounted) {
      showDialog(
        context: localContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(ret),
            alignment: Alignment.center,
            actionsAlignment: MainAxisAlignment.center,
            backgroundColor: Theme.of(context).colorScheme.background,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            actions: [
              FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          );
        },
      );
      model.saveAll();
      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            Text(
              model.modelName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: _openFileDialog,
                  child: const Text(
                    "Load Model",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                FilledButton(
                  onPressed: () {
                    model.resetAll(setState);
                  },
                  child: const Text(
                    "Reset All",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            llamaParamTextField(
              'User alias', model.userAliasController),
            llamaParamTextField(
              'Response alias', model.responseAliasController),
            ListTile(
              title: Row(
                children: [
                  const Expanded(
                    child: Text('PrePrompt'),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: model.prePromptController,
                      decoration: roundedInput('PrePrompt', context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {
                    setState(() {
                      model.examplePromptControllers.add(TextEditingController());
                      model.exampleResponseControllers.add(TextEditingController());
                    });
                  },
                  child: const Text(
                    "Add Example",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      model.examplePromptControllers.removeLast();
                      model.exampleResponseControllers.removeLast();
                    });
                  },
                  child: const Text(
                    "Remove Example",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            ...List.generate(
              (model.examplePromptControllers.length == model.exampleResponseControllers.length) ? model.examplePromptControllers.length : 0,
              (index) => Column(
                children: [
                  llamaParamTextField('Example prompt', model.examplePromptControllers[index]),
                  llamaParamTextField('Example response', model.exampleResponseControllers[index]),
                ],
              ),
            ),
            llamaParamSwitch(
              'memory_f16', model.memory_f16),
            llamaParamSwitch(
              'random_prompt', model.random_prompt),
            llamaParamSwitch(
              'interactive', model.interactive),
            llamaParamSwitch(
              'interactive_start', model.interactive_start),
            llamaParamSwitch(
              'instruct (Chat4all and Alpaca)', model.instruct),
            llamaParamSwitch(
              'ignore_eos', model.ignore_eos),
            llamaParamSwitch(
              'perplexity', model.perplexity),
            const SizedBox(height: 15.0),
            llamaParamTextField(
              'seed (-1 for random)', model.seedController),
            llamaParamTextField(
              'n_threads', model.n_threadsController),
            llamaParamTextField(
              'n_predict', model.n_predictController),
            llamaParamTextField(
              'repeat_last_n', model.repeat_last_nController),
            llamaParamTextField(
              'n_parts (-1 for auto)', model.n_partsController),
            llamaParamTextField(
              'n_ctx', model.n_ctxController),
            llamaParamTextField(
              'top_k', model.top_kController),
            llamaParamTextField(
              'top_p', model.top_pController),
            llamaParamTextField(
              'temp', model.tempController),
            llamaParamTextField(
              'repeat_penalty', model.repeat_penaltyController),
            llamaParamTextField(
              'batch_size', model.n_batchController),
          ],
        ),
      )
    );
  }

  Widget llamaParamTextField(String labelText, TextEditingController controller) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(labelText),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: controller,
              decoration: roundedInput(labelText, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget llamaParamSwitch(String title, bool initialValue) {
    return SwitchListTile(
      title: Text(title),
      value: initialValue,
      onChanged: (value) {
        setState(() {
          switch (title) {
            case 'memory_f16':
              model.memory_f16 = value;
              break;
            case 'random_prompt':
              model.random_prompt = value;
              break;
            case 'interactive':
              model.interactive = value;
              break;
            case 'interactive_start':
              model.interactive_start = value;
              break;
            case 'instruct':
              model.instruct = value;
              break;
            case 'ignore_eos':
              model.ignore_eos = value;
              break;
            case 'perplexity':
              model.perplexity = value;
              break;
            default:
              break;
          }
          model.saveBoolToSharedPrefs(title, value);
        });
      },
    );
  }
}

