import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myid_scan/core/extensions/navigation_extensions.dart';
import 'package:myid_scan/core/extensions/overlay_extensions.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/extensions/widget_extensions.dart';
import 'package:myid_scan/core/router/router.dart';
import 'package:myid_scan/core/utils/colors.dart';
import 'package:myid_scan/core/utils/enums.dart';
import 'package:myid_scan/core/utils/logger.dart';
import 'package:myid_scan/core/utils/vaidators.dart';
import 'package:myid_scan/view/general_widgets/app_bar.dart';
import 'package:myid_scan/view/general_widgets/app_button.dart';
import 'package:myid_scan/view/general_widgets/app_textfield.dart';
import 'package:myid_scan/view/home/model/card_model.dart';
import 'package:myid_scan/view/home/notifiers/card_notifiers.dart';
import 'package:path/path.dart' as path;

class CreateCard extends ConsumerStatefulWidget {
  const CreateCard({super.key});

  @override
  ConsumerState<CreateCard> createState() => _CreateCardState();
}

class _CreateCardState extends ConsumerState<CreateCard> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyAddressController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _webController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isEnabled = false;
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

  _upload() {
    ref.read(cardNotifierProvider.notifier).uploadFile(
        path: _image?.path ?? '',
        onError: (p0) {
          debugLog(p0);
          context.showError(
            message: p0,
          );
        },
        onSuccess: (p0) {
          context.replaceNamed(
            AppRouter.templates,
            arguments: CardParams(
              fullName: _nameController.text,
              imageUrl: p0,
              jobTitle: _jobTitleController.text,
              address: _companyAddressController.text,
              businessName: _companyNameController.text,
              phone: _phoneController.text,
              email: _emailController.text,
              website: _webController.text,
              fromSaved: false,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IdAppBar(
        title: 'Fill Your Details',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Form(
                key: _formKey,
                onChanged: () {
                  setState(() {
                    isEnabled = _formKey.currentState!.validate();
                  });
                },
                child: Column(
                  children: [
                    AppFormField(
                      label: 'Full Name',
                      controller: _nameController,
                      validateFunction: Validators.name(),
                    ),
                    AppFormField(
                      label: 'Job Title',
                      controller: _jobTitleController,
                      validateFunction: Validators.notEmpty(),
                    ),
                    AppFormField(
                      label: 'Business Name',
                      controller: _companyNameController,
                      validateFunction: Validators.notEmpty(),
                    ),
                    AppFormField(
                      label: 'Business Address',
                      validateFunction: Validators.notEmpty(),
                      controller: _companyAddressController,
                    ),
                    AppFormField(
                      label: 'Phone',
                      controller: _phoneController,
                      validateFunction: Validators.phone(),
                    ),
                    AppFormField(
                      label: 'Email',
                      controller: _emailController,
                      validateFunction: Validators.email(),
                    ),
                    AppFormField(
                      label: 'Website / Social Media Link',
                      controller: _webController,
                      validateFunction: Validators.url(
                        'Please enter a complete URL with http:// or https://',
                        true,
                      ),
                    ),
                    _image != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  path.basename(_image!.path),
                                  style: context.textTheme.s16w500,
                                  maxLines: 1,
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    color: AppColors.red,
                                  ))
                            ],
                          )
                        : GestureDetector(
                            onTap: () => _pickImage(ImageSource.gallery),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Upload Logo',
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
                            padding: EdgeInsets.all(16),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.border,
                            ),
                          ),
                    22.verticalSpace,
                    Consumer(builder: (context, r, c) {
                      final loadState = r.watch(
                          cardNotifierProvider.select((v) => v.loadState));
                      return AppButton(
                        isEnabled: isEnabled &&
                            loadState != LoadState.loading &&
                            _image != null,
                        isLoading: loadState.isLoading,
                        onTap: _upload,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
