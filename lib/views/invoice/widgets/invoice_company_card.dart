import 'package:flutter/material.dart';
import 'package:vibbra_test/models/partner.dart';

class InvoiceCompanyCard extends StatelessWidget {
  final Partner partner;
  final bool isActive;
  final Function onClick;
  const InvoiceCompanyCard(
      {super.key,
      this.isActive = false,
      required this.partner,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).primaryColor
                  : const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partner.document,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : Colors.black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    partner.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : Colors.black),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    partner.socialReason,
                    style: TextStyle(
                        fontSize: 16,
                        color: isActive ? Colors.white : Colors.black),
                  ),
                ],
              )),
            ],
          )),
    );
  }
}
