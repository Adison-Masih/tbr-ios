import 'package:flutter/material.dart';
import 'package:the_beauty_rox/models/DealModel.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:velocity_x/velocity_x.dart';

import 'deal_item.dart';

class DealList extends StatelessWidget {
  bool searchDeals = false;
  DealList({Key key, this.searchDeals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      itemCount:
          !searchDeals ? DealModel.deals.length : DealModel.searchDeals.length,
      itemBuilder: (BuildContext context, int index) {
        var item = !searchDeals
            ? DealModel.deals[index]
            : DealModel.searchDeals[index];
        print(index);
        return DealItem(item: item);
      },
    );
  }
}
