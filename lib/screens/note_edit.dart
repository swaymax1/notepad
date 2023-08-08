import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notepad/services/data_state.dart';
import 'package:provider/provider.dart';

class NoteEdit extends StatelessWidget {
  NoteEdit({super.key});
  late final TextEditingController _textController;
  DocumentReference? _ref;
  int? _timestamp;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as Map?;
    if (arguments == null) {
      _timestamp = DateTime.now().millisecondsSinceEpoch;
      _textController = TextEditingController();
    } else {
      _ref = arguments['reference'];
      _textController = TextEditingController(text: arguments['data']);
    }

    return Consumer<Data>(builder: (context, state, child) {
      return Scaffold(
        body: WillPopScope(
          onWillPop: () {
            try {
              Navigator.pop(context, <String, dynamic>{
                'data': _textController.text,
                'reference': _ref,
                'timeStamp': _timestamp
              });
            } on Exception catch (e) {
              print(e);
            }
            return Future<bool>(
              () => true,
            ).then((value) => value);
          },
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextFormField(
                    style: Theme.of(context).textTheme.bodyText1,
                    controller: _textController,
                    scrollPadding: const EdgeInsets.all(20.0),
                    keyboardType: TextInputType.multiline,
                    maxLines: 9999,
                    decoration:
                        const InputDecoration(hintText: 'write note here'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
