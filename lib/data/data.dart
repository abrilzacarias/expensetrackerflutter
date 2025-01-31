import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> transactionData = [
  {
    'id': 1,
    'icon': const FaIcon(FontAwesomeIcons.burger, color: Colors.white),
    'name': 'Food',
    'totalAmount': '-\$45.00',
    'date': 'Today',
    'color': Colors.red,
  },
  {
    'id': 2,
    'icon': const FaIcon(FontAwesomeIcons.car, color: Colors.white),
    'name': 'Transport',
    'totalAmount': '-\$15.00',
    'date': 'Yesterday',
    'color': Colors.blue,
  },
  {
    'id': 3,
    'icon': const FaIcon(FontAwesomeIcons.book, color: Colors.white),
    'name': 'Books',
    'totalAmount': '-\$20.00',
    'date': '3 days ago',
    'color': Colors.purple,
  },
  {
    'id': 4,
    'icon': const FaIcon(FontAwesomeIcons.bagShopping, color: Colors.white),
    'name': 'Shopping',
    'totalAmount': '-\$120.00',
    'date': 'Last week',
    'color': Colors.green,
  },
  {
    'id': 5,
    'icon': const FaIcon(FontAwesomeIcons.dumbbell, color: Colors.white),
    'name': 'Gym',
    'totalAmount': '-\$30.00',
    'date': 'Last month',
    'color': Colors.orange,
  }
];
