import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailObat extends StatefulWidget {
  const DetailObat({super.key});

  @override
  State<DetailObat> createState() => _DetailObatState();
}

class _DetailObatState extends State<DetailObat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Detail Obat",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_left,
              size: 50, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {  },)
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          // Set the shape of the card using a rounded rectangle border with a 8 pixel radius
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          // Set the clip behavior of the card
          clipBehavior: Clip.antiAliasWithSaveLayer,
          // Define the child widgets of the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Display an image at the top of the card that fills the width of the card and has a height of 160 pixels
              Image.asset(
                ('assets/images/obat-detail.png'),
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              // Add a container with padding that contains the card's title, text, and buttons
              Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            ('assets/images/JAMU.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Obat Jamu',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    // Display the card's title using a font size of 24 and a dark grey color
                    Text(
                      "Paracetamol 500 mg",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Add a space between the title and the text
                    Container(height: 10),
                    // Display the card's text using a font size of 15 and a light grey color
                    Text(
                      'Tanggal Kadaluarsa : DD/MM/YYYY',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      'Stok : 999',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    // Add a row with two buttons spaced apart and aligned to the right side of the card
                  ],
                ),
              ),
              // Add a small space between the card and the next widget
              Container(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
