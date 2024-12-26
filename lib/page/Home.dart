import 'package:carrot_market_clone/page/detail.dart';
import 'package:carrot_market_clone/repository/content_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late String _currentLocation;
  late ContentRepository contentRepository;
  final Map<String, String> locationTypeToString = {
    "banyeo": "반여동",
    "taepyeong": "태평동",
    "bokjung": "복정동"
  };

  @override
  void initState() {
    super.initState();

    _currentLocation = 'banyeo';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contentRepository = ContentRepository();
  }

  //appBar 위젯
  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () => {print('클릭')},
        child: PopupMenuButton<String>(
          offset: Offset(0, 35),
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),
          onSelected: (value) => {
            setState(() {
              _currentLocation = value;
            })
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(value: 'banyeo', child: Text('반여동')),
              const PopupMenuItem(value: 'taepyeong', child: Text('태평동')),
              const PopupMenuItem(value: 'bokjung', child: Text('복정동')),
            ];
          },
          child: Row(
            children: [
              Text(
                locationTypeToString[_currentLocation]!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
      shape: Border(
          bottom: BorderSide(
        color: Colors.grey[300]!,
        width: 1,
      )),
      actions: [
        IconButton(onPressed: () => {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () => {}, icon: const Icon(Icons.menu)),
        IconButton(
          onPressed: () => {},
          icon: SvgPicture.asset(
            "assets/svg/bell.svg",
            width: 22,
          ),
        )
      ],
    );
  }

  //화폐단위 포맷 변경
  String moneyFormat(String data) {
    if (data == "무료나눔") {
      return data;
    }
    late String formatData;
    formatData = NumberFormat('###,###,###,###').format(int.parse(data));

    return '${formatData}원';
  }

  Future<List<Map<String, String>>> _loadContents() {
    return contentRepository.getContentsFromLoaction(_currentLocation);
  }

  _makeDataList(List<Map<String, String>> datas) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext _context, int index) {
        return GestureDetector(
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (contenxt) =>
                        DetailContentView(data: datas[index])))
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Hero(
                    tag: datas[index]["cid"]!,
                    child: Image.asset(
                      datas[index]["image"]!,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          datas[index]["title"]!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          datas[index]["location"]!,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 151, 151, 151)),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          moneyFormat(datas[index]["price"]!),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/heart_off.svg',
                              width: 12,
                              color: Color.fromARGB(255, 116, 116, 116),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(datas[index]["likes"]!),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext _context, int index) {
        return Container(
          height: 1,
          color: const Color(0xffd3d3d3),
        );
      },
      itemCount: datas.length,
    );
  }

  Widget _bodyWidget() {
    //비동기
    return FutureBuilder(
      future: _loadContents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('오류 발생 : ${snapshot.error}'),
          );
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _makeDataList(snapshot.data!);
        }
        return const Center(
          child: Text("데이터 없음"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
