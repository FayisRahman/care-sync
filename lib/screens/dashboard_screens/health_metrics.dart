import 'package:caresync/form_response/form_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HealthMetrics extends StatelessWidget {
  static const String id = "Health Metrics";

  const HealthMetrics({super.key});

  Widget _buildVitalSignRow(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/dp.png'),
                ),
              ),
            ),
            Center(
              child: Text(
                Provider.of<FormResponse>(context, listen: false)
                    .user!
                    .name!
                    .toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Row(
              children: [
                Flexible(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Age',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '25',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Sex',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Male',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildVitalSignRow(
                    'Body Temperature', '98.6°F', Icons.thermostat),
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    _buildVitalSignRow('Pulse Rate', '72 bpm', Icons.favorite),
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildVitalSignRow(
                    'Blood Pressure', '120/80 mmHg', Icons.bloodtype),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
