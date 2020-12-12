import 'package:flutter/material.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

class InstagramLinkSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AllProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text('INSTAGRAM LINK'),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                          hintText:
                              'https://www.instagram.com/${provider.igHandle}',
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1))),
                    ),
                    height: 40,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
