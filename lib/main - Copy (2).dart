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
  bool showSecondAppBar = false;

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
  }
*/
  Future<void> loadNotes() async {
    final dbNotes = await getNotes(); // read from SQLite
    setState(() {
      notes = dbNotes; // trigger rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    //var titles = ["1", "2", "3"];
    // var content = ["aaaaaaaaaaaaaaaaaaaaaaaaaaaa", "b"];

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: !showSecondAppBar
          ? AppBar(
              //backgroundColor: Color.fromARGB(255, 155, 11, 11),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              //
              //title: Text(widget.title),
              leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
              // actions: <Widget>[IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
              title: TextField(decoration: InputDecoration(hintText: "Search")),
            )
          : AppBar(
              leading: BackButton(
                onPressed: () {
                  setState(() {
                    showSecondAppBar = false;
                  });
                  //   Navigator.pop(context);
                },
              ),

              actions: [
                TextButton(
                  onPressed: () async {
                    await removeNote(activeNote);
                    loadNotes();
                  },
                  child: Text("Delete"),
                ),
                Container(padding: EdgeInsets.only(right: 20)),
              ],
              //   titleSpacing: 0,
            ),

      body: Center(
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
            return buildNote(
              notes.elementAt(index).getId(),
              notes.elementAt(index).getTitle(),
              notes.elementAt(index).getContent(),
              notes.elementAt(index).getColor() ??
                  const Color.fromARGB(255, 224, 224, 224),
            );
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 224, 224, 224),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () => {
          //make new note and make id null, default note color
          //  activeNote = Note("", "", Color.fromARGB(255, 224, 224, 224)),
          activeNote = Note("", "", Colors.white),
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) =>
                  NoteViewer(title: "test123", onAdd: loadNotes),
            ),
          ),

          //
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      /*  bottomNavigationBar: BottomAppBar(
        height: 80,

        // elevation: 150,
        child: Row(
          children: [TextButton(onPressed: () {}, child: Text("Delete"))],
        ),
      ),*/
    );
  }

  Widget buildNote(int id, String title, String content, Color color) =>
      InkWell(
        onTap: () {
          debugPrint("int: $id content: $content");
          activeNote = Note.withId(id, title, content, color);
          Navigator.push(
            this.context,
            MaterialPageRoute<void>(
              builder: (context) =>
                  NoteViewer(title: "test123", onAdd: loadNotes),
            ),
          );

          loadNotes();
        },
        onLongPress: () async {
          await activeNote.setId(id);
          //await activeNote.setColor(Colors.blue);
          // await updateNote(activeNote);
          setState(() {
            //color = Colors.black12;
            //  loadNotes();
            showSecondAppBar = true;
          });
          debugPrint("id $id");
        },

        child: Ink(
          /*color: !showSecondAppBar
              ? color
              : null,*/
          // color ?? const Color.fromARGB(255, 224, 224, 224),
          decoration: BoxDecoration(
            color: showSecondAppBar && activeNote.getId() == id
                ? color.withAlpha(70)
                : color,
            border: showSecondAppBar && activeNote.getId() == id
                ? Border.all(
                    color: Colors.black87,
                    width: 3,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              Text(content.length <= 300 ? content : content.substring(1, 300)),
            ],
          ),
        ),
      );
}

//);
Note activeNote = Note("", "", Colors.amber);
//Note newNote = new Note(" "," ",Colors.amber);

class NoteViewer extends StatefulWidget {
  final VoidCallback onAdd;
  final String title;
  const NoteViewer({super.key, required this.title, required this.onAdd});

