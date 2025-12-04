import 'package:flutter/material.dart';

class search extends StatelessWidget {
  const search({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          const BoxDecoration(border: Border(left: BorderSide(width: 4))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Search...",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.apply(color: Colors.grey.withOpacity(0.5)),
          ),
          const Icon(Icons.mic, size: 25),
        ],
      ),
    );
  }
}
