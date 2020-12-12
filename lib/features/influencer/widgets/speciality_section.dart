import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

class SpecialitySection extends StatefulWidget {
  final String speciality;

  const SpecialitySection({Key key, this.speciality}) : super(key: key);
  @override
  _SpecialitySectionState createState() => _SpecialitySectionState();
}

class _SpecialitySectionState extends State<SpecialitySection> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (widget.speciality != null) {
      controller.text = widget.speciality;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AllProvider>(context, listen: false)
            .updateSpeciality(widget.speciality);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _sWidth = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              '(Optional)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            SizedBox(
              width: 5,
            ),
            Text('Speciality'),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: SizedBox(
                child: TextField(
                  controller: controller,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      Provider.of<AllProvider>(context, listen: false)
                          .updateSpeciality(value);
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
