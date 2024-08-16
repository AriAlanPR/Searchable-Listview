// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:searchable_listview/resources/arrays.dart';
import 'package:searchable_listview/widgets/search_text_field.dart';
import 'package:searchable_listview/widgets/vertical_pager.dart';


class PagerFailure extends StatelessWidget {
  final String text;

  const PagerFailure({Key? key, this.text = 'Error'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error,
          color: Colors.red,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(text),
      ],
    );
  }
}

class PagerLoading extends StatelessWidget {
  final String text;

  const PagerLoading({Key? key, this.text = 'Loading'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Search Loading');
  }
}

class SearchablePager extends StatefulWidget {
  /// Initial list of all elements that will be displayed.
  ///to filter the [initialList] you need provide [filter] callback
  late List<Map<String, dynamic>> initialList;

  /// Callback to filter the list based on the given search value.
  /// Invoked on changing the text field search if ```searchType == SEARCH_TYPE.onEdit```
  /// or invoked when submiting the text field if ```searchType == SEARCH_TYPE.onSubmit```.
  /// You should return a list of filtered elements.
  List<Map<String, dynamic>> Function(String query)? filter;

  ///Async callback that return list to be displayed with future builder
  ///to filter the [asyncListCallback] result you need provide [asyncListFilter]
  Future<List<Map<String, dynamic>>?> Function()? asyncListCallback;

  ///Callback invoked when filtring the searchable list
  ///used when providing [asyncListCallback]
  ///can't be null when [asyncListCallback] isn't null
  late List<Map<String, dynamic>> Function(String, List<Map<String, dynamic>>)? asyncListFilter;

  ///Loading widget displayed when [asyncListCallback] is loading
  ///if nothing is provided in [loadingWidget] searchable list will display a [CircularProgressIndicator]
  Widget? loadingWidget;

  ///error widget displayed when [asyncListCallback] result is null
  ///if nothing is provided in [errorWidget] searchable list will display a [Icon]
  Widget? errorWidget;

  /// Builder function that generates the ListView items
  /// based on the returned <T> type item
  late Widget Function(Map<String, dynamic> item)? itemBuilder;

  /// The widget to be displayed when the filter returns an empty list.
  /// Defaults to `const SizedBox.shrink()`.
  final Widget emptyWidget;

  /// Text editing controller applied on the search field.
  /// Defaults to null.
  late TextEditingController? searchTextController;

  /// The keyboard action key
  /// Defaults to [TextInputAction.done].
  final TextInputAction keyboardAction;

  /// The text field input decoration
  /// Defaults to null.
  final InputDecoration? inputDecoration;

  /// The style for the input text field
  /// Defaults to null.
  final TextStyle? style;

  /// The keyboard text input type
  /// Defaults to [TextInputType.text]
  final TextInputType textInputType;

  /// Callback function invoked when submiting the search text field
  final Function(String?)? onSubmitSearch;

  /// The search type on submiting text field or when changing the text field value
  ///```dart
  ///SEARCH_TYPE.onEdit,
  ///SEARCH_TYPE.onSubmit
  ///```
  /// Defaults to [SearchMode.onEdit].
  final SearchMode searchMode;

  /// Indicate whether the text field input should be obscured or not.
  /// Defaults to `false`.
  final bool obscureText;

  /// Indicate if the search text field is enabled or not.
  /// Defaults to `true`.
  final bool searchFieldEnabled;

  /// The focus node that applies to the search text field
  final FocusNode? focusNode;

  /// Indicate whether the clear and search icons will be displayed or not
  /// by default it's true, to display the clear icon the inputDecoration should not contains suffix icon
  /// otherwise the initial suffix icon will be displayed
  final bool displayClearIcon;

  /// Indicate whether the search icon will be displayed or not
  /// by default it's true, to display the search icon the inputDecoration should not contains suffix icon
  /// otherwise the initial suffix icon will be displayed
  final bool displaySearchIcon;

  /// The color applied on the suffix icon (if `displayClearIcon = true`).
  /// Defaults to [Colors.grey].
  final Color defaultSuffixIconColor;

  /// The size of the suffix icon (if `displayClearIcon = true`).
  /// Defaults to 24.
  final double defaultSuffixIconSize;

