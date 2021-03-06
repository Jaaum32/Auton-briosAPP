import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:share/share.dart';
import 'package:image/image.dart' as Img;

class QrCodeGenerator extends StatefulWidget {
  int? idCaixa;
  QrCodeGenerator({this.idCaixa});

  @override
  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {

  late CustomPaint qr;

  @override
  Widget build(BuildContext context) {
    final message =
    // ignore: lines_longer_than_80_chars
    widget.idCaixa.toString();

    final qrFutureBuilder = CustomPaint(
      size: Size.square(280.0),
      painter: QrPainter(
        color: Color(0xff123456),
        emptyColor: Color(0xffffffff),
        data: message,
        version: QrVersions.auto,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(0xff123456),
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          //color: Color(0xff123456),
        ),
        // size: 320.0,
        embeddedImage: null,
        embeddedImageStyle: null,
      ),
    );

    qr = qrFutureBuilder;

    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    width: 280,
                    child: qrFutureBuilder,
                  ),
                ),
              ),
              // Center(
              //   child: Row(
              //     children: [
              //       Padding(
              //           padding: EdgeInsets.all(10.0),
              //         child: RaisedButton(
              //           onPressed: _compartilhar,
              //           child: Text("Compartilhar"),
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.all(10.0),
              //         child: RaisedButton(
              //           onPressed: _salvar,
              //           child: Text("Salvar"),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('images/logo.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }

  _compartilhar() async{
    String path = await createQrPicture();

    await Share.shareFiles(
        [path],
        mimeTypes: ["image/png"],
        subject: 'My QR code',
        text: 'Please scan me'
    );
  }

  _salvar() async {
    String path = await createQrPicture();

    /*await Share.shareFiles(
        [path],
        mimeTypes: ["image/png"],
        subject: 'My QR code',
        text: 'Please scan me'
    );*/

    final success = await GallerySaver.saveImage(path);

    Scaffold.of(context).showSnackBar(SnackBar(
      content: success! ? Text('Imagem salva na Galeria') : Text(
          'Erro ao salvar imagem'),
    ));
  }

  Future<String> createQrPicture() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final ts = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    String path = '$tempPath/$ts.png';

    QrPainter? qrPainter = qr.painter as QrPainter?;


    final picData = await qrPainter!.toImageData(
        2048.0, format: ui.ImageByteFormat.png);
    //ByteData a;
    await writeToFile(picData!, path);
    return path;
  }

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    var a = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    a = (await removeBlackBackground(a))!;

    await File(path).writeAsBytes(a
    );
  }


  Future<Uint8List?> removeBlackBackground(Uint8List bytes) async {
    Img.Image? image = Img.decodeImage(bytes);
    Img.Image transparentImage = await colorTransparent(image!, 0, 0, 0);
    Future<Uint8List?> newPng = Img.encodePng(transparentImage) as Future<Uint8List?>;
    return newPng;
  }

  Future<Img.Image> colorTransparent(Img.Image src, int red, int green, int blue) async {
    var pixels = src.getBytes();
    for (int i = 0, len = pixels.length; i < len; i += 4) {
      if ((pixels[i] != 18
        || pixels[i + 1] != 52
        || pixels[i + 2] != 86)
      ) {
        pixels[i + 3] = 255;
        pixels[i] = 255;
        pixels[i + 1] = 255;
        pixels[i + 2] = 255;
      }
    }

    return src;
  }
}
