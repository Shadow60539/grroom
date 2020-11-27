import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

class NameSection extends StatefulWidget {
  final String firstName;
  final String lastName;

  const NameSection({Key key, this.firstName, this.lastName}) : super(key: key);

  @override
  _NameSectionState createState() => _NameSectionState();
}

class _NameSectionState extends State<NameSection> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    if (widget.firstName != null) {
      firstNameController.text = widget.firstName;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AllProvider>(context, listen: false)
            .updateFirstName(widget.firstName);
      });
    }
    if (widget.lastName != null) {
      lastNameController.text = widget.lastName;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AllProvider>(context, listen: false)
            .updateLastName(widget.lastName);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                child: TextField(
                  controller: firstNameController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      Provider.of<AllProvider>(context, listen: false)
                          .updateFirstName(value);
                    }
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      labelText: 'First Name',
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide:
                              BorderSide(color: Colors.black12, width: 1))),
                ),
                height: 45,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                child: TextField(
                  controller: lastNameController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      Provider.of<AllProvider>(context, listen: false)
                          .updateLastName(value);
                    }
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      labelText: 'Last Name',
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide:
                              BorderSide(color: Colors.black12, width: 1))),
                ),
                height: 45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
