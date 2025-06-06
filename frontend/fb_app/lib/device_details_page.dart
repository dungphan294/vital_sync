// device_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceDetailsPage extends StatefulWidget {
  final BluetoothDevice device;
  const DeviceDetailsPage({super.key, required this.device});

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  List<BluetoothService> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _discoverServices();
  }

  Future<void> _discoverServices() async {
    try {
      List<BluetoothService> services = await widget.device.discoverServices();
      setState(() {
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error discovering services: $e')));
    }
  }

  Stream<List<int>> _subscribeToNotify(BluetoothCharacteristic c) {
    c.setNotifyValue(true);
    return c.lastValueStream;
  }

  Widget _buildCharacteristicTile(BluetoothCharacteristic c) {
    final props = <String>[];
    if (c.properties.read) props.add('Read');
    if (c.properties.write) props.add('Write');
    if (c.properties.notify) props.add('Notify');

    return StreamBuilder<List<int>>(
      stream: c.properties.notify ? _subscribeToNotify(c) : null,
      builder: (context, snapshot) {
        final notifiedValue = snapshot.data;
        final valueHex = (notifiedValue != null)
            ? notifiedValue.map((b) => b.toString()).join(' ')
            : '';

        return ListTile(
          title: Text('Char: ${c.uuid}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(props.join(', ')),
              if (c.properties.notify && valueHex.isNotEmpty)
                Text('Notified Value: $valueHex'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (c.properties.notify)
                IconButton(
                  icon: const Icon(Icons.notifications_active),
                  tooltip: 'Listening',
                  onPressed: () {},
                ),
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy UUID',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: c.uuid.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('UUID copied to clipboard')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceTile(BluetoothService s) {
    return ExpansionTile(
      title: Text('Service: ${s.uuid}'),
      children: s.characteristics.map(_buildCharacteristicTile).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Services')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(children: _services.map(_buildServiceTile).toList()),
    );
  }
}
