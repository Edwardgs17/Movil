import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class GraphWidget extends StatefulWidget {
  final List<double> data;

  const GraphWidget({Key key, this.data}) : super(key: key);

  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  _onSelectionChanged(SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var time;
    final measures = <String, double>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum;
      selectedDatum.forEach((SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum;
      });
    }

    print(time);
    print(measures);
    print("bebe");

    // Request a build.
    //setState(() {
    //_time = time;
    //_measures = measures;
    //});
  }


  @override
  Widget build(BuildContext context) {
    List<Series<double, num>> series = [
      Series<double, int>(
        id: 'Invertido',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (value, index) => index,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 3,
      )
    ];

    return new LineChart(
      series,
      defaultRenderer: new LineRendererConfig(
        includeArea: true,
        stacked: true,
      ),
      animate: true,
      selectionModels: [
        SelectionModelConfig(
          type: SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      domainAxis: NumericAxisSpec(
          tickProviderSpec: StaticNumericTickProviderSpec([
            TickSpec(0, label: '01'),
            TickSpec(4, label: '05'),
            TickSpec(9, label: '10'),
            TickSpec(14, label: '15'),
            TickSpec(19, label: '20'),
            TickSpec(24, label: '25'),
            TickSpec(29, label: '30'),
          ]),
          renderSpec: GridlineRendererSpec(
              tickLengthPx: 0,
              labelOffsetFromAxisPx: 12,
              labelStyle: TextStyleSpec(
                fontSize: 13,
              ),
              lineStyle: LineStyleSpec(
                thickness: 1,
                color: MaterialPalette.gray.shadeDefault,
              ))),
      primaryMeasureAxis: NumericAxisSpec(
        tickProviderSpec: BasicNumericTickProviderSpec(
          desiredTickCount: 5,
        ),
        renderSpec: GridlineRendererSpec(
            labelStyle: TextStyleSpec(fontSize: 13),
            lineStyle: LineStyleSpec(
                thickness: 1, color: MaterialPalette.gray.shadeDefault)),
      ),
    );
  }
}
