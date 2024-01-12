import 'package:flutter/material.dart';

class EditSportsScreen extends StatefulWidget {
  @override
  _EditSportsScreenState createState() => _EditSportsScreenState();
}

class _EditSportsScreenState extends State<EditSportsScreen> {
  List<Item> _data = generateItems(3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Sports'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _buildPanel(),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: CircleAvatar(
                child: Text(item.headerValue),
              ),
              title: Text('Edit ${item.headerValue} Settings'),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Average Speed',
                  ),
                  initialValue: item.speed.toString(),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Total Distance',
                  ),
                  initialValue: item.distance.toString(),
                ),
              ],
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class Item {
  Item({
    required this.headerValue,
    this.isExpanded = false,
    this.speed = 0.0,
    this.distance = 0.0,
  });

  String headerValue;
  bool isExpanded;
  double speed;
  double distance;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: index == 0 ? '🚴 Biking' : index == 1 ? '🏃 Running' : '🚶 Walking',
    );
  });
}
