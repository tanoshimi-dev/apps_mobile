import 'package:flutter/material.dart';

import 'package:gurupoint/models/guru.dart';
import 'package:gurupoint/models/guru_category.dart';

const gurus = [
  Guru(
    guruId: '1',
    guruName: '武士',
    color: Colors.amber,
    guruDescription: '',
  ),
  Guru(
    guruId: '2',
    guruName: '侍',
    color: Colors.green,
    guruDescription: '',
  ),
  Guru(
    guruId: '3',
    guruName: '海賊',
    color: Colors.purple,
    guruDescription: '',
  ),
  Guru(
    guruId: '4',
    guruName: '山賊',
    color: Colors.blue,
    guruDescription: '',
  ),
];

const guruCategories = [
  GuruCategory(
    guruId: '1',
    categoryId: '1',
    categoryName: 'Italian',
    color: Colors.purple,
    imageUrl: '',
    categoryDescription: '',
  ),
  GuruCategory(
    guruId: '1',
    categoryId: '2',
    categoryName: 'Quick & Easy',
    color: Colors.red,
  ),
  GuruCategory(
    guruId: '1',
    categoryId: '3',
    categoryName: 'Hamburgers',
    color: Colors.orange,
  ),
  GuruCategory(
    guruId: '2',
    categoryId: '1',
    categoryName: 'German',
    color: Colors.amber,
  ),
  GuruCategory(
    guruId: '2',
    categoryId: '2',
    categoryName: 'Light & Lovely',
    color: Colors.blue,
  ),
  GuruCategory(
    guruId: '3',
    categoryId: '1',
    categoryName: 'Exotic',
    color: Colors.green,
  ),
  GuruCategory(
    guruId: '3',
    categoryId: '2',
    categoryName: 'Breakfast',
    color: Colors.lightBlue,
  ),
  GuruCategory(
    guruId: '3',
    categoryId: '3',
    categoryName: 'Asian',
    color: Colors.lightGreen,
  ),
  GuruCategory(
    guruId: '3',
    categoryId: '4',
    categoryName: 'French',
    color: Colors.pink,
  ),
  GuruCategory(
    guruId: '3',
    categoryId: '5',
    categoryName: 'Summer',
    color: Colors.teal,
  ),
];
