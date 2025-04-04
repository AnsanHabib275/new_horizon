import 'package:flutter/material.dart';
import 'package:new_horizon/core/models/ChatMessagesModel.dart';
import 'package:new_horizon/ui/utils/colors.dart';

class SenderRowView extends StatelessWidget {
  final ChatModel chat; // Use ChatModel directly

  const SenderRowView({Key? key, required this.chat}) : super(key: key);

  String formatTimeFromISO(String isoTimestamp) {
    // Parse the string into a DateTime object
    DateTime dateTime = DateTime.parse(isoTimestamp);

    // Extract hours, minutes, and seconds
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    // Determine AM or PM suffix
    String amPm = hour >= 12 ? 'PM' : 'AM';

    // Convert hour to 12-hour format
    hour = hour % 12;
    if (hour == 0) {
      hour = 12; // Convert hour '0' to '12' for 12-hour clock format
    }

    // Format minutes and seconds to always be two digits
    String minuteStr = minute.toString().padLeft(2, '0');
    // String secondStr = second.toString().padLeft(2, '0');

    // Combine parts into final time string
    String formattedTime = "$hour:$minuteStr $amPm";

    // Return the formatted time
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
      ),
      visualDensity: VisualDensity.comfortable,
      title: Wrap(alignment: WrapAlignment.end, children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(3, 111, 173, 1),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            chat.message,
            textAlign: TextAlign.left,
            style: const TextStyle(color: Colors.white),
            softWrap: true,
          ),
        ),
      ]),
      subtitle: Padding(
        padding: const EdgeInsets.only(right: 8, top: 4),
        child: Text(
          formatTimeFromISO(
            chat.time,
          ),
          // chatModelList.elementAt(index).time,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 10),
        ),
      ),
      trailing: const CircleAvatar(
        radius: 15,
        backgroundColor: appcolor.textColor,
        child: Icon(
          Icons.person,
          size: 18,
        ),
      ),
    );
  }
}
