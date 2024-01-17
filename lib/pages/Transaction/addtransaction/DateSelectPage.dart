
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateSelectPage extends StatefulWidget {
  final DateTime? selectDate;
  const DateSelectPage({super.key, this.selectDate});

  @override
  State<DateSelectPage> createState() => _DateSelectPageState();
}

class _DateSelectPageState extends State<DateSelectPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
         appBar: AppBar(
           surfaceTintColor: Colors.transparent,
           title: Text('Chọn ngày', style: TextStyle(fontWeight: FontWeight.bold)),
         ),
         body: SafeArea(
           child: Container(
             color: Colors.white,
             child: SfDateRangePicker(
                 initialSelectedDate: widget.selectDate,
                 navigationDirection: DateRangePickerNavigationDirection.vertical,
                 navigationMode: DateRangePickerNavigationMode.snap,
                 view: DateRangePickerView.month,
                 monthCellStyle: const DateRangePickerMonthCellStyle(
                     textStyle: TextStyle(
                       fontSize: 17,
                       color: Colors.black,
                     )),
                 monthViewSettings: const DateRangePickerMonthViewSettings(
                   firstDayOfWeek: 1,
                   viewHeaderStyle: DateRangePickerViewHeaderStyle(
                     backgroundColor: Colors.grey,
                     textStyle: TextStyle(
                       fontSize: 15,
                       color: Colors.black,
                     ),
                   ),
                 ),
                 headerStyle: const DateRangePickerHeaderStyle(
                   textAlign: TextAlign.start,
                   textStyle: TextStyle(
                     fontSize: 20,
                     color: Colors.black,
                     fontWeight: FontWeight.bold,

                   ),
                 ),
                 onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                   print(args.value);
                   Navigator.pop(context, {
                     'selectDate': args.value,
                   });
                 })
           )),
         );
  }
}
