import 'dart:async'; // Import Timer for automatic updates
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

// StatefulWidget to manage pet's dynamic behavior
class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 50; // New: Energy level for the pet
  Color petColor = Colors.yellow;
  String petMood = "Neutral";
  String moodEmoji = "😐";
  String petName = "Your Pet";
  TextEditingController nameController = TextEditingController();
  Timer? hungerTimer;
  Timer? happinessTimer;
  Timer? energyTimer; // New: Timer to decrease energy
  Timer? winTimer;
  bool hasWon = false;
  bool gameOver = false;

  // New: Activity selection dropdown values
  String selectedActivity = "Run";
  List<String> activities = ["Run", "Nap", "Eat"];

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _startHappinessTimer();
    _startEnergyTimer(); // Start energy decrease timer
    _startWinConditionTimer();
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    happinessTimer?.cancel();
    energyTimer?.cancel();
    winTimer?.cancel();
    super.dispose();
  }

  // Function to update pet's mood color and text
  void _updatePetMood() {
    setState(() {
      if (happinessLevel > 70) {
        petColor = Colors.green;
        petMood = "Happy";
        moodEmoji = "😃";
      } else if (happinessLevel >= 30) {
        petColor = Colors.yellow;
        petMood = "Neutral";
        moodEmoji = "😐";
      } else {
        petColor = Colors.red;
        petMood = "Unhappy";
        moodEmoji = "😢";
      }
    });
  }

  // Function to play with the pet
  void _playWithPet() {
    if (gameOver || hasWon) return;
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(0, 100); // Playing reduces energy
      _updatePetMood();
      _checkGameOver();
    });
  }

  // Function to feed the pet
  void _feedPet() {
    if (gameOver || hasWon) return;
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      happinessLevel = (happinessLevel + 5).clamp(0, 100);
      energyLevel =
          (energyLevel + 5).clamp(0, 100); // Eating restores some energy
      _updatePetMood();
      _checkGameOver();
    });
  }

  // Function to automatically increase hunger over time
  void _startHungerTimer() {
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (gameOver || hasWon) return;
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        _checkGameOver();
      });
    });
  }

  // Function to automatically decrease happiness over time
  void _startHappinessTimer() {
    happinessTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (gameOver || hasWon) return;
      setState(() {
        happinessLevel = (happinessLevel - 10).clamp(0, 100);
        _updatePetMood();
        _checkGameOver();
      });
    });
  }

  // New: Function to automatically decrease energy over time
  void _startEnergyTimer() {
    energyTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (gameOver || hasWon) return;
      setState(() {
        energyLevel = (energyLevel - 5).clamp(0, 100);
        _checkGameOver();
      });
    });
  }

  // Function to update pet name
  void _setPetName() {
    if (gameOver || hasWon) return;
    setState(() {
      petName =
          nameController.text.isNotEmpty ? nameController.text : "Your Pet";
      nameController.clear();
    });
  }

  // Function to check if the game is lost
  void _checkGameOver() {
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      setState(() {
        gameOver = true;
      });
    }
  }

  // Function to check if the win condition is met
  void _startWinConditionTimer() {
    winTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (gameOver || hasWon) return;
      if (happinessLevel > 80) {
        Future.delayed(Duration(minutes: 3), () {
          if (happinessLevel > 80) {
            setState(() {
              hasWon = true;
            });
          }
        });
      }
    });
  }

  // New: Function to perform selected activity
  void _performActivity() {
    if (gameOver || hasWon) return;
    setState(() {
      if (selectedActivity == "Run") {
        energyLevel = (energyLevel - 15).clamp(0, 100);
        happinessLevel = (happinessLevel + 5).clamp(0, 100);
      } else if (selectedActivity == "Nap") {
        energyLevel = (energyLevel + 15).clamp(0, 100);
      } else if (selectedActivity == "Eat") {
        hungerLevel = (hungerLevel - 10).clamp(0, 100);
        energyLevel = (energyLevel + 10).clamp(0, 100);
      }
      _updatePetMood();
      _checkGameOver();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Digital Pet")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (gameOver)
              Text("Game Over! 😢",
                  style: TextStyle(fontSize: 24.0, color: Colors.red)),
            if (hasWon)
              Text("You Won! 🎉",
                  style: TextStyle(fontSize: 24.0, color: Colors.green)),

            Container(
                width: 100,
                height: 100,
                decoration:
                    BoxDecoration(color: petColor, shape: BoxShape.circle)),
            SizedBox(height: 16.0),

            Text("Mood: $petMood $moodEmoji", style: TextStyle(fontSize: 20.0)),
            Text("Happiness: $happinessLevel"),
            Text("Hunger: $hungerLevel"),
            Text("Energy: $energyLevel"), // New: Display energy level
            Text("Name: $petName", style: TextStyle(fontSize: 20.0)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "Enter Pet's Name",
                      border: OutlineInputBorder())),
            ),
            ElevatedButton(onPressed: _setPetName, child: Text("Set Name")),

            ElevatedButton(
                onPressed: _playWithPet, child: Text("Play with Pet")),
            ElevatedButton(onPressed: _feedPet, child: Text("Feed Pet")),

            // New: Activity Selection
            DropdownButton<String>(
              value: selectedActivity,
              onChanged: (String? newValue) =>
                  setState(() => selectedActivity = newValue!),
              items: activities
                  .map((String activity) =>
                      DropdownMenuItem(value: activity, child: Text(activity)))
                  .toList(),
            ),
            ElevatedButton(
                onPressed: _performActivity, child: Text("Perform Activity")),

            // New: Energy Bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: LinearProgressIndicator(
                  value: energyLevel / 100, minHeight: 10),
            ),
          ],
        ),
      ),
    );
  }
}
