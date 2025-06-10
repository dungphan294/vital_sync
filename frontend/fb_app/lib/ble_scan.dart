import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

class BLEHome extends StatefulWidget {
  const BLEHome({super.key});

  @override
  State<BLEHome> createState() => _BLEHomeState();
}

class _BLEHomeState extends State<BLEHome> {
  BluetoothDevice? device;
  int? spo2, hr, steps;
  bool isScanning = false;
  bool isConnected = false;
  Timer? refreshTimer;

  static const String targetDeviceName = "ESP32 Fitness Band";
  static const Duration scanTimeout = Duration(seconds: 10);
  static const Duration retryDelay = Duration(seconds: 12);

  // Service and characteristic UUIDs
  static final Guid plxServiceUuid = Guid(
    "00001822-0000-1000-8000-00805F9B34FB",
  );
  static final Guid plxCharUuid = Guid("00002A5F-0000-1000-8000-00805F9B34FB");
  static final Guid stepServiceUuid = Guid(
    "0000FF10-0000-1000-8000-00805F9B34FB",
  );
  static final Guid stepCharUuid = Guid("0000FF11-0000-1000-8000-00805F9B34FB");

  StreamSubscription<List<ScanResult>>? scanSubscription;
  StreamSubscription<BluetoothConnectionState>? connectionSubscription;

