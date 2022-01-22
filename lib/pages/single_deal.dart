import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:the_beauty_rox/models/DealModel.dart';
import 'package:the_beauty_rox/pages/search_results.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:the_beauty_rox/widgets/go_back.dart';
import 'package:the_beauty_rox/widgets/navigation.dart';
import 'package:velocity_x/velocity_x.dart';

import 'checkout.dart';
import 'single_deal_services.dart';

// ignore: must_be_immutable
class SingleDeal extends StatefulWidget {
  var deal;
  SingleDeal({Key key, @required Deal this.deal}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _SingleDealState createState() => _SingleDealState(deal: deal);
}

class _SingleDealState extends State<SingleDeal> {
  // ignore: prefer_typing_uninitialized_variables
  var deal;
  // ignore: unused_element
  _SingleDealState({Key key, @required Deal this.deal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GoBack(),
      backgroundColor: context.theme.canvasColor,
      appBar: AppBar(
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (Const.name).text.make(),
            InkWell(
              onTap: () => {
                Share.share(
                  "Checkout ${deal.title} On The Beauty Rox! https://www.thebeautyrox.com/deal/${deal.alias}",
                  subject: "Checkout This Amazing Deal On The Beauty Rox!",
                )
              },
              child: Icon(Icons.share),
            )
          ],
        ),
      ),
      drawer: const TopNav(active: 99),
      // ignore: avoid_unnecessary_containers
      body: SizedBox(
        // height: context.screenHeight,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Container(
            height: context.screenHeight,
            width: MediaQuery.of(context).size.width,
            color: context.canvasColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Hero(
                    tag: Key(
                      deal.id.toString(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Image.network(
                        getImage(filename: deal.img),
                      ),
                    ),
                  ).h32(context),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: context.screenWidth,
                  // height: context.screenHeight,
                  color: context.canvasColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        deal.title
                            .toString()
                            .trim()
                            .text
                            .xl2
                            .color(context.accentColor)
                            .bold
                            .align(TextAlign.start)
                            .make(),
                        const SizedBox(
                          height: 15,
                        ),
                        deal.description
                            .toString()
                            .trim()
                            .text
                            .minFontSize(14)
                            // .overflow(TextOverflow.ellipsis)
                            // .maxLines(4)
                            .fontWeight(FontWeight.normal)
                            .make()
                            .py(6),
                        10.heightBox,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    // right: 20,
                    // left: 20,
                  ),
                  child: ButtonBar(
                    buttonPadding: EdgeInsets.zero,
                    alignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (ctx) {
                                return SingleDealServices(
                                  deal: deal,
                                );
                                // return SearchResults(filters: {'hi': 'bye'});
                              },
                            ),
                          );
                        },
                        child: "View Services".text.lg.make(),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              context.theme.buttonColor),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ).wFull(context).h(48.2)
                    ],
                  ).p(20),
                )
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        color: context.cardColor,
        child: ButtonBar(
          buttonPadding: EdgeInsets.zero,
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            ("\₹${deal.price.toString()}")
                .text
                .bold
                .xl4
                .color(context.theme.accentColor)
                .make(),
            BuyNow(deal: deal).w40(context).h(48.2)
          ],
        ).p(20),
      ),
    );
  }
}

class BuyNow extends StatelessWidget {
  var deal;
  BuyNow({Key key, this.deal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (ctx) {
              return Checkout(
                deal: deal,
              );
              // return SearchResults(filters: {'hi': 'bye'});
            },
          ),
        );
      },
      child: "Buy Now".text.lg.make(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(context.theme.buttonColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
