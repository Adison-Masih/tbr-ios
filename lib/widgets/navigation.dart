import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:the_beauty_rox/utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';

class TopNav extends StatefulWidget {
  final int active;
  const TopNav({Key key, @required this.active}) : super(key: key);

  @override
  State<TopNav> createState() => _TopNavState(active: active);
}

class _TopNavState extends State<TopNav> {
  var name = "Loading...";
  var email = "Loading...";

  Future<dynamic> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_id')) {
      var user_id = prefs.getString('user_id');
      var res = await callApi(
        url: getApiUrl(
          method: 'get-user-info',
        ),
        method: HttpMethods.POST,
        postParams: {'user_id': user_id},
        // decode: false,
      );
      print(res);
      setState(() {
        name = res["name"];
        email = res["email"];
      });
    }
  }

  final int active;
  _TopNavState({Key key, @required this.active});
  final List<List<dynamic>> items = [
    [
      "Home",
      Icons.home,
      Routes.homeRoute,
    ],
    [
      "Deals",
      Icons.search,
      Routes.dealsRoute,
    ],
    [
      "My Orders",
      Icons.shopping_cart,
      Routes.ordersRoute,
    ]
  ];

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: context.theme.cardColor),
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: context.theme.buttonColor),
                margin: EdgeInsets.zero,
                accountName: Text(name),
                accountEmail: Text(email),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      AssetImage('assets/images/default_avatar.png'),
                ),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                List item = items[index];
                return ListTile(
                  selected: active == index ? true : false,
                  leading: Icon(
                    item[1],
                    color: active == index
                        ? context.theme.buttonColor
                        : context.theme.accentColor,
                  ),
                  title: Text(
                    item[0],
                    style: TextStyle(
                      color: active == index
                          ? context.theme.buttonColor
                          : context.theme.accentColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(item[2]);
                    // Navigator.of(context).pop();
                  },
                );
              },
            ).expand()
          ],
        ),
      ),
    );
  }
}
