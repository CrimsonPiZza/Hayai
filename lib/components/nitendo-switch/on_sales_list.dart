import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import '../../services/API_manager.dart';
import '../../services/onsales_request.dart';
import '../../models/nintendo-switch/onsales.dart';
import '../loading_indicator.dart';

const MONTHS = <int, String>{
  1: "Jan",
  2: "Feb",
  3: "Mar",
  4: "Apr",
  5: "May",
  6: "Jun",
  7: "Jul",
  8: "Aug",
  9: "Sep",
  10: "Oct",
  11: "Nov",
  12: "Dec",
};

String jsTimeToReadable(dateString) {
  var date = DateTime.parse(dateString.toString());
  return "${date.year}-${MONTHS[date.month]}-${date.day}";
}

// Animated List key
GlobalKey<AnimatedListState> _animatedKey = GlobalKey<AnimatedListState>();

class OnSalesList extends StatefulWidget {
  @override
  _OnSalesListState createState() => _OnSalesListState();
}

class _OnSalesListState extends State<OnSalesList> {
  APIManager api = new APIManager();

  // At the beginning, we fetch the first 20 posts
  int _page = 0;
  int _limit = 20;
  int _optionID = OptionID.PRICE_HIGH_TO_LOW;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // Used to display block some actions when _insertListItem() function is running
  bool _isInsertingToList = false;

  // This holds the posts fetched from the server
  List _games = [];

  // The controller for the ListView
  late ScrollController _scrollController;

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    final OnSalesModel result = await api
        .getNSOnSales(new NSOnSalesRequestConfig(_page, _limit, _optionID));
    _games = result.data.results;

    setState(() {
      _isFirstLoadRunning = false;
      _isInsertingToList = true;
    });

    _insertListItem().then((value) => {
          setState(() {
            _isInsertingToList = false;
          })
        });
  }

  void _loadMore() async {
    if (_hasNextPage &&
        !_isFirstLoadRunning &&
        !_isLoadMoreRunning &&
        !_isInsertingToList &&
        _scrollController.position.extentAfter < 10) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1;
      final OnSalesModel result = await api
          .getNSOnSales(new NSOnSalesRequestConfig(_page, _limit, _optionID));
      _games.addAll(result.data.results);
      if (_page == result.data.lastPage) {
        // This means there is no more data
        // and therefore, we will not send another GET request
        setState(() {
          _hasNextPage = false;
        });
      }

      setState(() {
        _isLoadMoreRunning = false;
        _isInsertingToList = true;
      });

      _insertListItem().then((value) => {
            setState(() {
              _isInsertingToList = false;
            })
          });
    }
  }

  Future<void> _insertListItem() async {
    // Trigger Animated List
    _isInsertingToList = true;

    int offset = 0;
    while (offset < _limit && _isInsertingToList) {
      int indexToInsert = _games.length - _limit + offset;
      await Future.delayed(Duration(milliseconds: 150), () {
        if (_isInsertingToList) {
          _animatedKey.currentState!.insertItem(indexToInsert);
        }
      });
      offset++;
    }
  }

  void switchCategoryFilter() {
    _page = 0;
    _hasNextPage = true;
    _isFirstLoadRunning = false;
    _isLoadMoreRunning = false;
    _animatedKey = new GlobalKey<AnimatedListState>();
    _games.clear();
    _firstLoad();
  }

  void onSelectCategory(option) async {
    if (_optionID == option) {
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 30 * _games.length),
          curve: Curves.fastOutSlowIn);
      return;
    }
    setState(() {
      if (_optionID != option && !_isFirstLoadRunning && !_isLoadMoreRunning) {
        _isInsertingToList = false;
        _optionID = option;
        switchCategoryFilter();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController()..addListener(_loadMore);
    _firstLoad();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Let's buy",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w100),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "On Sales",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Category Selector
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: CategoryCard(
                      selectedOptionID: _optionID,
                      btnOptionID: OptionID.PRICE_HIGH_TO_LOW,
                      text: "Price High",
                    ),
                    onTap: () {
                      onSelectCategory(OptionID.PRICE_HIGH_TO_LOW);
                    },
                  ),
                  GestureDetector(
                      child: CategoryCard(
                        selectedOptionID: _optionID,
                        btnOptionID: OptionID.PRICE_LOW_TO_HIGH,
                        text: "Price Low",
                      ),
                      onTap: () {
                        onSelectCategory(OptionID.PRICE_LOW_TO_HIGH);
                      }),
                  GestureDetector(
                    child: CategoryCard(
                      selectedOptionID: _optionID,
                      btnOptionID: OptionID.FEATURED,
                      text: "Featured",
                    ),
                    onTap: () {
                      onSelectCategory(OptionID.FEATURED);
                    },
                  ),
                  GestureDetector(
                    child: CategoryCard(
                      selectedOptionID: _optionID,
                      btnOptionID: OptionID.A_TO_Z,
                      text: "Title A-Z",
                    ),
                    onTap: () {
                      onSelectCategory(OptionID.A_TO_Z);
                    },
                  ),
                  GestureDetector(
                    child: CategoryCard(
                      selectedOptionID: _optionID,
                      btnOptionID: OptionID.Z_TO_A,
                      text: "Title Z-A",
                    ),
                    onTap: () {
                      onSelectCategory(OptionID.A_TO_Z);
                    },
                  )
                ],
              ),
            ),
          ),
          // Do not show listview yet, unless first loading is already done
          Expanded(
            flex: _isFirstLoadRunning ? 0 : 1,
            child: AnimatedList(
              shrinkWrap: true,
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: 20),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              key: _animatedKey,
              initialItemCount: 0,
              itemBuilder: (BuildContext context, int index,
                  Animation<double> animation) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _GameList(
                    thumbnail: _games[index]
                        .horizontalHeaderImage
                        .toString()
                        .replaceFirst(
                            "upload/", "upload/c_fill,f_auto,q_auto,w_360/"),
                    title: _games[index].title!,
                    publisher: _games[index].publishers.length > 0
                        ? _games[index].publishers[0]!
                        : _games[index].developers.length > 0
                            ? _games[index].developers[0]!
                            : "",
                    price: double.parse(_games[index].msrp.toString()),
                    salePrice: double.parse(_games[index].salePrice.toString()),
                    date: jsTimeToReadable(_games[index].releaseDateDisplay),
                    animation: animation,
                  ),
                );
              },
            ),
          ),
          // Make the loading indicator centering the screen at first
          _isFirstLoadRunning
              ? Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: ZenitsuLoadingIndicator(),
                  ),
                )
              // Add the loading indicator at the bottom center of the screen when loading more games
              : _isLoadMoreRunning
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: ZenitsuLoadingIndicator(),
                      ),
                    )
                  : SizedBox.shrink()
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.selectedOptionID,
    required this.btnOptionID,
    required this.text,
  }) : super(key: key);

  final int selectedOptionID;
  final int btnOptionID;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 25000),
        curve: Curves.bounceOut,
        child: Card(
          color: selectedOptionID == btnOptionID
              ? Colors.white
              : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text,
                style: TextStyle(
                    color: selectedOptionID == btnOptionID
                        ? Colors.black
                        : Colors.white,
                    fontSize: selectedOptionID == btnOptionID ? 10 : 8,
                    fontWeight: selectedOptionID == btnOptionID
                        ? FontWeight.bold
                        : FontWeight.normal)),
          ),
        ),
      ),
    );
  }
}

