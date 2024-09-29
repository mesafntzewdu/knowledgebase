import 'package:flutter/material.dart';

import '../widget/card.dart';
import 'start_new_chat.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> faqs = [];
  @override
  void initState() {
    super.initState();
    addFaqs();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StartNewChat(),
            ));
          },
          child: const Icon(
            Icons.message,
          ),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          children: [
            ...faqs.map(
              (e) => HotCard(
                message: e,
                selectedMessage: e,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addFaqs() {
    faqs.addAll([
      'What is Wollo University?',
      'What is the AppFactory Academy?',
      'Who can apply for the AppFactory Academy?',
      'What skills will trainees learn at the AppFactory Academy?',
      'Is there a focus on female candidates?',
      'What certifications can trainees obtain?',
      'What resources are provided to trainees?',
      'How long is the training program?',
      'What role does DEMERA play in this initiative?',
      'How does the program help with employability?',
      'What are the main technologies covered in the training?',
      'How can interested candidates apply?'
    ]);
  }
}
