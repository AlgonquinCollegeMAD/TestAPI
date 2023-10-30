//
//  ContentView.swift
//  TestAPI
//
//  Created by Adesh Shah on 2023-10-30.
//

import SwiftUI

struct ContentView: View {
    @State var posts: [Post] = []
        //MARK: View
        var body: some View {
            NavigationStack {
                List(posts) { post in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(post.title).bold().lineLimit(1).font(.title3)
                            Text(post.body).lineLimit(1).font(.footnote)
                        }
                        Spacer()
                        Text("Post #: \(post.id)")
                    }
                }
                .navigationTitle("Posts from API")
                .onAppear {
                    fetchData()
                }
            }
        }
        //MARK: Model
        struct Post: Codable, Identifiable {
            let id: Int
            let title, body: String
        }
        //MARK: Function to fetch post data (ViewModel)
    
    private func fetchData() {
        //Parse URL
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    //Parse JSON
                    let decodedData = try JSONDecoder().decode([Post].self, from: data)
                    self.posts = decodedData
                } catch {
                    //Print JSON decoding error
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            } else if let error = error {
                //Print API call error
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
