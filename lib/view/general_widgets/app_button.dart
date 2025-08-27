import 'package:flutter/material.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/utils/styles.dart';
import 'package:myid_scan/view/general_widgets/app_loader.dart';

/// A custom App button. This was built to adapt to the our in-house button style.
/// Works similarly to default flutter button except for its aesthetic changes.
/// It currently support various AppButtonStyles
/// [AppButtonStyle.primary],
/// [AppButtonStyle.secondary],
/// which primarily decides the background and foreground colors of the buttons only.
/// Its represented by various states such as *isEnabled* which alters the state of the button
/// view and also disable it click action, similar to the *isLoading* which enables the loading view of the button.
/// ### Params
/// * [text] - represents the text to show in the button
/// * [height] - default button height
/// * [width] - default button width
/// * [isEnabled] - determines whether button should be clickable, invoke callback or not. Can also be use to modify
/// how button view reacts to click events and UI changes.
/// * [isLoading] - determines whether button should show loading state or not
/// * [buttonStyle] - can be use to determine the style applied to button as mentioned above
/// * [onTap] - a simple callback that gets triggered when button is pressed
///

class AppButton extends StatefulWidget {
  const AppButton({
    required this.onTap,
    this.height,
    this.width = AppButtonStyle.buttonDefaultWidth,
    this.isEnabled = AppButtonStyle.buttonIsEnable,
    this.isLoading = AppButtonStyle.buttonIsLoading,
    this.cornerRadius = AppButtonStyle.buttonCornerRadius,
    this.padding = 15,
    this.buttonStyle,
    this.text,
    this.shouldHaveHeight = true,
    super.key,
  });
  final String? text;
  final double? height;
  final double? width;
  final double cornerRadius;
  final bool isEnabled;
  final bool isLoading;
  final AppButtonStyle? buttonStyle;
  final VoidCallback onTap;
  final double padding;
  final bool shouldHaveHeight;

  @override
  State<AppButton> createState() => _AppButton();
}

class _AppButton extends State<AppButton> {
  bool isClicked = false;
  late AppButtonStyle _buttonStyle;
  double? height;

  @override
  void initState() {
    _buttonStyle = widget.buttonStyle ?? AppButtonStyle.primary();
    if (widget.shouldHaveHeight) {
      height = widget.height ?? AppButtonStyle.buttonDefaultHeight;
      setState(() {});
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    _buttonStyle = widget.buttonStyle ?? AppButtonStyle.primary();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive() ? widget.onTap : null,
      onTapDown: (_) {
        showClickEffect(show: true);
      },
      onTapUp: (_) {
        showClickEffect(show: false);
      },
      child: Container(
        padding: EdgeInsets.only(top: widget.padding, bottom: widget.padding),
        width: widget.width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: _buttonStyle.borderColor,
          ),
          gradient: switch (!widget.isEnabled) {
            true => null,
            _ => LinearGradient(
                colors: [
                  _buttonStyle.start,
                  _buttonStyle.end,
                ],
              ),
          },
          borderRadius: BorderRadius.circular(widget.cornerRadius),
          color: widget.isEnabled ? null : _buttonStyle.disabledBackgroundColor,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!widget.isLoading)
              Text(
                widget.text ?? 'Continue',
                style: context.textTheme.s15w500.copyWith(
                  color: widget.isEnabled
                      ? _buttonStyle.textColor
                      : _buttonStyle.disabledTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            if (widget.isLoading) ...[
              const SizedBox(width: 20),
              const AppLoader(),
            ],
          ],
        ),
      ),
    );
  }

  void showClickEffect({required bool show}) {
    if (isActive()) {
      setState(() {
        isClicked = show;
      });
    }
  }

  bool isActive() =>
      widget.isEnabled && (!widget.isLoading || widget.isLoading);
}
