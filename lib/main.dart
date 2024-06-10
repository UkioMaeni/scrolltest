import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
double _panelHeight = 0; // Начальная высота панели
double widgetHeight=0;
  bool _isPanelOpen = false;
  bool _isPhys=false;
  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _panelHeight = _panelHeight - details.delta.dy;
     // print(widgetHeight);
      print(_panelHeight);
      print(widgetHeight);
      _panelHeight = _panelHeight.clamp(0,_isPanelOpen? widgetHeight+10-300:MediaQuery.of(context).size.height-300);
      if (_panelHeight >= MediaQuery.of(context).size.height-300) {
        _isPanelOpen = true;
        _isPhys=true;
        
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      if (_panelHeight >= MediaQuery.of(context).size.height-300) {
        _isPanelOpen = true;
        _isPhys=true;
        _panelHeight = widgetHeight-300;
      } else {
       _isPanelOpen = false;
        _panelHeight = 0;
      }
    });
  }

  
  double offset0=0;
  void _handleScroll(double offset) {
    
    if(offset<MediaQuery.of(context).size.height-300){
      _panelHeight = offset;
     
    }else{
      _panelHeight=MediaQuery.of(context).size.height-300;
    }
    double velocity=offset-offset0;
    print("velocity"+velocity.toString());
    if(velocity>6&&offset<MediaQuery.of(context).size.height-300){
      return _scrollController.jumpTo(MediaQuery.of(context).size.height-300);
    }

      offset0=offset;
      setState(() {
        
      });
  }
  final ScrollController _scrollController = ScrollController();

  bool processinf=false;

  endScroll(){
    print(_isPanelOpen);
    if(!_isPanelOpen){
      processinf=true;
       print("geeeerr");
       print((MediaQuery.of(context).size.height-300)/2);
      if(_scrollController.offset>=(MediaQuery.of(context).size.height-300)/2&&_scrollController.offset<=MediaQuery.of(context).size.height-300){
        Future.delayed(Duration.zero, () {
             _scrollController.animateTo(MediaQuery.of(context).size.height-300, duration: Duration(milliseconds: 300), curve: Curves.linear);
          });
       
      }else if(_scrollController.offset<(MediaQuery.of(context).size.height-300)/2){
        print("uf");
        Future.delayed(Duration.zero, () {
            _scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn).then((_){
                print(_scrollController.offset);
              });
          });
        //_scrollController.jumpTo(0);
        
        
      }
     
    }
    processinf=false;
  }
double interpolateValue(double value, double minValue, double maxValue, double startRange, double endRange) {

  if (value < minValue) {
    print('interpolatedValue'+startRange.toString());
    return startRange;
    
  } else if (value > maxValue) {
    print('interpolatedValue'+endRange.toString());
    return endRange;
  }

  // Нормализация значений
  double normalizedValue = (value - minValue) / (maxValue - minValue);

  // Интерполяция
  double interpolatedValue = startRange + (endRange - startRange) * normalizedValue;
  print('interpolatedValue'+interpolatedValue.toString());
  return interpolatedValue;
}
  @override
  void initState() {
    _scrollController.addListener(() { 
    _scrollController;
     print(_scrollController.offset);
      if(!_isPanelOpen){
        setState(() {
          _handleScroll(_scrollController.offset);
          
        });
      }else{
        setState(() {
          _isPhys=true;
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  //   print("_isPanelOpen"); 
  //  print(_isPanelOpen); 
  //  print("_isPhys"); 
  //  print(_isPhys); 
  interpolateValue(_panelHeight,0,MediaQuery.of(context).size.height-300,0,1);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                    width:  MediaQuery.of(context).size.width,
                    height: _panelHeight+300,
                    color: const Color.fromARGB(0, 244, 67, 54),
                    child:NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) { 
                          if (scrollNotification is ScrollEndNotification &&!_isPanelOpen&&!processinf){
                            endScroll();
                          }
                          return true;
                        },
                      child: ListView(
                        controller: _scrollController,
                          children: [
                            SizedBox(height: _isPanelOpen?0:_panelHeight,),
                             Stack(
                                children: [
                                  Opacity(
                                    opacity: interpolateValue(_panelHeight,0,MediaQuery.of(context).size.height-300,0,1),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 300,
                                          width: 300,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          height: 300,
                                          width: 300,
                                          color: Colors.blueAccent,
                                        ),
                                        Container(
                                          height: 300,
                                          width: 300,
                                          color: Colors.amber,
                                        ),
                                        Container(
                                          height: 300,
                                          width: 300,
                                          color: Colors.blueAccent,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Opacity(
                                    opacity:1- interpolateValue(_panelHeight,0,MediaQuery.of(context).size.height-300,0,1),
                                    child: Container(
                                        height: 300,
                                        width: 300,
                                        color: Color.fromARGB(255, 28, 161, 57),
                                      ),
                                  ),
                                ],
                              ),
                            
                            
                            
                            
                          ],
                        ),
                    ),            
                  
                ),
            )
          ],
        ),
      )
     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyCustomPanel extends StatefulWidget {
  const MyCustomPanel({Key? key}) : super(key: key);

  @override
  State<MyCustomPanel> createState() => _MyCustomPanelState();
}

class _MyCustomPanelState extends State<MyCustomPanel> {
  double _panelHeight = 0; // Начальная высота панели

  bool _isPanelOpen = false; // Состояние панели (открыта/закрыта)

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _panelHeight = _panelHeight + details.delta.dy;
      _panelHeight = _panelHeight.clamp(0, MediaQuery.of(context).size.height);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      if (_panelHeight > MediaQuery.of(context).size.height * 0.5) {
        _isPanelOpen = true;
        _panelHeight = MediaQuery.of(context).size.height;
      } else {
        _isPanelOpen = false;
        _panelHeight = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Выдвижная панель'),
            pinned: true,
          ),
        
          
        ],
      ),
    );
  }
}