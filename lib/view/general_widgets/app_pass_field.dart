import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myid_scan/core/extensions/texttheme_extensions.dart';
import 'package:myid_scan/core/utils/colors.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    this.width,
    this.labelSpace = 8,
    this.padding = const SizedBox(
      height: 24,
    ),
    this.onTap,
    this.decoration,
    this.hintStyle,
    this.backgroundColor,
    this.isLoading = false,
    this.readOnly = false,
    this.customLabel,
    this.hintText,
    this.controller,
    this.minLines = 1,
    this.enabled = true,
    this.validateFunction,
    this.borderSide,
    this.onSaved,
    this.onChange,
    this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
    this.submitAction,
    this.enableErrorMessage = true,
    this.maxLines = 1,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.prefixIcon,
    this.bordercolor,
    this.autofocus,
    this.label,
    this.inputFormatters,
    this.borderRadius = 15,
    this.initialValue,
    this.labelSize,
    this.labelColor,
    this.obscureIconColor,
  });
  final double? width;
  final double? labelSize;
  final String? hintText;
  final TextEditingController? controller;
  final int? minLines;
  final int? maxLines;
  final bool? enabled;
  final FormFieldValidator<String>? validateFunction;
  final void Function(String)? onSaved;
  final void Function(String)? onChange;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final VoidCallback? submitAction;
  final bool? enableErrorMessage;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? bordercolor;
  final Color? backgroundColor;
  final Color? labelColor;
  final bool? autofocus;
  final String? label;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;
  final bool isLoading;
  final bool readOnly;
  final double borderRadius;
  final double labelSpace;
  final String? initialValue;
  final Widget? customLabel;
  final TextStyle? hintStyle;
  final BorderSide? borderSide;
  final Widget padding;
  final Color? obscureIconColor;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  String? error;
  bool obscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.customLabel != null) widget.customLabel!,
        if (widget.customLabel == null && widget.label != null)
          Text(
            widget.label!,
            style: context.textTheme.s14w400.copyWith(color: Colors.black),
          ),
        if (widget.customLabel != null || widget.label != null)
          SizedBox(height: widget.labelSpace),
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          initialValue: widget.initialValue,
          textAlign: TextAlign.left,
          inputFormatters: widget.inputFormatters,
          autofocus: widget.autofocus ?? false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: widget.enabled,
          validator: widget.validateFunction != null
              ? widget.validateFunction!
              : (value) {
                  return null;
                },
          onSaved: (val) {
            error = widget.validateFunction!(val);
            setState(() {});
            widget.onSaved!(val!);
          },
          onChanged: (val) {
            widget.validateFunction != null
                ? error = widget.validateFunction!(val)
                : error = null;
            setState(() {});
            widget.onChange?.call(val);
          },
          style: const TextStyle(
            fontSize: 16,
          ),
          cursorColor: AppColors.primaryColor,
          key: widget.key,
          maxLines: widget.maxLines,
          controller: widget.controller,
          obscureText: obscure,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: widget.decoration ??
              InputDecoration(
                prefixIcon: widget.prefixIcon,
                suffixIcon: GestureDetector(
                  onTap: () => setState(
                    () {
                      obscure = !obscure;
                    },
                  ),
                  child: Icon(
                    !obscure ? Icons.visibility : Icons.visibility_off_outlined,
                  ),
                ),
                filled: true,
                enabled: false,
                errorStyle: const TextStyle(fontSize: 0, height: -30),
                fillColor: widget.backgroundColor ?? Colors.transparent,
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ??
                    context.textTheme.s16w400
                        .copyWith(color: AppColors.lightGrey),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(
                    color: AppColors.red.withValues(alpha: 0.3),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(
                    color: AppColors.red.withValues(alpha: 0.3),
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide:
                        BorderSide(color: AppColors.border, width: 0.88)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide:
                        BorderSide(color: AppColors.border, width: 0.88)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide:
                        BorderSide(color: AppColors.border, width: 0.88)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 1,
                  ),
                ),
              ),
        ),
        if (error != null)
          SizedBox(
            height: 5.h,
          ),
        if (error != null)
          Text(
            error!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        widget.padding,
      ],
    );
  }
}
