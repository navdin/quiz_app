class Question {
  int index;
  int ans;
  String q;
  String options;

  Question({
    this.index,
    this.q,
    this.options,
    this.ans,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      index: json['index'],
      q: json['q'],
      options: json['options'],
      ans: json['ans'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['q'] = this.q;
    data['ans'] = this.ans;
    data['options'] = this.options;

    return data;
  }
}
