import 'package:flexone/data/models/class_result.dart';
import 'package:flutter/material.dart';

class ModuleProvider extends ChangeNotifier {
  List<Module> _modules = [];
  int _currentIndex = 0;

  List<Module> get modules => _modules;
  int get currentIndex => _currentIndex;

  Future setModules() async {
    _modules = [];
    notifyListeners();
  }

  Future openModule(int id) async {
    _currentIndex = _modules.indexWhere((module) => module.id == id);
    notifyListeners();
  }

  Future addModule(Module module) async {
    _modules.add(module);
    notifyListeners();
  }

  Future previous() async {
    _currentIndex--;
    notifyListeners();
  }

  Future next() async {
    _currentIndex++;
    notifyListeners();
  }
}