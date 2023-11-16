//  Created by Dariusz Niklewicz on 07/10/2021.

import SwiftUI

public enum Artwork: Equatable {
    case image(Image)
    case url(URL)

    public var url: URL? {
        switch self {
        case let .url(url):
            return url
        default:
            return nil
        }
    }
}
