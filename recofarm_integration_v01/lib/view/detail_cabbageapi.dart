import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_recofarm_app/model/api_chart_model.dart';
import 'package:new_recofarm_app/model/year_api_chart_model.dart';
import 'package:new_recofarm_app/vm/napacabbage_price_api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

/*
 
  Description : 배추 거래에 관한 상세 내용을 차트로 보여주는 페이지 
  Date        : 2024-04-17 13:32
  Author      : lcy
  Updates     : 
  Detail      : - 

*/

class DetailCabbage extends StatefulWidget {
  const DetailCabbage({super.key});

  @override
  State<DetailCabbage> createState() => _DetailCabbageState();
}

class _DetailCabbageState extends State<DetailCabbage> {

  late DateTime chosenDateTime;

  late List<ChartModel> chartData;
  List<Map<String,double>> chartApiModel = [];
  
  TooltipBehavior tooltipBehavior = TooltipBehavior(enable : true);

  final NapaCabbageAPI cabbageController = Get.put(NapaCabbageAPI());

  @override
  void initState() {
    super.initState();
    chosenDateTime = DateTime.now();
    
    chartData = [];

    cabbageController.fetchXmlData();
    cabbageController.yearlySalesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '배추 가격 현황',
          style: TextStyle(
            fontSize: 35
          ),
        ),
        backgroundColor: Colors.amber[100],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => datePicker(),
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: Text('${chosenDateTime.toString().substring(0,10)} 기준'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                    ),
                    IconButton(
                      onPressed: () => loadAction(),
                      icon: const Icon(Icons.replay_outlined),
                    )
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: SfCartesianChart(
                  key: ValueKey(DateTime.now().millisecondsSinceEpoch),  // 데이터가 갱신될 때마다 새로운 키를 생성
                  title: const ChartTitle(
                    text: '서울가락도매 배추 거래량'
                  ),
                  // 범례
                  legend: const Legend(
                    isVisible: true,
                    isResponsive: false,
                  ),
                  tooltipBehavior: tooltipBehavior,
                  series: [
                    // Series에 따라 차트 모양이 변경된다.
                    LineSeries<ChartModel, int>(
                      color: Theme.of(context).colorScheme.primary,
                      dataSource: chartData,
                      xValueMapper: (ChartModel chartModel, _ ) => chartModel.date,
                      yValueMapper: (ChartModel chartModel, _ ) => chartModel.weight,
                      // Data의 실제값을 차트에서 나타낸다.
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                      enableTooltip: true,
                      legendItemText: '일일 거래량',
                    ),
                  ],
                  // x축을 category로 표현, xlab
                  primaryXAxis: const CategoryAxis(
                    title: AxisTitle(
                      text: '날짜'
                    ),
                  ),
                  // y축을 숫자로 표현, ylab
                  primaryYAxis: const NumericAxis(
                    title: AxisTitle(
                      text: '거래량(단위 : t(톤))'
                    ),
                    // minimum: minimumY,
                    // maximum: maximumY,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              GetBuilder<NapaCabbageAPI>(
                builder: (controller) {
                  return SfCartesianChart(
                // key: ValueKey(DateTime.now().millisecondsSinceEpoch),  // 데이터가 갱신될 때마다 새로운 키를 생성
                title: const ChartTitle(
                  text: '연도별 봄배추(10kg 그물망) 평균 가격 '
                ),
                // 범례
                legend: const Legend(
                  isVisible: true,
                  isResponsive: false,
                ),
                tooltipBehavior: tooltipBehavior,
                series: [
                  // Series에 따라 차트 모양이 변경된다.
                  LineSeries<YearChart, int>(
                    color: Theme.of(context).colorScheme.primary,
                    dataSource: cabbageController.chartData2,
                    xValueMapper: (YearChart yearChart, _ ) => yearChart.year,
                    yValueMapper: (YearChart yearChart, _ ) => yearChart.price,
                    // Data의 실제값을 차트에서 나타낸다.
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                    ),
                    enableTooltip: true,
                    legendItemText: '연도별 평균가격',
                  ),
                ],
                // x축을 category로 표현, xlab
                primaryXAxis: const CategoryAxis(
                  title: AxisTitle(
                    text: '연도'
                  ),
                ),
                // y축을 숫자로 표현, ylab
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(
                    text: '평균 가격 (단위 : 원)'
                  ),
                ),
              );
                },
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 200,
                  child: Swiper(
                    loop: cabbageController.loopStatus,
                    itemCount: cabbageController.apiModel.length,
                    pagination: const SwiperPagination(),
                    control: const SwiperControl(),
                    autoplay: true,
                    autoplayDelay: 5000,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              color: Theme.of(context).colorScheme.secondaryContainer
                            ),
                            width: MediaQuery.of(context).size.width - 50,
                            height: 200,
                            child: cabbageController.apiModel.isNotEmpty?
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 10, 0, 7),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${cabbageController.apiModel[index]['date']!.substring(0,4)} - ${cabbageController.apiModel[index]['date']!.substring(4,6)} - ${cabbageController.apiModel[index]['date']!.substring(6,8)}',
                                        style: const TextStyle(
                                          fontSize: 18
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        backgroundImage: AssetImage('images/Cabbage.png'),
                                        backgroundColor: Colors.white,
                                        radius: 40,
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '${cabbageController.apiModel[index]['marketName']}',
                                            style: const TextStyle(
                                              fontSize: 17
                                            ),
                                          ),
                                          Text(
                                            '${cabbageController.apiModel[index]['sClassName']}'
                                          ),
                                          Text(
                                            '${cabbageController.apiModel[index]['weight']} 당 ',
                                            style: const TextStyle(
                                              fontSize: 17
                                            ),
                                          ),
                                          Text(
                                            '평균 ${cabbageController.apiModel[index]['price']}원',
                                            style: const TextStyle(
                                              fontSize: 19
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                            : const Text('데이터가 존재하지 않습니다.')
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  datePicker() {
    DateTime now = DateTime.now();

    Get.dialog(
      AlertDialog(
        title: const Text('날짜 선택'),
        content: SizedBox(
          height: 150,
          width: 300,
          child: CupertinoDatePicker(
            // PickerView의 시작 날짜
            initialDateTime: chosenDateTime,
            dateOrder: DatePickerDateOrder.ymd,
            maximumDate: now,
            maximumYear: now.year,
            minimumYear: now.year - 2,
            mode: CupertinoDatePickerMode.date,
            // showDayOfWeek: true,
            onDateTimeChanged: (value) {
              chosenDateTime = value;
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              loadAction();
            },
            child: const Text('확인'))
        ],
      )
    );
  }

  loadAction() async {
    loadingDialog(true);
    await chartXmlData('${chosenDateTime.year}${chosenDateTime.month.toString().padLeft(2, '0')}${chosenDateTime.day.toString().padLeft(2,'0')}');
    loadingDialog(false);
    setState(() {});
  }

  Future<void> chartXmlData(String date) async {

    print('입력 날짜 : $date');
    chartApiModel.clear();
    double parseDate = double.parse(date) - 7;

    for(int i=0; i<7; i++) {
      print('시작 : ${parseDate.toString().substring(0,8)}');
      final url = Uri.parse('http://211.237.50.150:7080/openapi/b2c4c81d3e3b685b913bd27e183618c306a179d340cb05593d06ace9746b6270/xml/Grid_20220817000000000620_1/1/10?DATES=${parseDate.toString().substring(0,8)}&MCLASSNAME=배추&MARKETNAME=서울가락도매');
      final response = await http.get(url);

      double allWeight = 0;

      if (response.statusCode == 200) {

        final document = xml.XmlDocument.parse(response.body);

        final rootElement = document.rootElement;
        final items = rootElement.findAllElements('row');

        if(items.isNotEmpty) {
          
          for (final item in items) {
            final weight = item.findElements('UNITNAME').single.innerText;
            final sumAmt = item.findElements('SUMAMT').single.innerText;

            List<String> parts = weight.split(' ');
            RegExp regex = RegExp(r'\d+(\.\d+)?');
            Match? match = regex.firstMatch(parts[0]);
            if(match != null) {
              double weigh1t = double.parse(match.group(0)!);
              allWeight += weigh1t * double.parse(sumAmt);
            }
          }

          chartApiModel.add({
            'date' : parseDate,
            'allWeight' : allWeight
          });

          print(chartApiModel.toString());
        }

      }else {
        print('Failed to fetch XML data: ${response.statusCode}');
      }
      parseDate = parseDate + 1;
      print('끝 : ${parseDate}');
    }

    if(chartApiModel.isEmpty) {
      print('dataisEmpty\!');
      // Get.back();
      await noDataDialog();
      return;
    }
     
    chartData.clear();

    // maximumY = 0;
    for(int i=0; i<chartApiModel.length; i++) {
      print('length: ${chartApiModel.length}');

      chartApiModel[i]['allWeight']!.round();
      chartData.add(
        ChartModel(date: int.parse(chartApiModel[i]['date'].toString().substring(0,8)), weight: chartApiModel[i]['allWeight']!.round())
      );
    }
  }

  loadingDialog(bool status) {
    if(!status) {
      Get.back();
      return;
    }
    
    Get.defaultDialog(
      title: '알림',
      middleText: '불러오는 중 입니다.. 잠시만 기다려 주세요',
      barrierDismissible: false
    );

  }

  noDataDialog() async {
    await Get.defaultDialog(
      title: '알림',
      middleText: '날짜에 해당하는 데이터가 없습니다!',
      actions: [
        ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('확인')
        )
      ]
    );
  }
}