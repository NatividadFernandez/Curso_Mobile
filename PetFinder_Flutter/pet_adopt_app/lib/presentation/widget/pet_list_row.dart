import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_adopt_app/model/pets/pets.dart';
import 'package:pet_adopt_app/presentation/widget/label_with_icon.dart';

class PetListRow extends StatelessWidget {
  const PetListRow({super.key, required this.pet, required this.route});

  final Pet pet;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {
          context.go(route, extra: pet.id.toString());
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10.0),
                  bottom: Radius.circular(10.0),
                ),
                child: pet.photos != null && pet.photos!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: pet.photos!.first.full ?? "",
                        width: 120,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/pet_placeholder.jpg',
                        width: 120,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(56, 2, 100, 1.0),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        LabelWithIcon(
                          text: pet.age,
                          icon: Icons.cake,
                          iconSize: 14,
                          result: false,
                          iconColor: const Color.fromRGBO(66, 66, 66, 1.0),
                          textSize: 12,
                        ),
                        const Spacer(),
                        LabelWithIcon(
                          text: pet.gender,
                          icon: selectGenderIcon(pet.gender),
                          iconSize: 14,
                          result: false,
                          iconColor: const Color.fromRGBO(66, 66, 66, 1.0),
                          textSize: 12,
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 5),
                    LabelWithIcon(
                      text: pet.contact?.address?.city ?? 'No data',
                      icon: Icons.location_on,
                      iconSize: 14,
                      result: false,
                      iconColor: const Color.fromRGBO(66, 66, 66, 1.0),
                      textSize: 12,
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

  IconData selectGenderIcon(String gender) {
    return gender.toLowerCase() == 'female'
        ? Icons.female_outlined
        : Icons.male_outlined;
  }
}
