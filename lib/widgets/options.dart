import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Options extends StatefulWidget {
  Options(
      {this.selectedItems,
      this.multiSelect,
      @required this.items,
      this.showAnswer,
      this.ansVal
      // this.onChange
      });
  List items;
  List selectedItems;
  bool multiSelect;
  bool showAnswer;
  String ansVal;
  // Function onChange;
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.selectedItems == null) {
      widget.selectedItems = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget.selectedItems below:");
    // print(widget.selectedItems.asMap());

    return
        // Wrap(
        // spacing: 10,
        // alignment: WrapAlignment.center,
        GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 2,
      childAspectRatio: 4,
      mainAxisSpacing: 2,
      primary: true,
      padding: EdgeInsets.all(5.0),
      children: widget.items.map((e) {
        return ChipSelectItem(
          itemName: e.toString(),
          selectedItems: widget.selectedItems,
          multiSelect: widget.multiSelect,
          isSelected: widget.selectedItems.contains(e.toString()),
          showAnswer: widget.showAnswer,
          ansVal: widget.ansVal,
          singleSelectFunc: () {
            setState(() {});
            // if (widget.onChange != null) {
            //   widget.onChange(widget.selectedItems);
            // }
          },
        );
      }).toList(),
    );
  }
}

class ChipSelectItem extends StatefulWidget {
  ChipSelectItem(
      {@required this.itemName,
      @required this.selectedItems,
      this.singleSelectFunc,
      this.isSelected = false,
      @required this.multiSelect,
      this.showAnswer,
      this.ansVal});
  String itemName;
  List selectedItems;
  Function singleSelectFunc;
  bool isSelected;
  bool multiSelect;
  bool showAnswer;
  String ansVal;
  @override
  _ChipSelectItemState createState() => _ChipSelectItemState();
}

class _ChipSelectItemState extends State<ChipSelectItem> {
  //bool selected = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width * 0.7,
      child: ActionChip(
        elevation: 1,
        //materialTapTargetSize: MaterialTapTargetSize.,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        label: Text(
          widget.itemName,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: widget.isSelected
                  ? Colors.white
                  : (widget.showAnswer && widget.itemName == widget.ansVal
                      ? Colors.white
                      : Colors.black)),
        ),
        backgroundColor: widget.isSelected
            ? (widget.showAnswer
                ? (widget.itemName == widget.ansVal ? Colors.green : Colors.red)
                : Colors.orange)
            : (widget.showAnswer
                ? (widget.itemName == widget.ansVal
                    ? Colors.green
                    : Colors.white)
                : Colors.white),
        onPressed: () {
          if (widget.showAnswer) {
            return;
          }
          if (!widget.multiSelect) {
            widget.selectedItems.clear();
            if (!widget.isSelected) {
              widget.selectedItems.add(widget.itemName);
            }
            print("single select widget.selectedItems below:");
            print(widget.selectedItems.asMap());
            widget.singleSelectFunc();
            return;
          }
          if (widget.isSelected) {
            widget.selectedItems.remove(widget.itemName);
          } else {
            widget.selectedItems.add(widget.itemName);
          }
          widget.isSelected = !widget.isSelected;
          setState(() {});
        },
      ),
    );
  }
}
