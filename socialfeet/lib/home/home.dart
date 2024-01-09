import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [ 
          _buildMainContainer(context), 
        ],
      ),
    );
  } 

  Widget _buildMainContainer(context) {
    // Obtain the screen size
    var screenSize = MediaQuery.of(context).size;
    
    double containerWidth = screenSize.width; 
    double containerHeight = screenSize.height; 
    return Expanded(
      child: Container(
        width: containerWidth,
        height: containerHeight,
        clipBehavior: Clip.antiAlias,
        decoration: _mainContainerDecoration(),
        child: Stack(
          children: [
            _buildTitle(),
            _buildCharacterCard(left: 20, top: 132, name: 'Leon Kennedy', imageUrl: 'https://via.placeholder.com/155x95'),
            _buildCharacterCard(left: 225, top: 132, name: 'Leon Kennedy', imageUrl: 'https://via.placeholder.com/155x95'),
            // Add other character cards similarly
          ],
        ),
      ),
    );
  }



  BoxDecoration _mainContainerDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment(-0.21, -0.98),
        end: Alignment(0.21, 0.98),
        colors: [Color(0x4C36DDA6), Color(0x4C8846DF)],
      ),

      border: Border.all(width: 3),
    );
  }

  Widget _buildTitle() {
    return const Positioned(
      left: 111,
      top: 44,
      child: Text(
        'Choose your Buddy!',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCharacterCard({required double left, required double top, required String name, required String imageUrl}) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 155,
        height: 157,
        decoration: BoxDecoration(
          color: Color(0x338846DF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1),
        ),
        // Add other properties and children
      ),
    );
  }
}
