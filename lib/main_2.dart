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
  String act;
  String scene;
  String title;
  List<Character> characters;

  Scene(this.act, this.scene, this.title, this.characters);

  // Initialize the list of characters
  Scene.empty(this.act, this.scene) : title = '', characters = [];
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theater Play Writer',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 114, 102, 194),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color.fromARGB(255, 111, 214, 114)),
      ),
      home: const PlayWriter(),
    );
  }
}

class PlayWriter extends StatefulWidget {
  const PlayWriter({Key? key});

  @override
  State<PlayWriter> createState() => _PlayWriterState();
}

class _PlayWriterState extends State<PlayWriter> {
  TextEditingController playTitleController = TextEditingController();
  TextEditingController sceneTitleController = TextEditingController();
  TextEditingController characterNameController = TextEditingController();
  TextEditingController dialogueController = TextEditingController();

  List<Scene> scenes = [];
  List<Character> characters = [];
  int currentAct = 1;
  int currentScene = 1;

  void _addScene() {
    final sceneTitle = sceneTitleController.text.trim();
    if (sceneTitle.isNotEmpty) {
      setState(() {
        scenes.add(Scene('Act $currentAct', 'Scene $currentScene', sceneTitle, []));
        sceneTitleController.clear();
        currentScene++;
      });
    }
  }

  void _addCharacter() {
    final characterName = characterNameController.text.trim();
    if (characterName.isNotEmpty) {
      setState(() {
        characters.add(Character(characterName, []));
        characterNameController.clear();

      }
      );
    }
  }

  void _addCharacterToScene(Scene scene, Character character) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Dialogue'),
          content: TextField(
            controller: dialogueController,
            onSubmitted: (value) {
              character.dialogues.add(value);
              dialogueController.clear();
              Navigator.pop(context);
              setState(() {});
            },
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(labelText: 'Dialogue'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                character.dialogues.add(dialogueController.text);
                dialogueController.clear();
                Navigator.pop(context);
                setState(() {});
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _nextAct() {
    setState(() {
      currentAct++;
      currentScene = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Theater Play Writer')),
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: playTitleController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(labelText: 'Play Title'),
                  ),
                  TextField(
                    controller: characterNameController,
                    onChanged: (value) {
                      // setState(() {});
                    },
                    onSubmitted: (_) {
                      _addCharacter();
                    },
                    decoration: InputDecoration(labelText: 'New Character Name'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addCharacter();
                    },
                    child: Text('Add Character'),
                  ),
                  TextField(
                    controller: sceneTitleController,
                    onChanged: (value) {
                      // setState(() {});
                    },
                    onSubmitted: (_) {
                      _addScene();
                    },
                    decoration: InputDecoration(labelText: 'Scene Title (Act $currentAct, Scene $currentScene)'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addScene();
                    },
                    child: Text('Add Scene'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _nextAct();
                    },
                    child: Text('Next Act'),
                  ),
                  for (var scene in scenes)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${scene.act}, ${scene.scene}: ${scene.title}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        for (var character in scene.characters)
                          Text(
                            '${character.name}: ${character.dialogues.join(' ')}',
                          ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Add Character to Scene'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: characters
                                          .where((character) => !scene.characters.contains(character))
                                          .map((character) => ListTile(
                                                title: Text(character.name),
                                                onTap: () {
                                                  scene.characters.add(character);
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text('Add Character to Scene'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _addCharacterToScene(scene, scene.characters.first);
                          },
                          child: Text('Add Dialogue'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Characters:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...characters.map((character) {
                    return SizedBox(
                       width:300,
                      child: Column(
                      
                        children: [
                          ListTile(
                            title: Text(character.name),
                          ),
                          
                          Text(character.dialogues.last),
                          
                        ],
                      ),
                    );
                  },),
                   ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
