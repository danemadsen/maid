  
import 'package:flutter/material.dart';
import 'package:maid/classes/providers/large_language_model.dart';
import 'package:maid/classes/providers/app_data.dart';

void storageOperationDialog(BuildContext context, Future<String> Function() storageFunction) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<String>(
        future: storageFunction(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AlertDialog(
              title: Text(
                snapshot.data!,
                textAlign: TextAlign.center
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                FilledButton(
                  onPressed: () {
                    AppData.of(context).notify();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Close",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            );
          } else {
            return const AlertDialog(
              title: Text(
                "Storage Operation Pending",
                textAlign: TextAlign.center
              ),
              content: Center(
                heightFactor: 1.0,
                child: CircularProgressIndicator(),
              )
            );
          }
        },
      );
    },
  );
}

void showMissingRequirementsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Missing Requirements",
          textAlign: TextAlign.center
        ),
        actionsAlignment: MainAxisAlignment.center,
        content: Text(
          LargeLanguageModel.of(context).missingRequirements.join()
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "OK",
              style: Theme.of(context).textTheme.labelLarge
            ),
          ),
        ],
      );
    },
  );
}