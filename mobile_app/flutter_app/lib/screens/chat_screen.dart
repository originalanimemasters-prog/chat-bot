import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  int? currentChatId;

  Map<int, List<Map<String,String>>> chats = {};
  Map<int,String> chatTitles = {};

  List<int> chatList = [];

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    createNewChat();
  }

  void createNewChat() async {

    int chatId = await ApiService.createNewChat();

    setState(() {
      chatList.add(chatId);
      chats[chatId] = [];
      chatTitles[chatId] = "New Chat";
      currentChatId = chatId;
    });
  }

  void switchChat(int chatId){
    setState(() {
      currentChatId = chatId;
    });
  }

  void sendMessage(String text) async {

    if(currentChatId == null) return;

    setState(() {

      chats[currentChatId]!.add({
        "role":"user",
        "text":text
      });

      chats[currentChatId]!.add({
        "role":"ai",
        "text":""
      });

    });

    int aiIndex = chats[currentChatId]!.length - 1;

    await for (String chunk
        in ApiService.streamMessage(currentChatId!, text)) {

      setState(() {

        chats[currentChatId]![aiIndex]["text"] =
            chats[currentChatId]![aiIndex]["text"]! + chunk;

      });

      scrollToBottom();

    }

  }

  void scrollToBottom(){

    Future.delayed(Duration(milliseconds:100),(){

      if(scrollController.hasClients){
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds:300),
          curve: Curves.easeOut,
        );
      }

    });

  }

  void renameChat(int chatId){

    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context){

        return AlertDialog(

          title: Text("Rename Chat"),

          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter chat name"
            ),
          ),

          actions: [

            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),

            TextButton(
              onPressed: (){

                setState(() {
                  chatTitles[chatId] = controller.text;
                });

                ApiService.renameChat(chatId, controller.text);

                Navigator.pop(context);
              },
              child: Text("Save"),
            )

          ],
        );

      }
    );
  }

  void deleteChat(int chatId){

    setState(() {

      chats.remove(chatId);
      chatList.remove(chatId);
      chatTitles.remove(chatId);

      if(chatList.isNotEmpty){
        currentChatId = chatList.first;
      } else {
        currentChatId = null;
      }

    });

    ApiService.deleteChat(chatId);
  }

  @override
  Widget build(BuildContext context) {

    List<Map<String,String>> messages =
        currentChatId == null ? [] : chats[currentChatId]!;

    return Scaffold(

      body: Row(
        children: [

          /// SIDEBAR
          Container(
            width: 260,
            color: Colors.grey[900],

            child: Column(
              children: [

                SizedBox(height:20),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal:10),
                  child: ElevatedButton.icon(
                    onPressed: createNewChat,
                    icon: Icon(Icons.add),
                    label: Text("New Chat"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity,45),
                    ),
                  ),
                ),

                SizedBox(height:10),

                Expanded(
                  child: ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (context,index){

                      int chatId = chatList[index];

                      return Container(
                        color: currentChatId == chatId
                            ? Colors.grey[800]
                            : Colors.transparent,

                        child: ListTile(

                          title: Text(
                            chatTitles[chatId] ?? "Chat $chatId",
                            style: TextStyle(color: Colors.white),
                          ),

                          onTap: (){
                            switchChat(chatId);
                          },

                          trailing: PopupMenuButton<String>(

                            icon: Icon(Icons.more_vert,color:Colors.white),

                            itemBuilder:(context)=>[
                              PopupMenuItem(
                                value:"rename",
                                child: Text("Rename"),
                              ),
                              PopupMenuItem(
                                value:"delete",
                                child: Text("Delete"),
                              )
                            ],

                            onSelected:(value){

                              if(value=="rename"){
                                renameChat(chatId);
                              }

                              if(value=="delete"){
                                deleteChat(chatId);
                              }

                            },

                          ),

                        ),
                      );

                    },
                  ),
                )

              ],
            ),
          ),

          /// CHAT AREA
          Expanded(
            child: Column(
              children: [

                AppBar(
                  title: Text("AI Assistant"),
                ),

                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context,index){

                      final msg = messages[index];

                      return ChatBubble(
                        text: msg["text"]!,
                        isUser: msg["role"]=="user",
                      );

                    },
                  ),
                ),

                MessageInput(onSend: sendMessage)

              ],
            ),
          )

        ],
      ),
    );
  }
}