// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AccidentCategoryWidget extends StatelessWidget {
  AccidentCategoryWidget({
    Key? key,
    this.accidentCategory,
    required this.function,
  }) : super(key: key);

  Function function;
  //Risk Level Alerts
  late final String? accidentCategory;
  final _accidentCategoryList = [
    "PI/Hazard/Hatari,",
    "Property Damage/Uharibifu wa mali/gari",
    "Near Miss/Kosa kosa/Almanusura",
    "Environmental Incident/Uharibifu wa mazingira",
    "Medical Treatment Injury/Ajari ya Kimatibabu",
    "Minor Injury (First Aid Injury)/Ajari ya huduma ya kwanza",
    "Lost Time Injury/Ajari ya kukosa kazini",
    "Fatality/Kifo",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey,
          )),
      child: Center(
        child: DropdownButton(
          isExpanded: true,
          underline: const SizedBox(),
          elevation: 0,
          hint: const Text(
            'Select accident category',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          value: accidentCategory,
          onChanged: (value) {
            accidentCategory = value;
            function(value);
          },
          items: _accidentCategoryList.map((list) {
            return DropdownMenuItem(
              value: list,
              child: Text(
                list,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
