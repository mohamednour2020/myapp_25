import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/reusable_components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  static String homeScreenRoute = '/home';

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.grey[800],
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  cubit.titles[cubit.currentIndex],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              toolbarHeight: 60,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
             
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ConditionalBuilder(
                condition: true,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) => Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.grey[800],
              splashColor: Colors.white,
              child: Icon(
                cubit.bottomSheetIsOpened ? Icons.done : Icons.add,
                size: 30,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              onPressed: () {
                if (cubit.bottomSheetIsOpened) {
                  if (formKey.currentState.validate()) {
                    cubit.insertInDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) => SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                )),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //Title
                                  defaultTextEditing(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    label: 'Task Title',
                                    prefix: Icons.title,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return ('Title can not be empty');
                                      return null;
                                    },
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),

                                  defaultTextEditing(
                                      controller: timeController,
                                      type: TextInputType.datetime,
                                      label: 'Time',
                                      prefix: Icons.watch_later,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return ('Title can not be empty');
                                        return null;
                                      },
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timeController.text =
                                              value.format(context);
                                        });
                                      }),

                                  SizedBox(
                                    height: 20,
                                  ),

                                  defaultTextEditing(
                                      controller: dateController,
                                      type: TextInputType.datetime,
                                      label: 'Date',
                                      suffix: null,
                                      prefix: Icons.date_range,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return ('Title can not be empty');
                                        return null;
                                      },
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2099-04-01'),
                                        ).then((value) {
                                          dateController.text =
                                              '${value.day} / ${value.month} / ${value.year}';
                                        });
                                      }),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(isShow: false);
                    titleController.text = '';
                    dateController.text = '';
                    timeController.text = '';
                  });
                  cubit.changeBottomSheetState(isShow: true);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              fixedColor: Colors.grey[800],
              selectedIconTheme: IconThemeData(
                color: Colors.grey[800],
                size: 40,
              ),
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.grey[800],
                  ),
                  title: Text(
                    'Tasks'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.done,
                    color: Colors.grey[800],
                  ),
                  title: Text(
                    'done'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive,
                    color: Colors.grey[800],
                  ),
                  title: Text(
                    'archived'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
