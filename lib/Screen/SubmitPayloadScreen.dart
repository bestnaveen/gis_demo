import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmitPayloadScreen extends StatelessWidget {
  dynamic payload;
  dynamic response;
   SubmitPayloadScreen(this.payload,this.response,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(),
            Text('Payload',style: TextStyle(fontSize: 18),),
            Text(payload),
            Divider(),
            Text('Response',style: TextStyle(fontSize: 18),),
            Text(response['Data'].toString()??'-'),
            Text(response['Status']['MessageList'][0]['MessageTitle']??'-'),
            Divider(),
          ],
        ),
      ),
    );
  }
}
