// based on code repo from https://github.com/Origogi/Vertical_Card_Pager.git
import 'package:flutter/material.dart';

typedef PageChangedCallback = void Function(double? page);
typedef PageSelectedCallback = void Function(int index);

enum AlignTowards { left, center, right }

class VerticalCardPager extends StatefulWidget {
  final List<String> titles;
  final List<Widget> cards;
  final PageChangedCallback? onPageChanged;
  final PageSelectedCallback? onSelectedItem;
  final ScrollPhysics? physics;
  final TextStyle? textStyle;
  final int initialPage;
  final AlignTowards align;

  const VerticalCardPager(
      {required this.titles,
      required this.cards,
      this.onPageChanged,
      this.textStyle,
      this.initialPage = 2,
      this.onSelectedItem,
      this.physics,
      this.align = AlignTowards.center,})
      : assert(titles.length == cards.length);

  @override
  _VerticalCardPagerState createState() => _VerticalCardPagerState();
}

class _VerticalCardPagerState extends State<VerticalCardPager> {
  bool isScrolling = false;
  late double currentPosition;
  late PageController controller;

  @override
  void initState() {
    super.initState();

    currentPosition = widget.initialPage.toDouble();
    controller = PageController(initialPage: widget.initialPage);

    controller.addListener(() {
      setState(() {
        currentPosition = controller.page ?? 0;

        if (widget.onPageChanged != null) {
          Future(() => widget.onPageChanged!(currentPosition));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onVerticalDragEnd: (details) {
          isScrolling = false;
        },
        onVerticalDragStart: (details) {
          isScrolling = true;
        },
        onTapUp: (details) {
          if ((currentPosition - currentPosition.floor()).abs() <= 0.15) {
            int selectedIndex = onTapUp(
                context, constraints.maxHeight, constraints.maxWidth, details,);

            if (selectedIndex == 2) {
              if (widget.onSelectedItem != null) {
                Future(() => widget.onSelectedItem!(currentPosition.round()));
              }
            } else if (selectedIndex >= 0) {
              int goToPage = currentPosition.toInt() + selectedIndex - 2;
              controller.animateToPage(goToPage,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutExpo,);
            }
          }
        },
        child: Stack(
          children: [
            PagerCard(
              titles: widget.titles,
              cards: widget.cards,
              textStyle: widget.textStyle,
              currentPostion: currentPosition,
              cardViewPagerHeight: constraints.maxHeight,
              cardViewPagerWidth: constraints.maxWidth,
              align: widget.align,
            ),
            Positioned.fill(
              child: PageView.builder(
                physics: widget.physics,
                scrollDirection: Axis.vertical,
                itemCount: widget.cards.length,
                controller: controller,
                itemBuilder: (context, index) {
                  return Container();
                },
              ),
            ),
          ],
        ),
      );
    },);
  }

  int onTapUp(context, maxHeight, maxWidth, details) {
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);

    double dx = localOffset.dx;
    double dy = localOffset.dy;

    for (int i = 0; i < 5; i++) {
      double width = getWidth(maxHeight, i);
      double height = getHeight(maxHeight, i);
      double? left = getStartPositon(maxWidth, width);
      double top = getCardPositionTop(height, maxHeight, i);

      if (top <= dy && dy <= top + height) {
        if (left <= dx && dx <= left + width) {
          return i;
        }
      }
    }
    return -1;
  }

  double getStartPositon(cardViewPagerWidth, cardWidth) {
    double position = 0;

    switch (widget.align) {
      case AlignTowards.left:
        position = 0;
        break;
      case AlignTowards.center:
        position = (cardViewPagerWidth / 2) - (cardWidth / 2);
        break;
      case AlignTowards.right:
        position = cardViewPagerWidth - cardWidth;
        break;
    }

    return position;
  }

  double getWidth(maxHeight, i) {
    double cardMaxWidth = maxHeight / 2;
    return cardMaxWidth - 60 * (i - 2).abs();
  }

  double getHeight(maxHeight, i) {
    double cardMaxHeight = maxHeight / 2;

    if (i == 2) {
      return cardMaxHeight;
    } else if (i == 0 || i == 4) {
      return cardMaxHeight - cardMaxHeight * (4 / 5) - 10;
    } else
      return cardMaxHeight - cardMaxHeight * (4 / 5);
  }
}

double getCardPositionTop(double cardHeight, double viewHeight, int i) {
  int diff = (2 - i);
  int diffAbs = diff.abs();

  double basePosition = (viewHeight / 2) - (cardHeight / 2);
  double cardMaxHeight = viewHeight / 2;

  if (diffAbs == 0) {
    return basePosition;
  }
  if (diffAbs == 1) {
    if (diff >= 0) {
      return basePosition - (cardMaxHeight * (6 / 9));
    } else {
      return basePosition + (cardMaxHeight * (6 / 9));
    }
  } else {
    if (diff >= 0) {
      return basePosition - cardMaxHeight * (8 / 9);
    } else {
      return basePosition + cardMaxHeight * (8 / 9);
    }
  }
}

class PagerCard extends StatelessWidget {
  final double? currentPostion;
  final double cardMaxWidth;
  final double cardMaxHeight;
  final double cardViewPagerHeight;
  final double? cardViewPagerWidth;
  final TextStyle? textStyle;
  final AlignTowards align;

  final List<String>? titles;
  final List<Widget>? cards;

