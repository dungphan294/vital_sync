// views/vital_detail_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/vital_detail_viewmodel.dart';
import '../models/vital_type_model.dart';

class VitalDetailView extends StatelessWidget {
  final VitalType vitalType;
  final int? currentValue;

  const VitalDetailView({
    super.key,
    required this.vitalType,
    this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VitalDetailViewModel>(
      create: (context) => VitalDetailViewModel(
        vitalType: vitalType,
        currentValue: currentValue,
      ),
      child: Consumer<VitalDetailViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                viewModel.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Current Value",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: .6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        children: [
                          TextSpan(text: viewModel.currentValueString),
                          if (viewModel.unit.isNotEmpty)
                            TextSpan(
                              text: " ${viewModel.unit}",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: .6),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Detailed ${viewModel.title} data and history will be displayed here.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: .6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
