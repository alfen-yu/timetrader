import 'package:flutter/material.dart';
import 'package:timetrader/constants/categories.dart';

class RegisterTaskerBottomSheet extends StatefulWidget {
  final Map<String, dynamic> userData;

  const RegisterTaskerBottomSheet({super.key, required this.userData});

  @override
  State<RegisterTaskerBottomSheet> createState() => _RegisterTaskerBottomSheetState();
}

class _RegisterTaskerBottomSheetState extends State<RegisterTaskerBottomSheet> {
  int? capacityOfWork;
  final List<String> _selectedSkills = [];

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.90, 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true, // Ensures the ListView is only as tall as its content
          children: [
            Text(
              'Tasker Registration',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildUserDetail('Full Name', widget.userData['fullName'] ?? 'N/A'),
            _buildUserDetail('Address', widget.userData['address'] ?? 'N/A'),
            _buildUserDetail('Phone Number', widget.userData['phoneNumber'] ?? 'N/A'),
            const SizedBox(height: 16),
            _buildCapacityOfWorkField(),
            const SizedBox(height: 16),
            _buildSkillsField(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle submission logic
                  Navigator.of(context).pop();
                },
                child: const Text('Complete Registration'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(child: Text('$label:')),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityOfWorkField() {
    return Row(
      children: [
        const Expanded(child: Text('Capacity of Work:')),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter number of hours',
              hintStyle: const TextStyle(fontSize: 12), 
              suffixIcon: IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Capacity of Work'),
                        content: const Text('Indicate how many hours you can work in a day.'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                capacityOfWork = int.tryParse(value);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Skills:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: categories.map((category) {
            return ChoiceChip(
              label: Text(category.name),
              selected: _selectedSkills.contains(category.name),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSkills.add(category.name);
                  } else {
                    _selectedSkills.remove(category.name);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