  ///An async callback invoked when dragging down the list
  ///if onRefresh is nullable the drag to refresh is not applied
  late Future<void> Function()? onRefresh;

  ///The scroll direction of the list
  ///by default [Axis.vertical]
  Axis scrollDirection = Axis.vertical;

  ///The position of the text field (bottom or top)
  ///by default the textfield is displayed on top
  SearchTextPosition searchTextPosition = SearchTextPosition.top;

  ///Callback function invoked each time the listview
  ///reached the bottom
  ///used to create pagination in listview
  Future<dynamic> Function()? onPaginate;

  ///space between the search textfield and the list
  ///by default the padding is set to 20
  final double spaceBetweenSearchAndList;

  ///cusor color used in the search textfield
  final Color? cursorColor;

  ///max lines attribute used in the search textfield
  final int? maxLines;

  ///max length attribute used in the search field
  final int? maxLength;

  ///the text alignement of the search field
  ///by default the alignement is start
  final TextAlign textAlign;

  ///List of strings  to display in an auto complete field
  ///by default list is empty so a simple text field is displayed
  final List<String> autoCompleteHints;

  ///secondary widget will be displayed alongside the search field
  ///by default it's null
  final Widget? secondaryWidget;

  ///physics attributes used in listview widget
  late ScrollPhysics? physics;

  ///shrinkWrap used in listview widget, not used in sliver searchable list
  ///by default `shrinkWrap = false`
  late bool shrinkWrap;

  ///item extent of the listview
  late double? itemExtent;

  ///listview item padding
  late EdgeInsetsGeometry? listViewPadding;

  ///list items reverse attributes
  ///by default `reverse = false`
  ///not available for sliver listview constructor
  late bool reverse;

  ///Predicate callback invoked when sorting list items
  late int Function(Map<String, dynamic> a, Map<String, dynamic> b)? sortPredicate;

  ///Widget displayed when sorting list
  late Widget? sortWidget;

  ///Scroll controller passed to listview widget
  ///by default listview uses scrollcontroller with a listener for pagination if `onPaginate = true`
  ///or `closeKeyboardWhenScrolling = true` to close keyboard when scrolling
  ScrollController? scrollController;

  ///indicates whether the keyboard will be closed when scrolling or not
  ///by default `closeKeyboardWhenScrolling = true`
  final bool closeKeyboardWhenScrolling;

  /// max width of search text field
  final double? searchFieldWidth;

  /// height of search text field
  final double? searchFieldHeight;

  //Added by Awri properties and methods
  final List<String> headerList;

  static Widget oldListView<T>({
    required List<T> list,
    required Widget Function(T)? itemBuilder,
    ScrollPhysics? physics,
    double? itemExtent,
    EdgeInsetsGeometry? listViewPadding,
    bool shrinkWrap = false,
    bool reverse = false,
    ScrollController? scrollController,
    Axis scrollDirection = Axis.vertical,
  }) {
    return ListView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemExtent: itemExtent,
      padding: listViewPadding,
      reverse: reverse,
      controller: scrollController,
      scrollDirection: scrollDirection,
      itemCount: list.length,
      itemBuilder: (context, index) => itemBuilder!(list[index]),
    );
  }


