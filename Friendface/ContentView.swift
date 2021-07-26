//
//  ContentView.swift
//  Friendface
//
//  Created by Bruce Gilmour on 2021-07-25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc

    var body: some View {
        NavigationView {
            FilteredList(
                filterKey: "name",
                filterValue: "A",
                predicate: PredicateOp.greaterThanEquals,
                negate: false,
                caseSensitive: false,
                sortDescriptors: [
                    NSSortDescriptor(keyPath: \UserDetail.name, ascending: true)
                ]
            ) { (user: UserDetail) in
                NavigationLink(destination: UserDetailView(user: user)) {
                    UserRow(user: user)
                }
            }
            .onAppear(perform: loadData)
            .navigationBarTitle("Friendface")
        }
    }

    var hasCoreData: Bool {
        if let count = try? moc.count(for: UserDetail.fetchRequest()) {
            return count > 0
        }
        return false
    }

    func loadData() {
        if (hasCoreData) {
            print("Core Data already exists")
            return
        }
        
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                if let decodedResponse = try? decoder.decode([User].self, from: data) {
                    DispatchQueue.main.async {
                        createCoreData(from: decodedResponse)
                    }
                    return
                }
            }

            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }
        .resume()
    }

    func createCoreData(from users: [User]) {
        print("Create Core Data from \(users.count) JSON objects")

        var cache = [UUID: NSManagedObjectID]()

        for user in users {
            let userDetail = UserDetail(context: moc)

            cache[user.id] = userDetail.objectID

            userDetail.id = user.id
            userDetail.isActive = user.isActive
            userDetail.name = user.name
            userDetail.age = Int16(user.age)
            userDetail.company = user.company
            userDetail.email = user.email
            userDetail.address = user.address
            userDetail.about = user.about
            userDetail.registered = user.registered

            for userTag in user.tags {
                let tag = Tag(context: moc)
                tag.id = userTag
                userDetail.addToTags(tag)
            }
        }

        for user in users {
            guard let userObjectId = cache[user.id] else { continue }
            guard let userDetail = try? moc.existingObject(with: userObjectId) as? UserDetail else { continue }

            for userFriend in user.friends {
                guard let friendObjectId = cache[userFriend.id] else { continue }
                guard let friend = try? moc.existingObject(with: friendObjectId) as? UserDetail else { continue }

                userDetail.addToFriends(friend)
            }
        }

        try? moc.save()
    }
}

struct UserRow: View {
    let user: UserDetail

    var body: some View {
        VStack(alignment: .leading) {
            Text(user.wrappedName)
                .font(.headline)
                .foregroundColor(user.isActive ? .primary : .secondary)
                .padding(.bottom, 1)

            DetailEntry(image: "calendar", detail: "\(user.age) years old")
            DetailEntry(image: "envelope", detail: user.wrappedEmail)
        }
    }
}

struct UserDetailView: View {
    let user: UserDetail

    var body: some View {
        Form {
            Section(header: Text("Personal Details")) {
                DetailEntry(image: "mail", detail: user.wrappedAddress)
                DetailEntry(image: "building", detail: user.wrappedCompany)
                DetailEntry(image: "envelope", detail: user.wrappedEmail)
                DetailEntry(image: "calendar", detail: "\(user.age) years old")
                DetailEntry(image: "tag", detail: user.tagsArray.map { $0.wrappedId }.joined(separator: ", "))
            }

            Section(header: Text("About")) {
                VStack(alignment: .leading) {
                    Text(user.wrappedAbout.trimmingCharacters(in: .whitespacesAndNewlines))
                        .padding(.bottom)
                    Text("Since: \(formattedDate(from: user.wrappedRegistered))")
                }
            }

            Section(header: Text("Friends (\(user.friendsArray.count))")) {
                List(user.friendsArray) { friend in
                    NavigationLink(destination: UserDetailView(user: friend)) {
                        UserRow(user: friend)
                    }
                }
            }
        }
        .navigationBarTitle("\(user.wrappedName)\(user.isActive ? "" : " (inactive)")", displayMode: .inline)
    }

    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
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
        ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
