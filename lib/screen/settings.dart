import 'package:flutter/material.dart';
import 'package:kb/service/auth.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Auth();
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListTile(
              title: Text(
                'General',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ExpansionTile(
              leading: Icon(Icons.light_mode),
              title: Text(
                'Theme',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              children: [
                ListTile(
                  title: Text(
                    'Light',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  leading: Icon(Icons.light_mode),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    'Dark',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  leading: Icon(Icons.dark_mode),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    'Follow System',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  leading: Icon(Icons.settings_system_daydream_outlined),
                  onTap: () {},
                ),
              ],
            ),
            ListTile(
              title: Text(
                'Notification',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: Icon(Icons.notification_add),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'Data Usage',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: Icon(Icons.data_usage),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Support',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListTile(
              title: Text(
                'Help & Feedback',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: Icon(Icons.feedback),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'Privacy',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: Icon(Icons.privacy_tip_rounded),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'About',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: Icon(Icons.info),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Logout',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.red),
              ),
              leading: Icon(Icons.logout),
              onTap: () async {
                await auth.signOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
