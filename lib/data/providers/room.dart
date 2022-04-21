import 'package:flexone/data/models/room_result.dart';
import 'package:flutter/material.dart';

class RoomProvider extends ChangeNotifier {
  Room? _room;

  Room? get room => _room;

  void setRoom(Room room) {
    _room = room;
    notifyListeners();
  }

  void addMember() {
    _room!.totalMembers++;
    notifyListeners();
  }

  void removeMember() {
    _room!.totalMembers--;
    notifyListeners();
  }
}