import 'package:flutter/material.dart';

class Settings {
  late int id;
  late String label;
  late IconData icon;

  Settings({
    required this.id,
    required this.label,
    required this.icon,
  });
}

List<Settings> settings = [
  Settings(
    id: 0,
    label: "Profile settings",
    icon: Icons.settings,
  ),
  Settings(
    id: 1,
    label: "Archive",
    icon: Icons.archive,
  ),
  Settings(
    id: 2,
    label: "Theme",
    icon: Icons.palette,
  ),
  Settings(
    id: 3,
    label: "Log out",
    icon: Icons.logout,
  ),
];
