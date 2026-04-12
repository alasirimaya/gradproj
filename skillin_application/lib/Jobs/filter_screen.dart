import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final String selectedJobType;
  final String selectedLocation;

  const FilterScreen({
    super.key,
    required this.selectedJobType,
    required this.selectedLocation,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late String selectedJobType;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    selectedJobType = widget.selectedJobType;
    locationController = TextEditingController(text: widget.selectedLocation);
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  Widget _jobTypeButton(String label) {
    final isSelected = selectedJobType == label;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedJobType = label;
          });
        },
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0F1F57) : const Color(0xFFF7F2EA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF6A6F85),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6FB),
        elevation: 0,
        title: const Text(
          "Filter",
          style: TextStyle(
            color: Color(0xFF1B1F3B),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1B1F3B)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Location",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B1F3B),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Riyadh, KSA",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              "Job Type",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B1F3B),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _jobTypeButton("Full Time"),
                const SizedBox(width: 10),
                _jobTypeButton("Part Time"),
                const SizedBox(width: 10),
                _jobTypeButton("Remote"),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F1F57),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    "jobType": selectedJobType,
                    "location": locationController.text.trim(),
                  });
                },
                child: const Text(
                  "APPLY NOW",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}