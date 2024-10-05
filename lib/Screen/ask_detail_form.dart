import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:main_evcharge/data/Station_data.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingForm extends StatefulWidget {
  final String id;
  const BookingForm({
    super.key,
    required this.id,
  });

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {

  final _formKey = GlobalKey<FormState>();
  String _vehicleType = 'Two Wheeler';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  final _nameController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehiclePlateNumberController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Color _fieldFocusColor = const Color.fromARGB(255, 222, 168, 231);
  Color _buttonHoverColor = const Color.fromARGB(255, 181, 162, 234);

  @override
  Widget build(BuildContext context) {
   StationData st = StationData();
    final stationModel = st.getStationById(widget.id);
    return Scaffold(
      appBar: AppBar(
        title:  Text(stationModel.stationName),
        backgroundColor: const Color.fromARGB(255, 197, 173, 238),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _animatedTextField(
                label: 'Name',
                controller: _nameController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 20),
              _animatedDropdown(),
              const SizedBox(height: 20),
              _animatedTextField(
                label: 'Vehicle Model',
                controller: _vehicleModelController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter vehicle model' : null,
              ),
              const SizedBox(height: 20),
              _animatedTextField(
                label: 'Vehicle Plate Number',
                controller: _vehiclePlateNumberController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter vehicle plate number' : null,
              ),
              const SizedBox(height: 20),
              _animatedTextField(
                label: 'Mobile Number',
                controller: _mobileNumberController,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty || value.length != 10
                    ? 'Please enter a valid mobile number'
                    : null,
              ),
              const SizedBox(height: 20),
              _animatedCalendar(),
              const SizedBox(height: 20),
              _timePickerSection(),
              const SizedBox(height: 20),
              _animatedButton(
                label: 'Book Charging Station',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String bookingDate =
                        DateFormat('yyyy-MM-dd').format(_selectedDate);
                    String bookingStartTime =
                        '${_startTime.hour}:${_startTime.minute}';
                    String bookingEndTime =
                        '${_endTime.hour}:${_endTime.minute}';

                    print('Form submitted');
                    print(stationModel.id);
                    print(stationModel.stationName);
                    print(_nameController.text);
                    print(_vehicleType);
                    print(_vehicleModelController.text);
                    print(_vehiclePlateNumberController.text);
                    print(_mobileNumberController.text);
                    print(bookingDate);
                    print('From: $bookingStartTime');
                    print('To: $bookingEndTime');

                    
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Time Picker Section for "From" and "To"
  Widget _timePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Booking Time:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _animatedButton(
                label: 'From: ${_startTime.format(context)}',
                onPressed: () {
                  _selectTime(context, true);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _animatedButton(
                label: 'To: ${_endTime.format(context)}',
                onPressed: () {
                  _selectTime(context, false);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Time picker method for selecting time
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null && picked != (isStartTime ? _startTime : _endTime)) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // Custom Animated TextField
  Widget _animatedTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        //color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.deepPurple),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _fieldFocusColor, width: 2),
          ),
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  // Custom Animated Dropdown
  Widget _animatedDropdown() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        //color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          labelText: 'Vehicle Type',
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null ? 'Please select vehicle type' : null,
        items: const [
          DropdownMenuItem(value: 'Two Wheeler', child: Text('Two Wheeler')),
          DropdownMenuItem(value: 'Four Wheeler', child: Text('Four Wheeler')),
        ],
        onChanged: (value) {
          setState(() {
            _vehicleType = value as String;
          });
        },
        value: _vehicleType,
      ),
    );
  }

  // Custom Animated Calendar
  Widget _animatedCalendar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TableCalendar(
        firstDay: DateTime(2022),
        lastDay: DateTime(2030),
        focusedDay: _selectedDate,
        selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDate = selectedDay;
          });
        },
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _selectedDate = focusedDay;
        },
      ),
    );
  }

  // Custom Animated Button with Hover Effect
  Widget _animatedButton(
      {required String label, required VoidCallback onPressed}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.hovered)) {
              return _buttonHoverColor;
            }
            return const Color.fromARGB(255, 197, 178, 234);
          }),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
