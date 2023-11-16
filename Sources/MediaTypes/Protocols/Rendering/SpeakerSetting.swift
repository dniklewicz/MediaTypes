//  Created by Dariusz Niklewicz on 21/03/2023.

import Foundation

public protocol SpeakerSettingType: Equatable {}
extension String: SpeakerSettingType {}
extension Bool: SpeakerSettingType {}
extension Int: NumericalSpeakerSettingType {}
extension Double: NumericalSpeakerSettingType {}

public protocol SpeakerSetting<SettingType>: Identifiable, Equatable {
    associatedtype SettingType: SpeakerSettingType

    var id: String { get }
    var name: String { get }
    var value: SettingType { get set }
}

public protocol NumericalSpeakerSettingType: SpeakerSettingType, SignedNumeric, Comparable {}
public struct EnumerationSpeakerSetting: SpeakerSetting {
    public var name: String
    public var id: String
    public var value: String

    public let cases: [String]

    public init(name: String, id: String, value: String, cases: [String]) {
        self.name = name
        self.id = id
        self.value = value
        self.cases = cases
    }
}

public protocol NumericalSpeakerSettingProtocol<SettingType>: SpeakerSetting
where SettingType: NumericalSpeakerSettingType {
    var id: String { get }
    var range: ClosedRange<Double> { get }
    var step: Double { get }
}

public struct BooleanSpeakerSetting: SpeakerSetting {
    public var id: String
    public var name: String
    public var value: Bool

    public init(id: String, name: String, value: Bool) {
        self.id = id
        self.name = name
        self.value = value
    }
}

public struct DoubleSpeakerSetting: NumericalSpeakerSettingProtocol {
    public var id: String
    public var name: String
    public var value: Double
    public var range: ClosedRange<Double>
    public var step: Double

    public init(id: String, name: String, value: Double, range: ClosedRange<Double>, step: Double) {
        self.id = id
        self.name = name
        self.value = value
        self.range = range
        self.step = step
    }
}
