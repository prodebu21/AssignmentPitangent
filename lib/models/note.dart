class NoteModel {
  final int? id;
  final String title;
  final String content;
  final String? timestamp;
  final int isPinned;
  final String? alarmTime;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    this.timestamp,
    this.isPinned = 0,
    this.alarmTime,
  });

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    String? timestamp,
    int? isPinned,
    String? alarmTime,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isPinned: isPinned ?? this.isPinned,
      alarmTime: alarmTime ?? this.alarmTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp,
      'isPinned': isPinned,
      'alarmTime': alarmTime,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      timestamp: map['timestamp'],
      isPinned: map['isPinned'],
      alarmTime: map['alarmTime'],
    );
  }
}
