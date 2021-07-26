//
//  Tag+CoreDataProperties.swift
//  Friendface
//
//  Created by Bruce Gilmour on 2021-07-26.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var id: String?
    @NSManaged public var friends: NSSet?

    public var wrappedId: String {
        id ?? "Unspecified tag"
    }

    public var friendsArray: [UserDetail] {
        let set = friends as? Set<UserDetail> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for friends
extension Tag {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: UserDetail)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: UserDetail)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension Tag : Identifiable {

}
