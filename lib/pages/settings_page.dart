import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maid/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maid/lib.dart';
import 'package:system_info_plus/system_info_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void testFileExisting() async {
    if (Platform.isIOS) {
      (await SharedPreferences.getInstance()).remove('path');
    }

    if (model.modelPath != "" && await File(model.modelPath).exists()) {
      setState(() {
        model.fileState = FileState.found;
      });
    } else {
      setState(() {
        model.fileState = FileState.notFound;
      });
    }
  }

  @override
  initState() {
    super.initState();
    testFileExisting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade900,  // Set a solid color here
          ),
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Row>(
                future: ramDisplay(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else if (snapshot.hasError) {
                      return const Text('Error displaying RAM');
                    }
                  }
                  return const SizedBox.shrink();
                },
            ),
            const SizedBox(height: 10.0),
            Text(model.modelName),
            ElevatedButton(
              onPressed: () {
                model.openFile();
              },
              child: const Text(
                "Load Model",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
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
            const SizedBox(height: 15.0),
            llamaParamTextField(
              'User alias:', model.userAliasController, 'User alias'),
            llamaParamTextField(
              'Response alias:', model.responseAliasController, 'Response alias'),
            ListTile(
              title: const Text('PrePrompt:'),
              subtitle: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: model.prePromptController,
                decoration: const InputDecoration(
                  hintText: 'PrePrompt',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
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
                ElevatedButton(
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
            ...List.generate(
              (model.examplePromptControllers.length == model.exampleResponseControllers.length) ? model.examplePromptControllers.length : 0,
              (index) => Column(
                children: [
                  llamaParamTextField('Example prompt:', model.examplePromptControllers[index], 'Example prompt'),
                  llamaParamTextField('Example response:', model.exampleResponseControllers[index], 'Example response'),
                ],
              ),
            ),
            llamaParamSwitch(
              'memory_f16:', model.memory_f16, 'memory_f16'),
            llamaParamSwitch(
              'random_prompt:', model.random_prompt, 'random_prompt'),
            llamaParamSwitch(
              'interactive:', model.interactive, 'interactive'),
            llamaParamSwitch(
              'interactive_start:', model.interactive_start, 'interactive_start'),
            llamaParamSwitch(
              'instruct (Chat4all and Alpaca):', model.instruct, 'instruct'),
            llamaParamSwitch(
              'ignore_eos:', model.ignore_eos, 'ignore_eos'),
            llamaParamSwitch(
              'perplexity:', model.perplexity, 'perplexity'),
            const SizedBox(height: 15.0),
            llamaParamTextField(
              'seed (-1 for random):', model.seedController, 'seed'),
            llamaParamTextField(
              'n_threads:', model.n_threadsController, 'n_threads'),
            llamaParamTextField(
              'n_predict:', model.n_predictController, 'n_predict'),
            llamaParamTextField(
              'repeat_last_n:', model.repeat_last_nController, 'repeat_last_n'),
            llamaParamTextField(
              'n_parts (-1 for auto):', model.n_partsController, 'n_parts'),
            llamaParamTextField(
              'n_ctx:', model.n_ctxController, 'n_ctx'),
            llamaParamTextField(
              'top_k:', model.top_kController, 'top_k'),
            llamaParamTextField(
              'top_p:', model.top_pController, 'top_p'),
            llamaParamTextField(
              'temp:', model.tempController, 'temp'),
            llamaParamTextField(
              'repeat_penalty:', model.repeat_penaltyController, 'repeat_penalty'),
            llamaParamTextField(
              'batch_size:', model.n_batchController, 'batch_size'),
          ],
        ),
      )
    );
  }

  Widget llamaParamTextField(String labelText, TextEditingController controller, String hintText) {
    return ListTile(
      title: Text(labelText),
      subtitle: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    );
  }

  Widget llamaParamSwitch(String title, bool initialValue, String key) {
    return SwitchListTile(
      title: Text(title),
      value: initialValue,
      onChanged: (value) {
        setState(() {
          switch (key) {
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
          model.saveBoolToSharedPrefs(key, value);
        });
      },
    );
  }

  Future<Row> ramDisplay() async {
    String ram = "\nCalculating...";
    Color color = Colors.black;
    
    try {
      if (Platform.isWindows == false) {
        int? deviceMemory = await SystemInfoPlus.physicalMemory;
        int deviceMemoryGB = (deviceMemory ?? 0) ~/ 1024 + 1;

        setState(() {
          ram = "${deviceMemoryGB}GB";
          if (deviceMemoryGB <= 6) {
            ram += " (WARNING ! May not be enough)";
          } else {
            ram += " (Should be enough)";
          }
          color = deviceMemoryGB > 6
              ? Colors.green
              : deviceMemoryGB > 4
                  ? Colors.orange
                  : Colors.red;
        });
      } else {
        setState(() {
          ram = " Can't get RAM on Windows";
          color = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        ram = " Can't get RAM";
        color = Colors.red;
      });
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("RAM: "),
        Text(
          ram,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
