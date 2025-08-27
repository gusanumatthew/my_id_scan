// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myid_scan/core/extensions/overlay_extensions.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/extensions/widget_extensions.dart';
import 'package:myid_scan/view/general_widgets/app_sheet.dart';
import 'package:myid_scan/view/home/model/card_model.dart';
import 'package:myid_scan/view/home/views/widgets/card_reciept.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareCard extends StatefulWidget {
  const ShareCard({super.key, required this.args});
  final CardParams args;

  @override
  State<ShareCard> createState() => _ShareCardState();
}

class _ShareCardState extends State<ShareCard> {
  late final ScreenshotController _controller;
  final ValueNotifier<bool> _recieptLoading = ValueNotifier(false);
  bool isImage = false;

  @override
  void initState() {
    super.initState();
    _controller = ScreenshotController();
  }

  @override
  void dispose() {
    _recieptLoading.dispose();
    super.dispose();
  }

  Future<File?> _getReceiptPdfFromImage(String imagePath) async {
    try {
      final doc = pw.Document();
      final imageBytes = await File(imagePath).readAsBytes();
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.undefined,
          build: (pw.Context context) {
            return pw.Image(
              pw.MemoryImage(imageBytes),
            );
          },
        ),
      );

      final b = await doc.save();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${widget.args.businessName}.pdf');
      await file.writeAsBytes(b);
      return file;
    } catch (_) {
      return null;
    }
  }

  void _shareReceipt(String filePath) async {
    final l = await SharePlus.instance.share(ShareParams(files: [
      XFile(
        filePath,
        name: widget.args.businessName,
      )
    ]));
    if (l.status == ShareResultStatus.success && mounted) {
      Navigator.pop(context);
    }
  }

  Future<String?> _getReceiptImage(bool s) async {
    try {
      _recieptLoading.value = true;
      final image = await _controller.captureFromWidget(
        CardReceipt(
          args: widget.args,
        ),
        context: context,
      );

      final directory = await getTemporaryDirectory();
      final imageFile =
          await File('${directory.path}/${widget.args.businessName}.png')
              .create();
      await imageFile.writeAsBytes(image);

      return imageFile.path;
    } catch (_) {
      return null;
    } finally {
      _recieptLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: 'Choose Share Option',
      content: Stack(
        children: [
          ValueListenableBuilder<bool>(
              valueListenable: _recieptLoading,
              builder: (context, r, c) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            isImage = true;
                          });
                          if (r) return;
                          _getReceiptImage(false).then((value) {
                            if (value == null) {
                              context.showError(
                                  message: 'Error sharing reciept');
                              return;
                            }
                            _shareReceipt(value);
                          });
                        },
                        child: Row(children: [
                          (r && isImage)
                              ? const CupertinoActivityIndicator()
                              : const Icon(Icons.camera),
                          const SizedBox(width: 10),
                          Text('Share as Image',
                              style: context.textTheme.s14w600),
                        ]).withContainer(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(10),
                        )),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isImage = false;
                        });
                        if (r) return;

                        _getReceiptImage(false).then((value) {
                          if (value == null) {
                            context.showError(message: 'Error sharing card');
                            return;
                          }
                          _getReceiptPdfFromImage(value).then((value) {
                            if (value == null) {
                              context.showError(message: 'Error sharing card');
                              return;
                            }
                            _shareReceipt(value.path);
                          });
                        });
                      },
                      child: Row(children: [
                        (r && !isImage)
                            ? const CupertinoActivityIndicator()
                            : Icon(
                                Icons.picture_as_pdf,
                              ),
                        const SizedBox(width: 10),
                        Text('Share as PDF', style: context.textTheme.s14w600),
                      ]).withContainer(
                        padding: const EdgeInsets.all(16),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
