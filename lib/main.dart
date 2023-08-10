import 'package:flutter/material.dart';

class Character {
  String name;
  List<String> dialogues;

  Character(this.name) : dialogues = [];

  String get currentDialogue => dialogues.isNotEmpty ? dialogues.last : '';

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
        primaryColor: const Color.fromARGB(255, 114, 102, 194),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color.fromARGB(255, 111, 214, 114)),
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

  void _addCharacter() {
    final characterName = characterNameController.text.trim();
    if (characterName.isNotEmpty) {
      setState(() {
        characters.add(Character(characterName));
        characterNameController.clear();
      });
    }
  }

  void _nextAct() {
    setState(() {
      currentAct++;
      currentScene = 1;
    });
  }

  void _showAddDialoguePopup(Character character) {
    var prueba=3;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Dialogue for ${character.name}'),
          content: TextField(
            controller: dialogueController,
        decoration: InputDecoration(labelText: '${prueba}'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (dialogueController.text.isNotEmpty) {
                  character.dialogues.add(dialogueController.text);
                  dialogueController.clear();
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSceneWidget(Scene scene) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (scenes.indexOf(scene) == 0)
          Text(
            playTitleController.text.isNotEmpty ? playTitleController.text : 'Play Title',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 16),
        Text(
          '${scene.act}, ${scene.scene}: ${scene.title}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        for (var character in scene.characters)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${character.name}:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(' - ${character.currentDialogue}'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showAddDialoguePopup(character);
                },
                child: const Text('Add Dialogue'),
              ),
            ],
          ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Character to Scene'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: characters
                          .map((character) => ListTile(
                                title: Text(character.name),
                                onTap: () {
                                  setState(() {
                                    scene.characters.add(character);
                                  });
                                  Navigator.pop(context);
                                },
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('Add Character to Scene'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theater Play Writer')),
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
                    decoration: const InputDecoration(labelText: 'Play Title'),
                  ),
                  TextField(
                    controller: characterNameController,
                    onChanged: (value) {
                      // setState(() {});
                    },
                    onSubmitted: (_) {
                      _addCharacter();
                    },
                    decoration: const InputDecoration(labelText: 'New Character Name'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addCharacter();
                    },
                    child: const Text('Add Character'),
                  ),
                  TextField(
                    controller: sceneTitleController,
                    onChanged: (value) {
                      // setState(() {});
                    },
                    onSubmitted: (_) {
                      final sceneTitle = sceneTitleController.text.trim();
                      if (sceneTitle.isNotEmpty) {
                        setState(() {
                          scenes.add(Scene('Act $currentAct', 'Scene $currentScene', sceneTitle, []));
                          sceneTitleController.clear();
                          currentScene++;
                        });
                      }
                    },
                    decoration: InputDecoration(labelText: 'Scene Title (Act $currentAct, Scene $currentScene)'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final sceneTitle = sceneTitleController.text.trim();
                      if (sceneTitle.isNotEmpty) {
                        setState(() {
                          scenes.add(Scene('Act $currentAct', 'Scene $currentScene', sceneTitle, []));
                          sceneTitleController.clear();
                          currentScene++;
                        });
                      }
                    },
                    child: const Text('Add Scene'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _nextAct();
                    },
                    child: const Text('Next Act'),
                  ),
                  for (var scene in scenes) _buildSceneWidget(scene),
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
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Characters:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...characters.map((character) {
                    return SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(character.name),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
