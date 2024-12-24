import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  String groupName = '';
  String groupDescription = '';
  DateTime selectedDateTime = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    // Step 1: Select Date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Step 2: Select Time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Running Group',
            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), // Adjusted for a cohesive theme
        elevation: 0, // Removes the shadow for a flatter design
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "🏃‍♂️ Assemble Your Squad! 🏃‍♀️",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Because running alone is just cardio, but running with friends is a party!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              buildLabeledFormField('Group Name', 'Please enter group name'),
              SizedBox(height: 20),
              buildLabeledFormField('Description', 'Please enter a description',
                  isDescription: true),
              SizedBox(height: 20),
              buildDateTimeSelector(context),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Handle data submission or navigation here
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 199, 255, 135), // Light green background
                    foregroundColor: Colors.black, // Text color
                    padding: EdgeInsets.symmetric(
                        horizontal: 100, vertical: 20), // Button size
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Fully rounded corners
                    ),
                    elevation: 0, // Remove shadow for a flat look
                  ),
                  child: Text(
                    'Create Group',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabeledFormField(String label, String errorMessage,
      {bool isDescription = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          maxLines:
              isDescription ? 5 : 1, // Allow multiple lines for description
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.grey[200],
            filled: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorMessage;
            }
            return null;
          },
          onSaved: (value) {
            if (label == 'Group Name') {
              groupName = value!;
            } else if (label == 'Description') {
              groupDescription = value!;
            }
          },
        ),
      ],
    );
  }

  Widget buildDateTimeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date and time:",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${selectedDateTime.toLocal()}",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today, color: Colors.green),
                onPressed: () => _selectDateTime(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