class _GameList extends StatelessWidget {
  const _GameList({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.publisher,
    required this.price,
    required this.salePrice,
    required this.date,
    required this.animation,
  }) : super(key: key);

  final String thumbnail;
  final String title;
  final String publisher;
  final double price;
  final double salePrice;
  final String date;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: CurvedAnimation(curve: Curves.easeOut, parent: animation)
          .drive((Tween<Offset>(
        begin: Offset(1, 0),
        end: Offset(0, 0),
      ))),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 4, 20, 0),
        child: Container(
          child: SizedBox(
            height: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: thumbnail != "null"
                        ? Image.network(
                            thumbnail,
                            width: 170,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/nintendo_thumbnail.png",
                            width: 170,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                _GameCard(
                    title: title,
                    publisher: publisher,
                    price: price,
                    salePrice: salePrice,
                    date: date)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    Key? key,
    required this.title,
    required this.publisher,
    required this.price,
    required this.salePrice,
    required this.date,
  }) : super(key: key);

  final String title;
  final String publisher;
  final double price;
  final double salePrice;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  Text(
                    publisher,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 8),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: [
                      if (salePrice != "") ...[
                        _BeforeDiscountPriceTag(price: price),
                        _SellingPriceTag(salePrice: salePrice)
                      ] else ...[
                        _SellingPriceTag(salePrice: price)
                      ]
                    ],
                  ),
                  Text(
                    date,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SellingPriceTag extends StatelessWidget {
  const _SellingPriceTag({
    Key? key,
    required this.salePrice,
  }) : super(key: key);

  final double salePrice;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(83, 109, 254, 1),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          "\$ " + salePrice.toString(),
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class _BeforeDiscountPriceTag extends StatelessWidget {
  const _BeforeDiscountPriceTag({
    Key? key,
    required this.price,
  }) : super(key: key);

  final double price;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[500],
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          "\$ " + price.toString(),
          style: TextStyle(
              fontSize: 8,
              decoration: TextDecoration.lineThrough,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
