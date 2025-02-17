part of 'package:maid/main.dart';

extension OllamaExtension on ArtificialIntelligence {
  Stream<String> ollamaPrompt(List<ChatMessage> messages) async* {
    assert(_model[LlmEcosystem.ollama] != null);

    _ollamaClient = OllamaClient(baseUrl: "$ollamaUrl/api");

    final completionStream = _ollamaClient.generateChatCompletionStream(
      request: GenerateChatCompletionRequest(
        model: _model[LlmEcosystem.ollama]!, 
        messages: messages.toOllamaMessages(),
        options: RequestOptions.fromJson(overrides),
        stream: true
      )
    );

    await for (final completion in completionStream) {
      yield completion.message.content;
    }
  }
  
  Future<Uri?> checkForOllama(Uri url) async {
    try {
      final request = http.Request("GET", url);
      final headers = {
        "Accept": "application/json",
      };

      request.headers.addAll(headers);

      final response = await request.send();
      if (response.statusCode == 200) {
        log('Found Ollama at ${url.host}');
        return url;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<bool> searchForOllama() async {
    assert(_searchLocalNetworkForOllama == true);

    // Check current URL and localhost first
    if (await checkForOllama(Uri.parse(ollamaUrl)) != null) {
      return true;
    }

    final localIP = await NetworkInfo().getWifiIP();

    // Get the first 3 octets of the local IP
    final baseIP = ipToCSubnet(localIP ?? '');

    // Scan the local network for hosts
    final hosts = await LanScanner(debugLogging: true).quickIcmpScanAsync(baseIP);

    List<Future<Uri?>> hostFutures = [];
    for (final host in hosts) {
      final hostUri = Uri.parse('http://${host.internetAddress.address}:11434');
      hostFutures.add(checkForOllama(hostUri));
    }

    final results = await Future.wait(hostFutures);

    final validUrls = results.where((result) => result != null);

    if (validUrls.isNotEmpty) {
      _ollamaUrl = validUrls.first.toString();
      await save();
      notify();
      return true;
    }
    notify();
    return false;
  }

  Future<List<String>> getOllamaModelOptions() async {
    try {
      if (searchLocalNetworkForOllama == true) {
        final found = await searchForOllama();
        if (!found) return [];
      }

      final uri = Uri.parse("$ollamaUrl/api/tags");
      final headers = {
        "Accept": "application/json",
      };

      var request = http.Request("GET", uri)..headers.addAll(headers);

      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      var data = json.decode(responseString);

      List<String> newOptions = [];
      if (data['models'] != null) {
        for (var option in data['models']) {
          newOptions.add(option['name']);
        }
      }

      return newOptions;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}