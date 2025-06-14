// views/ble_home_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../models/vital_type_model.dart';
import 'vital_detail_view.dart';
import '../widgets/vital_card_widget.dart';
import '../widgets/connection_status_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProfileButton(context),
                    _buildConnectionStatus(),
                    _buildSyncButton(context),
                    _buildVitalSignsGrid(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Image.asset('assets/images/logo.png', height: 40),
      centerTitle: true,
      actions: [
        Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isScanning) return const SizedBox.shrink();

            return IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              onPressed: viewModel.isConnected ? null : viewModel.manualRefresh,
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSecondary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(context, '/profile'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  "My Profile",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.1),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncButton(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.hasFileData) return const SizedBox.shrink();
        return IconButton(
          icon: Icon(Icons.sync, color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            // Trigger sync action or open processing
            viewModel.manualRefresh(); // <‑– rescans BLE
          },
        );
      },
    );
  }

  Widget _buildConnectionStatus() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return ConnectionStatusWidget(
          isConnected: viewModel.isConnected,
          isScanning: viewModel.isScanning,
          statusText: viewModel.connectionStatusText,
          statusColor: viewModel.connectionStatusColor,
          onManualRefresh: viewModel.manualRefresh,
        );
      },
    );
  }

  Widget _buildVitalSignsGrid() {
    return Expanded(
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Heart Rate
              VitalCardWidget(
                vitalType: VitalTypeModel.heartRate(),
                value: viewModel.heartRateValue,
                onTap: () => _navigateToDetail(
                  VitalType.heartRate,
                  viewModel.vitalSigns.heartRate,
                ),
              ),

              const SizedBox(height: 12),

              // SpO2 and Steps Row
              Row(
                children: [
                  Expanded(
                    child: VitalCardWidget(
                      vitalType: VitalTypeModel.spo2(),
                      value: viewModel.spo2Value,
                      isCompact: true,
                      onTap: () => _navigateToDetail(
                        VitalType.spo2,
                        viewModel.vitalSigns.spo2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: VitalCardWidget(
                      vitalType: VitalTypeModel.steps(),
                      value: viewModel.stepsValue,
                      isCompact: true,
                      onTap: () => _navigateToDetail(
                        VitalType.steps,
                        viewModel.vitalSigns.steps,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToDetail(VitalType type, int? currentValue) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VitalDetailView(vitalType: type, currentValue: currentValue),
      ),
    );
  }
}
