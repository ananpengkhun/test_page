import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MyTextField extends HookWidget {
  MyTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemFocusNode = useFocusNode();
    // listen to focus chances
    FocusNode focusNode = new FocusNode();
    focusNode.addListener(() {
      print('focusNode updated: hasFocus: ${focusNode.hasFocus}');
    });

    useListenable(itemFocusNode);
    final isFocused = itemFocusNode.hasFocus;
    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    final _mobileFormatter = NumberTextInputFormatter();

    return Material(
      child: Center(
        child: Focus(
            focusNode: focusNode,
            onFocusChange: (focused) {
              // if (focused) {
              //   textEditingController.text = "asdasd";
              // } else {
              // Commit changes only when the textfield is unfocused, for performance
              // todoListProvider
              //     .read(context)
              //     .edit(id: todo.id, description: textEditingController.text);
              // }
            },
            child: TextFormField(
              keyboardType: TextInputType.phone,
              maxLength: 15,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly,
                _mobileFormatter,
              ],
              decoration: InputDecoration(
                icon: Icon(Icons.phone_iphone),
                hintText: "Mobile*",
              ),
            )),
      ),
    );
  }
}

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    // if (newTextLength >= 1) {
    //   newText.write('');
    //   if (newValue.selection.end >= 1) selectionIndex++;
    // }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + '-');
      if (newValue.selection.end >= 3) selectionIndex += 1;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
