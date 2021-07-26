//
//  UserDetail+CoreDataProperties.swift
//  Friendface
//
//  Created by Bruce Gilmour on 2021-07-26.
//
//

import Foundation
import CoreData


extension UserDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetail> {
        return NSFetchRequest<UserDetail>(entityName: "UserDetail")
    }

    @NSManaged public var about: String?
    @NSManaged public var address: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: NSSet?
    @NSManaged public var friends: NSSet?

    public var wrappedAbout: String {
        about ?? ""
    }

    public var wrappedAddress: String {
        address ?? "No address"
    }

    public var wrappedCompany: String {
        company ?? "Unknown company"
    }

    public var wrappedEmail: String {
        email ?? "No email"
    }

    public var wrappedId: UUID {
        id ?? UUID()
    }

    public var wrappedName: String {
        name ?? "Unknown name"
    }

    public var wrappedRegistered: Date {
        registered ?? Date()
    }

    public var friendsArray: [UserDetail] {
        let set = friends as? Set<UserDetail> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

    public var tagsArray: [Tag] {
        let set = tags as? Set<Tag> ?? []
        return set.sorted {
            $0.wrappedId < $1.wrappedId
        }
    }
}

// MARK: Generated accessors for tags
extension UserDetail {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

// MARK: Generated accessors for friends
extension UserDetail {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: UserDetail)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: UserDetail)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension UserDetail : Identifiable {

}
