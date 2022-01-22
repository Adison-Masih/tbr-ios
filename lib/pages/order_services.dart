import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:the_beauty_rox/widgets/go_back.dart';
import 'package:the_beauty_rox/widgets/navigation.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderServices extends StatefulWidget {
  var order;
  OrderServices({Key key, @required this.order}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _OrderServicesState createState() => _OrderServicesState(orderId: order);
}

class _OrderServicesState extends State<OrderServices> {
  bool isLoading = true;
  List<dynamic> services = [
    {
      "loading": true,
    },
  ];
  Future<dynamic> getServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id').toString();

    var res = await callApi(
      url: getApiUrl(method: 'services'),
      method: HttpMethods.POST,
      postParams: {
        'order_id': orderId,
      },
    );

    setState(() {
      services = res["services"];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getServices();
  }

  var orderId;
  _OrderServicesState({@required this.orderId});
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
      body: SizedBox(
        height: context.screenHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: !isLoading
                  ? ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        var service = services[index];
                        return Container(
                          margin: Vx.mV12,
                          child: InkWell(
                            onTap: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (ctx) {
                              //       return null;
                              //     },
                              //   ),
                              // );
                            },
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
                                          service["service"],
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
                                              color:
                                                  service["is_used"] == "Unused"
                                                      ? Colors.green
                                                      : Colors.amber,
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              service['is_used'].toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
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
