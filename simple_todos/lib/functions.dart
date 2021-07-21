import 'dart:convert';

import './note.dart';

getNotes(client, notes, retrieveUrl, hasError) async {
  try {
    final request = await client.get(retrieveUrl);
    if (request.statusCode == 200) {
      List response = await json.decode(request.body);
      response.forEach((element) {
        notes.add(Note.fromMap(element));
      });
    }
  } catch (error) {
    hasError = true;
  }
}
