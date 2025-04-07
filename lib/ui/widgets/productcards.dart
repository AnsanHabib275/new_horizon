// ignore_for_file: constant_identifier_names, use_key_in_widget_constructors, unused_element

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:new_horizon/ui/utils/colors.dart';

const redeempoints_content =
    "The primary motive behind a loyalty program is to retain customers by rewarding them for their repeat purchase behavior.";
const kyc_content =
    "Know Your Customer guidelines in financial services require that professionals make an effort to verify the identity, suitability, and risks involved with maintaining a business relationship.";
const loremIpsum = "";

class Card2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    buildImg(Color color, double height) {
      return SizedBox(height: height, child: Container(color: color));
    }

    buildCollapsed1() {
      return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(),
          ]);
    }

    buildCollapsed2() {
      return buildImg(Colors.lightGreenAccent, 0);
    }

    buildCollapsed3() {
      return Container();
    }

    buildExpanded1() {
      return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 14, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Formulation",
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                ],
              ),
            ),
          ]);
    }

    buildExpanded3() {
      return const Padding(
        padding: EdgeInsets.only(top: 5, left: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              kyc_content,
              softWrap: true,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        elevation: 0.5,
        child: ExpandableNotifier(
            child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  // tapBodyToCollapse: true,
                ),
                header: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("Formulation",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500))),
                collapsed: const Text(
                  loremIpsum,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expandable(
                      collapsed: buildCollapsed1(),
                      expanded: buildExpanded1(),
                    ),
                    Expandable(
                      collapsed: buildCollapsed3(),
                      expanded: buildExpanded3(),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Builder(
                          builder: (context) {
                            var controller = ExpandableController.of(context,
                                required: true)!;
                            return TextButton(
                              child: Text(controller.expanded ? "OK" : "",
                                  style: const TextStyle(
                                      color: appcolor.textColor, fontSize: 14)),
                              onPressed: () {
                                controller.toggle();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        )),
      ),
    );
  }
}

class Card3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    buildImg(Color color, double height) {
      return SizedBox(height: height, child: Container(color: color));
    }

    buildCollapsed1() {
      return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(),
          ]);
    }

    buildCollapsed2() {
      return buildImg(Colors.lightGreenAccent, 0);
    }

    buildCollapsed3() {
      return Container();
    }

    buildExpandedCARD3() {
      return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 14, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Usage",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                  ),
                ],
              ),
            ),
          ]);
    }

    buildExpanded3() {
      return const Padding(
        padding: EdgeInsets.only(left: 14, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              redeempoints_content,
              softWrap: true,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        elevation: 1,
        child: ExpandableNotifier(
            child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                    hasIcon: true),
                header: const Padding(
                    padding: EdgeInsets.only(left: 10, top: 0),
                    child: Text("Usage",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500))),
                collapsed: const Text(
                  loremIpsum,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expandable(
                      collapsed: buildCollapsed1(),
                      expanded: buildExpandedCARD3(),
                    ),
                    Expandable(
                      collapsed: buildCollapsed3(),
                      expanded: buildExpanded3(),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Builder(
                          builder: (context) {
                            var controller = ExpandableController.of(context,
                                required: true)!;
                            return TextButton(
                              child: Text(controller.expanded ? "Ok" : "?",
                                  style: const TextStyle(
                                      color: appcolor.textColor, fontSize: 14)),
                              onPressed: () {
                                controller.toggle();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        )),
      ),
    );
  }
}
