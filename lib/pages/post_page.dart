import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app/blocs/post/post_bloc.dart';
import 'package:post_app/models/post_model.dart';
import 'package:post_app/services/auth_service.dart';
import 'package:post_app/services/db_service.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({Key? key, required this.post}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (post, state) {
          if (state is WriteCommentPostSuccess) {
            textController.clear();
          }
        },
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(image: NetworkImage(widget.post.imageUrl))),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Content: ${widget.post.content}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream:
                  DBService.db.ref(Folder.post).child(widget.post.id).onValue,
              builder: (context, snapshot) {
                Post current = snapshot.hasData
                    ? Post.fromJson(
                        jsonDecode(jsonEncode(snapshot.data!.snapshot.value))
                            as Map<String, Object?>,
                        isMe: AuthService.user.uid == widget.post.userId)
                    : widget.post;

                widget.post.comments = current.comments;
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: current.comments.length,
                  itemBuilder: (context, index) {
                    final msg = current.comments[index];

                    if (AuthService.user.uid == msg.userId) {
                      return Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: SizedBox.shrink(),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        )),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          msg.username,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              msg.message,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${msg.writtenAt.hour.toString().padLeft(2, "0")} : ${msg.writtenAt.minute.toString().padLeft(2, "0")}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.deepPurple,
                                    child: Text(
                                      msg.username.substring(0, 1),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.message,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          child: Text(
                                            msg.username.substring(0, 1),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          msg.username,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        )
                                      ],
                                    ),
                                    Text(
                                      "${msg.writtenAt.hour.toString().padLeft(2, "0")} : ${msg.writtenAt.minute.toString().padLeft(2, "0")}",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: SizedBox.shrink(),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file_rounded),
                onPressed: () {},
              ),
              SizedBox(
                height: 45,
                width: 285,
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: "Write a comment...",
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          context.read<PostBloc>().add(WriteCommentPostEvent(
                              widget.post.id,
                              textController.text,
                              widget.post.comments));
                        },
                      )),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () {},
              )
            ]),
      ),
    );
  }
}

class SampleItem {}
