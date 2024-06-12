import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_adopt_app/model/organization/organization.dart';
import 'package:pet_adopt_app/presentation/navigation/navigation_routes.dart';
import 'package:pet_adopt_app/presentation/widget/label_with_icon.dart';

class OrganizationListRow extends StatelessWidget {
  const OrganizationListRow({super.key, required this.organization});

  final Organization organization;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(225, 216, 246, 1.0),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 5,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () {
          context.go(NavigationRoutes.ORGANIZATION_DETAIL_ROUTE,
              extra: organization.id);
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  organization.photos != null && organization.photos!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: organization.photos!.first.full ?? "",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/org_placeholder.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    organization.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[900],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  LabelWithIcon(
                    text: organization.address?.city ?? "No data",
                    icon: Icons.location_on,
                    iconSize: 18,
                    result: true,
                    iconColor: const Color.fromRGBO(66, 66, 66, 1.0),
                    textSize: 12,
                  ),
                  const SizedBox(height: 4),
                  LabelWithIcon(
                    text: organization.email ?? "No data",
                    icon: Icons.email,
                    iconSize: 18,
                    result: true,
                    iconColor: const Color.fromRGBO(66, 66, 66, 1.0),
                    textSize: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
