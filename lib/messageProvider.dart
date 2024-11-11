import 'dart:async';

import 'package:campus_connect/main.dart';
import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  StreamSubscription<List<Map<String, dynamic>>>? _listener;

  List<Map<String, dynamic>> messages = [];

  MessageProvider() {
    _listener = null;
    if (supabase.auth.currentUser != null) {
      startListening();
    }
  }

  void startListening() {
    _listener?.cancel();
    _listener = supabase
        .from("Messages")
        .stream(primaryKey: ["receiver"])
        .eq("receiver", supabase.auth.currentUser!.id)
        .order("time", ascending: false)
        .listen((List<Map<String, dynamic>> snapshot) {
          messages = snapshot;
          notifyListeners();
        });
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }
}
