import 'package:flutter/material.dart'; // Import the Flutter material package for UI components

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(), // Sets DigitalPetApp as the home screen of the app
  ));
}

// A StatefulWidget allows the app to update and change dynamically
class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key});

  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

// This class handles the state (changing values) of the pet
class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet"; // Pet's default name
  int happinessLevel = 50; // Pet starts with 50 happiness
  int hungerLevel = 50; // Pet starts with 50 hunger

  // Function to play with the pet (increases happiness, slightly increases hunger)
  void _playWithPet() {
    setState(() {
      happinessLevel =
          (happinessLevel + 10).clamp(0, 100); // Increase happiness (max 100)
      _updateHunger(); // Playing makes the pet a little hungry
    });
  }

  // Function to feed the pet (reduces hunger, affects happiness)
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100); // Reduce hunger (min 0)
      _updateHappiness(); // Feeding can also make the pet happier
    });
  }

  // Function to adjust happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20)
          .clamp(0, 100); // If too hungry, pet becomes unhappy
    } else {
      happinessLevel = (happinessLevel + 10)
          .clamp(0, 100); // If well-fed, happiness increases
    }
  }

  // Function to increase hunger slightly when playing
  void _updateHunger() {
    hungerLevel =
        (hungerLevel + 5).clamp(0, 100); // Playing makes the pet hungrier
    if (hungerLevel >= 100) {
      // If hunger is maxed out
      hungerLevel = 100;
      happinessLevel =
          (happinessLevel - 20).clamp(0, 100); // Pet gets unhappy if too hungry
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'), // App title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers everything on the screen
          children: <Widget>[
            // Displays the pet's name
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0), // Spacing between elements

            // Displays the pet's happiness level
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),

            // Displays the pet's hunger level
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),

            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 32.0),

            // Button to play with the pet
            ElevatedButton(
              onPressed: _playWithPet, // Calls _playWithPet() when clicked
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),

            // Button to feed the pet
            ElevatedButton(
              onPressed: _feedPet, // Calls _feedPet() when clicked
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
