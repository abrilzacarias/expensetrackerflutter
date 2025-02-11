import 'package:expense_repository/expense_repository.dart';
import 'package:expensetrackerflutter/screens/add_expense/blocs/create_category/create_category_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';

Future<Category?> addCategoryDialog(BuildContext context) {
  return showDialog(
    context: context, 
    builder: (ctx) {
    bool isLoading = false;
    bool isExpanded = false;
    String iconSelected = '';
    Color colorSelected = Colors.white;
    Category category = Category.empty;

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

    TextEditingController categoryNameController = TextEditingController();
    TextEditingController categoryIconController = TextEditingController();
    TextEditingController categoryColorController = TextEditingController();

    return BlocProvider.value(
        value: context.read<CreateCategoryBloc>(),
        child: StatefulBuilder(
          builder: (ctx, setState) {
          return BlocListener<CreateCategoryBloc, CreateCategoryState>(
            listener: (context, state) {
              if (state is CreateCategorySuccess) {
                Navigator.pop(ctx, category);
              } else if (state is CreateCategoryLoading) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            child: AlertDialog(
              title: Text('Create a Category'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: categoryNameController,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          CupertinoIcons.list_number,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Name',
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      controller: categoryIconController,
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          CupertinoIcons.square_favorites_alt,
                          color: Colors.grey,
                        ),
                        suffixIcon: isExpanded
                            ? Icon(CupertinoIcons.chevron_up, size: 12)
                            : Icon(CupertinoIcons.chevron_down, size: 12),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: isExpanded
                              ? BorderRadius.vertical(top: Radius.circular(12))
                              : BorderRadius.circular(12),
                        ),
                        hintText: 'Pick an icon',
                      ),
                    ),
                    isExpanded
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 3,
                                  crossAxisSpacing: 3,
                                ),
                                itemCount: categoriesList.length,
                                itemBuilder: (context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        iconSelected =
                                            categoriesList[index]['name'];
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: iconSelected ==
                                                  categoriesList[index]['name']
                                              ? Colors.green
                                              : Colors.grey,
                                          width: iconSelected ==
                                                  categoriesList[index]['name']
                                              ? 2
                                              : 0.5,
                                        ),
                                      ),
                                      child: Icon(
                                        categoriesList[index]['icon'],
                                        size: 24,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: categoryColorController,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx2) {
                            return AlertDialog(
                              title: Text('Select a color'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ColorPicker(
                                    pickerColor: colorSelected,
                                    onColorChanged: (Color color) {
                                      setState(() {
                                        colorSelected = color;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx2);
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
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
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Pick a color',
                      ),
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: kToolbarHeight,
                      child: isLoading 
                            ? const Center(child: CircularProgressIndicator())
                            : TextButton(
                            onPressed: () {
                              setState(() {
                                category.categoryId = Uuid().v1();
                                category.name = categoryNameController.text;
                                category.icon = iconSelected;
                                // ignore: deprecated_member_use
                                category.color = '#${colorSelected.value.toRadixString(16).padLeft(8, '0')}';
                              });
                              context
                                  .read<CreateCategoryBloc>()
                                  .add(CreateCategory(category));
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          );
          },
        ),
      );
    }
  );
}