// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        EmailAuthProvider,
        PhoneAuthProvider; // new
import 'package:flutter/material.dart'; // new
import 'package:provider/provider.dart'; // new

import 'app_state.dart'; // new
import 'guest_book.dart'; // new
import 'src/authentication.dart'; // new
import 'src/widgets.dart';
import 'yes_no_selection.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cindy' 's Mobile App Party'),
      ),
      body: ListView(
        children: <Widget>[
          Image.asset('assets/codelabreal.png'),
          const SizedBox(height: 8),
          const IconAndDetail(Icons.calendar_today, 'March 23'),
          const IconAndDetail(Icons.location_city, 'Nashville'),
          // Add from here
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
          // to here
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("What we'll be doing"),
          const Paragraph(
            'Join us for a Mobile App Workshops and Pizza!',
          ),
          // Modify from here...
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add from here...
                if (appState.attendees >= 2)
                  Paragraph('${appState.attendees} people going')
                else if (appState.attendees == 1)
                  const Paragraph('1 person going')
                else
                  const Paragraph('No one going'),
                // ...to here.
                if (appState.loggedIn) ...[
                  // Add from here...
                  YesNoSelection(
                    state: appState.attending,
                    onSelection: (attending) => appState.attending = attending,
                  ),
                  // ...to here.
                  const Header('Here is what people attending have to say'),
                  GuestBook(
                    addMessage: (message) =>
                        appState.addMessageToGuestBook(message),
                    messages: appState.guestBookMessages, // new
                  ),
                ],
              ],
            ),
          ),
          // ...to here.
        ],
      ),
    );
  }
}
