class Animal {
  final String name;
  final String description;
  final String imagePath;

  const Animal({
    required this.name,
    required this.description,
    required this.imagePath,
  });

  static const List<Animal> animals = [
    Animal(
      name: 'Lion',
      description:
          'The lion is a large cat of the genus Panthera native to Africa and India. It has a muscular, deep-chested body, short, rounded head, round ears, and a hairy tuft at the end of its tail.',
      imagePath: 'assets/Lion.jpg',
    ),
    Animal(
      name: 'Tiger',
      description:
          'The tiger is the largest living cat species and a member of the genus Panthera. It is most recognisable for its dark vertical stripes on orange fur with a white underside.',
      imagePath: 'assets/Tiger.jpg',
    ),
    Animal(
      name: 'Elephant',
      description:
          'Elephants are the largest living land animals. Three living species are currently recognised: the African bush elephant, the African forest elephant, and the Asian elephant.',
      imagePath: 'assets/Elephant.jpg',
    ),
    Animal(
      name: 'Giraffe',
      description:
          'The giraffe is a large African hoofed mammal belonging to the genus Giraffa. It is the tallest living terrestrial animal and the largest ruminant on Earth.',
      imagePath: 'assets/Giraffe.jpg',
    ),
    Animal(
      name: 'Zebra',
      description:
          'Zebras are African equines with distinctive black-and-white striped coats. There are three living species: the Grévy\'s zebra, the plains zebra, and the mountain zebra.',
      imagePath: 'assets/Zebra.jpg',
    ),
    Animal(
      name: 'Bear',
      description:
          'Bears are carnivoran mammals of the family Ursidae. They are classified as caniforms, or dog-like carnivorans. Bears are found on the continents of North America, South America, Europe, and Asia.',
      imagePath: 'assets/Bear.jpg',
    ),
    Animal(
      name: 'Deer',
      description:
          'Deer or true deer are hoofed ruminant mammals forming the family Cervidae. The two main groups of deer are the Cervinae, including the muntjac, the elk, the red deer, and the fallow deer.',
      imagePath: 'assets/Deer.jpg',
    ),
    Animal(
      name: 'Wolf',
      description:
          'The wolf, also known as the gray wolf or grey wolf, is a large canine native to Eurasia and North America. It is the largest extant member of the family Canidae.',
      imagePath: 'assets/Wolf.jpg',
    ),
    Animal(
      name: 'Fox',
      description:
          'Foxes are small to medium-sized, omnivorous mammals belonging to several genera of the family Canidae. They have a flattened skull, upright triangular ears, a pointed, slightly upturned snout, and a long bushy tail.',
      imagePath: 'assets/Fox.jpg',
    ),
    Animal(
      name: 'Monkey',
      description:
          'Monkey is a common name that may refer to most mammals of the infraorder Simiiformes, also known as the simians. Traditionally, all animals in the group now known as simians are counted as monkeys except the apes.',
      imagePath: 'assets/Monkey.jpg',
    ),
  ];
}
