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
  int happinessLevel = 50; // Initial happiness level
  Color petColor = Colors.yellow; // Default pet color (neutral)

  // Function to update pet's mood color based on happiness level
  void _updatePetMood() {
    setState(() {
      if (happinessLevel > 70) {
        petColor = Colors.green; // Happy state
      } else if (happinessLevel >= 30) {
        petColor = Colors.yellow; // Neutral state
      } else {
        petColor = Colors.red; // Unhappy state
      }
    });
  }

  // Function to increase happiness when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updatePetMood(); // Update color based on new happiness level
    });
  }

  // Function to decrease happiness (simulating neglect or hunger)
  void _decreaseHappiness() {
    setState(() {
      happinessLevel = (happinessLevel - 10).clamp(0, 100);
      _updatePetMood(); // Update color based on new happiness level
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
            // Pet visualization (changes color based on mood)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: petColor, // Dynamic pet color
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 16.0),

            // Display Happiness Level
            Text(
              "Happiness: $happinessLevel",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),

            // Play Button (increases happiness)
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text("Play with Pet"),
            ),
            SizedBox(height: 16.0),

            // Decrease Happiness Button (simulates neglect)
            ElevatedButton(
              onPressed: _decreaseHappiness,
              child: Text("Decrease Happiness"),
            ),
          ],
        ),
      ),
    );
  }
}
