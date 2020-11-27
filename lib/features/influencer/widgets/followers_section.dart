import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

class FollowersSection extends StatefulWidget {
  final String noOfFollowers;

  const FollowersSection({Key key, this.noOfFollowers}) : super(key: key);
  @override
  _FollowersSectionState createState() => _FollowersSectionState();
}

class _FollowersSectionState extends State<FollowersSection> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (widget.noOfFollowers != null) {
      controller.text = widget.noOfFollowers;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AllProvider>(context, listen: false)
            .updateFollowerCount(int.parse(widget.noOfFollowers));
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
            Text('No of followers'),
            Spacer(),
            SizedBox(
              child: TextField(
                controller: controller,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    Provider.of<AllProvider>(context, listen: false)
                        .updateFollowerCount(int.parse(value));
                  }
                },
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide:
                            BorderSide(color: Colors.black12, width: 1))),
              ),
              height: 40,
              width: 100,
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
