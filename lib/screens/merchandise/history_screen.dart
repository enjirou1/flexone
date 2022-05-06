import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/merchandise_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/widgets/listtile/merchandise_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MerchandiseHistoryScreen extends StatefulWidget {
  const MerchandiseHistoryScreen({ Key? key }) : super(key: key);

  @override
  State<MerchandiseHistoryScreen> createState() => _MerchandiseHistoryScreenState();
}

class _MerchandiseHistoryScreenState extends State<MerchandiseHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  List<MerchandiseHistory> _histories = [];
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: FutureBuilder<List<MerchandiseHistory>>(
        future: MerchandiseHistory.getOwnedMerchandises(_provider.user!.userId!, _histories.length, 10),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<MerchandiseHistory> data = snapshot.data!;

            if (_histories.isEmpty) {
              Future.delayed(Duration.zero, () {
                _histories.addAll(data);
                data = [];
                setState(() {});
              });
            }

            if (data.isEmpty) {
              Future.delayed(Duration.zero, () {
                _hasReachedMax = true;
                data = [];
                setState(() {});
              });
            }

            _scrollController.addListener(() {
              double currentScroll = _scrollController.position.pixels;
              double maxScroll = _scrollController.position.maxScrollExtent;

              if (currentScroll == maxScroll) {
                if (!_hasReachedMax) {
                  List<MerchandiseHistory> temp = [];
                  temp.addAll(_histories);
                  _histories.clear();
                  _histories.addAll([...temp, ...data]);
                  data.clear();
                  setState(() {});
                }
              }
            });
          }

          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return (index < _histories.length)
                  ? MerchandiseListTile(history: _histories[index])
                  : const Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      ),
                    );
                },
                itemCount: (_hasReachedMax || _histories.isEmpty) ? _histories.length : _histories.length + 1,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}