import 'package:flutter/material.dart';

class HelpWidget extends StatelessWidget {
  final Widget title;
  final List<Widget> entries;
  const HelpWidget({super.key, required this.title, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        title,
        for (var i = 0; i < entries.length; i++)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: CircleAvatar(
                    radius: 20.0,
                    child: Text((i + 1).toString()),
                  ),
                ),
                Expanded(
                  child: entries[i],
                )
              ],
            ),
          ),
      ],
    );
  }
}
