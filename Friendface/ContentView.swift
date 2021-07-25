//
//  ContentView.swift
//  Friendface
//
//  Created by Bruce Gilmour on 2021-07-25.
//

import SwiftUI

struct ContentView: View {
    // start with a local version of the json data and replace it with the downloaded data later
    @StateObject var friendfaceData = FriendfaceData()

    var body: some View {
        NavigationView {
            List(friendfaceData.users.sorted(by: { $0.name < $1.name })) { user in
                NavigationLink(destination: UserDetail(user: user)) {
                    UserRow(user: user)
                }
            }
            .navigationBarTitle("Friendface")
        }
        .environmentObject(friendfaceData)
    }
}

struct UserRow: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading) {
            Text(user.name)
                .font(.headline)
                .foregroundColor(user.isActive ? .primary : .secondary)
                .padding(.bottom, 1)

            DetailEntry(image: "calendar", detail: "\(user.age) years old")
            DetailEntry(image: "envelope", detail: user.email)
        }
    }
}

struct UserDetail: View {
    let user: User

    @EnvironmentObject var friendfaceData: FriendfaceData

    var body: some View {
        Form {
            Section(header: Text("Personal Details")) {
                DetailEntry(image: "mail", detail: user.address)
                DetailEntry(image: "building", detail: user.company)
                DetailEntry(image: "envelope", detail: user.email)
                DetailEntry(image: "calendar", detail: "\(user.age) years old")
                DetailEntry(image: "tag", detail: user.tags.joined(separator: ", "))
            }

            Section(header: Text("About")) {
                VStack(alignment: .leading) {
                    Text(user.about.trimmingCharacters(in: .whitespacesAndNewlines))
                        .padding(.bottom)
                    Text("Since: \(formattedDate(from: user.registered))")
                }
            }

            Section(header: Text("Friends")) {
                List(userList(from: user.friends)) { friend in
                    NavigationLink(destination: UserDetail(user: friend)) {
                        UserRow(user: friend)
                    }
                }
            }
        }
        .navigationBarTitle("\(user.name)\(user.isActive ? "" : " (inactive)")", displayMode: .inline)
    }

    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    func userList(from friends: [Friend]) -> [User] {
        friends.compactMap { friend in
            friendfaceData.users.first(where: { $0.id == friend.id})
        }
    }
}

struct DetailEntry: View {
    let image: String
    let detail: String

    var body: some View {
        HStack {
            Image(systemName: image)
                .frame(width: 30)
            Text(detail)
        }
        .font(.subheadline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
