import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'dart:async';
// import 'package:flutter/widgets.dart';
import 'package:notes/database.dart';
import 'package:notes/Note.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'note_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, color TEXT)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  notes = await getNotes();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demoff',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        primaryColor: Colors.amber,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.amber,
          // cardColor: Color.fromARGB(255, 225, 225, 225),
          backgroundColor: Colors.red,
          primarySwatch: Colors.deepPurple,
        ),
      ),

      home: const MyHomePage(title: 'Fluttfsder Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    /* var titles = ["1", "2", "3"];
    var content = ["aaaaaaaaaaaaaaaaaaaaaaaaaaaa", "b"];
*/
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //
        //title: Text(widget.title),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        // actions: <Widget>[IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        title: TextField(decoration: InputDecoration(hintText: "Search")),
      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        /* child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                _incrementCounter();
              },

              child: Text("111111"),
            ),
          ],
        ),*/
        child: MasonryGridView.count(
          //  clipBehavior: Clip.none,
          shrinkWrap: true,
          //   primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          //    shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          //   childAspectRatio: 1.4, // adjusts height/width proportion
          /*  direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 20,
          runSpacing: 5,*/
          itemCount: notesLength(),
          // itemCount: 1,
          // itemCount: titles.length, //  textDirection: TextDirection.ltr,
          //  children:Wrap(
          itemBuilder: (context, index) {
            return buildItem(
              notes.elementAt(index).getTitle(),
              notes.elementAt(index).getContent(),
              const Color.fromARGB(255, 224, 224, 224),
            );
          },

          //    <Widget>[
          /*  Column(
              children: [
                buildI  tem("999999999"),
                // Wrap(
                //   alignment: WrapAlignment.start,
                // runAlignment: WrapAlignment.start,
                //  verticalDirection: VerticalDirection.down,
                // runSpacing: 20,
                // children: <Widget>[
                InkWell(
                  onTap: () {
                    debugPrint("Click event on Congggtainer");
                  },
                  //   borderOnForeground: true,
                  //padding: const EdgeInsets.all(8),
                  //  color: Colors.teal[100],
                  child: Ink(
                    /*  height: 5,
                width: 150,*/
                    //  width: 150,
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "111111111111111111111",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text("122222222aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
                      ],
                    ),
                    //  ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    debugPrint("Click event on Congggtainer");
                  },
                  //   borderOnForeground: true,
                  //padding: const EdgeInsets.all(8),
                  //  color: Colors.teal[100],
                  child: Ink(
                    /*  height: 5,
                width: 150,*/
                    //  width: 150,
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "2",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text("22222222"),
                      ],
                    ),
                    //  ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    debugPrint("Click event on Congggtainer");
                  },
                  //   borderOnForeground: true,
                  //padding: const EdgeInsets.all(8),
                  //  color: Colors.teal[100],
                  child: Ink(
                    /*  height: 5,
                width: 150,*/
                    //  width: 150,
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "3333333333333333333333",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text("33333333333333333333333333333333333333333333"),
                      ],
                    ),
                    //  ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    debugPrint("Click event on Congggtainer");
                  },
                  //   borderOnForeground: true,
                  //padding: const EdgeInsets.all(8),
                  //  color: Colors.teal[100],
                  child: Ink(
                    /*  height: 5,
                width: 150,*/
                    //  width: 150,
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "4444444444444444",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "4444444444444444444444444444444444444444444444444444444444",
                        ),
                      ],
                    ),
                    //  ],
                  ),
                ),
              ],
              //   ];
            );
          },
        ),
      ),

      //   )
     
    );
  }
}

Widget buildItem(String title) => InkWell(
  onTap: () {},
  child: Ink(
    color: Colors.red,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text("Some text here"),
      ],
    ), */
          //  },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const HexViewer(title: "erewrw"),
            ),
          ),
          activeNote = Note("", "", Colors.amber),
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//);
Note activeNote = Note("", "", Colors.amber);
//Note newNote = new Note(" "," ",Colors.amber);

Widget buildItem(String title, String content, Color color) => InkWell(
  onTap: () {
    Color a = Color(0xFFFF9000);
    // a.toString();
    debugPrint(a.toARGB32().toRadixString(16));
  },
  child: Ink(
    color:
        color, // color != null ? color : const Color.fromARGB(255, 224, 224, 224),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        Text(content),
      ],
    ),
  ),
);

class HexViewer extends StatefulWidget {
  const HexViewer({super.key, required this.title});
  final String title;

  @override
  State<HexViewer> createState() => _HexViewerState();
}

class _HexViewerState extends State<HexViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint(activeNote.getId().toString());
              debugPrint(notes.elementAt(9).getContent());
              debugPrint("aaaaaaaaaaaaaa");
            },
            icon: Icon(Icons.archive),
          ),
        ],
        title: TextFormField(
          decoration: InputDecoration(
            hintText: "Title",
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
          ),
          onChanged: (title) {
            activeNote.setTitle(title);
            insertNote(activeNote);
            //   activeNote.set
            //     Note note = new Note(value, content, color)
          },
        ),
      ),
      body: SizedBox(
        child: TextFormField(
          autofocus: true,
          expands: true,
          minLines: null,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Note",
            contentPadding: EdgeInsets.all(10),
          ),
          onChanged: (content) {
            activeNote.setContent(content);
            if (activeNote.getId() == null) {
              insertNote(activeNote);
            } else {
              updateNote(activeNote);
            }
            //activeNote.setId(insertNote(activeNote));
            debugPrint("ggggggggggggggggggggggggggg");
            // debugPrint(getNotes().toString());
            printNotes();
            debugPrint("active note id= ${activeNote.getId().toString()}");
            //     Note note = new Note(value, content, color)
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(30, 0, 0, 0),
        height: 60,
        elevation: 0,
        padding: EdgeInsets.all(0),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                StyledIconButton(
                  icon: Icon(Icons.add_circle_outline_outlined),
                  onPressed: () {},
                ),
                StyledIconButton(icon: Icon(Icons.palette), onPressed: () {}),
              ],
            ),
            StyledIconButton(
              icon: Icon(Icons.more_vert_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class StyledIconButton extends IconButton {
  const StyledIconButton({
    super.key,
    required super.onPressed,
    required super.icon,
  });

  @override
  // TODO: implement padding
  EdgeInsetsGeometry? get padding =>
      EdgeInsets.all(BorderSide.strokeAlignOutside);

  @override
  // TODO: implement style
  ButtonStyle? get style => ButtonStyle(
    backgroundColor: WidgetStateColor.fromMap(<WidgetStatesConstraint, Color>{
      WidgetState.any: Color.fromARGB(255, 207, 207, 207),
    }),
  );
}
