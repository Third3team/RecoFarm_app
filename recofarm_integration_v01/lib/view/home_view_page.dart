import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_recofarm_app/model/user_area.dart';
import 'package:new_recofarm_app/view/detail_cabbageapi.dart';
import 'package:new_recofarm_app/view/drawer_widget.dart';
import 'package:new_recofarm_app/view/predict_yield.dart';
import 'package:new_recofarm_app/vm/napacabbage_price_api.dart';
import 'package:new_recofarm_app/vm/user_firebase.dart';
import 'package:new_recofarm_app/vm/user_mysql.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 
  Description : 사용자에게 보여줄 메인 화면입니다.
  Date        : 2024-04-17 13:32
  Author      : lcy
  Updates     : 
  Detail      : - 

*/

class HomeViewPage extends StatelessWidget {
  String userId = '';

  initSharedPreferences() async {
    final pref = await SharedPreferences.getInstance();
    userId = pref.getString('userId')!;
  }

  HomeViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    initSharedPreferences();
    final NapaCabbageAPI cabbageController = Get.put(NapaCabbageAPI());
    cabbageController.fetchXmlData();

    final Future<List<UserArea>> areaList = UserMySQL().getAreaData(userId);

    return FutureBuilder(
      future: initSharedPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Reco Farm'),
              ),
              drawer: DrawerWidget(userId: userId),
              body: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: UserFirebase().selectUserEqaulID(userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: SizedBox(
                                width: 300,
                                height: 400,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${snapshot.data!.docs[0]['userName']}  ',
                                            style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text(
                                            '님의 관심 농작지',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300,
                                      height: 300,
                                      child: FutureBuilder(
                                        future: areaList,
                                        builder: (context, snapshot) {
                                          print(areaList);
                                          if(snapshot.hasData && snapshot.data!.isNotEmpty) {
                                            print('epdlxj');
                                            List<UserArea> areas = snapshot.data!;
                                            return Swiper(
                                              itemBuilder: (context, index) {
                                                // Swiper 배경색
                                                Color? backgroundColor;
                                                backgroundColor = index % 2 == 0 ? 
                                                Theme.of(context).colorScheme.secondaryContainer : 
                                                Theme.of(context).colorScheme.errorContainer;
                                                return Container(
                                                  color: backgroundColor,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          SizedBox(
                                                            width: 300,
                                                            height: 80,
                                                            child: Text(
                                                              areas[index].area_address,
                                                              style: const TextStyle(
                                                                fontSize: 30,
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          const Positioned(
                                                            left: 190,
                                                            top: -10,
                                                            child: Text(
                                                              '* 농작지 이름',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors.red
                                                              ),
                                                            )
                                                          )
                                                        ],
                                                      ),
                                                      Stack(
                                                        children: [
                                                          SizedBox(
                                                            width: 300,
                                                            height: 80,
                                                            child: Text(
                                                              '${areas[index].area_size}',
                                                              style: const TextStyle(
                                                                fontSize: 30,
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          const Positioned(
                                                            left: 190,
                                                            top: -5,
                                                            child: Text(
                                                              '* 농작지 면적',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors.red
                                                              ),
                                                            )
                                                          )
                                                        ],
                                                      ),
                                                      Stack(
                                                        children: [
                                                          SizedBox(
                                                            width: 300,
                                                            height: 80,
                                                            child: Text(
                                                              areas[index].area_product,
                                                              style: const TextStyle(
                                                                fontSize: 30,
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          const Positioned(
                                                            left: 190,
                                                            top: -5,
                                                            child: Text(
                                                              '* 농작지 작물',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors.red
                                                              ),
                                                            )
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              itemCount: areas.length,
                                              pagination: const SwiperPagination(),
                                              );
                                          }
                                          else {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.secondaryContainer,
                                                borderRadius: const BorderRadius.all(Radius.circular(10))
                                              ),
                                              child: Swiper(
                                                itemCount: 1,
                                                loop: false,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Text('아직 관심 농작지를 \n등록하지 않았습니다!'),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                        child: TextButton(
                                                          onPressed: () {
                                                            // Map으로 연결시켜 등록하게 한다.
                                                            Get.toNamed("/interestArea");
                                                          },
                                                          child: const Text(
                                                            '등록하기',
                                                            style: TextStyle(
                                                              color: Colors.blue
                                                            ),
                                                          )
                                                        )
                                                      )
                                                    ],
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                              child: Container(
                                color: const Color.fromARGB(255, 222, 216, 216),
                                width: MediaQuery.of(context).size.width,
                                height: 5,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GetBuilder<NapaCabbageAPI>(
                                  builder: (cabbageController) {
                                    return Column(
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 15),
                                          child: Text(
                                            '오늘의 배추가격은?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          height: 200,
                                          child: Swiper(
                                            loop: cabbageController.loopStatus,
                                            itemCount: cabbageController
                                                .apiModel.length,
                                            pagination:
                                                const SwiperPagination(),
                                            control: const SwiperControl(),
                                            autoplay: true,
                                            autoplayDelay: 5000,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .secondaryContainer),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              50,
                                                      height: 200,
                                                      child:
                                                          cabbageController
                                                                  .apiModel
                                                                  .isNotEmpty
                                                              ? Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          15,
                                                                          10,
                                                                          0,
                                                                          0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                            '${cabbageController.apiModel[index]['date']!.substring(0, 4)} - ${cabbageController.apiModel[index]['date']!.substring(4, 6)} - ${cabbageController.apiModel[index]['date']!.substring(6, 8)}',
                                                                            style:
                                                                                const TextStyle(fontSize: 25),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const CircleAvatar(
                                                                          backgroundImage:
                                                                              AssetImage('images/Cabbage.png'),
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                          radius:
                                                                              40,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              50,
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            Text(
                                                                              '${cabbageController.apiModel[index]['marketName']}',
                                                                              style: const TextStyle(fontSize: 20),
                                                                            ),
                                                                            Text(
                                                                              '${cabbageController.apiModel[index]['sClassName']}',
                                                                              style: const TextStyle(fontSize: 20),
                                                                            ),
                                                                            Text(
                                                                              '${cabbageController.apiModel[index]['weight']} 당 ',
                                                                              style: const TextStyle(fontSize: 24),
                                                                            ),
                                                                            Text(
                                                                              '평균 ${cabbageController.apiModel[index]['price']}원',
                                                                              style: const TextStyle(fontSize: 24),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
                                                              : const Text(
                                                                  '데이터가 존재하지 않습니다.')),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              '출처 : 농림축산식품 공공데이터포털',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            const SizedBox(
                                              width: 100,
                                            ),
                                            TextButton(
                                                onPressed: () => Get.to(
                                                    const DetailCabbage()),
                                                style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.blue),
                                                child: const Text(
                                                  '자세히 보기',
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                )),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                              child: Container(
                                color: const Color.fromARGB(255, 222, 216, 216),
                                width: MediaQuery.of(context).size.width,
                                height: 5,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                '수확량 & 배추가격 예측',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(PredictYield()),
                              child: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                width: 350,
                                height: 70,
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '수확량 예측하기',
                                        style: TextStyle(fontSize: 30),
                                      ),
                                      SizedBox(width: 70),
                                      Icon(Icons.arrow_forward_ios),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 50),
                              child: GestureDetector(
                                onTap: () => print('12312312'),
                                child: Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  width: 350,
                                  height: 70,
                                  child: const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '배추가격 예측하기',
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        SizedBox(width: 60),
                                        Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
