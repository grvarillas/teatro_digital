import 'package:flutter/material.dart';

class Character {
  String name;
  List<String> dialogues;

  Character(this.name, this.dialogues);

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(other) {
    return other is Character && name == other.name;
  }
}

class Scene {
  String title;
  List<Character> characters;

  Scene(this.title, this.characters);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Primera Obra de Teatro',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 114, 102, 194),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color.fromARGB(255, 111, 214, 114)),
      ),
      home: const Names(),
    );
  }
}

class Names extends StatefulWidget {
  const Names({super.key});

  @override
  State<Names> createState() => _NamesState();
}

class _NamesState extends State<Names> {
  TextEditingController characterNameController = TextEditingController();
  TextEditingController sceneTitleController = TextEditingController();
  List<Scene> scenes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Scene and Character Names')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: sceneTitleController,
                onChanged: (value) => sceneTitleController.text = value,
                decoration: const InputDecoration(labelText: 'Scene Title'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  scenes.add(Scene(sceneTitleController.text, []));
                });
              },
              child: const Text('Add Scene'),
            ),
            for (var scene in scenes)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: TextEditingController(text: scene.title),
                      onChanged: (value) => scene.title = value,
                      decoration: const InputDecoration(labelText: 'Scene Title'),
                    ),
                  ),
                  for (var character in scene.characters)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: TextEditingController(text: character.name),
                        onChanged: (value) => character.name = value,
                        decoration: const InputDecoration(labelText: 'Character Name'),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        scene.characters.add(Character('', []));
                      });
                    },
                    child: const Text('Add Character'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class SceneDialogues extends StatefulWidget {
  final Scene scene;

  const SceneDialogues({super.key, required this.scene});

  @override
  State<SceneDialogues> createState() => _SceneDialoguesState();
}

class _SceneDialoguesState extends State<SceneDialogues> {
  TextEditingController dialogueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Dialogues')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var character in widget.scene.characters)
              _buildCharacterExpansionTile(character),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Dialogue'),
              content: TextField(
                controller: dialogueController,
                onChanged: (value) => dialogueController.text = value,
                decoration: const InputDecoration(labelText: 'Dialogue'),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.scene.characters[0].dialogues.add(dialogueController.text);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCharacterExpansionTile(Character character) {
    return ExpansionTile(
      title: Text(character.name),
      children: [
        for (var i = 0; i < character.dialogues.length; i++)
          ListTile(
            title: Text(character.dialogues[i]),
          ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Add Dialogue'),
                content: TextField(
                  controller: dialogueController,
                  onChanged: (value) => dialogueController.text = value,
                  decoration: const InputDecoration(labelText: 'Dialogue'),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        character.dialogues.add(dialogueController.text);
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Add Dialogue'),
        ),
      ],
    );
  }
}
