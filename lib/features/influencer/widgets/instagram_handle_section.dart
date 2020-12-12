import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

class InstagramHandleSection extends StatefulWidget {
  final String igHandle;

  const InstagramHandleSection({Key key, this.igHandle}) : super(key: key);
  @override
  _InstagramHandleSectionState createState() => _InstagramHandleSectionState();
}

class _InstagramHandleSectionState extends State<InstagramHandleSection> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (widget.igHandle != null) {
      controller.text = widget.igHandle;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AllProvider>(context, listen: false)
            .updateIgHangle(widget.igHandle);
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
              children: [
                SizedBox(
                  width: 20,
                ),
                Text('INSTAGRAM HANDLE'),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      autofocus: false,
                      controller: controller,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          provider.updateIgHangle(value);
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
      },
    );
  }
}
