// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/utils/colors.dart';
import 'package:myid_scan/core/utils/enums.dart';
import 'package:myid_scan/core/utils/typedefs.dart';
import 'package:myid_scan/gen/assets.gen.dart';
import 'package:myid_scan/view/general_widgets/app_loader.dart';

class AppOverLay extends StatefulWidget {
  const AppOverLay({
    required this.child,
    required this.controller,
    super.key,
    this.messagePadding,
  });
  final Widget child;
  final OverLayController controller;
  final EdgeInsetsGeometry? messagePadding;

  @override
  State<AppOverLay> createState() => _AppOverLayState();

  static _AppOverLayState of(BuildContext context) {
    final result = context.findAncestorStateOfType<_AppOverLayState>();
    if (result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'AppOverLay.of() called with a context that does not contain a AppOverLay.',
      ),
      ErrorDescription(
        'No AppOverLay ancestor could be found starting from the context that was passed to AppOverLay.of(). '
        'This usually happens when the context provided is from the same StatefulWidget as that '
        'whose build function actually creates the AppOverLay widget being sought.',
      ),
      context.describeElement('The context used was'),
    ]);
  }
}

class _AppOverLayState extends State<AppOverLay> {
  OverLayController get controller => widget.controller;
  double scale = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        widget.child,
        ValueListenableBuilder<
            ({OverLayType type, MessageText? msg, Color? color})>(
          valueListenable: widget.controller._valueNotifier,
          builder: (context, listen, child) {
            if (listen.type == OverLayType.loader) {
              return Positioned.fill(
                child: Material(
                  color: Colors.black.withValues(alpha: .5),
                  child: AppLoader(
                    color: listen.color ?? Colors.white,
                  ),
                ),
              );
            } else if (listen.type == OverLayType.message) {
              return SafeArea(
                child: Container(
                  padding: widget.messagePadding ?? const EdgeInsets.all(20),
                  alignment: Alignment.topCenter,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: -40, end: 0),
                    curve: Curves.easeInOut,
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, value),
                        child: _messageWidget(
                          messageIcon: Assets.svgs.tickCircle,
                          messageText: listen.msg,
                          messageColor:
                              listen.msg?.messageType == MessageType.error
                                  ? AppColors.lightRed
                                  : AppColors.white,
                          onClose: () {
                            controller.removeOverLay();
                          },
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _messageWidget({
    required MessageText? messageText,
    required String messageIcon,
    required Color messageColor,
    required VoidCallback onClose,
  }) {
    return Material(
      color: messageText?.messageType == MessageType.error
          ? const Color(0XFFFB3748)
          : Color(0xFF1FC16B),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: 63,
          maxWidth: MediaQuery.of(context).size.width,
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(
              messageIcon,
              colorFilter: ColorFilter.mode(
                messageColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                messageText?.message ?? '',
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.s16w500.copyWith(
                      color: AppColors.white,
                    ),
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OverLayController {
  final ValueNotifier<({OverLayType type, MessageText? msg, Color? color})>
      _valueNotifier =
      ValueNotifier((type: OverLayType.none, msg: null, color: null));

  void showLoader({Color? color}) {
    _valueNotifier.value = (type: OverLayType.loader, msg: null, color: color);
  }

  void showError({required String message, String? title}) {
    _valueNotifier.value = (
      type: OverLayType.message,
      msg: (
        message: message,
        title: title ?? 'Error',
        messageType: MessageType.error
      ),
      color: AppColors.red,
    );
    Future.delayed(const Duration(seconds: 3), removeOverLay);
  }

  void showSuccess({required String message, String? title}) {
    _valueNotifier.value = (
      type: OverLayType.message,
      msg: (
        message: message,
        title: title ?? 'Success',
        messageType: MessageType.success
      ),
      color: AppColors.green,
    );
    Future.delayed(const Duration(seconds: 3), removeOverLay);
  }

  void showToast({
    required String message,
  }) {
    _valueNotifier.value = (
      type: OverLayType.toast,
      msg: (
        message: message,
        title: '',
        messageType: MessageType.success,
      ),
      color: AppColors.red,
    );
    Future.delayed(const Duration(milliseconds: 1500), removeOverLay);
  }

  void removeOverLay() {
    _valueNotifier.value = (type: OverLayType.none, msg: null, color: null);
  }

  void dispose() => _valueNotifier.dispose();
}
