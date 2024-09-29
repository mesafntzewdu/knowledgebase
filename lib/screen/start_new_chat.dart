import 'dart:async';
import 'dart:convert';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartNewChat extends StatefulWidget {
  StartNewChat({super.key, this.selectedMessage = ''});
  String selectedMessage;
  @override
  State<StartNewChat> createState() => _StartNewChatState();
}

class _StartNewChatState extends State<StartNewChat> {
  TextEditingController searchTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String userQuestion = '';
  bool isTyping = false;
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();

    searchTextController.text = widget.selectedMessage;

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _scrollToBottom,
    );
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchTextController.dispose();
    super.dispose();
    cacheQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'New Chat',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        actions: [
          Center(
            child: isTyping
                ? Container(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      size: 25,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  )
                : Container(),
          ),
          IconButton(
            onPressed: () {
              getMessage();
            },
            icon: Icon(
              Icons.history,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            const SizedBox(
              height: 3,
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, index) {
                  return sendMessage(
                    isSender: messages[index]['from'],
                    message: messages[index]['message'],
                  );
                },
                itemCount: messages.length,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.8,
                  child: TextField(
                    controller: searchTextController,
                    minLines: 1,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Start typing your question...'),
                    maxLines: 4,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                IconButton.filled(
                  onPressed: () {
                    checkAndSendQuestion(searchTextController.text);
                  },
                  icon: const Icon(
                    Icons.send,
                    size: 35,
                  ),
                )
              ],
            ),
            SizedBox(
              height: constraints.maxHeight * 0.01,
            ),
          ],
        ),
      ),
    );
  }

  Widget sendMessage({required String message, required bool isSender}) {
    return InkWell(
      onLongPress: () => chatOptions(context),
      child: BubbleSpecialThree(
        text: message,
        color: isSender ? Color(0xFF1B97F3) : Colors.amber.withOpacity(0.2),
        tail: true,
        textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
        isSender: isSender,
      ),
    );
  }

  void checkAndSendQuestion(String text) {
    userQuestion = text.trim();
    searchTextController.clear();
    // FocusScope.of(context).unfocus();
    if (text.isEmpty) return;
    if (text.length < 3) {
      scaffoldMessage(status: false, message: 'Question too small.');
      return;
    }

    Map<String, dynamic> questionAsked = {'message': text, 'from': true};
    setState(() {
      messages.add(questionAsked);
    });

    Future.delayed(
      const Duration(milliseconds: 200),
      () => _scrollToBottom(),
    );
    callRestEndPoint(text.trim());
  }

  Future<void> callRestEndPoint(String userQuestion) async {
    try {
      setState(() {
        isTyping = true;
      });
      String postChatUrl =
          'https://expo-ai.openai.azure.com/openai/deployments/expomodel/chat/completions?api-version=2024-06-01';

      Map<String, dynamic> question = {
        "data_sources": [
          {
            "type": "azure_search",
            "parameters": {
              "endpoint": "https://kiotaisearch.search.windows.net",
              "index_name": "kiotsearch1",
              "semantic_configuration": "default",
              "query_type": "semantic",
              "fields_mapping": {},
              "in_scope": true,
              "role_information":
                  "You are an AI assistant that helps people find information.",
              "filter": null,
              "strictness": 3,
              "top_n_documents": 5,
              "authentication": {
                "type": "api_key",
                "key": "''"
              }
            }
          }
        ],
        "messages": [
          {
            "role": "system",
            "content":
                "You are an AI assistant that helps people find information about Mesafint Zewdu."
          },
          {"role": "user", "content": userQuestion}
        ],
        "temperature": 0.7,
        "top_p": 0.95,
        "max_tokens": 800,
        "stop": null,
        "stream": false,
        "frequency_penalty": 0,
        "presence_penalty": 0
      };

      Map<String, String> headers = {
        'api-key': '',
        'Content-Type': 'application/json'
      };

      var response = await http.post(
        Uri.parse(postChatUrl),
        headers: headers,
        body: json.encode(question),
      );

      if (response.statusCode == 200) {
        var parsedJson = json.decode(response.body);

        // Extract the assistant's content
        var assistantContent = parsedJson['choices'][0]['message']['content'];
        Map<String, dynamic> chatReplay = {
          'message': assistantContent,
          'from': false
        };
        setState(() {
          messages.add(chatReplay);
        });
        Future.delayed(
          const Duration(milliseconds: 200),
          () => _scrollToBottom(),
        );
        setState(() {
          isTyping = false;
        });
      } else {
        scaffoldMessage(status: true, message: 'Please try again.');
        setState(() {
          isTyping = false;
        });
      }
    } on TimeoutException catch (_) {
      scaffoldMessage(status: false, message: 'Request timed out.');
      setState(() {
        isTyping = false;
      });
    } on http.ClientException catch (_) {
      scaffoldMessage(status: true, message: 'Check your internet.');
      setState(() {
        isTyping = false;
      });
    } catch (_) {
      scaffoldMessage(status: false, message: 'Unknown error.');
      setState(() {
        isTyping = false;
      });
    } finally {
      setState(() {
        isTyping = false;
      });
    }
  }

  void scaffoldMessage({required bool status, required String message}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        showCloseIcon: true,
        closeIconColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Container(
              child: status
                  ? TextButton(
                      onPressed: () {
                        callRestEndPoint(userQuestion);
                      },
                      child: Text(
                        'Retry?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

  Future chatOptions(context) {
    return showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            ListTile(
              leading: Icon(Icons.loop_rounded),
              title: Text(
                'Retry',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                callRestEndPoint(userQuestion);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(
                'Edit',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.delete_forever),
              title: Text(
                'Delete',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.copy),
              title: Text(
                'Copy',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.reply),
              title: Text(
                'Reply',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.arrow_outward_rounded),
              title: Text(
                'Forward',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.save),
              title: Text(
                'Save',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Future<void> cacheQuestion() async {
    SharedPreferences cacheHistory = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(messages);
    cacheHistory.setString('history', jsonString);
  }

  Future<void> getMessage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? jsonString = pref.getString('history');

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);

      setState(() {
        messages = List<Map<String, dynamic>>.from(jsonList);
      });
    }
  }

  void clearHistory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('history');
  }
}
