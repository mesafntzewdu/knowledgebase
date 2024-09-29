import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? userName;
  String? email;
  String? profileUrl;

  @override
  void initState() {
    userInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              child: profileUrl == null
                  ? Container()
                  : CachedNetworkImage(
                      progressIndicatorBuilder: (context, url, progress) =>
                          const Center(
                        child: CircularProgressIndicator(),
                      ),
                      imageUrl: profileUrl!,
                    ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 200,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                      child: userName == null ? Container() : Text(userName!)),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    child: email == null ? Container() : Text(email!),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: ListTile(
                    leading: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Delete Account',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),
                )
              ],
            ),
          )
        ],
      ),

      //  Container(
      //   child: Row(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Container(
      //         child: Column(
      //           children: [
      //             SizedBox(
      //                 child: userName == null ? Container() : Text(userName!)),
      //             SizedBox(
      //               child: email == null ? Container() : Text(email!),
      //             ),
      //           ],
      //         ),
      //       ),
      //       Container(
      //         child: profileUrl == null
      //             ? Container()
      //             : CachedNetworkImage(
      //                 progressIndicatorBuilder: (context, url, progress) =>
      //                     const Center(
      //                   child: CircularProgressIndicator(),
      //                 ),
      //                 imageUrl: profileUrl!,
      //               ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  void userInfo() async {
    final sharedPref = await SharedPreferences.getInstance();

    var userInfo = jsonDecode(sharedPref.getString('userInfo')!);

    setState(() {
      userName = userInfo['name'];
      email = userInfo['email'];
      profileUrl = userInfo['profileUrl'];
    });
  }
}
