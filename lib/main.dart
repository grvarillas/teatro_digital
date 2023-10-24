import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';

const Color backgroundclr = Colors.black; // Updated background color
final Color? lbackgroundclr = Colors.grey[800];
const Color whiteclr = Colors.white;
const Color primaryclr = Colors.deepPurple; // Updated primary color

void main() {
  runApp(const MyApp());
}

class RoundedButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final double horizontalPadding;
  final double verticalPadding;
  final Color backgroundColor;
  final Color textColor;

  const RoundedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.horizontalPadding = 20,
    this.verticalPadding = 12,
    this.backgroundColor = primaryclr, // Use primary color as the default background color
    this.textColor = whiteclr, // Updated text color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class PlayData {
  String title = '';
  String author = '';
  String characters = '';
  String cast = '';
  String acts = '';
  String scenes = '';
  String dialogues = '';

  void fromMap(Map<String, dynamic> map) {
    title = map['title'] ?? '';
    author = map['author'] ?? '';
    characters = map['characters'] ?? '';
    cast = map['cast'] ?? '';
    acts = map['acts'] ?? '';
    scenes = map['scenes'] ?? '';
    dialogues = map['dialogues'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'characters': characters,
      'cast': cast,
      'acts': acts,
      'scenes': scenes,
      'dialogues': dialogues,
    };
  }
}

class PlayListItem {
  final PlayData data;
  PlayListItem(this.data);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryclr, // Set primary color for the app
        scaffoldBackgroundColor: backgroundclr, // Set background color for the scaffold
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _playwrightController = TextEditingController();
  final TextEditingController _charactersController = TextEditingController();
  final TextEditingController _castController = TextEditingController();
  final TextEditingController _actsController = TextEditingController();
  final TextEditingController _scenesController = TextEditingController();
  final TextEditingController _dialoguesController = TextEditingController();
  final List<PlayListItem> _playList = <PlayListItem>[];
  File? _csvFile;

  @override
  void initState() {
    super.initState();
    readPlayListFromCSV();
  }

  Future<void> saveDataToCSV(Map<String, dynamic> playData) async {
    final List<List<dynamic>> rows = <List<dynamic>>[];
    rows.add(playData.keys.toList());
    rows.add(playData.values.toList());
    if (_csvFile != null) {
      final csvFile = _csvFile!;
      final file = File(csvFile.path);
      final csvContent = await file.readAsString();
      final csvList = const CsvToListConverter().convert(csvContent);
      csvList.addAll(rows);
      final csvString = const ListToCsvConverter().convert(csvList);
      await file.writeAsString(csvString);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/play_list.csv';
      final file = File(filePath);
      final csvString = const ListToCsvConverter().convert(rows);
      await file.writeAsString(csvString);
      _csvFile = file;
    }
    readPlayListFromCSV();
  }

  Future<void> readPlayListFromCSV() async {
    _playList.clear();
    if (_csvFile != null) {
      final csvFile = _csvFile!;
      final file = File(csvFile.path);
      if (await file.exists()) {
        final csvContent = await file.readAsString();
        final csvList = const CsvToListConverter().convert(csvContent);
        if (csvList.length >= 2) {
          final headers = csvList[0].map((e) => e.toString()).toList();
          final values = csvList[1].map((e) => e.toString()).toList();
          final playDataMap = Map<String, dynamic>.fromIterables(headers, values);
          final playData = PlayData();
          playData.fromMap(playDataMap);
          _playList.add(PlayListItem(playData));
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teatro Digital'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _playwrightController,
                    decoration: const InputDecoration(
                      labelText: 'Playwright',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a playwright';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _charactersController,
                    decoration: const InputDecoration(
                      labelText: 'Characters',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter characters';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _castController,
                    decoration: const InputDecoration(
                      labelText: 'Cast',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter cast';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _actsController,
                    decoration: const InputDecoration(
                      labelText: 'Acts',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter acts';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _scenesController,
                    decoration: const InputDecoration(
                      labelText: 'Scenes',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter scenes';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dialoguesController,
                    decoration: const InputDecoration(
                      labelText: 'Dialogues',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter dialogues';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final playData = {
                          'title': _titleController.text,
                          'author': _playwrightController.text,
                          'characters': _charactersController.text,
                          'cast': _castController.text,
                          'acts': _actsController.text,
                          'scenes': _scenesController.text,
                          'dialogues': _dialoguesController.text,
                        };
                        await saveDataToCSV(playData);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data saved successfully'),
                          ),
                        );
                        clearForm();
                      }
                    },
                    child: const Text('Save Play Data'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _playList.length,
                itemBuilder: (context, int index) { // Specify the type of index as int
                  final item = _playList[index];
                  return ListTile(
                    title: Text(item.data.title),
                    subtitle: Text(item.data.author),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clearForm() {
    _titleController.text = '';
    _playwrightController.text = '';
    _charactersController.text = '';
    _castController.text = '';
    _actsController.text = '';
    _scenesController.text = '';
    _dialoguesController.text = '';
  }
}
//unitest***inves
//widget testing***inves
//integration testing
//*types of testing */