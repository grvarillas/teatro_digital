import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Character {
  String name;
  String actorName;

  Character(this.name, this.actorName);

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Character && name == other.name;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theater Play Writer',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 114, 102, 194),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color.fromARGB(255, 111, 214, 114),
        ),
      ),
      home: const PlayWriter(),
    );
  }
}

class PlayWriter extends StatefulWidget {
  const PlayWriter({super.key});

  @override
  State<PlayWriter> createState() => _PlayWriterState();
}

class _PlayWriterState extends State<PlayWriter> {
  TextEditingController characterNameController = TextEditingController();
  List<String> script = [];
  int currentAct = 1; // Start with Act 1
  int currentScene = 1;
  bool isFirstActCompleted = false;
  List<Character> cast = [];
  Character? selectedCharacter;
  List<String> conversation = [];
  String playTitle = '';
  String playwrightText = '';

  void _addCharacter(String name, String actorName) {
    if (name.isNotEmpty) {
      cast.add(Character(name, actorName));
      characterNameController.clear();
      setState(() {});
    }
  }

  void _nextAct() {
    if (!isFirstActCompleted) {
      isFirstActCompleted = true;
      currentAct = 1;
    } else {
      currentAct++;
    }
    currentScene = 1;
    script.add('\nAct $currentAct');
    setState(() {});
  }

  void _navigateToSceneScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SceneScreen(
          currentAct: currentAct,
          currentScene: currentScene,
          characters: cast,
          addScene: _addScene,
          addSaveAndExit: _addAndExit,
        ),
      ),
    );
  }

  void _addScene(String sceneTitle) {
    if (sceneTitle.isNotEmpty) {
      currentScene++;
      conversation.clear();
      setState(() {});
    }
  }

  void _addAndExit(List<String> sceneConversation) {
    script.addAll(sceneConversation);
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theater Play Writer'),
      ),
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: script.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(script[index]),
                );
              },
            ),
          ),
          SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Play Title'),
                  onChanged: (title) {
                    playTitle = title;
                    setState(() {});
                  },
                  onSubmitted: (_) {
                    conversation.add('Play Title: $playTitle');
                    setState(() {});
                  },
                ),
                if (playTitle.isNotEmpty)
                  TextField(
                    decoration: const InputDecoration(labelText: 'Playwright/Author'),
                    onChanged: (playwright) {
                      setState(() {
                        playwrightText = playwright;
                      });
                    },
                    onSubmitted: (_) {
                      conversation.add('Playwright text: $playwrightText');
                      conversation.add('Current Act: $currentAct');
                      setState(() {
                        currentAct = 1;
                      });
                    },
                    enabled: playTitle.isNotEmpty,
                  ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _navigateToSceneScreen,
                      child: const Text('Add Scene'),
                    ),
                    ElevatedButton(
                      onPressed: _nextAct,
                      child: const Text('Next Act'),
                    ),
                    Text('Act: $currentAct, Scene: $currentScene'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: characterNameController,
                      decoration: const InputDecoration(labelText: 'New Character Name'),
                      onSubmitted: (name) {
                        _addCharacter(name, '');
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _addCharacter(characterNameController.text, '');
                      },
                      child: const Text('Add Character'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Cast:', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: cast.length,
                    itemBuilder: (context, index) {
                      final character = cast[index];
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(character.name),
                            ),
                            SizedBox(
                              width: 150,
                              child: TextField(
                                onChanged: (actorName) {
                                  character.actorName = actorName;
                                  setState(() {});
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Actor Name',
                                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SceneScreen extends StatefulWidget {
  final int currentAct;
  final int currentScene;
  final List<Character> characters;
  final Function(String) addScene;
  final Function(List<String>) addSaveAndExit;

  const SceneScreen({
    required this.currentAct,
    required this.currentScene,
    required this.characters,
    required this.addScene,
    required this.addSaveAndExit,
    super.key,
  });

  @override
  State<SceneScreen> createState() => _SceneScreenState();
}

class _SceneScreenState extends State<SceneScreen> {
  TextEditingController sceneTitleController = TextEditingController();
  TextEditingController dialogueController = TextEditingController();
  Character? selectedCharacter;
  Character? lastCharacter;
  List<String> conversation = [];

  void _addAndExit() {
    widget.addSaveAndExit(conversation);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scene Writer - Act ${widget.currentAct}, Scene ${widget.currentScene}'),
      ),
      body: Column(
        children: [
          TextField(
            controller: sceneTitleController,
            decoration: const InputDecoration(labelText: 'Scene Title'),
            onSubmitted: (title) {
              if (title.isNotEmpty) {
                setState(() {
                  widget.addScene(title);
                  conversation.insert(0, 'Act ${widget.currentAct}, Scene ${widget.currentScene}: $title');
                });
              }
            },
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButton<Character>(
                  hint: const Text('Select Character'),
                  value: selectedCharacter,
                  onChanged: (character) {
                    setState(() {
                      selectedCharacter = character;
                    });
                  },
                  items: widget.characters.map((Character character) {
                    return DropdownMenuItem<Character>(
                      value: character,
                      child: Text(character.name),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          TextField(
            controller: dialogueController,
            decoration: InputDecoration(
              labelText: 'Enter Dialogue',
              enabled: selectedCharacter != null,
            ),
            enabled: selectedCharacter != null,
            onSubmitted: (dialogue) {
              if (selectedCharacter != null && dialogue.isNotEmpty) {
                if (lastCharacter != selectedCharacter) {
                  conversation.add('${selectedCharacter!.name}: $dialogue');
                  lastCharacter = selectedCharacter;
                }
                dialogueController.clear();
                setState(() {});
              }
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: conversation.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(conversation[index]),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _addAndExit,
            child: const Text('Add Scene and Exit'),
          ),
        ],
      ),
    );
  }
}
