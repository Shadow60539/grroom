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
    } else {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AllProvider>(context, listen: false).updateCountry("India");
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text('Country'),
                ),
                SizedBox(
                  child: CountryListPick(
                    initialSelection: 'in',
                    pickerBuilder: (context, countryCode) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              countryCode.name,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w300),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black54,
                            )
                          ],
                        ),
                      );
                    },
                    onChanged: (value) {
                      provider.updateCountry(value.name);
                    },
                  ),
                  height: 40,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
