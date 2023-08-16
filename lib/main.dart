import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Character {
  String name;

  Character(this.name);

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(other) {
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
  int currentAct = 1;
  int currentScene = 1; // Change back to 1
  List<Character> characters = [];
  Character? selectedCharacter;
  Character? lastCharacter;
  List<String> conversation = [];
  String playTitle = '';

  void _addCharacter(String name) {
    if (name.isNotEmpty) {
      characters.add(Character(name));
      characterNameController.clear();
      setState(() {});
    }
  }

  void _nextAct() {
    currentAct++;
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
          characters: characters,
          addScene: _addScene,
          addSaveAndExit: _addAndExit,
        ),
      ),
    );
  }

  void _addScene(String sceneTitle) {
    if (sceneTitle.isNotEmpty) {
      // final sceneHeader = 'Act $currentAct, Scene $currentScene: $sceneTitle';
      // script.add(sceneHeader);
      currentScene++;
      conversation.clear();
      setState(() {});
    }
  }

  void _addAndExit(List<String> sceneConversation) {
    script.addAll(sceneConversation);
    Navigator.pop(context); // Pop the SceneScreen
    setState(() {}); // Trigger a rebuild of the script ListView.builder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theater Play Writer: $playTitle'),
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
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Play Title'),
                  onChanged: (title) {
                    playTitle = title;
                    setState(() {});
                  },
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
                TextField(
                  controller: characterNameController,
                  decoration: const InputDecoration(labelText: 'New Character Name'),
                  onSubmitted: (name) {
                    _addCharacter(name);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _addCharacter(characterNameController.text);
                  },
                  child: const Text('Add Character'),
                ),
                const SizedBox(height: 16),
                const Text('Characters:', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(characters[index].name),
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

