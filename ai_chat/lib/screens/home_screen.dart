import 'package:ai_chat/index.dart';
import 'package:ai_chat/models/chat_model.dart';
import 'package:ai_chat/shared/cubit/app_cubit/app_cubit.dart';

void main() {
  runApp(ChatBotApp());
}

class ChatBotApp extends StatelessWidget {
  const ChatBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatBotHomeScreen(),
    );
  }
}

class ChatBotHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        cubit.getAllChats();
        return Scaffold(
          appBar: AppBar(
            title: const Text('NexGen Bot'),
            actions: [
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  // Navigate to profile/settings
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                const Text(
                  'Hi, User!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'How can I assist you today?',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),

                // Suggested Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen()));
                      },
                      child: Text('Start a Chat'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Go to recent chats
                      },
                      child: Text('Recent Chats'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Open FAQs
                      },
                      child: Text('FAQs'),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Chat Interface Preview
                Text(
                  'Recent Chats',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cubit.chats.length, // Replace with actual chat count
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(child: Icon(Icons.chat_bubble)),
                        title: Text('Chat with Bot $index'),
                        subtitle: Text(cubit.chats[index].Fquestion),
                        trailing: Text(cubit.chats[index].time.toString()),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ChatScreen())
                          );
                          // Navigate to chat screen
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Floating Action Button to Start New Chat
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Start a new chat
            },
            child: Icon(Icons.add),
          ),

          // Bottom Navigation Bar
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.black),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat, color: Colors.black),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications, color: Colors.black),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, color: Colors.black),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              // Handle navigation on tap
            },
          ),
        );
      },
    );
  }
}
