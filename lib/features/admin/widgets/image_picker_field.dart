import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';

class ImagePickerFormField extends FormField<List<File>?> {
  ImagePickerFormField({
    super.key,
    ImagePickerInputController? controller,
    ValueChanged<List<File>?>? onChanged,
    super.validator,
    super.autovalidateMode,
  }) : super(
          initialValue: controller?.value,
          builder: (state) {
            void onChangedHandler(List<File>? value) {
              state.didChange(value);

              if (onChanged != null) {
                onChanged(value);
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImagePickerField(
                    controller: controller,
                    borderColor:
                        state.hasError ? Colors.red.shade900 : Colors.black,
                    onChanged: onChangedHandler,
                  ),
                  if (state.hasError) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      child: Text(
                        state.errorText!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade900,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            );
          },
        );
}

class ImagePickerField extends StatefulWidget {
  final ImagePickerInputController? controller;
  final ValueChanged<List<File>?>? onChanged;
  final Color borderColor;

  const ImagePickerField({
    super.key,
    this.controller,
    this.onChanged,
    this.borderColor = Colors.black,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  late ImagePickerInputController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? ImagePickerInputController();
    controller.addListener(() {
      widget.onChanged?.call(controller.value);
    });
  }

  @override
  void didUpdateWidget(covariant ImagePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      controller = widget.controller ?? ImagePickerInputController();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();

    super.dispose();
  }

  void selectImages() async {
    var result = await pickImages();
    controller.addImages(result);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectImages,
      child: DottedBorder(
        color: widget.borderColor,
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [10, 4],
        strokeCap: StrokeCap.round,
        child: SizedBox(
          width: double.infinity,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.folder_open,
                size: 40,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Select Product Images",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImagePickerInputController extends ValueNotifier<List<File>?> {
  ImagePickerInputController({List<File>? initialValue}) : super(initialValue);

  void addImages(List<File> imagesFiles) {
    if (imagesFiles.isEmpty) return;

    value = [...value ?? [], ...imagesFiles];

    notifyListeners();
  }
}
