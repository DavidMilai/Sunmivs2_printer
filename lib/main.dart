import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage(title: 'Flutter Demo Home Page'));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _bindingPrinter().then((bool? isBind) async {
      print("isBind: $isBind");
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        print("printer version: $version");
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        print("printer serial: $serial");

        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind!;
      });
    });
  }

  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  void _print() async {
    print("less go");
    await SunmiPrinter.startTransactionPrint(true);

    await SunmiPrinter.setAlignment(SunmiPrintAlign.RIGHT); // Right align
    await SunmiPrinter.printText('Align right');

    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT); // Left align
    await SunmiPrinter.printText('Align left');

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER); // Center align
    await SunmiPrinter.printText('Align center');

    await SunmiPrinter.lineWrap(2); // Jump 2 lines

    await SunmiPrinter.setFontSize(SunmiFontSize.XL); // Set font to very large
    await SunmiPrinter.printText('Very Large font!');
    await SunmiPrinter.resetFontSize(); // Reset font to medium size

    await SunmiPrinter.setCustomFontSize(12); // SET CUSTOM FONT 12
    await SunmiPrinter.printText('Custom font size!!!');
    await SunmiPrinter.resetFontSize(); // Reset font to medium size

    await SunmiPrinter.printQRCode(
        'https://github.com/brasizza/sunmi_printer'); // PRINT A QRCODE
    await SunmiPrinter.submitTransactionPrint(); // SUBMIT and cut paper
    await SunmiPrinter.exitTransactionPrint(true); // Close the transaction
    print("I'm done");
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Text("Print binded: " + printBinded.toString()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text("Paper size: " + paperSize.toString()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text("Serial number: " + serialNumber),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text("Printer version: " + printerVersion),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.initPrinter();
                          await SunmiPrinter.startTransactionPrint(true);
                          await SunmiPrinter.printQRCode(
                              'https://github.com/brasizza/sunmi_printer');
                          await SunmiPrinter.lineWrap(2);
                          await SunmiPrinter.exitTransactionPrint(true);
                        },
                        child: const Text('Print qrCode')),
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.initPrinter();
                          await SunmiPrinter.startTransactionPrint(true);
                          await SunmiPrinter.printBarCode('1234567890',
                              barcodeType: SunmiBarcodeType.CODE128,
                              textPosition: SunmiBarcodeTextPos.TEXT_UNDER,
                              height: 20);
                          await SunmiPrinter.lineWrap(2);
                          await SunmiPrinter.exitTransactionPrint(true);
                        },
                        child: const Text('Print barCode')),
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.initPrinter();
                          await SunmiPrinter.startTransactionPrint(true);
                          await SunmiPrinter.line();
                          await SunmiPrinter.lineWrap(2);
                          await SunmiPrinter.exitTransactionPrint(true);
                        },
                        child: const Text('Print line')),
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.lineWrap(2);
                        },
                        child: const Text('Wrap line')),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.initPrinter();
                          await SunmiPrinter.startTransactionPrint(true);
                          await SunmiPrinter.printText('Hello I\'m bold',
                              style: SunmiStyle(bold: true));
                          await SunmiPrinter.lineWrap(2);
                          await SunmiPrinter.exitTransactionPrint(true);
                        },
                        child: const Text('Bold Text')),
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.initPrinter();
                          await SunmiPrinter.startTransactionPrint(true);
                          await SunmiPrinter.printText('Very small!',
                              style: SunmiStyle(fontSize: SunmiFontSize.XS));
                          await SunmiPrinter.lineWrap(2);

                          await SunmiPrinter.exitTransactionPrint(true);
                        },
                        child: const Text('Very small font')),
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.initPrinter();
                          await SunmiPrinter.startTransactionPrint(true);
                          await SunmiPrinter.printText('Very small!',
                              style: SunmiStyle(fontSize: SunmiFontSize.SM));
                          await SunmiPrinter.lineWrap(2);
                          await SunmiPrinter.exitTransactionPrint(true);
                        },
                        child: const Text('Small font')),
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.initPrinter();
                          await SunmiPrinter.startTransactionPrint(true);
                          await SunmiPrinter.printText('Normal font',
                              style: SunmiStyle(fontSize: SunmiFontSize.MD));

                          await SunmiPrinter.lineWrap(2);
                          await SunmiPrinter.exitTransactionPrint(true);
                        },
                        child: const Text('Normal font')),
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.initPrinter();
                          await SunmiPrinter.printText('Large font',
                              style: SunmiStyle(fontSize: SunmiFontSize.LG));

                          await SunmiPrinter.lineWrap(2);
                          await SunmiPrinter.exitTransactionPrint(true);
                        },
                        child: const Text('Large font')),
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.initPrinter();
                          await SunmiPrinter.startTransactionPrint(true);
                          await SunmiPrinter.setFontSize(SunmiFontSize.XL);
                          await SunmiPrinter.printText('Very Large font!');
                          await SunmiPrinter.resetFontSize();
                          await SunmiPrinter.lineWrap(2);
                          await SunmiPrinter.exitTransactionPrint(true);
                        },
                        child: const Text('Very large font')),
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.initPrinter();
                          await SunmiPrinter.startTransactionPrint(true);
                          await SunmiPrinter.setCustomFontSize(13);
                          await SunmiPrinter.printText('Very Large font!');
                          await SunmiPrinter.resetFontSize();
                          await SunmiPrinter.lineWrap(2);
                          await SunmiPrinter.exitTransactionPrint(true);
                        },
                        child: const Text('Custom size font')),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await SunmiPrinter.initPrinter();
                        await SunmiPrinter.startTransactionPrint(true);
                        await SunmiPrinter.printText('Align right',
                            style: SunmiStyle(align: SunmiPrintAlign.RIGHT));
                        await SunmiPrinter.lineWrap(2);
                        await SunmiPrinter.exitTransactionPrint(true);
                      },
                      child: const Text('Align right')),
                  ElevatedButton(
                      onPressed: () async {
                        await SunmiPrinter.initPrinter();

                        await SunmiPrinter.startTransactionPrint(true);
                        await SunmiPrinter.printText('Align left',
                            style: SunmiStyle(align: SunmiPrintAlign.LEFT));

                        await SunmiPrinter.lineWrap(2);
                        await SunmiPrinter.exitTransactionPrint(true);
                      },
                      child: const Text('Align left')),
                  ElevatedButton(
                    onPressed: () async {
                      await SunmiPrinter.initPrinter();

                      await SunmiPrinter.startTransactionPrint(true);
                      await SunmiPrinter.printText(
                        'Align center/ LARGE TEXT AND BOLD',
                        style: SunmiStyle(
                            align: SunmiPrintAlign.CENTER,
                            bold: true,
                            fontSize: SunmiFontSize.LG),
                      );

                      await SunmiPrinter.lineWrap(2);
                      await SunmiPrinter.exitTransactionPrint(true);
                    },
                    child: const Text('Align center'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await SunmiPrinter.initPrinter();

                      String url =
                          'https://avatars.githubusercontent.com/u/14101776?s=100';
                      // convert image to Uint8List format
                      Uint8List byte =
                          (await NetworkAssetBundle(Uri.parse(url)).load(url))
                              .buffer
                              .asUint8List();
                      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
                      await SunmiPrinter.startTransactionPrint(true);
                      await SunmiPrinter.printImage(byte);
                      await SunmiPrinter.lineWrap(2);
                      await SunmiPrinter.exitTransactionPrint(true);
                    },
                    child: Column(
                      children: [
                        Image.network(
                            'https://avatars.githubusercontent.com/u/14101776?s=100'),
                        const Text('Print this image from WEB!')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.cut();
                        },
                        child: const Text('CUT PAPER')),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.initPrinter();

                          await SunmiPrinter.startTransactionPrint(true);
                          await SunmiPrinter.setAlignment(
                              SunmiPrintAlign.CENTER);
                          await SunmiPrinter.line();
                          await SunmiPrinter.printText('Payment receipt');
                          await SunmiPrinter.printText(
                              'Using the old way to bold!');
                          await SunmiPrinter.line();

                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'Name',
                                width: 12,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: 'Qty',
                                width: 6,
                                align: SunmiPrintAlign.CENTER),
                            ColumnMaker(
                                text: 'UN',
                                width: 6,
                                align: SunmiPrintAlign.RIGHT),
                            ColumnMaker(
                                text: 'TOT',
                                width: 6,
                                align: SunmiPrintAlign.RIGHT),
                          ]);

                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'Fries',
                                width: 12,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: '4x',
                                width: 6,
                                align: SunmiPrintAlign.CENTER),
                            ColumnMaker(
                                text: '3.00',
                                width: 6,
                                align: SunmiPrintAlign.RIGHT),
                            ColumnMaker(
                                text: '12.00',
                                width: 6,
                                align: SunmiPrintAlign.RIGHT),
                          ]);

                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'Strawberry',
                                width: 12,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: '1x',
                                width: 6,
                                align: SunmiPrintAlign.CENTER),
                            ColumnMaker(
                                text: '24.44',
                                width: 6,
                                align: SunmiPrintAlign.RIGHT),
                            ColumnMaker(
                                text: '24.44',
                                width: 6,
                                align: SunmiPrintAlign.RIGHT),
                          ]);

                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'Soda',
                                width: 12,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: '1x',
                                width: 6,
                                align: SunmiPrintAlign.CENTER),
                            ColumnMaker(
                                text: '1.99',
                                width: 6,
                                align: SunmiPrintAlign.RIGHT),
                            ColumnMaker(
                                text: '1.99',
                                width: 6,
                                align: SunmiPrintAlign.RIGHT),
                          ]);

                          await SunmiPrinter.line();
                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'TOTAL',
                                width: 25,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: '38.43',
                                width: 5,
                                align: SunmiPrintAlign.RIGHT),
                          ]);

                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'ARABIC TEXT',
                                width: 15,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: 'اسم المشترك',
                                width: 15,
                                align: SunmiPrintAlign.LEFT),
                          ]);

                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'اسم المشترك',
                                width: 15,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: 'اسم المشترك',
                                width: 15,
                                align: SunmiPrintAlign.LEFT),
                          ]);

                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'RUSSIAN TEXT',
                                width: 15,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: 'Санкт-Петербу́рг',
                                width: 15,
                                align: SunmiPrintAlign.LEFT),
                          ]);
                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'Санкт-Петербу́рг',
                                width: 15,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: 'Санкт-Петербу́рг',
                                width: 15,
                                align: SunmiPrintAlign.LEFT),
                          ]);

                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'CHINESE TEXT',
                                width: 15,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: '風俗通義',
                                width: 15,
                                align: SunmiPrintAlign.LEFT),
                          ]);
                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: '風俗通義',
                                width: 15,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: '風俗通義',
                                width: 15,
                                align: SunmiPrintAlign.LEFT),
                          ]);

                          await SunmiPrinter.setAlignment(
                              SunmiPrintAlign.CENTER);
                          await SunmiPrinter.line();
                          await SunmiPrinter.bold();
                          await SunmiPrinter.printText('Transaction\'s Qrcode');
                          await SunmiPrinter.resetBold();
                          await SunmiPrinter.printQRCode(
                              'https://github.com/brasizza/sunmi_printer');
                          await SunmiPrinter.lineWrap(2);
                          await SunmiPrinter.exitTransactionPrint(true);
                        },
                        child: const Text('TICKET EXAMPLE')),
                  ]),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _print,
        tooltip: 'Print',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
