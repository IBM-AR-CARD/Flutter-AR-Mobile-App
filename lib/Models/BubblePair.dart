class BubblePair{
  String _content;
  int _type;
  static final int FROM_ME = 0;
  static final int FROM_OTHER = 1;

  BubblePair(this._content, this._type);

  int get type => _type;

  String get content => _content;

}