  const PagerCard(
      {this.titles,
      this.cards,
      this.cardViewPagerWidth,
      required this.cardViewPagerHeight,
      this.currentPostion,
      required this.align,
      this.textStyle,})
      : cardMaxHeight = cardViewPagerHeight * (1 / 2),
        cardMaxWidth = cardViewPagerHeight * (1 / 2);

  @override
  Widget build(BuildContext context) {
    List<Widget> cardList = [];

    TextStyle? titleTextStyle;

    if (textStyle != null) {
      titleTextStyle = textStyle;
    } else {
      titleTextStyle = Theme.of(context).textTheme.titleLarge;
    }

    for (int i = 0; i < cards!.length; i++) {
      double cardWidth = MediaQuery.of(context).size.width; // Full width of the parent

      // Adjust the height based on the card's position for scaling effect
      double scaleFactor = 0.2; // Adjust to control scaling
      double cardHeight = cardMaxHeight * (1 - (scaleFactor * (i / (cards!.length - 1))));

      var cardTop = getTop(cardHeight, cardViewPagerHeight, i);

      // Define the desired border radius
      double borderRadius = 15.0; // Adjust the radius as needed

      //NOTE - Card element design of the pager is managed here
      Widget card = Positioned.directional(
        textDirection: TextDirection.ltr,
        top: cardTop, // Correct positioning
        start: getStartPositon(cardWidth), // Correct horizontal positioning
        child: Opacity(
          opacity: getOpacity(i), // Adjust opacity
          child: SizedBox(
            width: cardWidth,
            height: cardHeight, // Adjust height for scaling effect
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: cards![i], // Card content
            ),
          ),
        ),
      );

      cardList.add(card);
    }

    return Stack(
      children: cardList,
    );
  }

  double getOpacity(int i) {
    double diff = (currentPostion! - i);

    if (diff >= -2 && diff <= 2) {
      return 1.0;
    } else if (diff > -3 && diff < -2) {
      return 3 - diff.abs();
    } else if (diff > 2 && diff < 3) {
      return 3 - diff.abs();
    } else {
      return 0;
    }
  }

  double getTop(double cardHeight, double viewHeight, int i) {
    double diff = (currentPostion! - i);
    double diffAbs = diff.abs();

    double basePosition = (viewHeight / 2) - (cardHeight / 2);

    if (diffAbs == 0) {
      return basePosition;
    }
    if (diffAbs > 0.0 && diffAbs <= 1.0) {
      if (diff >= 0) {
        return basePosition - (cardMaxHeight * (6 / 9)) * diffAbs;
      } else {
        return basePosition + (cardMaxHeight * (6 / 9)) * diffAbs;
      }
    } else if (diffAbs > 1.0 && diffAbs < 2.0) {
      if (diff >= 0) {
        return basePosition -
            (cardMaxHeight * (6 / 9)) -
            cardMaxHeight * (2 / 9) * (diffAbs - diffAbs.floor()).abs();
      } else {
        return basePosition +
            (cardMaxHeight * (6 / 9)) +
            cardMaxHeight * (2 / 9) * (diffAbs - diffAbs.floor()).abs();
      }
    } else {
      if (diff >= 0) {
        return basePosition - cardMaxHeight * (8 / 9);
      } else {
        return basePosition + cardMaxHeight * (8 / 9);
      }
    }
  }

  double getCardHeight(int index) {
    double diff = (currentPostion! - index).abs();

    if (diff >= 0.0 && diff < 1.0) {
      return cardMaxHeight - cardMaxHeight * (4 / 5) * ((diff - diff.floor()));
    } else if (diff >= 1.0 && diff < 2.0) {
      return cardMaxHeight -
          cardMaxHeight * (4 / 5) -
          10 * ((diff - diff.floor()));
    } else {
      final height = cardMaxHeight -
          cardMaxHeight * (4 / 5) -
          10 -
          5 * ((diff - diff.floor()));

      return height > 0 ? height : 0;
    }
  }

  double getFontSize(int index) {
    double diffAbs = (currentPostion! - index).abs();
    diffAbs = num.parse(diffAbs.toStringAsFixed(2)) as double;

    double maxFontSize = 30; // Reduced max font size for the center card
    if (diffAbs >= 0.0 && diffAbs < 1.0) {
      if (diffAbs < 0.02) {
        diffAbs = 0;
      }

    return maxFontSize - 15 * ((diffAbs - diffAbs.floor())); // Adjusted decrement for smoother transition
  } else if (diffAbs >= 1.0 && diffAbs < 2.0) {
    return maxFontSize - 15 - 5 * ((diffAbs - diffAbs.floor())); // Adjusted for outer cards
  } else {
    final fontSize = maxFontSize - 20 - 10 * ((diffAbs - diffAbs.floor())); // Adjusted for further cards

    return fontSize > 0 ? fontSize : 0;
  }
}

  double getStartPositon(cardWidth) {
    double position = 0;

    switch (align) {
      case AlignTowards.left:
        position = 0;
        break;
      case AlignTowards.center:
        position = (cardViewPagerWidth! / 2) - (cardWidth / 2);
        break;
      case AlignTowards.right:
        position = cardViewPagerWidth! - cardWidth;
        break;
    }

    return position;
  }

  double getScaleFactor(int index) {
    // Example scale factor logic
    // Adjust the scale factor based on your requirements
    if (index == 0) {
      return 1.0; // No scaling for the first card
    } else {
      return 0.8; // Scale down for other cards
    }
  }
}