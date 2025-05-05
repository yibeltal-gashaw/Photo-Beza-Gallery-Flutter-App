import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: size.height * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.white38,
              spreadRadius: 3,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'መልካም',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Washera',
                            color: Colors.black
                          ),
                          children: [
                            TextSpan(
                              text: ' ፋሲካ',
                              style: TextStyle(
                                color: Colors.amberAccent,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Washera'
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Text('20', style: TextStyle(fontSize: 35, color: Colors.grey[600]),),
                          SizedBox(width: 5,),
                          Column(children: [
                            Text("%", style: TextStyle(fontSize: 13, color: Colors.grey[600]),),
                            Text("OFF", style: TextStyle(fontSize: 13, color: Colors.grey[600]),),
                          ],),
                        ],
                      ),
                      SizedBox(height: 10,),
                      ],
          
                  ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/fasika.png', fit: BoxFit.cover, width: 250, height: 250,)),
                ),
              ),
            ],
          ),
        )
    ));
  }
}