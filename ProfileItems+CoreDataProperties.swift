//
//  ProfileItems+CoreDataProperties.swift
//  Contributeurs
//
//  Created by Antoine El Samra on 28/09/2023.
//
//

import Foundation
import CoreData


extension ProfileItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileItems> {
        return NSFetchRequest<ProfileItems>(entityName: "ProfileItems")
    }

    @NSManaged public var name: String?
    @NSManaged public var avatar: UUID?
    @NSManaged public var entreprise: String?
    @NSManaged public var localisation: String?
    @NSManaged public var followers: Int64
    @NSManaged public var url: URL?

}

extension ProfileItems : Identifiable {

}
