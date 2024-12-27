import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrot_market_clone/components/manner_temperature_widget.dart';
import 'package:carrot_market_clone/utills/data_utills.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, String> data;
  DetailContentView({super.key, required this.data});

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Size size;
  late List<Map<String, String>> imgList;
  late int _current;
  final ScrollController _controller = ScrollController();
  double scrollPositionX = 0;
  late AnimationController _animationController;
  late Animation _colorTween;
  late bool isFavorit;

  @override
  void initState() {
    super.initState();
    isFavorit = false;
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);

    _controller.addListener(() {
      setState(() {
        if (_controller.offset > 255) {
          scrollPositionX = 255;
        } else {
          scrollPositionX = _controller.offset;
          _animationController.value = scrollPositionX / 255;
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    _current = 0;
    imgList = [
      {"id": "0", "url": widget.data['image']!},
      {"id": "1", "url": widget.data['image']!},
      {"id": "2", "url": widget.data['image']!},
      {"id": "3", "url": widget.data['image']!},
      {"id": "4", "url": widget.data['image']!},
      {"id": "5", "url": widget.data['image']!},
    ];
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) => Icon(
              icon,
              color: _colorTween.value,
            ));
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollPositionX.toInt()),
      elevation: 0,
      leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: _makeIcon(Icons.arrow_back)),
      actions: [
        IconButton(onPressed: () => {}, icon: _makeIcon(Icons.share)),
        IconButton(onPressed: () => {}, icon: _makeIcon(Icons.more_vert)),
      ],
    );
  }

  Widget _makeSliderImage() {
    return Stack(
      children: [
        Hero(
          tag: widget.data["cid"]!,
          child: CarouselSlider(
            items: imgList.map((item) {
              return Image.asset(
                item['url']!,
                width: size.width,
                fit: BoxFit.fill,
              );
            }).toList(),
            // carouselController: _controller,
            options: CarouselOptions(
                height: size.width,
                initialPage: 0,
                enableInfiniteScroll: false,
                viewportFraction: 1, //이미지 전체 width
                autoPlay: false,
                enlargeCenterPage: false,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((item) {
              return GestureDetector(
                // onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.white)
                          .withOpacity(_current == int.parse(item.value['id']!)
                              ? 0.9
                              : 0.4)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _sellerSimpleInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset('assets/images/user.png').image,
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Duke',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '해운대구 반여동',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Expanded(
            child: MannerTemperatureWidget(
              mannerTemp: 37.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _contentsDetail() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.data['title']!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.data['type']!,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500]),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.data['content']!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "채팅 3 · 관심 8 · 조회 46",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _otherCellContents() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "판매자님의 판매 상품",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "모두보기",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            _makeSliderImage(),
            _sellerSimpleInfo(),
            _line(),
            _contentsDetail(),
            _line(),
            _otherCellContents(),
          ]),
        ),
        SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
                delegate: SliverChildListDelegate(List.generate(20, (index) {
                  {
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.grey,
                              height: 120,
                            ),
                          ),
                          const Text(
                            "상품 제목",
                            style: TextStyle(fontSize: 14),
                          ),
                          const Text(
                            "금액",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }
                }).toList()),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10)))
      ],
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: size.width,
      height: 55,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => {
              setState(() {
                isFavorit = !isFavorit;
              }),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                content: Text(
                  isFavorit ? '관심목록애 추가하였습니다.' : '관심목록에서 제외하였습니다.',
                  style: TextStyle(fontSize: 14),
                ),
              ))
            },
            child: SvgPicture.asset(
              isFavorit
                  ? "assets/svg/heart_on.svg"
                  : "assets/svg/heart_off.svg",
              width: 25,
              height: 25,
              color: Color(0xfff08f4f),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: 1,
            height: 40,
            color: Colors.grey[400],
          ),
          Column(
            children: [
              Text(
                DataUtills.moneyFormat(widget.data['price']!),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '가격제안불가',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              )
            ],
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  color: const Color(0xfff08f4f),
                  child: const Text(
                    '채팅으로 거래하기',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }
}
