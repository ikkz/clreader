import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meta/meta.dart';

import 'package:clreader/book/book_info.dart';

class BookItem extends StatefulWidget {
  BookItem({@required this.bookInfo});
  BookInfo bookInfo;
  @override
  State<StatefulWidget> createState() {
    return _BookItemState();
  }
}

class _BookItemState extends State<BookItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            height: 100,
            width: 80,
            alignment: Alignment.center,
            child: CachedNetworkImage(
              imageUrl: widget.bookInfo.urlCover,
              placeholder: CircularProgressIndicator(),
              errorWidget: Icon(Icons.error),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.bookInfo.name,
                    style: Theme.of(context).textTheme.subhead,
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
                    maxLines: 3,
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
