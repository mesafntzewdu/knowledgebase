import 'package:flutter/material.dart';
import 'package:kb/screen/login.dart';
import 'package:kb/service/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final auth = Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SizedBox(
          width: 240,
          child: Column(
            children: [
              Image.asset(
                'assets/images/bot.png',
                width: 240,
                height: 100,
              ),
              Text(
                'Knowledge Base',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Center(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                  child: Text(
                    'Already have account?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton.icon(
                    onPressed: () async {},
                    label: Text(
                      'SignUp',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Divider(),
              Center(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await auth.loginWithGoogle(context);
                    },
                    label: Text(
                      'Continue with Google',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    icon: Image.asset('assets/images/google.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
