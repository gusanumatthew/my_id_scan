// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import for Clipboard
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myid_scan/core/extensions/context_extensions.dart';
import 'package:myid_scan/core/extensions/overlay_extensions.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/extensions/widget_extensions.dart';
import 'package:myid_scan/core/utils/colors.dart';
import 'package:myid_scan/core/utils/enums.dart';
import 'package:myid_scan/view/general_widgets/app_bar.dart';
import 'package:myid_scan/view/general_widgets/app_button.dart';
import 'package:myid_scan/view/home/model/business_card_model.dart';
import 'package:myid_scan/view/home/notifiers/home_notifiers.dart';
import 'package:myid_scan/view/home/views/widgets/select_image.dart';
import 'package:share_plus/share_plus.dart';

class Scan extends ConsumerStatefulWidget {
  const Scan({super.key});

  @override
  ConsumerState<Scan> createState() => _ScanState();
}

class _ScanState extends ConsumerState<Scan> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectImage = await _picker.pickImage(source: source);
    if (selectImage != null) {
      setState(() {
        _image = selectImage;
      });
    }
  }

  void _scan() {
    ref.read(homeNotifierProvider.notifier).scanCard(
        imagePath: _image?.path ?? '',
        onError: (p0) {
          context.showError(message: p0);
        },
        onSuccess: () {
          setState(() {
            _image = null;
          });
        });
  }

  void _onShare() {
    final result = ref.read(homeNotifierProvider.select((v) => v.scanResult));
    SharePlus.instance.share(
      ShareParams(
          title: 'ID Card Details', // Changed title
          text: _formatBusinessCardData(result!)),
    );
  }

  void _copyToClipboard(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));

    context.showSuccess(message: '$label copied to clipboard');
  }

  String _formatBusinessCardData(BusinessCardData result) {
    List<String> lines = [];

    // Prioritize ID Card details
    if (result.matricNumber != null || result.session != null) {
      lines.add("🎓 Student ID Card Details");
    } else {
      lines.add("📇 Business Card Details");
    }
    lines.add("");

    // ID Card Specific Fields
    if (result.company != null && result.company!.trim().isNotEmpty) {
      lines.add("🏫 Institution: ${result.company!.trim()}");
    }
    if (result.session != null && result.session!.trim().isNotEmpty) {
      lines.add("🗓️ Session: ${result.session!.trim()}");
    }
    if (result.matricNumber != null && result.matricNumber!.trim().isNotEmpty) {
      lines.add("🆔 Matric No: ${result.matricNumber!.trim()}");
    }
    if (result.lastName != null && result.lastName!.trim().isNotEmpty) {
      lines.add("🗂️ Surname: ${result.lastName!.trim()}");
    }
    if (result.firstName != null && result.firstName!.trim().isNotEmpty) {
      lines.add("👤 Other Names: ${result.firstName!.trim()}");
    }
    if (result.faculty != null && result.faculty!.trim().isNotEmpty) {
      lines.add("🏛️ Faculty: ${result.faculty!.trim()}");
    }
    if (result.department != null && result.department!.trim().isNotEmpty) {
      lines.add("⚙️ Department: ${result.department!.trim()}");
    }
    if (result.level != null && result.level!.trim().isNotEmpty) {
      lines.add("📊 Level/Class: ${result.level!.trim()}");
    }

    // General Contact Fields (might still be useful)
    if (result.title != null && result.title!.trim().isNotEmpty) {
      lines.add("💼 Title: ${result.title!.trim()}");
    }
    if (result.address != null && result.address!.trim().isNotEmpty) {
      lines.add("📍 Address: ${result.address!.trim()}");
    }

    if (result.phoneNumbers.isNotEmpty) {
      final validPhones = result.phoneNumbers
          .where((phone) => phone.trim().isNotEmpty)
          .toList();

      if (validPhones.isNotEmpty) {
        if (validPhones.length == 1) {
          lines.add("📞 Phone: ${validPhones.first}");
        } else {
          lines.add("📞 Phone Numbers:");
          for (int i = 0; i < validPhones.length; i++) {
            lines.add("   ${i + 1}. ${validPhones[i]}");
          }
        }
      }
    }

    if (result.emails.isNotEmpty) {
      final validEmails =
          result.emails.where((email) => email.trim().isNotEmpty).toList();

      if (validEmails.isNotEmpty) {
        if (validEmails.length == 1) {
          lines.add("📧 Email: ${validEmails.first}");
        } else {
          lines.add("📧 Email Addresses:");
          for (int i = 0; i < validEmails.length; i++) {
            lines.add("   ${i + 1}. ${validEmails[i]}");
          }
        }
      }
    }

    if (result.websites.isNotEmpty) {
      final validWebsites = result.websites
          .where((website) => website.trim().isNotEmpty)
          .toList();

      if (validWebsites.isNotEmpty) {
        if (validWebsites.length == 1) {
          lines.add("🌐 Website: ${validWebsites.first}");
        } else {
          lines.add("🌐 Websites:");
          for (int i = 0; i < validWebsites.length; i++) {
            lines.add("   ${i + 1}. ${validWebsites[i]}");
          }
        }
      }
    }

    // Check if any useful data was added
    // The initial header and two new lines add 3 items, so check > 3
    if (lines.length > 3) {
      lines.add("");
      lines.add("Generated by MyID Scan App");
    } else {
      return "No business card or ID data available to share.";
    }

    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(homeNotifierProvider.select((v) => v.scanResult));

    return Scaffold(
      appBar: IdAppBar(
        title: 'Scan Card', // Simplified title
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: Image.file(
                        File(_image!.path),
                        fit: BoxFit.cover,
                        height: 200.h,
                        width: context.width,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        ref.read(homeNotifierProvider.notifier).resetState();
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return SelectImage(
                              onPickFile: (p0) {
                                _pickImage(p0);
                              },
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Upload Card',
                            style: context.textTheme.s16w500,
                          ),
                          8.horizontalSpace,
                          RotatedBox(
                            quarterTurns: 3,
                            child: const Icon(Icons.logout),
                          ),
                        ],
                      ),
                    ).withContainer(
                      alignment: Alignment.center,
                      border: Border.all(
                        color: AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(
                        15.r,
                      ),
                      height: 200.h,
                      width: context.width,
                    ),
              24.verticalSpace,
              if (result != null) ...[
                _buildScanResults(result),
              ]
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Consumer(builder: (context, r, c) {
          final loadState =
              r.watch(homeNotifierProvider.select((v) => v.scanLoadState));
          return AppButton(
            isEnabled: _image != null,
            isLoading: loadState.isLoading,
            text: 'Scan',
            onTap: _scan,
          );
        }),
      ),
    );
  }

  Widget _buildScanResults(BusinessCardData result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scan Results',
            style: context.textTheme.s18w600,
          ),
          const SizedBox(height: 16),

          // --- ID CARD SPECIFIC FIELDS ---
          if (result.company != null)
            _buildResultRow('Institution', result.company!),
          if (result.session != null)
            _buildResultRow('Session', result.session!),
          if (result.matricNumber != null)
            _buildResultRow('Matric No', result.matricNumber!),

          // Name is often split into surname and other names
          if (result.lastName != null)
            _buildResultRow('Surname', result.lastName!),
          if (result.firstName != null)
            _buildResultRow('Other Names', result.firstName!),

          if (result.faculty != null)
            _buildResultRow('Faculty', result.faculty!),
          if (result.department != null)
            _buildResultRow(
                'Dept', result.department!), // 'Dept' is shorter for display
          if (result.level != null) _buildResultRow('Level', result.level!),

          // --- GENERAL FIELDS ---
          if (result.title != null) _buildResultRow('Title', result.title!),

          // Address might contain the P.M.B info
          if (result.address != null)
            _buildResultRow('Address', result.address!),

          // Contact info might still be extracted
          if (result.phoneNumbers.isNotEmpty)
            _buildResultList('Phone', result.phoneNumbers),
          if (result.emails.isNotEmpty)
            _buildResultList('Email', result.emails),
          if (result.websites.isNotEmpty)
            _buildResultList('Website', result.websites),

          8.verticalSpace,
          GestureDetector(
            onTap: _onShare,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Share',
                  style: context.textTheme.s16w500,
                ),
                8.horizontalSpace,
                Icon(Icons.share)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '',
            style: context.textTheme.s14w600,
          ),
          Expanded(
            child: Text(
              value,
              style: context.textTheme.s14w400,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => _copyToClipboard(value, label),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.copy,
                size: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultList(String label, List<String> values) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '',
                // '$label:',
                style: context.textTheme.s14w600,
              ),
              Expanded(
                child: Text(
                  '${values.length} item${values.length > 1 ? 's' : ''}',
                  style: context.textTheme.s12w400.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _copyToClipboard(values.join(', '), label),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.copy_all,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          ...values.map((value) => Padding(
                padding: const EdgeInsets.only(left: 80, top: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: context.textTheme.s14w400,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _copyToClipboard(value, label),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.copy,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
