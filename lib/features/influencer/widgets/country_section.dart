import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

class CountrySection extends StatefulWidget {
  final String country;

  const CountrySection({Key key, this.country}) : super(key: key);

  @override
  _CountrySectionState createState() => _CountrySectionState();
}

class _CountrySectionState extends State<CountrySection> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (widget.country != null) {
      controller.text = widget.country;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AllProvider>(context, listen: false)
            .updateCountry(widget.country);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Text('Country'),
            SizedBox(
              width: 50,
            ),
            Expanded(
              child: SizedBox(
                child: TextField(
                  controller: controller,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      Provider.of<AllProvider>(context, listen: false)
                          .updateCountry(value);
                    }
                  },
                  decoration: InputDecoration(
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
  }
}
