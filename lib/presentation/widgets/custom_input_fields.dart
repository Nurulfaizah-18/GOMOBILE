import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function()? onSuffixIconPressed;
  final bool obscureText;
  final int maxLines;
  final int? maxLength;
  final String? errorText;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.errorText,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          obscureText: _obscureText,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.borderColor.withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: AppColors.darkCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.borderColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.electricBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: AppColors.electricBlue,
                  )
                : null,
            suffixIcon: widget.suffixIcon != null
                ? GestureDetector(
                    onTap: widget.onSuffixIconPressed ??
                        () {
                          if (widget.obscureText) {
                            setState(() => _obscureText = !_obscureText);
                          }
                        },
                    child: Icon(
                      widget.suffixIcon,
                      color: AppColors.borderColor,
                    ),
                  )
                : null,
            counterText: '',
            errorText: widget.errorText,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onClear;
  final void Function()? onSearch;

  const CustomSearchField({
    Key? key,
    this.hintText = 'Cari kendaraan...',
    this.controller,
    this.onChanged,
    this.onClear,
    this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.borderColor.withValues(alpha: 0.6),
        ),
        filled: true,
        fillColor: AppColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.electricBlue,
            width: 2,
          ),
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.electricBlue,
        ),
        suffixIcon: controller?.text.isNotEmpty ?? false
            ? GestureDetector(
                onTap: onClear,
                child: const Icon(
                  Icons.close,
                  color: AppColors.borderColor,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    );
  }
}

class CustomDropdownField<T> extends StatefulWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? hintText;
  final IconData? prefixIcon;

  const CustomDropdownField({
    Key? key,
    required this.label,
    this.value,
    required this.items,
    this.onChanged,
    this.hintText,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  late T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.darkCard,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: _selectedValue,
              hint: Text(
                widget.hintText ?? 'Pilih ${widget.label.toLowerCase()}',
                style: TextStyle(
                  color: AppColors.borderColor.withValues(alpha: 0.6),
                ),
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.electricBlue,
              ),
              items: widget.items,
              onChanged: (T? newValue) {
                setState(() => _selectedValue = newValue);
                widget.onChanged?.call(newValue);
              },
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              dropdownColor: AppColors.darkBackground,
            ),
          ),
        ),
      ],
    );
  }
}
