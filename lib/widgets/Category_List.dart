import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spendwise/utils/icons_list.dart';

class CategoryList extends StatefulWidget {
  CategoryList({super.key, required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Map<String, dynamic>> categoryList = [];
  String currentCategory = "";
  final scrollController = ScrollController();
  var appIcons = AppIcons();

  @override
  void initState() {
    super.initState();
    setState(() {
      categoryList = appIcons.homeExpensesCategories;
      categoryList.insert(0, addCat);
    });
  }

  // scrollToSelectedMonth() {
  //   final selectedMonthIndex = months.indexOf(currentMonth);
  //   if (selectedMonthIndex != -1) {
  //     final scrollOffset = (selectedMonthIndex * 100.0) - 150;
  //     scrollController.animateTo(scrollOffset,
  //         duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  //   }
  // }
  var addCat = {"name": "All", "icon": FontAwesomeIcons.cartPlus};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            var data = appIcons.homeExpensesCategories[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentCategory = data['name'];
                  widget.onChanged(data['name']);
                });
              },
              child: Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: currentCategory == data['name']
                      ? Colors.blue.shade900
                      : Colors.blue.withOpacity(0.1),
                ),
                child: Center(
                    child: Row(
                  children: [
                    Icon(data['icon'],
                        size: 15,
                        color: currentCategory == data['name']
                            ? Colors.white
                            : Colors.blue.shade900),
                    SizedBox(
                      width: 5,
                    ),
                    Text(data['name'],
                        style: TextStyle(
                            color: currentCategory == data['name']
                                ? Colors.white
                                : Colors.blue.shade900)),
                  ],
                )),
              ),
            );
          }),
    );
  }
}
