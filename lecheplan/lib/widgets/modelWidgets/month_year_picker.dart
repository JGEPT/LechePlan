import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';

class MonthYearPickerOverlay extends StatefulWidget {
  final int initialMonth;
  final int initialYear;
  final void Function() onCancel;
  final void Function(int year, int month) onSelect;
  const MonthYearPickerOverlay({
    required this.initialMonth,
    required this.initialYear,
    required this.onCancel,
    required this.onSelect,
    super.key,
  });
  @override
  State<MonthYearPickerOverlay> createState() => _MonthYearPickerOverlayState();
}

class _MonthYearPickerOverlayState extends State<MonthYearPickerOverlay> {
  late int selectedMonth;
  late int selectedYear;
  bool showYearPicker = false;
  FixedExtentScrollController? _fixedExtentController;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialMonth;
    selectedYear = widget.initialYear;
    final yearList = List.generate(21, (i) => widget.initialYear - 10 + i);
    final initialIndex = yearList.indexOf(selectedYear);
    _fixedExtentController = FixedExtentScrollController(
      initialItem: initialIndex >= 0 ? initialIndex : 0,
    );
  }

  @override
  void dispose() {
    _fixedExtentController?.dispose();
    super.dispose();
  }

  void _handleYearSelection(int year) {
    setState(() {
      selectedYear = year;
      showYearPicker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final yearList = List.generate(21, (i) => widget.initialYear - 10 + i);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onCancel,
            child: Container(color: const Color.fromARGB(60, 0, 0, 0)),
          ),
        ),
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: showYearPicker ? 200 : 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [defaultBoxShadow],
              ),
              child:
                  showYearPicker
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: greyAccentColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [defaultBoxShadow],
                            ),
                            child: ListWheelScrollView.useDelegate(
                              controller: _fixedExtentController,
                              itemExtent: 22,
                              diameterRatio: 1.2,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged:
                                  (i) => setState(
                                    () => selectedYear = yearList[i],
                                  ),
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: yearList.length,
                                builder:
                                    (context, i) => Center(
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 120,
                                        ),
                                        curve: Curves.easeOut,
                                        decoration: BoxDecoration(
                                          color:
                                              yearList[i] == selectedYear
                                                  ? orangeAccentColor.withAlpha(
                                                    40,
                                                  )
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 1,
                                        ),
                                        child: Text(
                                          '${yearList[i]}',
                                          style: TextStyle(
                                            fontWeight:
                                                yearList[i] == selectedYear
                                                    ? FontWeight.bold
                                                    : FontWeight.w600,
                                            color:
                                                yearList[i] == selectedYear
                                                    ? orangeAccentColor
                                                    : darktextColor,
                                            fontSize:
                                                yearList[i] == selectedYear
                                                    ? 18
                                                    : 16,
                                            shadows:
                                                yearList[i] == selectedYear
                                                    ? [defaultShadow]
                                                    : null,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: widget.onCancel,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: darktextColor),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: orangeAccentColor,
                                  foregroundColor: lighttextColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                onPressed:
                                    () => _handleYearSelection(selectedYear),
                                child: const Text('Select'),
                              ),
                            ],
                          ),
                        ],
                      )
                      : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.chevron_left,
                                  color: orangeAccentColor,
                                ),
                                onPressed: () => setState(() => selectedYear--),
                              ),
                              GestureDetector(
                                onTap:
                                    () => setState(() => showYearPicker = true),
                                child: Text(
                                  '$selectedYear',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: darktextColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.chevron_right,
                                  color: orangeAccentColor,
                                ),
                                onPressed: () => setState(() => selectedYear++),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(
                              12,
                              (i) => ChoiceChip(
                                label: Text(
                                  months[i],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        selectedMonth == i + 1
                                            ? lighttextColor
                                            : darktextColor,
                                  ),
                                ),
                                selected: selectedMonth == i + 1,
                                selectedColor: orangeAccentColor,
                                backgroundColor: greyAccentColor,
                                showCheckmark: false,
                                onSelected:
                                    (_) =>
                                        setState(() => selectedMonth = i + 1),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: widget.onCancel,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: darktextColor),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: orangeAccentColor,
                                  foregroundColor: lighttextColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed:
                                    () => widget.onSelect(
                                      selectedYear,
                                      selectedMonth,
                                    ),
                                child: const Text('Select'),
                              ),
                            ],
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ],
    );
  }
}
