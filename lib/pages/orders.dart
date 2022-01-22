import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:the_beauty_rox/widgets/go_back.dart';
import 'package:the_beauty_rox/widgets/navigation.dart';
import 'package:velocity_x/velocity_x.dart';
import 'order_services.dart';
import 'package:url_launcher/url_launcher.dart';

class Orders extends StatefulWidget {
  const Orders({Key key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool isLoading = true;
  List<dynamic> orders = [
    {
      "loading": true,
    },
  ];
  Future<dynamic> getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id').toString();

    var res = await callApi(
      url: getApiUrl(method: 'orders'),
      method: HttpMethods.POST,
      postParams: {
        'user_id': userId,
      },
    );

    setState(() {
      orders = res["orders"];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GoBack(),
      backgroundColor: context.theme.canvasColor,
      appBar: AppBar(
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        title: (Const.name).text.make(),
      ),
      drawer: const TopNav(active: 2),
      body: SizedBox(
        height: context.screenHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: !isLoading
                  ? ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        var order = orders[index];
                        return Container(
                          margin: Vx.mV12,
                          child: InkWell(
                            onTap: () {},
                            child: Card(
                              color: context.theme.cardColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          order["deal"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: 10,
                                              color: order["status"] ==
                                                      "Payment Done"
                                                  ? Colors.green
                                                  : Colors.amber,
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              order['status'].toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return OrderServices(
                                                      order: order["id"]);
                                                },
                                              ),
                                            );
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              context.theme.buttonColor,
                                            ),
                                          ),
                                          child:
                                              const Text("View Services").p12(),
                                        ).wFull(context),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            launch(
                                              "tel:${order['salon_mobile']}",
                                            );
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.green,
                                            ),
                                          ),
                                          child: const Text("Call Salon").p12(),
                                        ).wFull(context),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: context.theme.accentColor,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
