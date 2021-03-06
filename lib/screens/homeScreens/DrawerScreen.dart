import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takas_app/Utils/AddItemDialog.dart';
import 'package:takas_app/screens/chatScreens/activeChat.dart';
import 'package:takas_app/screens/itemScreens/subScreens/AllItems.dart';
import 'package:takas_app/screens/itemScreens/subScreens/MyItems.dart';
import 'package:takas_app/screens/chatScreens/allUsers.dart';
import 'package:takas_app/auth.dart';
import 'package:takas_app/screens/profileScreens/profileScreen.dart';

// command to run flutter web:   flutter run -d chrome --web-renderer html
// command to build flutter web for release: flutter build web --web-renderer html --release

//StreamController<Map<String, dynamic>> phobiasStream = StreamController<Map<String, dynamic>>();

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    //
    //
    // Auth().fetchUser().then((value) {
    //   // for (var user in Auth().users) {
    //   //   Auth().fetchLastMessage(user.id);
    //   //   print("sdsd");
    //   // }
    // });

    Auth().fetchMe();

    screen = allUsersStream;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        print("paused");
        break;
      case AppLifecycleState.resumed:
        print("resumed");
        break;

      case AppLifecycleState.inactive:
        print("inactive");
        break;

      case AppLifecycleState.detached:
        print("detached");
        Auth().signOut();
        break;
    }
  }

  Widget myItemsStream = myItems();
  Widget allItemsStream = const AllItems();
  Widget allUsersStream = const AllUsers();
  Widget activeChatStream = const ActiveChat();

  int selectedScreen = 0;
  String menuName = "Kullan??c??lar";
  late Widget screen;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('????k???? Yapmak istiyor musunuz?'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(Icons.clear),
                        title: Text("????k???? yap"),
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          // Do something here
                          Auth().signOut();
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/', (route) => false);
                        },
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Text(
                          "Tamam",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Text(
                          "??ptal",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 8,
          title: Text(
            menuName,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            selectedScreen == 2
                ? IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AddItemDialog();
                          });
                    },
                  )
                : Container()
          ],
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/library.jpg"),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kitap Takasla",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Profilim',
                        style: TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.underline,),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                trailing: const Icon(Icons.supervised_user_circle_sharp),
                title: const Text("Kullan??c??lar"),
                onTap: () {
                  if (selectedScreen != 0) {
                    setState(() {
                      menuName = "Kullan??c??lar";
                      selectedScreen = 0;
                      screen = allUsersStream;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                trailing: const Icon(Icons.chat),
                title: const Text("Konu??malar"),
                onTap: () {
                  if (selectedScreen != 1) {
                    setState(() {
                      menuName = "Konu??malar";
                      selectedScreen = 1;
                      screen = activeChatStream;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                trailing: const Icon(Icons.book),
                title: const Text("Kitaplar??m"),
                onTap: () {
                  if (selectedScreen != 2) {
                    setState(() {
                      menuName = "Kitaplar??m";
                      selectedScreen = 2;
                      screen = myItemsStream;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                trailing: const Icon(Icons.library_books),
                title: const Text("T??m Kitaplar"),
                onTap: () {
                  if (selectedScreen != 3) {
                    setState(() {
                      menuName = "T??m Kitaplar";
                      selectedScreen = 3;
                      screen = allItemsStream;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                trailing: const Icon(Icons.logout),
                title: const Text("????k???? Yap"),
                onTap: () {
                  Auth().signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ],
          ),
        ),
        body: screen,
      ),
    );
  }
}
