class ProfileModel {
  final String name;
  final String avatarlink;
  final String linkedin;
  final String github;

  ProfileModel({
    required this.name,
    required this.avatarlink,
    required this.linkedin,
    required this.github,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? '',
      avatarlink: map['avatarlink'] ?? '',
      linkedin: map['linkedin'] ?? '',
      github: map['github'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatarlink': avatarlink,
      'linkedin': linkedin,
      'github': github,
    };
  }

  @override
  String toString() {
    return 'ProfileModel(name: $name, avatarLink: $avatarlink, linkedin: $linkedin, github: $github)';
  }
}