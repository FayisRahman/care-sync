import 'package:caresync/constants/constants.dart';
import 'package:caresync/form_response/form_response.dart';
import 'package:caresync/networking/authentication.dart';
import 'package:caresync/widgets/expanded_button.dart';
import 'package:caresync/widgets/expanding_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../constants/models.dart';
import '../../networking/cloud_storage.dart';
import '../../widgets/drawer.dart';

class GraphData {
  GraphData(this.year, this.sales);

  final String year;
  final double sales;
}

class LabReport extends StatefulWidget {
  static const String id = "Lab Reports";

  LabReport({super.key});

  @override
  State<LabReport> createState() => _LabReportState();
}

class _LabReportState extends State<LabReport> {
  final List<List<GraphData>> data = [];

  List<ItemData> items = [];
  List<List<String>> urls = [];
  List<List<String>> dates = [];
  List<List<ExpandedButton>> pdfButtons = [];

  List<ExpandableCard> cards = [];
  List<CartesianSeries<GraphData, String>> series = [];
  List<Category> categories = [];
  List<Category> mainCategoryList = [];
  String pno = "";

  int? _expandedIndex;
  int _prevExpandedIndex = 0;

  int length = 0;

  GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();

  LineSeries<GraphData, String> getLineSeriesData(int index) {
    return LineSeries<GraphData, String>(
      animationDuration: 500,
      dataSource: data[index],
      xValueMapper: (GraphData sales, _) => sales.year,
      yValueMapper: (GraphData sales, _) => sales.sales,
      name: items[index].itemName,
      pointColorMapper: (GraphData sales, _) {
        return sales.sales < categories[index].minVal! ||
                sales.sales > categories[index].maxVal!
            ? Colors.red
            : Colors.green;
      },
      // Enable data label
      dataLabelSettings: const DataLabelSettings(isVisible: true),
    );
  }

  void expandedView(int index, int prevIndex) {
    cards[prevIndex] = ExpandableCard(
      expandedChildren: pdfButtons[prevIndex],
      mainContext: context,
      item: items[prevIndex],
      onTap: () {
        _toggleExpansion(prevIndex);
        series = [
          getLineSeriesData(prevIndex),
        ];
        setState(() {
          series;
        });
      },
    );

    cards[index] = ExpandableCard(
      expandedChildren: pdfButtons[index],
      mainContext: context,
      item: items[index],
      onTap: () {
        _toggleExpansion(index);
        series = [
          getLineSeriesData(index),
        ];
        setState(() {
          series;
        });
      },
    );
  }

  void _toggleExpansion(int index) {
    _prevExpandedIndex = _expandedIndex ?? 0;

    setState(() {
      if (_expandedIndex != null && _expandedIndex != index) {
        // Collapse the previously expanded item.
        items[_expandedIndex!].isExpanded = false;
      }
      items[index].isExpanded = !items[index].isExpanded;
      _expandedIndex = items[index].isExpanded ? index : null;
    });

    expandedView(index, _prevExpandedIndex);
    setState(() {
      cards;
    });
  }

  void setCards() {
    cards.clear();
    for (int i = 0; i < items.length; i++) {
      cards.add(
        ExpandableCard(
          expandedChildren: pdfButtons[i],
          item: items[i],
          onTap: () {
            _toggleExpansion(i);
            series = [
              getLineSeriesData(i),
            ];
            setState(() {
              series;
            });
          },
          mainContext: context,
        ),
      );
    }
    setState(() {
      cards;
    });
  }

  void addItem(Map<String, dynamic> vals, String url, String date) {
    for (String category in vals.keys) {
      if (mainCategoryList.any((e) => e.name == category)) {
        if (categories.any((e) => e.name == category)) {
          int index = categories.indexWhere((e) => e.name == category);
          data[index].add(GraphData(date, vals[category]!.toDouble()));
          pdfButtons[index].add(
            ExpandedButton(
              title: date,
              url: url,
            ),
          );
        } else {
          categories
              .add(mainCategoryList.firstWhere((e) => e.name == category));
          pdfButtons.add([
            ExpandedButton(
              title: date,
              url: url,
            ),
          ]);
          data.add([GraphData(date, vals[category]!.toDouble())]);
          items.add(
              ItemData(items.length - 1, items.length - 1, false, category));
        }
      }
    }
  }

  Future<void> setGraphData() async {
    List<String> itemsData = [];
    int index = 0;
    double value = 0;
    int dateMilli = 0;
    DateTime date = DateTime.now();
    int idx = 0;
    dynamic result = await CloudStorage.getUploads(pno, context);
    length = result.length;
    for (var doc in result) {
      Map<String, dynamic> vals = doc["vals"];
      dateMilli = int.parse(doc["filename"].toString());
      date = DateTime.fromMillisecondsSinceEpoch(dateMilli);
      addItem(vals, doc["url"], kGetDate(date));
    }

    debugPrint("successful ${itemsData.length}");

    setState(() {
      data;
      items;
    });
  }

  Future<void> initialise() async {
    mainCategoryList = await CloudStorage.getCategories();
    print(categories);
    await setGraphData();
    if (length == 0) return;
    setCards();
    series = [getLineSeriesData(0)];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pno = Provider.of<FormResponse>(context, listen: false).pno;
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          widthFactor: 2,
          child: Text("Lab Reports"),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const DrawerDash(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SfCartesianChart(
                primaryXAxis: const CategoryAxis(
                  labelRotation: -70,
                  interval: 0.5,
                ),
                // Chart title
                title: const ChartTitle(text: 'Sugar Level'),
                // Enable legend
                legend: const Legend(isVisible: true),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: series,
              ),
              const SizedBox(
                height: 20,
              ),
              ...cards,
            ],
          ),
        ),
      ),
    );
  }
}
