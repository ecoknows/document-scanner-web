import 'package:flutter/material.dart';

class StorageTab extends StatefulWidget {
  const StorageTab({super.key});

  @override
  State<StorageTab> createState() => _StorageTabState();
}

class _StorageTabState extends State<StorageTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 8,
            ), //
            Image.asset(
              'assets/images/logo.jpg', // Path to your logo image
              height: 40, // Adjust height as needed
            ),
            const SizedBox(
              width: 8,
            ), // Add spacing between the logo and title
            const Expanded(
              child: Text(
                "ADMIN CONSOLE FOR MOBILE DOCUMENT SCANNER APP FOR PSU",
                maxLines: 2,
                overflow: TextOverflow.visible,
                softWrap: true,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
