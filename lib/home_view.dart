import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final txturl = TextEditingController();
  String? _exstractLink = 'Loading...';
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
    String pasteValue = '';
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              FontAwesomeIcons.youtube,
              color: Colors.red,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'YouTube Downloader',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: MediaQuery.of(context).size.height / 3),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Masukkan link Youtube disini',
                  suffixIcon: InkWell(
                      onTap: () {
                        FlutterClipboard.paste().then((value) {
                          setState(() {
                            txturl.text = value;
                            pasteValue = value;
                          });
                        });
                      },
                      child: const Icon(Icons.paste)),
                ),
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
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.blue),
              child: TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      downloadVideo();
                    }
                  },
                  child: const Text(
                    'Download',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}
