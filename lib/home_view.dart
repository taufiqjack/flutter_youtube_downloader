import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final txturl = TextEditingController();
  String _exstractLink = 'Loading...';
  String getId = (1).toString().padLeft(2, 'Video00');

  @override
  void initState() {
    super.initState();
    exstractYoutubeLink();
  }

  Future<void> exstractYoutubeLink() async {
    String link;
    try {
      link =
          await (FlutterYoutubeDownloader.extractYoutubeLink(txturl.text, 18));
    } on PlatformException {
      link = 'Failed to exstract YouTube Video Link!';
    }

    if (!mounted) return;
    setState(() {
      _exstractLink = link;
    });
  }

  Future<void> downloadVideo() async {
    final result =
        await FlutterYoutubeDownloader.downloadVideo(txturl.text, '$getId', 18);
    print('resul : $result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: formKey,
          child: TextFormField(
            decoration:
                const InputDecoration(hintText: 'Masukkan link Youtube disini'),
            controller: txturl,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value.toString().isEmpty) {
                return 'link tidak boleh kosong';
              }
              return null;
            },
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            downloadVideo();
          }
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
