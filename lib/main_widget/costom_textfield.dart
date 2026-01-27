import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  // كل الخصائص كما هي
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText; // إذا true، يمكن إظهار/إخفاء
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? label;
  final String? hint;
  final String? suffixText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final Color fillColor;
  final Color iconColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final bool showFullBorder;
  final bool borderLeft;
  final bool borderTop;
  final bool borderRight;
  final bool borderBottom;
  final BoxShadow? boxShadow;

  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.label,
    this.hint,
    this.suffixText,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.onChanged,
    this.onTap,
    this.validator,
    this.fillColor = Colors.white,
    this.iconColor = const Color(0xFF001839),
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.borderRadius = 12.0,
    this.borderWidth = 1.0,
    this.borderColor = const Color(0xFF001839),
    this.showFullBorder = true,
    this.borderLeft = true,
    this.borderTop = true,
    this.borderRight = true,
    this.borderBottom = true,
    this.boxShadow,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  Border _buildBorder() {
    if (widget.showFullBorder) {
      return Border.all(color: widget.borderColor, width: widget.borderWidth);
    } else {
      return Border(
        left: widget.borderLeft ? BorderSide(color: widget.borderColor, width: widget.borderWidth) : BorderSide.none,
        top: widget.borderTop ? BorderSide(color: widget.borderColor, width: widget.borderWidth) : BorderSide.none,
        right: widget.borderRight ? BorderSide(color: widget.borderColor, width: widget.borderWidth) : BorderSide.none,
        bottom: widget.borderBottom ? BorderSide(color: widget.borderColor, width: widget.borderWidth) : BorderSide.none,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      validator: widget.validator,
      style: widget.textStyle ?? TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        isDense: true,
        counterText: '',
        contentPadding: widget.contentPadding,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: widget.hint,
        hintStyle: widget.hintStyle ?? TextStyle(color: Colors.grey[600]),
        prefixIcon: widget.prefixIcon != null
            ? GestureDetector(
                onTap: widget.obscureText
                    ? () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }
                    : null,
                child: IconTheme(
                  data: IconThemeData(color: widget.iconColor),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 6.0),
                    child: widget.prefixIcon,
                  ),
                ),
              )
            : null,
        suffixIcon: widget.suffixIcon != null
            ? IconTheme(
                data: IconThemeData(color: widget.iconColor),
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0, right: 12.0),
                  child: widget.suffixIcon,
                ),
              )
            : null,
        suffix: widget.suffixWidget ??
            (widget.suffixText != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      widget.suffixText!,
                      style: widget.hintStyle ?? TextStyle(color: Colors.grey[700]),
                    ),
                  )
                : null),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style: widget.labelStyle ?? TextStyle(fontWeight: FontWeight.w600, color: widget.iconColor),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: widget.fillColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: _buildBorder(),
            boxShadow: widget.boxShadow != null ? [widget.boxShadow!] : null,
          ),
          child: Row(
            children: [
              if (widget.prefixWidget != null) widget.prefixWidget!,
              Expanded(child: field),
              if (widget.suffixWidget != null) widget.suffixWidget!,
            ],
          ),
        ),
      ],
    );
  }
}

