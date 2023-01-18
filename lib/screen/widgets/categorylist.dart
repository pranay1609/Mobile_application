import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:hy_application/mastercolor.dart';
import 'package:hy_application/screen/departmenwiseproject.dart';

import '../../model/categorymodel.dart';
import '../../model/departmentmodel.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  List<CategoryModel> _districtlist = [];
  List<DepartmentModel> _departmentList = [];
  void initState() {
    super.initState();
    fetchdistrict();
    // getallslider();
  }

  fetchdistrict() async {
    String geturl =
        '${GlobalConfiguration().getValue('api_base_url')}/Category';

    var response = await http.get(Uri.parse(geturl));
    var responsedata = jsonDecode(response.body);

    var districtliscountrydata = responsedata['data'];

    if (districtliscountrydata.isNotEmpty) {
      districtliscountrydata.forEach((d) {
        CategoryModel dtl =
            CategoryModel(title: "${d['title']}", department: d['department']);

        setState(() {
          _districtlist.add(dtl);
        });
      });
    } else {
      setState(() {
        _districtlist.clear();
      });

      print(" data not found");
    }
  }

  Widget _buildTiles(String title, List<dynamic> data, int department_id) {
    return InkWell(
      onTap: data.isNotEmpty
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Departmentwiseproject(department_id, title)),
              );
            }
          : () {},
      child: ListTile(
        leading: const Icon(Icons.list),
        title: Text(title),
      ),
    );
  }

  Widget build(BuildContext context) {
    return _districtlist.isEmpty
        ? Center(
            child: CircularProgressIndicator(
            color: defaultcolor,
          ))
        : ListView.builder(
            itemCount: _districtlist.length,
            itemBuilder: (BuildContext context, int index) {
              return _districtlist[index].department.isEmpty
                  ? _buildTiles(_districtlist[index].title,
                      _districtlist[index].department, 0)
                  : ExpansionTile(
                      leading: Icon(Icons.list),
                      title: Text(_districtlist[index].title),
                      children: _districtlist[index]
                          .department
                          .map((title) => Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: _buildTiles(
                                    title['title'],
                                    _districtlist[index].department,
                                    int.parse("${title['id']}")),
                              ))
                          .toList(),
                      // ListTile(
                      //     leading: const Icon(Icons.list),
                      //     title:
                      //         Text("${_districtlist[index].department.length}")

                      //         ),
                    );
            });
  }
}
