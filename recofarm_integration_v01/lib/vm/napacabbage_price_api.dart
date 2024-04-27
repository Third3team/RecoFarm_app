import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_recofarm_app/model/year_api_chart_model.dart';
import 'package:xml/xml.dart' as xml;

/*
  Description : API 정보를 불러오는 VM
  Date        : 2024.04.18 Thr
  Author      : LCY 
  Updates     : 
	  2024.04.25 Thr by LCY
		  -  code review :: 주석 

*/

class NapaCabbageAPI extends GetxController {

  /*
    사용하는 API가 2개 존재

    1. 농림축산식품 공공데이터 포털 - 농산물도매법인별경락가격조회
    2. 농산물 유통 정보(KAMIS) - 연도별 도.소매가격정보

  */

  // 1번 API 정보들의 List
  List<Map<String,String>> apiModel = [];
  // 2번 API 정보들의 List
  List<Map<String,String>> yearModel = [];

  late List<YearChart> chartData2 = [];

  // Swipe의 loop, 맨 처음 Swipe를 구성할때 계속 돌아가는 경우를 방지
  bool loopStatus = false;


  // 1번 API : 농림축산식품 공공데이터 포털 - 농산물도매법인별경락가격조회
  Future<void> fetchXmlData() async {
    // home_view_page의 Swipe 내용
    // API 요청
    final url = Uri.parse('http://211.237.50.150:7080/openapi/b2c4c81d3e3b685b913bd27e183618c306a179d340cb05593d06ace9746b6270/xml/Grid_20220817000000000620_1/1/10?DATES=20231120&MCLASSNAME=배추');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      
      apiModel.clear();

      // xml 형식 data 변환
      final document = xml.XmlDocument.parse(response.body);

      // 가장 상위에 있는 엘리먼트 => 루트 엘리먼트
      final rootElement = document.rootElement;
      // 엘리먼트들 중 row란 이름의 엘리먼트를 가져옴
      final items = rootElement.findAllElements('row');

      // 데이터가 없을 경우
      if(items.isEmpty) {
        return;
      }

      // 향상된 for문을 통해 items의 개수만큼 반복
      for (final item in items) {
        // <DATES> 엘리먼트의 data
        final date = item.findElements('DATES').single.innerText;
        // <SCLASSNAME> 엘리먼트의 data
        final sClassName = item.findElements('SCLASSNAME').single.innerText;
        // <AVGPRICE> 엘리먼트의 data
        final price = item.findElements('AVGPRICE').single.innerText;
        // <MARKETNAME> 엘리먼트의 data
        final marketName = item.findElements('MARKETNAME').single.innerText;
        // <UNITNAME> 엘리먼트의 data
        final weight = item.findElements('UNITNAME').single.innerText;

        // print('날짜 : $date, 품종 : $sClassName, 가격 : $price, 마켓이름 : $marketName, 무게 : $weight');
        
        apiModel.add(
          {
            'date' : date,
            'sClassName' : sClassName,
            'price' : price,
            'marketName' : marketName,
            'weight' : weight,
          }
        );
      }
      
    }else {
      print('실패 : ${response.statusCode}');
    }

    loopStatus = true;
    update();
  }

  // 2번 API : 농산물 유통 정보(KAMIS) - 연도별 도.소매가격정보
  Future<void> yearlySalesList() async {
    // API 요청
    final url = Uri.parse('https://www.kamis.or.kr/service/price/xml.do?action=yearlySalesList&p_yyyy=2024&p_period=3&p_itemcategorycode=200&p_itemcode=211&p_kindcode=01&p_graderank=2&p_countycode=1101&p_convert_kg_yn=N&p_cert_key=996165d6-29e7-4d50-9078-8e1439ad545f&p_cert_id=4276&p_returntype=xml');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // xml 형식 data 변환
      final document = xml.XmlDocument.parse(response.body);

      // 1. 문서에서 모든 <price> 엘리먼트를 찾는다.
      // 2. 각 <price> 엘리먼트에 대해 내부에서 <item> 엘리먼트를 찾는다.
      // 3. 1,2번을 반복하여 요청한 Data의 모든 <item> 엘리먼트들을 담은 하나의 컬렉션을 반환.
      final items = document.findAllElements('price').expand((price) => price.findElements('item'));
      
      if(items.isEmpty) {
        return;
      }

      chartData2.clear();

      // item에는 Data가 여러개 있지만, 가장 최상단의 4개만 불러옴.
      for (final item in items.take(4)) {
        // Chart, X : 연도, Y : 가격
        
        // 연도
        final year = item.findElements('div').single.innerText;
        // 평균 가격
        final avgData = item.findElements('avg_data').single.innerText;
        // 최대 가격
        // final maxData = item.findElements('max_data').single.innerText;
        // // 최소 가격
        // final minData = item.findElements('min_data').single.innerText;
        // // 표준편차
        // final stddevData = item.findElements('stddev_data').single.innerText;
        // // 변동계수
        // final cvData = item.findElements('cv_data').single.innerText;
        // // 진폭계수
        // final afData = item.findElements('af_data').single.innerText;

        // print('연도 : $year, 평균가 : $avgData, 최대가 : $maxData, 최소가 : $minData, 표준편차 : $stddevData, 변동계수 : $cvData, 진폭계수 : $afData');

        chartData2.add(
          YearChart(year: int.parse(year), price: int.parse(avgData.replaceAll(',', '')))
        );
      }
      
      // A data, B data 두개의 데이터를 year를 기준으로 오름차순 정렬한다.
      chartData2.sort((a, b) => a.year.compareTo(b.year));
      
    }else {
      print('실패 : ${response.statusCode}');
    }
 
    update();
  }




}