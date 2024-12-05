import "package:flutter/material.dart";
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'api_handler.dart';

void main() {
  runApp(
    const MaterialApp(home: App()),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late String stock;
  String time = "D";
  bool controller = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: controller,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            title: const Text(
              "Stock Price Analyzer",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownMenu(
                    label: Text(
                      "Time period",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    width: double.infinity,
                    onSelected: (val) {
                      time = val!;
                    },
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: "M",
                        label: "Monthly",
                      ),
                      DropdownMenuEntry(
                        value: "W",
                        label: "Weekly",
                      ),
                      DropdownMenuEntry(
                        value: "D",
                        label: "Daily",
                      ),
                    ],
                  ),
                  const SizedBox(height: 25.0),
                  TextField(
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: "Stock symbol",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onChanged: (val) {
                      stock = val.toString().toUpperCase();
                    },
                  ),
                  const SizedBox(height: 25.0),
                  MaterialButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        controller = true;
                      });
                      final data = await getData(stock, time);
                      setState(() {
                        controller = false;
                      });
                      if (data[0] == "ok") {
                        final yesterdayPrice = data[0 + 1];
                        final dayBefYesterdayPrice = data[1 + 1];
                        final percent = data[2 + 1];
                        final growthOrLoss = data[3 + 1];
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Results",
                                      style: TextStyle(
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20.0),
                                    Text((time == "D")
                                        ? "Yesterday market close price: \$$yesterdayPrice"
                                        : (time == "W")
                                            ? "Previous week market close price: \$$yesterdayPrice"
                                            : "Previous month market close price: \$$yesterdayPrice"),
                                    Text((time == "D")
                                        ? "Day before yesterday market close price: \$$dayBefYesterdayPrice"
                                        : (time == "W")
                                            ? "Week before last week market close price: \$$dayBefYesterdayPrice"
                                            : "Month before last month market close price: \$$dayBefYesterdayPrice"),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "$stock $growthOrLoss by ${percent.toStringAsFixed(3)}%.",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 30.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (data[0] == "error") {
                        Alert(
                          context: context,
                          title: "Error",
                          desc: data[1].toString(),
                          type: AlertType.error,
                        ).show();
                      }
                    },
                    color: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    elevation: 10.0,
                    minWidth: double.infinity,
                    child: const Text("Get data! 📈"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
