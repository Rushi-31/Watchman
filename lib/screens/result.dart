import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';
import 'package:certificate_generator/utils/commons.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null || args['result'] == null || args['result'][0] == null) {
      return Scaffold(
        body: Center(
          child: Text('No data found.'),
        ),
      );
    }

    String name = args['result'][0];

    return Scaffold(
      backgroundColor: Colors.deepPurple[400],
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
          ),
        ),
        title: Container(
          child: Text('Result'),
        ),
        centerTitle: true,
        // Name and dummy photo of the participant below app-bar
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(64),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple[200],
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.deepPurple[100],
                      size: 35,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        // Certificate of particular participant
        builder: (context) => SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            color: Colors.deepPurple[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple[200],
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.deepPurple[100],
                    size: 100,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'certificate of completion',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'presented to:',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Download certificate
                    TextButton(
                      onPressed: () {
                        pdfGenerator(name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$name.pdf downloaded'),
                            action: SnackBarAction(
                              label: 'View',
                              onPressed: () async {
                                String downloadPath = await getApplicationDocumentsDirectoryPath();
                                Navigator.pushNamed(context, '/viewer', arguments: {
                                  'view': '$downloadPath/$name.pdf'
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.file_download),
                    ),

                    // View certificate
                    TextButton(
                      onPressed: () async {
                        String downloadPath = await getApplicationDocumentsDirectoryPath();
                        if (File('$downloadPath/$name.pdf').existsSync()) {
                          Navigator.pushNamed(context, '/viewer', arguments: {'view': '$downloadPath/$name.pdf'});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$name.pdf File Not Found'),
                              action: SnackBarAction(
                                label: 'Download',
                                onPressed: () {
                                  pdfGenerator(name);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('$name.pdf downloaded'),
                                      action: SnackBarAction(
                                        label: 'View',
                                        onPressed: () async {
                                          String downloadPath = await getApplicationDocumentsDirectoryPath();
                                          Navigator.pushNamed(context, '/viewer', arguments: {
                                            'view': '$downloadPath/$name.pdf'
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                      child: Icon(Icons.open_in_new),
                    ),

                    // Share certificate
                    TextButton(
                      onPressed: () async {
                        String downloadPath = await getApplicationDocumentsDirectoryPath();
                        if (File('$downloadPath/$name.pdf').existsSync()) {
                          ShareExtend.share(File('$downloadPath/$name.pdf').path, 'file');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$name.pdf File Not Found'),
                              action: SnackBarAction(
                                label: 'Download',
                                onPressed: () {
                                  pdfGenerator(name);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('$name.pdf downloaded'),
                                      action: SnackBarAction(
                                        label: 'View',
                                        onPressed: () async {
                                          String downloadPath = await getApplicationDocumentsDirectoryPath();
                                          Navigator.pushNamed(context, '/viewer', arguments: {
                                            'view': '$downloadPath/$name.pdf'
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                      child: Icon(Icons.share),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
