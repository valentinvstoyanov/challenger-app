class Challenge {
  final String id;
  final String name;
  final String description;
  final double difficulty;
  final double popularity;
  final bool isCompleted;
  final String completedBy;
  final String createdBy;
  final DateTime createdAt;

  const Challenge({
    this.id,
    this.name,
    this.description,
    this.difficulty,
    this.popularity,
    this.isCompleted,
    this.completedBy,
    this.createdBy,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
      'difficulty': this.difficulty,
      'popularity': this.popularity,
      'isCompleted': this.isCompleted,
      'completedBy': this.completedBy,
      'createdBy': this.createdBy,
      'createdAt': this.createdAt.toIso8601String(),
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> map) {
    return new Challenge(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      difficulty: map['difficulty'] as double,
      popularity: map['popularity'] as double,
      isCompleted: map['isCompleted'] as bool,
      completedBy: map['completedBy'] as String,
      createdBy: map['createdBy'] as String,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Challenge && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Challenge{id: $id, name: $name, description: $description, difficulty: $difficulty, popularity: $popularity, isCompleted: $isCompleted, completedBy: $completedBy, createdBy: $createdBy, createdAt: $createdAt}';
  }
}

class CreateChallenge {
  final String name;
  final String description;
  final double difficulty;
  final String createdBy;

  const CreateChallenge({
    this.name,
    this.description,
    this.difficulty,
    this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'description': this.description,
      'difficulty': this.difficulty,
      'createdBy': this.createdBy,
    };
  }

  factory CreateChallenge.fromJson(Map<String, dynamic> map) {
    return new CreateChallenge(
      name: map['name'] as String,
      description: map['description'] as String,
      difficulty: map['difficulty'] as double,
      createdBy: map['createdBy'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateChallenge &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          description == other.description &&
          difficulty == other.difficulty &&
          createdBy == other.createdBy;

  @override
  int get hashCode => name.hashCode ^ description.hashCode ^ difficulty.hashCode ^ createdBy.hashCode;

  @override
  String toString() {
    return 'CreateChallenge{name: $name, description: $description, difficulty: $difficulty, createdBy: $createdBy}';
  }
}
