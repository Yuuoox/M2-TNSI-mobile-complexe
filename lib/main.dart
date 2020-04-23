import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/fragment/appbar/appbar.dart';
import 'package:flutterapp/pokedexview.dart';
import 'pokedex.dart';
import 'pokemon.dart';
import 'webservice.dart';
import 'package:flutterapp/globals.dart' as globals;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'PokeFlex',
			theme: ThemeData(
				// This is the theme of your application.
				//
				// Try running your application with "flutter run". You'll hysee the
				// application has a blue toolbar. Then, without quitting the app, try
				// changing the primarySwatch below to Colors.green and then invoke
				// "hot reload" (press "r" in the console where you ran "flutter run",
				// or simply save your changes to "hot reload" in a Flutter IDE).
				// Notice that the counter didn't reset back to zero; the application
				// is not restarted.
				primarySwatch: Colors.blue,
			),
			home: MyHomePage(),
		);
	}

}

class MyHomePage extends StatefulWidget {
	MyHomePage({Key key}) : super(key: key);
	final String title = "PokeFlex";
	@override
	_MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
	Pokedex pokedex = new Pokedex();

	List<Pokemon> savedPokemon = new List<Pokemon>();
	final ValueNotifier<int> _counter = ValueNotifier<int>(0);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBarView(title: widget.title, pokedex: pokedex),
			body: Center(
				child :
				Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: <Widget>[
						Flexible(child:Image(image: AssetImage('images/logo_title.png'))),
						Flexible(child:Image(image: AssetImage('images/pokeball.png'))),
						initPokedex(),
					],
				)
			)
		);
	}

	Widget initPokedex(){
		if(pokedex.pokemonsList.isNotEmpty){
			return RaisedButton(
				child: Text('Go to Pokedex'),
				onPressed: () {
					Navigator.push(
						context,
						MaterialPageRoute(builder: (context) => PokedexView.pok(pokedex : pokedex)),
					);
				},
			);
		}else{
			return FutureBuilder<Pokedex>(
				future: WebService.fetchPokedex(),
				builder: (BuildContext context, AsyncSnapshot<Pokedex> snapshot) {
					if (!snapshot.hasData){
						return new Center(child : new CircularProgressIndicator());
					}
					pokedex = new Pokedex.list(snapshot.data.pokemonsList);
					return RaisedButton(
						child: Text('Go to Pokedex'),
						onPressed: () {
							Navigator.push(
								context,
								MaterialPageRoute(builder: (context) => PokedexView.pok(pokedex : pokedex)),
							);
						},
					);
				},
			);
		}
	}
}
