import 'package:campus_connect/db.dart';
import 'package:campus_connect/homescreen.dart';
import 'package:campus_connect/main.dart';
import 'package:campus_connect/volunteerEvent.dart';
import 'package:campus_connect/constants.dart';
import 'package:flutter/material.dart';
import 'themeProvider.dart';
import 'package:provider/provider.dart';

class volunteerForm extends StatefulWidget {
  final Map<String, dynamic>? event;
  const volunteerForm({super.key, this.event = null});

  @override
  State<volunteerForm> createState() => _volunteerFormState();
}

class _volunteerFormState extends State<volunteerForm> {
  final _formKey = GlobalKey<FormState>();

  //all var are string now

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final TextEditingController csHoursController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController eventOfficerController = TextEditingController();
  final TextEditingController spotsController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController wechatController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController hostClubController = TextEditingController();

  @override
  void dispose() {
    eventNameController.dispose();
    countController.dispose();
    csHoursController.dispose();
    timeController.dispose();
    locationController.dispose();
    detailsController.dispose();
    eventOfficerController.dispose();
    spotsController.dispose();
    phoneNumberController.dispose();
    wechatController.dispose();
    emailController.dispose();
    hostClubController.dispose();
    super.dispose();
  }

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateTime? combinedDateTime;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      eventNameController.text = widget.event!['EventName'];
      countController.text = widget.event!['Count'].toString();
      csHoursController.text = widget.event!['CsHours'].toString();
      timeController.text = widget.event!['Time'].toString();
      locationController.text = widget.event!['Location'];
      detailsController.text = widget.event!['Details'];
      eventOfficerController.text = widget.event!['EventOfficer'];
      spotsController.text = widget.event!['Spots'].toString();
      phoneNumberController.text = widget.event!['PhoneNumber'].toString();
      wechatController.text = widget.event!['Wechat'];
      emailController.text = widget.event!['Email'];
      hostClubController.text = widget.event!['HostClub'];
      selectedDate = DateTime.parse(widget.event!['Time']);
      selectedTime = TimeOfDay.fromDateTime(selectedDate!);
      for (int i = 0; i < tags.length; i++) {
        if (widget.event!['Kind'].contains(tags[i])) {
          tagFlags[i] = true;
        }
      }
    }
  }

//select date and time functions
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  List<bool> tagFlags = List.generate(tags.length, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Please fill in the form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: eventNameController,
                    decoration: const InputDecoration(
                      labelText: 'Event name:',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the event name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),

                  TextFormField(
                    controller: csHoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cs hours:',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      try {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the cs hours';
                        }
                        if (double.parse(value) < 0) {
                          return 'Please enter a positive number';
                        }
                      } catch (e) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),

                  TextFormField(
                    controller: hostClubController,
                    decoration: const InputDecoration(
                      labelText: 'Host club:',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the host club';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),

                  TextFormField(
                    controller: detailsController,
                    decoration: const InputDecoration(
                      labelText: 'Details:',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),

                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      'Select date',
                      style: TextStyle(
                          fontSize: 18,
                          color:
                              Provider.of<ThemeProvider>(context, listen: false)
                                          .themeMode ==
                                      ThemeMode.dark
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.black.withOpacity(0.7),
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectTime(context),
                    child: Text(
                      'Select time',
                      style: TextStyle(
                          fontSize: 18,
                          color:
                              Provider.of<ThemeProvider>(context, listen: false)
                                          .themeMode ==
                                      ThemeMode.dark
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.black.withOpacity(0.7),
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location:',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),

//////////////////ask for event officer contact info
                  TextFormField(
                    controller: eventOfficerController,
                    decoration: const InputDecoration(
                      labelText: 'Event officer:',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the event officer';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),

                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Event officer\'s phone number:',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the event officer\'s phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),

                  TextFormField(
                    controller: wechatController,
                    decoration: const InputDecoration(
                      labelText: 'Event officer\'s wechat:',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the event officer\'s wechat';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),

                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Event officer\'s email:',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the event officer\'s email';
                      }
                      if (!emailRegex.hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),

                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: spotsController,
                    decoration: const InputDecoration(
                      labelText: 'Spots:',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the spots';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),

                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: countController,
                    decoration: const InputDecoration(
                      labelText: 'Count:',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the count';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),

                  Text('Tags:', style: TextStyle(fontSize: 20)),
                  Wrap(
                    children: [
                      for (int i = 0; i < tags.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: FilterChip(
                            label: Text(tags[i]),
                            selected: tagFlags[i], //display true / false
                            onSelected: (bool selected) {
                              setState(() {
                                tagFlags[i] = selected;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            if (selectedDate != null && selectedTime != null) {
                              // Combine date and time into a single DateTime object
                              combinedDateTime = DateTime(
                                selectedDate!.year,
                                selectedDate!.month,
                                selectedDate!.day,
                                selectedTime!.hour,
                                selectedTime!.minute,
                              );
                              List<String> selectedTags = [];
                              for (int i = 0; i < tagFlags.length; i++) {
                                if (tagFlags[i]) {
                                  selectedTags.add(tags[i]);
                                }
                              } /////////****** */
                              if (_formKey.currentState!.validate()) {
                                if (widget.event == null) {
                                  await storeVolunteerEvent(
                                    VolunteerEvent(
                                      eventName: eventNameController.text,
                                      hostClub: hostClubController.text,
                                      count: int.parse(countController.text),
                                      kind: selectedTags, //TODO
                                      csHours:
                                          double.parse(csHoursController.text),
                                      time: combinedDateTime!,
                                      location: locationController.text,
                                      details: detailsController.text,
                                      eventOfficer: eventOfficerController.text,
                                      spots: int.parse(spotsController.text),
                                      participants: const [], ////
                                      phoneNumber:
                                          int.parse(phoneNumberController.text),
                                      email: emailController.text,
                                      wechat: wechatController.text,
                                      creatorUid: supabase.auth.currentUser!.id,
                                      completed: const [],
                                    ),
                                  );
                                } else {
                                  await updateVolunteerEvent(
                                      widget.event!["id"],
                                      VolunteerEvent(
                                          eventName: eventNameController.text,
                                          hostClub: hostClubController.text,
                                          count:
                                              int.parse(countController.text),
                                          kind: selectedTags, //TODO
                                          csHours: double.parse(
                                              csHoursController.text),
                                          time: combinedDateTime!,
                                          location: locationController.text,
                                          details: detailsController.text,
                                          eventOfficer:
                                              eventOfficerController.text,
                                          spots:
                                              int.parse(spotsController.text),
                                          participants: widget
                                              .event!["Participants"], ////
                                          phoneNumber: int.parse(
                                              phoneNumberController.text),
                                          email: emailController.text,
                                          wechat: wechatController.text,
                                          creatorUid:
                                              supabase.auth.currentUser!.id,
                                          completed:
                                              widget.event!["Completed"]));
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const homescreen(),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Form submitted successfully')),
                                );
                              }
                              //Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Please select both date and time')),
                              );
                            }
                          },
                          child: const Text('Submit'))),
                ],
              ),
            )),
      ),
    );
  }
}