  ///basic filtering where it searchs for the typed text in the value of each item
  ///the comparison converts the key value to a string lowercase to have it compared to the query as lowercase
  static List<Map<String, dynamic>> filterMapList(
    List<Map<String, dynamic>> list,
    String query,
  ) {
    final keys = list.isNotEmpty ? list.first.keys.toList() : [];

    return list.where((element) {
      final coincident = keys.firstWhere(
        (filterKey) {
          if (element[filterKey] != null) {
            return element[filterKey]
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase());
          }
          return false;
        },
        orElse: () => null,
      );

      return coincident != null;
    }).toList();
  }

  ///default predefined decoration for the search text field
  static InputDecoration baseInputDecoration({
    required String placeholder,
    Color? background,
    Color? border,
  }) {
    return InputDecoration(
      labelText: placeholder,
      fillColor: background ?? Colors.white,
      suffixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: border ?? Colors.blue,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: border ?? Colors.blue,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
  // End added by Awri properties and methods

  SearchablePager({
    Key? key,
    this.initialList = const [],
    required this.itemBuilder,
    required this.headerList,
    this.filter,
    this.loadingWidget,
    this.errorWidget = const PagerFailure(),
    this.searchTextController,
    this.keyboardAction = TextInputAction.done,
    this.inputDecoration,
    this.style = const TextStyle(),
    this.onSubmitSearch,
    this.searchMode = SearchMode.onEdit,
    this.emptyWidget = const SizedBox.shrink(),
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.focusNode,
    this.searchFieldEnabled = true,
    this.searchFieldWidth,
    this.searchFieldHeight = 60,
    //TODO: adjust this effect
    this.displayClearIcon = false,
    this.onRefresh,
    this.scrollDirection = Axis.vertical,
    this.searchTextPosition = SearchTextPosition.top,
    this.onPaginate,
    this.spaceBetweenSearchAndList = 20,
    this.cursorColor,
    this.maxLines,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.autoCompleteHints = const [],
    this.secondaryWidget,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.shrinkWrap = false,
    this.itemExtent,
    this.listViewPadding,
    this.reverse = false,
    this.sortPredicate,
    this.sortWidget,
    this.scrollController,
    this.closeKeyboardWhenScrolling = true,
    this.displaySearchIcon = true,
    this.defaultSuffixIconColor = Colors.grey,
    this.defaultSuffixIconSize = 24,
    this.asyncListCallback,
    this.asyncListFilter,
  }) : super(key: key) {
    searchTextController ??= TextEditingController();
    if (sortWidget != null) {
      assert(sortPredicate != null);
    }
  }

  @override
  _SearchablePagerState<Map<String, dynamic>> createState() => _SearchablePagerState<Map<String, dynamic>>();
}

class _SearchablePagerState<T extends Map<String, dynamic>> extends State<SearchablePager> {
  ///create scroll controller instance
  ///attached to the listview widget
  late ScrollController scrollController =
      widget.scrollController ?? ScrollController();
  List<T> asyncListResult = [];
  List<Map<String, dynamic>> filteredAsyncListResult = [];
  bool dataDownloaded = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.closeKeyboardWhenScrolling) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
      if (widget.onPaginate != null &&
          scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
        setState(() {
          widget.onPaginate?.call();
        });
      }
    });
    widget.searchTextController?.addListener(() {
      filterList(widget.searchTextController?.text ?? '');
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget renderAsyncListView() {
    return FutureBuilder(
      future: widget.asyncListCallback!.call(),
      builder: (context, snapshot) {
        dataDownloaded = snapshot.connectionState != ConnectionState.waiting;
        if (!dataDownloaded) {
          return widget.loadingWidget ?? const PagerLoading();
        }
        if (snapshot.data == null) {
          return widget.errorWidget ?? const PagerFailure();
        }
        asyncListResult = snapshot.data as List<T>;
        filteredAsyncListResult = asyncListResult;
        return renderSearchableListView();
      },
    );
  }

  Widget renderSearchableListView() {
    List<Map<String, dynamic>> renderedList = widget.asyncListCallback != null
        ? filteredAsyncListResult
        : widget.initialList;
    return renderListView(
      list: renderedList,
    );
  }

  ///creates listview based on the items passed to the widget
  ///check whether the [widget.onRefresh] parameter is nullable or not
  ///the function will render a normal listview [ListView.builder]
  Widget renderListView({
    required List<Map<String, dynamic>> list,
  }) {
    if (list.isEmpty) {
      return widget.emptyWidget;
    } else {
      return widget.onRefresh != null
          ? RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: widget.onRefresh!,
              child: verticalPager(list: list),
            )
          : verticalPager(list: list);
    }
  }

  Widget _oldListView() {
    return SearchablePager.oldListView(
      list: widget.initialList,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      itemExtent: widget.itemExtent,
      listViewPadding: widget.listViewPadding,
      reverse: widget.reverse,
      scrollController: scrollController,
      scrollDirection: widget.scrollDirection,
      itemBuilder: widget.itemBuilder,
    );
  }

  Widget verticalPager({required List<Map<String, dynamic>> list}) {
    return VerticalCardPager(
      titles: widget.headerList,
      cards: list.map(
        (e) => Hero(
          tag: e.hashCode,
          child: widget.itemBuilder?.call(e) ?? Text(e.toString()),
        ),
      ).toList(),
      // onPageChanged: (page) {},
      // onSelectedItem: (index) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => DetailView(
      //         champion: champions[index],
      //       ),
      //     ),
      //   );
      // },
    );
  }

  void filterList(String value) {
    if (widget.asyncListCallback != null) {
      setState(() {
        filteredAsyncListResult = widget.asyncListFilter!(
          value,
          asyncListResult,
        );
      });
    } else {
      setState(() {
        widget.initialList = widget.filter!(value);
      });
    }
  }

  void sortList() {
    if (widget.asyncListCallback != null) {
      setState(() {
        filteredAsyncListResult.sort(widget.sortPredicate);
      });
    } else {
      setState(() {
        widget.initialList.sort(widget.sortPredicate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.searchTextPosition == SearchTextPosition.top
          ? [
              SizedBox(
                width: widget.searchFieldWidth,
                height: widget.searchFieldHeight,
                child: SearchTextField(
                  filterList: filterList,
                  focusNode: widget.focusNode,
                  inputDecoration: widget.inputDecoration,
                  keyboardAction: widget.keyboardAction,
                  obscureText: widget.obscureText,
                  onSubmitSearch: widget.onSubmitSearch,
                  searchFieldEnabled: widget.searchFieldEnabled,
                  searchMode: widget.searchMode,
                  searchTextController: widget.searchTextController,
                  textInputType: widget.textInputType,
                  displayClearIcon: widget.displayClearIcon,
                  displaySearchIcon: widget.displaySearchIcon,
                  defaultSuffixIconColor: widget.defaultSuffixIconColor,
                  defaultSuffixIconSize: widget.defaultSuffixIconSize,
                  textStyle: widget.style,
                  cursorColor: widget.cursorColor,
                  maxLength: widget.maxLength,
                  maxLines: widget.maxLines,
                  textAlign: widget.textAlign,
                  autoCompleteHints: widget.autoCompleteHints,
                  secondaryWidget: widget.secondaryWidget,
                  onSortTap: sortList,
                  sortWidget: widget.sortWidget,
                ),
              ),
              SizedBox(
                height: widget.spaceBetweenSearchAndList,
              ),
              Expanded(
                child: widget.asyncListCallback != null && !dataDownloaded
                    ? renderAsyncListView()
                    : renderSearchableListView(),
              ),
            ]
          : [
              Expanded(
                child: widget.asyncListCallback != null && !dataDownloaded
                    ? renderAsyncListView()
                    : renderSearchableListView(),
              ),
              SizedBox(
                height: widget.spaceBetweenSearchAndList,
              ),
              SizedBox(
                width: widget.searchFieldWidth,
                height: widget.searchFieldHeight,
                child: SearchTextField(
                  filterList: filterList,
                  focusNode: widget.focusNode,
                  inputDecoration: widget.inputDecoration,
                  keyboardAction: widget.keyboardAction,
                  obscureText: widget.obscureText,
                  onSubmitSearch: widget.onSubmitSearch,
                  searchFieldEnabled: widget.searchFieldEnabled,
                  searchMode: widget.searchMode,
                  searchTextController: widget.searchTextController,
                  textInputType: widget.textInputType,
                  displayClearIcon: widget.displayClearIcon,
                  displaySearchIcon: widget.displaySearchIcon,
                  defaultSuffixIconColor: widget.defaultSuffixIconColor,
                  defaultSuffixIconSize: widget.defaultSuffixIconSize,
                  textStyle: widget.style,
                  cursorColor: widget.cursorColor,
                  maxLength: widget.maxLength,
                  maxLines: widget.maxLines,
                  textAlign: widget.textAlign,
                  autoCompleteHints: widget.autoCompleteHints,
                  secondaryWidget: widget.secondaryWidget,
                  onSortTap: sortList,
                  sortWidget: widget.sortWidget,
                ),
              ),
            ],
    );
  }
}
