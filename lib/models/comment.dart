class Comment {
  String id;
  String contents;
  String createdAt;

  Comment(this.id, this.contents, this.createdAt);

  @override
  String toString() {
    return 'Comment{id: $id, contents: $contents, createdAt: $createdAt}';
  }
}
