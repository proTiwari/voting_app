import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../flutterflow/flutter_flow_theme.dart';
import '../objects/ElectionEvent.dart';
import '../objects/PollEvent.dart';
import '../screens/event_details.dart';

class EventCard extends StatelessWidget {
  final List activeEvents;
  EventCard({super.key, required this.activeEvents});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: activeEvents.length,
        itemBuilder: (BuildContext context, int index) {
          var type = activeEvents[index].runtimeType;
          String topic = "";
          String description = "";
          String timeStr = "";
          if (type == ElectionEvent) {
            final event = activeEvents[index] as ElectionEvent;
            topic = event.topic;
            description = event.description;
          } else if (type == PollEvent) {
            final event = activeEvents[index] as PollEvent;
            topic = event.topic;
            description = event.description;
          }
          return GestureDetector(
            onTap: () async {
              Get.to(EventDetails(activeEvents[index]));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.all(10),
              elevation: 0,
              color: FlutterFlowTheme.of(context).cardBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.how_to_vote,
                      color: FlutterFlowTheme.of(context).primaryColor,
                      size: 24,
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${topic}',
                                style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .cardTextColor,
                                    fontSize: 20)),
                            SizedBox(height: 4),
                            Text('${description}',
                                style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .cardTextColor,
                                    fontSize: 12)),
                            SizedBox(height: 6),
                            Text('${timeStr}',
                                style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .cardTextColor,
                                    fontSize: 8)),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
