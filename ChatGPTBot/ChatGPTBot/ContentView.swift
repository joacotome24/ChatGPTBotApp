//
//  ContentView.swift
//  ChatGPTBot
//
//  Created by Joaquin Tome on 11/3/23.
//

import SwiftUI
import ChatGPTSwift

import SwiftUI

struct ContentView: View {
    @State private var messageText = ""
    @State private var messages: [Message] = []
    let chatbotAPI = ChatbotAPI()

    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollView in
                    LazyVStack {
                        ForEach(messages) { message in
                            MessageView(text: message.text, isUserMessage: message.isUserMessage)
                        }
                    }
                    .onChange(of: messages) { _ in
                        withAnimation {
                            scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }.padding(15)
            HStack {
                TextField("Type your message here", text: $messageText)
                    .padding(.horizontal, 8)
                Button(action: {
                    sendMessage()
                }) {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(16)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(16)
            .padding()
        }
    }

    func sendMessage() {
        if messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        let userMessage = Message(text: messageText, isUserMessage: true)
        messages.append(userMessage)
        chatbotAPI.getResponse(for: messageText) { response in
            let chatbotMessage = Message(text: response, isUserMessage: false)
            messages.append(chatbotMessage)
        }
        messageText = ""
    }
}

struct MessageView: View {
    let text: String
    let isUserMessage: Bool
    let id = UUID()

    var body: some View {
        HStack {
            if isUserMessage {
                Spacer()
                Text(text)
                    .padding(12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
            } else {
                Text(text)
                    .padding(12)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(16)
                Spacer()
            }
        }
        .id(id)
    }
}

struct Message: Equatable, Identifiable {
    let text: String
    let isUserMessage: Bool
    let id = UUID()
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
