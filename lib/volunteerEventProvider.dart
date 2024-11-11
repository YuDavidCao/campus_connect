import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VolunteerEventProvider extends ChangeNotifier {
  StreamSubscription<List<Map<String, dynamic>>>? _listener;
  List<Map<String, dynamic>> volunteerEvents = [];

  VolunteerEventProvider() {
    final supabase = Supabase.instance.client;
    _listener = supabase
        .from('Volunteer')
        .stream(primaryKey: ['id'])
        .order('Time', ascending: false)
        .listen((snapshot) {
          List<Map<String, dynamic>> eventsAfterNow = [];
          for (var event in snapshot) {
            DateTime eventDateTime = DateTime.parse(event['Time']);
            if (eventDateTime.isAfter(DateTime.now())) {
              eventsAfterNow.add(event);
            }
          }
          volunteerEvents = eventsAfterNow;
          notifyListeners();
        });
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }
}
