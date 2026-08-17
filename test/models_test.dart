import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/models/message_model.dart';
import 'package:post_app/models/post_model.dart';
import 'package:post_app/models/user_model.dart';

void main() {
  test('Member round-trips through JSON', () {
    final member = Member(
      uid: 'u1',
      username: 'alice',
      email: 'alice@example.com',
      password: 'secret',
      userImg: 'https://example.com/a.png',
      phone: '123',
    );

    expect(Member.fromJson(member.toJson()).toJson(), member.toJson());
  });

  test('Post.fromJson maps comments and createdAt', () {
    final createdAt = DateTime.utc(2026, 8, 17, 12);
    final json = {
      'id': 'p1',
      'title': 'Hello',
      'content': 'World',
      'userId': 'u1',
      'imageUrl': 'https://example.com/p.png',
      'isPublic': true,
      'createdAt': createdAt.toIso8601String(),
      'comments': [
        {
          'id': 'm1',
          'message': 'Nice',
          'writtenAt': createdAt.toIso8601String(),
          'userId': 'u2',
          'userImage': null,
          'username': 'bob',
        },
      ],
    };

    final post = Post.fromJson(json);

    expect(post.id, 'p1');
    expect(post.title, 'Hello');
    expect(post.comments, hasLength(1));
    expect(post.comments.first.message, 'Nice');
    expect(post.toJson()['createdAt'], createdAt.toIso8601String());
  });

  test('Message.fromJson keeps optional userImage', () {
    final writtenAt = DateTime.utc(2026, 1, 1);
    final message = Message.fromJson({
      'id': 'm1',
      'message': 'Hi',
      'writtenAt': writtenAt.toIso8601String(),
      'userId': 'u1',
      'userImage': null,
      'username': 'alice',
    });

    expect(message.userImage, isNull);
    expect(message.toJson()['username'], 'alice');
  });
}
