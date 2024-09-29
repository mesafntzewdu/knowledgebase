import 'package:flutter/material.dart';

import '../screen/start_new_chat.dart';

class HotCard extends StatelessWidget {
  HotCard({super.key, required this.message, required this.selectedMessage});

  String message;
  String selectedMessage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.amber.withOpacity(0.1),
        elevation: 2,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StartNewChat(
                        selectedMessage: selectedMessage,
                      ),
                    ));
                  },
                  icon: const Icon(Icons.arrow_circle_right_sharp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
