import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';

BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

String _address = "...";
String _name = "...";

Timer _discoverableTimeoutTimer;
int _discoverableTimeoutSecondsLeft = 0;

BackgroundCollectingTask _collectingTask;

bool _autoAcceptPairingRequests = false;
