//  Created by Dariusz Niklewicz on 19/12/2022.

import Foundation

public protocol QueuedItem: Identifiable {
    var title: String { get }
    var artist: String? { get }
    var album: String? { get }
    var artwork: Artwork? { get }
    
    init(id: NSNumber, title: String, artist: String?, album: String?, artwork: Artwork?)
}
