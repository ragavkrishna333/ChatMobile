import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TileWidget extends StatelessWidget {
  const TileWidget(
      {super.key,
      this.onTap,
      required this.title,
      required this.unread,
      required this.time,
      required this.isGroup,
      this.subtitle,
      required this.isUnread,
      required this.message});
  final Function()? onTap;
  final String title;
  final String? subtitle;
  final String unread;
  final String time;
  final String message;
  final bool isGroup;
  final bool isUnread;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 7.0, 4.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 59,
            width: screenWidth * 1,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(200, 224, 223, 223)
                        .withOpacity(0.5), // Color of the shadow
                    spreadRadius: 5, // Spread radius of the shadow
                    blurRadius: 7, // Blur radius of the shadow
                    offset: const Offset(0, 3), // Offset of the shadow
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isGroup
                            ? Text(
                                title,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              )
                            : Row(
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    " ($subtitle)",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Text(
                            message,
                            maxLines: 1,
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                        )
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            formatDateTime(time),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        isUnread
                            ? Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(172, 255, 209, 70)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(unread),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ]),
            ),
          ),
        ));
  }
}

DateTime? tryParseDateTime(String dateTimeStr, List<DateFormat> formats) {
  for (var format in formats) {
    try {
      return format.parse(dateTimeStr);
    } catch (e) {
      continue;
    }
  }
  return null;
}

String formatDateTime(String dateTimeStr) {
  // Define the possible input date formats
  List<DateFormat> inputFormats = [
    DateFormat('yyyy-MM-dd HH:mm:ss'),
    DateFormat('dd-MM-yyyy hh:mm:ss a')
  ];

  // Attempt to parse the input date-time string
  DateTime? dateTime = tryParseDateTime(dateTimeStr, inputFormats);

  if (dateTime == null) {
    return 'Invalid date format';
  }

  // Get the current date and time
  DateTime now = DateTime.now();

  // Define start and end of today
  DateTime startOfToday = DateTime(now.year, now.month, now.day);
  DateTime endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

  // Define start and end of yesterday
  DateTime startOfYesterday = startOfToday.subtract(Duration(days: 1));
  DateTime endOfYesterday = endOfToday.subtract(Duration(days: 1));

  // Check if the date is within today
  if (dateTime.isAfter(startOfToday) && dateTime.isBefore(endOfToday)) {
    return DateFormat.jm().format(dateTime); // Format as "3:00 PM"
  }

  // Check if the date is within yesterday
  if (dateTime.isAfter(startOfYesterday) && dateTime.isBefore(endOfYesterday)) {
    return "Yesterday";
  }

  // Otherwise, format as "dd-MM-yyyy"
  return DateFormat('dd-MM-yyyy').format(dateTime);
}