  @override
  void initState() {
    super.initState();
    startRefreshScan();
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  void _cleanup() {
    refreshTimer?.cancel();
    scanSubscription?.cancel();
    connectionSubscription?.cancel();
    FlutterBluePlus.stopScan();
    device?.disconnect();
  }

  void startRefreshScan() async {
    if (isConnected || isScanning) return;

    setState(() => isScanning = true);

    try {
      await FlutterBluePlus.startScan(timeout: scanTimeout);

      scanSubscription = FlutterBluePlus.scanResults.listen(
        _onScanResult,
        onError: (error) {
          debugPrint("Scan error: $error");
          _retryScanning();
        },
      );

      refreshTimer = Timer(retryDelay, () {
        if (!isConnected) {
          debugPrint("Device not found, restarting scan...");
          startRefreshScan();
        }
      });
    } catch (e) {
      debugPrint("Failed to start scan: $e");
      _retryScanning();
    }
  }

  void _onScanResult(List<ScanResult> results) {
    for (final result in results) {
      if (result.device.platformName == targetDeviceName) {
        FlutterBluePlus.stopScan();
        setState(() => isScanning = false);
        connectToDevice(result.device);
        return;
      }
    }
  }

  void _retryScanning() {
    setState(() => isScanning = false);
    if (!isConnected) {
      Timer(const Duration(seconds: 2), startRefreshScan);
    }
  }

  Future<void> connectToDevice(BluetoothDevice d) async {
    try {
      device = d;
      await device!.connect();

      setState(() {
        isConnected = true;
        isScanning = false;
      });

      refreshTimer?.cancel();
      _setupConnectionListener();
      await discoverServices();
    } catch (e) {
      debugPrint("Failed to connect: $e");
      _handleConnectionFailure();
    }
  }

  void _setupConnectionListener() {
    connectionSubscription = device!.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        _resetConnectionState();
        startRefreshScan();
      }
    });
  }

  void _resetConnectionState() {
    setState(() {
      isConnected = false;
      device = null;
      spo2 = null;
      hr = null;
      steps = null;
    });
    connectionSubscription?.cancel();
  }

  void _handleConnectionFailure() {
    setState(() {
      isConnected = false;
      isScanning = false;
    });
    startRefreshScan();
  }

  Future<void> discoverServices() async {
    if (device == null) return;

    try {
      final services = await device!.discoverServices();

      for (final service in services) {
        if (service.uuid == plxServiceUuid) {
          await _setupPlxCharacteristic(service);
        } else if (service.uuid == stepServiceUuid) {
          await _setupStepCharacteristic(service);
        }
      }
    } catch (e) {
      debugPrint("Error discovering services: $e");
    }
  }

  Future<void> _setupPlxCharacteristic(BluetoothService service) async {
    try {
      final char = service.characteristics.firstWhere(
        (c) => c.uuid == plxCharUuid,
      );
      await char.setNotifyValue(true);
      char.onValueReceived.listen((value) {
        if (value.length >= 5) {
          setState(() {
            spo2 = _decodeSfloat(value[1], value[2]);
            hr = _decodeSfloat(value[3], value[4]);
          });
        }
      });
    } catch (e) {
      debugPrint("Error setting up PLX characteristic: $e");
    }
  }

  Future<void> _setupStepCharacteristic(BluetoothService service) async {
    try {
      final char = service.characteristics.firstWhere(
        (c) => c.uuid == stepCharUuid,
      );
      await char.setNotifyValue(true);
      char.onValueReceived.listen((value) {
        if (value.length >= 2) {
          setState(() {
            steps = value[0] + (value[1] << 8);
          });
        }
      });
    } catch (e) {
      debugPrint("Error setting up step characteristic: $e");
    }
  }

  int _decodeSfloat(int low, int high) {
    int raw = (high << 8) | low;
    int mantissa = raw & 0x0FFF;
    if ((mantissa & 0x0800) != 0) mantissa |= 0xF000;
    return mantissa;
  }

  void manualRefresh() {
    if (!isConnected && !isScanning) {
      startRefreshScan();
    }
  }

  Widget _buildStatusIndicator() {
    final (color, text) = isConnected
        ? (Colors.green, "Connected to ESP32")
        : isScanning
        ? (Colors.orange, "Scanning for device...")
        : (Colors.red, "Disconnected");

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isScanning)
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        else if (!isConnected)
          TextButton.icon(
            onPressed: manualRefresh,
            icon: const Icon(Icons.bluetooth_searching_rounded, size: 20),
            label: const Text("Scan for Device"),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "VitalSync",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!isScanning)
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              onPressed: isConnected ? null : manualRefresh,
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Profile Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withValues(alpha: .1),
                    width: 1,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
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
                        const Expanded(
                          child: Text(
                            "My Profile",
                            style: TextStyle(
                              fontSize: 16,
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
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: _buildStatusIndicator(),
              ),

              // Vital Signs Grid
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Heart Rate
                    _buildVitalCard(
                      icon: Icons.favorite_rounded,
                      iconColor: const Color(0xFFFF6B6B),
                      value: hr?.toString() ?? "--",
                      unit: "bpm",
                      label: "Heart Rate",
                      onTap: () => _navigateToDetail("Heart Rate"),
                    ),

                    const SizedBox(height: 12),

                    // SpO2 and Steps Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildVitalCard(
                            icon: Icons.water_drop_rounded,
                            iconColor: const Color.fromARGB(255, 0, 90, 226),
                            value: spo2?.toString() ?? "--",
                            unit: "%",
                            label: "SpO2",
                            isCompact: true,
                            onTap: () => _navigateToDetail("SpO2"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildVitalCard(
                            icon: Icons.directions_walk,
                            iconColor: const Color.fromARGB(255, 28, 152, 32),
                            value: steps?.toString() ?? "--",
                            unit: "",
                            label: "Steps",
                            isCompact: true,
                            onTap: () => _navigateToDetail("Steps"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVitalCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String unit,
    required String label,
    bool isCompact = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isCompact ? 140 : 160,
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
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: isCompact ? 20 : 24,
                      color: iconColor,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface
                      ..withValues(alpha: 0.3),
                  ),
                ],
              ),

              const Spacer(),

              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: isCompact ? 24 : 32,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  children: [
                    TextSpan(text: value),
                    if (unit.isNotEmpty)
                      TextSpan(
                        text: " $unit",
                        style: TextStyle(
                          fontSize: isCompact ? 14 : 16,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VitalDetailPage(
          vitalType: type,
          currentValue: type == "Heart Rate"
              ? hr
              : type == "SpO2"
              ? spo2
              : steps,
        ),
      ),
    );
  }
}

class VitalDetailPage extends StatelessWidget {
  final String vitalType;
  final int? currentValue;

  const VitalDetailPage({
    super.key,
    required this.vitalType,
    this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
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
          vitalType,
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
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                currentValue?.toString() ?? "--",
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Detailed $vitalType data and history will be displayed here.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