  @override
  State<NoteViewer> createState() => _NoteViewerState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _NoteViewerState extends State<NoteViewer> {
  String? get title => null;
  final TextEditingController _controller = TextEditingController();
  SampleItem? selectedMenu;

  //get loadNotes => null;

  @override
  void dispose() {
    _controller.dispose(); // always dispose controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        //filled: true,
        //   fillColor: activeNote.getColor(),
        elevation: 0,
        backgroundColor: activeNote.getColor(),
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
          initialValue: activeNote.getTitle(),

          //maxLines: 2,
          //controller: _controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: activeNote.getColor(),
            hintText: "Title",

            // labelText: "this.title",
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
          ),
          onChanged: (title) async {
            /*  activeNote.setTitle(title);
            insertNote(activeNote);
*/
            activeNote.setTitle(title);
            if (activeNote.getId() == null) {
              await insertNote(activeNote);
            } else {
              await updateNote(activeNote);
            }
            widget.onAdd();
            //   activeNote.set
            //     Note note = new Note(value, content, color)
          },
        ),
      ),
      body: SizedBox(
        child: TextFormField(
          initialValue: activeNote.getContent(),
          autofocus: true,
          expands: true,
          minLines: null,
          maxLines: null,

          decoration: InputDecoration(
            filled: true,
            fillColor: activeNote.getColor(),
            //  focusColor: activeNote.getColor(),
            // fillColor: activeNote.getColor(),
            hintText: "Note",
            contentPadding: EdgeInsets.all(10),
          ),
          onChanged: (content) async {
            activeNote.setContent(content);
            if (activeNote.getId() == null) {
              await insertNote(activeNote);
            } else {
              await updateNote(activeNote);
            }
            widget.onAdd();
            //activeNote.setId(insertNote(activeNote));
            ///  debugPrint("ggggggggggggggggggggggggggg");
            // debugPrint(getNotes().toString());
            // printNotes();
            //  debugPrint("active note id= ${activeNote.getId().toString()}");
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
                MenuAnchor(
                  style: MenuStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(5)),

                    // elevation: WidgetStatePropertyAll(100),
                    //  alignment: Alignment(-4, 0),
                    //  fixedSize: WidgetStatePropertyAll(Size(, 20)),
                    // alignment: Alignment(0, 0)
                    // ,
                    //   elevation: WidgetStatePropertyAll(100),
                    // visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                  ),
                  alignmentOffset: Offset(-40, 0),

                  //  layerLink: LayerLink(),
                  builder:
                      (
                        BuildContext context,
                        MenuController controller,
                        Widget? child,
                      ) {
                        return StyledIconButton(
                          onPressed: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                          icon: const Icon(Icons.palette_outlined),
                          //  tooltip: 'Show menu',
                        );
                      },
                  menuChildren: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10,
                      /*    spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      runSpacing: 0,
                      verticalDirection: VerticalDirection.down,*/
                      //    crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisSize: MainAxisSize,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // runSpacing: 0,
                      //  mainAxisSize: MainAxisSize.max,
                      children: [
                        //    buildCircleButton(Color.fromARGB(255, 207, 207, 207)),
                        buildCircleButton(Colors.white70),
                        buildCircleButton(Colors.deepOrangeAccent),
                        buildCircleButton(Colors.yellowAccent),
                        buildCircleButton(Colors.lightGreenAccent),
                        buildCircleButton(Colors.greenAccent),
                        buildCircleButton(Colors.lightBlueAccent),
                        buildCircleButton(Colors.cyan),
                        buildCircleButton(Colors.cyanAccent),
                      ],
                    ),
                  ],
                  /* List<MenuItemButton>.generate(
                   3,

                    (int index) => MenuItemButton(
                      onPressed: () => setState(
                        () => selectedMenu = SampleItem.values[index],
                      ),
                      child: Text('Item ${index + 1}'),
                    ),
                  ), */
                ),
              ],
            ),
            /*  StyledIconButton(
              icon: Icon(Icons.more_vert_outlined),
              onPressed: () {},
            ),*/
            MenuAnchor(
              //  alignmentOffset: Offset(200, 0),
              // useRootOverlay: true,
              // crossAxisUnconstrained: true,
              //  alignmentOffset: Offset(-150, -50),
              style: MenuStyle(
                alignment: AlignmentGeometry.xy(-15, 0),
                shape: WidgetStatePropertyAll(
                  ContinuousRectangleBorder(
                    side: BorderSide(style: BorderStyle.solid, width: 2),
                  ),
                ),
                //  shadowColor: WidgetStatePropertyAll(Colors.amber),
              ),
              //   elevation: WidgetStatePropertyAll(200),
              //    minimumSize: WidgetStatePropertyAll(Size(100, 100)),
              menuChildren: [
                Container(
                  //  widthFactor: double.infinity,
                  // alignment: Alignment(-100, 50),
                  //    transformAlignment: AlignmentGeometry.xy(-50, 0),
                  // alignment: AlignmentGeometry.xy(-250, 300),
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  /*   foregroundDecoration: ShapeDecoration(
                        shape: Border.all(style: BorderStyle.solid, width: 5),
                  ),*/
                  //  height: 240,
                  //  decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey, width: 2),
                  //  ),
                  //  alignment: Alignment(-150, 150),
                  width: MediaQuery.of(context).size.width - 20,
                  //  height: MediaQuery.of(context).size.height,
                  child: MenuItemButton(
                    style: ButtonStyle(
                      //   alignment: Alignment.centerLeft,
                      /*  fixedSize: WidgetStatePropertyAll(
                        Size(double.infinity, double.negativeInfinity),
                      ),*/
                    ),
                    child: Row(children: [Icon(Icons.delete), Text("Delete")]),
                    onPressed: () async {
                      await removeNote(activeNote);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Deleted"),
                          action: SnackBarAction(label: "", onPressed: () {}),
                        ),
                      );
                      widget.onAdd();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
              builder: (context, controller, child) {
                return StyledIconButton(
                  icon: Icon(Icons.more_vert_outlined),
                  onPressed: () {
                    if (controller.isOpen)
                      controller.close();
                    else
                      controller.open();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircleButton(Color color) => IconButton(
    //   visualDensity: VisualDensity(horizontal: 0, vertical: 0),
    // splashRadius: 0.5,
    //alignment: Alignment(x, y),
    //color: Colors.amber,
    //constraints: BoxConstraints.loose(Size(30, 30)),
    // focusColor: Colors.amber,
    //visualDensity: VisualDensity(horizontal: 0.0001, vertical: 0.0001),
    iconSize: 32,
    padding: EdgeInsets.all(0),

    // color: Colors.red,
    //  highlightColor: Colors.amber,
    style: ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
      minimumSize: WidgetStatePropertyAll(Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: WidgetStateColor.fromMap(<WidgetStatesConstraint, Color>{
        WidgetState.any: Color.fromARGB(255, 207, 207, 207),
      }),
    ),
    //splashColor: Colors.amber,
    onPressed: () async {
      setState(() {
        activeNote.setColor(color);
      });
      await updateNote(activeNote);
      widget.onAdd();
      //  await loadNotes;
    },
    icon: Icon(
      Icons.circle,
      color: color,

      //weight: 130,
      //  shadows: [Shadow(color: Colors.black12)],
    ),
  );
}

class StyledIconButton extends IconButton {
  const StyledIconButton({
    super.key,
    required super.onPressed,
    required super.icon,
  });

  @override
  //padding
  EdgeInsetsGeometry? get padding =>
      EdgeInsets.all(BorderSide.strokeAlignOutside);

  @override
  // implement style
  ButtonStyle? get style => ButtonStyle(
    backgroundColor: WidgetStateColor.fromMap(<WidgetStatesConstraint, Color>{
      WidgetState.any: Color.fromARGB(255, 207, 207, 207),
    }),
  );
}
