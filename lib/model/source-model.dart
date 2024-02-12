class Source {
  String id;
  String name;
   String category;

  Source({required this.id,required this.name,required this.category});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(id: json['id'], name: json['name'], category: json['category']);
  }
}
