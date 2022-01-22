import 'package:flutter/material.dart';

class Deal {
  final int id;
  final String title;
  final String description;
  final num price;
  final String salon_id;
  final String alias;
  final String img;
  final List<dynamic> services;
  final Map salon;

  Deal({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.salon_id,
    @required this.alias,
    @required this.img,
    @required this.services,
    @required this.salon,
  });

  factory Deal.fromMap(Map<String, dynamic> map) {
    return Deal(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      salon_id: map["salon_id"],
      alias: map["alias"],
      price: int.parse(map["price"]),
      img: map["img"],
      services: map["services"],
      salon: map["salon"],
    );
  }

  toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "salon_id": salon_id,
        "alias": alias,
        "price": price,
        "img": img,
        "services": services,
        "salon": salon,
      };
}

class DealModel {
  static List<Deal> deals = [];
  static List<Deal> searchDeals = [];

  // Get Deal By ID
  Deal getById(int id) {
    return deals.firstWhere((element) => element.id == id, orElse: null);
  }

  // Get Deal By Position
  Deal getByPosition(int pos) {
    return deals[pos];
  }
}
