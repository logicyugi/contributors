//
//  Profile+CoreDataProperties.swift
//  Contributeurs
//
//  Created by Antoine El Samra on 28/09/2023.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var avatarURL: URL?
    @NSManaged public var login: String?
    @NSManaged public var url: URL?
    @NSManaged public var organizations: String?

}

extension Profile : Identifiable {

}
