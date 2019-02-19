import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meta/meta.dart';

import 'package:clreader/book/book_info.dart';

class BookItem extends StatefulWidget {
  BookItem(
      {@required this.bookInfo, this.onTap, this.onLongPress, this.onMoreTap});
  final BookInfo bookInfo;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final VoidCallback onMoreTap;
  @override
  State<StatefulWidget> createState() {
    return _BookItemState();
  }
}

class _BookItemState extends State<BookItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      contentPadding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              height: 100,
              width: 80,
              alignment: Alignment.center,
              child: CachedNetworkImage(
                imageUrl: widget.bookInfo.urlCover,
                placeholder: Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: Center(
                  child: Icon(Icons.error),
                ),
              )),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.bookInfo.name,
                          style: Theme.of(context).textTheme.subhead,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          iconSize: 16,
                          icon: Icon(
                            Icons.more_vert,
                          ),
                          onPressed: widget.onMoreTap,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 7,
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 14,
                        ),
                      ),
                      Container(
                        width: 5,
                      ),
                      Text(
                        widget.bookInfo.author,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  Container(height: 5),
                  Text(
                    widget.bookInfo.introduction,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.overline,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
