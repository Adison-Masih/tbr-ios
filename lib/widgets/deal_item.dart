import 'package:flutter/material.dart';
import 'package:the_beauty_rox/models/DealModel.dart';
import 'package:the_beauty_rox/pages/single_deal.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class DealItem extends StatelessWidget {
  final Deal item;
  DealItem({Key key, @required this.item});

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Container(
      margin: Vx.mV12,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return SingleDeal(deal: item);
              },
            ),
          );
        },
        child: Card(
          color: context.theme.cardColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: Key(
                  item.id.toString(),
                ),
                child: Image.network(
                  getImage(filename: item.img),
                  width: _mediaQuery.width - 40,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      item.salon['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      item.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      softWrap: false,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          item.salon['city'] + " - " + item.salon['state'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "₹" + item.price.toString(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SingleDeal(deal: item);
                            },
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          context.theme.buttonColor,
                        ),
                      ),
                      child: const Text("Get Now").p12(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
