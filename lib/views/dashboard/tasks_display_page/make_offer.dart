import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timetrader/services/cloud/firebase_cloud_storage.dart';
import 'package:timetrader/services/cloud/tasks/cloud_offer.dart';
import 'package:timetrader/utilities/dialogs/error_dialog.dart';

void makeOfferSheet({
  required BuildContext context,
  required String taskId,
  required String offererId,
  required void Function(double) onOfferMade,
}) {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Place Your Bid',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Offer Amount (Rs.)',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Time (in hours)',
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  final offerAmount = int.tryParse(priceController.text) ?? 0;
                  final timeRequired = int.tryParse(timeController.text) ?? 0;

                  if (offerAmount <= 0 || timeRequired <= 0) {
                    await showErrorDialog(
                        context, 'Please enter valid details.');
                    return;
                  }

                  // Create the offer object
                  final offer = CloudOffer(
                    offerId: '',
                    taskId: taskId,
                    offererId: offererId,
                    offerAmount: offerAmount,
                    offerTime: timeRequired,
                    timestamp: Timestamp.now(),
                  );

                  // Save the offer to Firestore
                  await FirebaseCloudStorage().createOffer(offer);
                  if (!context.mounted) return;
                  Navigator.of(context).pop(); // Close the bottom sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Offer placed successfully!')),
                  );
                },
                child: const Text('Place Bid'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
