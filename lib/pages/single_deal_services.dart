import 'package:flutter/material.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:the_beauty_rox/widgets/go_back.dart';
import 'package:the_beauty_rox/widgets/navigation.dart';
import 'package:velocity_x/velocity_x.dart';

class SingleDealServices extends StatefulWidget {
  var deal;
  SingleDealServices({Key key, @required this.deal}) : super(key: key);

  @override
  _SingleDealServicesState createState() =>
      _SingleDealServicesState(deal: deal);
}

class _SingleDealServicesState extends State<SingleDealServices> {
  var deal;
  _SingleDealServicesState({@required this.deal});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GoBack(),
      backgroundColor: context.theme.canvasColor,
      appBar: AppBar(
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        title: (Const.name).text.make(),
      ),
      drawer: const TopNav(active: 99),
      body: Container(
        height: context.screenHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: deal.services.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.3,
                        color: context.theme.dividerColor,
                      ),
                    ),
                    child: ListTile(
                      title: Text(deal.services[index]["name"]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
