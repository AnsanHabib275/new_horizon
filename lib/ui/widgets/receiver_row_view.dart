import 'package:flutter/material.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';
import 'package:new_horizon/core/models/ChatMessagesModel.dart';

class ReceiverRowView extends StatelessWidget {
  final ChatModel chat; // Use ChatModel directly

  const ReceiverRowView({Key? key, required this.chat}) : super(key: key);

  // final int index;
  String formatTimeFromISO(String isoTimestamp) {
    // Parse the string into a DateTime object
    DateTime dateTime = DateTime.parse(isoTimestamp);

    // Extract hours, minutes, and seconds
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    // int second = dateTime.second;

    // Determine AM or PM suffix
    String amPm = hour >= 12 ? 'PM' : 'AM';

    // Convert hour to 12-hour format
    hour = hour % 12;
    if (hour == 0) {
      hour = 12;
    }

    String minuteStr = minute.toString().padLeft(2, '0');

    // Combine parts into final time string
    String formattedTime = "$hour:$minuteStr $amPm";

    // Return the formatted time
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 2,
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CircleAvatar(
          radius: 16,
          child: Image.asset(AssetConstants.new_horizonlogo),
        ),
      ),
      title: Wrap(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            chat.message,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ]),
      trailing: Container(
        width: 50,
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(left: 8, top: 4),
        child:
            Text(formatTimeFromISO(chat.time), style: TextStyle(fontSize: 10)),
      ),
    );
  }
}
