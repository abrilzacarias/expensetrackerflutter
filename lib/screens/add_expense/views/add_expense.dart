import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  List<Map<String, dynamic>> categoriesList = [
    {'name': 'cart', 'icon': CupertinoIcons.cart},
    {'name': 'car', 'icon': CupertinoIcons.car},
    {'name': 'tv', 'icon': CupertinoIcons.tv},
    {'name': 'heart', 'icon': CupertinoIcons.heart},
    {'name': 'book', 'icon': CupertinoIcons.book},
    {'name': 'bag', 'icon': CupertinoIcons.bag},
    {'name': 'money_dollar', 'icon': CupertinoIcons.money_dollar},
    {'name': 'paw', 'icon': CupertinoIcons.paw},
    {'name': 'circle', 'icon': CupertinoIcons.circle},
  ];

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //unfocus keyboard when tapped outside of textfield
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Add Expense',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        CupertinoIcons.money_dollar,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  readOnly: true,
                  controller: categoryController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        CupertinoIcons.list_number,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                bool isExpanded = false;
                                //move to this level to not perserve the selected after closing the dialog
                                String iconSelected = '';
                                Color colorSelected = Colors.white;

                                return StatefulBuilder(
                                    builder: (ctx, setState) {
                                  return AlertDialog(
                                      title: Text(
                                        'Create a Category',
                                      ),
                                      content: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              //controller: dateController,
                                              decoration: InputDecoration(
                                                  isDense: true,
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  prefixIcon: const Icon(
                                                    CupertinoIcons.list_number,
                                                    color: Colors.grey,
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      borderSide:
                                                          BorderSide.none),
                                                  hintText: 'Name'),
                                            ),
                                            SizedBox(height: 16),
                                            TextFormField(
                                              onTap: () {
                                                setState(() {
                                                  isExpanded = !isExpanded;
                                                });
                                              },
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                filled: true,
                                                fillColor: Colors.white,
                                                prefixIcon: const Icon(
                                                  CupertinoIcons
                                                      .square_favorites_alt,
                                                  color: Colors.grey,
                                                ),
                                                suffixIcon: isExpanded
                                                    ? Icon(
                                                        CupertinoIcons
                                                            .chevron_up,
                                                        size: 12)
                                                    : Icon(
                                                        CupertinoIcons
                                                            .chevron_down,
                                                        size: 12),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: isExpanded
                                                        ? BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    12))
                                                        : BorderRadius.circular(
                                                            12)),
                                                hintText: 'Pick an icon',
                                              ),
                                            ),
                                            isExpanded
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              bottom: Radius
                                                                  .circular(
                                                                      12)),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: GridView.builder(
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    3,
                                                                mainAxisSpacing:
                                                                    3,
                                                                crossAxisSpacing:
                                                                    3),
                                                        itemCount:
                                                            categoriesList
                                                                .length,
                                                        itemBuilder: (context,
                                                            int index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                iconSelected =
                                                                    categoriesList[
                                                                            index]
                                                                        [
                                                                        'name'];
                                                              });
                                                            },
                                                            child: Container(
                                                              width: 50,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: iconSelected ==
                                                                                categoriesList[index]['name']
                                                                            ? Colors.green
                                                                            : Colors.grey,
                                                                        width: iconSelected ==
                                                                                categoriesList[index]['name']
                                                                            ? 2
                                                                            : 0.5,
                                                                      )),
                                                              child: Icon(
                                                                  categoriesList[
                                                                          index]
                                                                      ['icon'],
                                                                  size: 24),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ))
                                                : Container(),
                                            SizedBox(height: 16),
                                            TextFormField(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx2) {
                                                      return AlertDialog(
                                                          title: Text(
                                                              'Select a color'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              ColorPicker(
                                                                pickerColor:
                                                                    colorSelected,
                                                                onColorChanged:
                                                                    (Color
                                                                        color) {
                                                                  setState(() {
                                                                    colorSelected =
                                                                        color;
                                                                  });
                                                                },
                                                              ),
                                                              SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 50,
                                                                  child: TextButton(
                                                                      onPressed: () {
                                                                        Navigator.pop(
                                                                            ctx2);
                                                                      },
                                                                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                                                      child: Text(
                                                                        'Save',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ))),
                                                            ],
                                                          ));
                                                    });
                                              },
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  isDense: true,
                                                  filled: true,
                                                  fillColor: colorSelected,
                                                  prefixIcon: const Icon(
                                                    CupertinoIcons.color_filter,
                                                    color: Colors.grey,
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      borderSide:
                                                          BorderSide.none),
                                                  hintText: 'Pick a color'),
                                            ),
                                            SizedBox(height: 32),
                                            SizedBox(
                                                width: double.infinity,
                                                height: kToolbarHeight,
                                                child: TextButton(
                                                    onPressed: () {
                                                      //create category object
                                                      Navigator.pop(context);
                                                    },
                                                    style: TextButton.styleFrom(
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12))),
                                                    child: Text(
                                                      'Save',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )))
                                          ],
                                        ),
                                      ));
                                });
                              });
                        },
                        icon: Icon(CupertinoIcons.plus),
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      hintText: 'Category'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 45)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );

                    if (newDate != null) {
                      setState(() {
                        dateController.text =
                            DateFormat('dd/MM/yyyy').format(newDate);
                        selectedDate = newDate;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        CupertinoIcons.calendar_today,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      hintText: 'Date'),
                ),
                SizedBox(height: 32),
                SizedBox(
                    width: double.infinity,
                    height: kToolbarHeight,
                    child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )))
              ],
            ),
          )),
    );
  }
}
