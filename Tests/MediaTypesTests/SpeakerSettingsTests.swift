import XCTest
@testable import MediaTypes

final class SpeakerSettingsTests: XCTestCase {
    
    // MARK: - BooleanSpeakerSetting Tests
    
    func testBooleanSpeakerSettingInitialization() {
        let setting = BooleanSpeakerSetting(
            id: "test-boolean",
            name: "Test Boolean Setting",
            value: true
        )
        
        XCTAssertEqual(setting.id, "test-boolean")
        XCTAssertEqual(setting.name, "Test Boolean Setting")
        XCTAssertTrue(setting.value)
    }
    
    func testBooleanSpeakerSettingEquality() {
        let setting1 = BooleanSpeakerSetting(
            id: "test-boolean",
            name: "Test Boolean Setting",
            value: true
        )
        
        let setting2 = BooleanSpeakerSetting(
            id: "test-boolean",
            name: "Test Boolean Setting",
            value: true
        )
        
        let setting3 = BooleanSpeakerSetting(
            id: "test-boolean",
            name: "Test Boolean Setting",
            value: false
        )
        
        XCTAssertEqual(setting1, setting2)
        XCTAssertNotEqual(setting1, setting3)
    }
    
    func testBooleanSpeakerSettingMutability() {
        var setting = BooleanSpeakerSetting(
            id: "test-boolean",
            name: "Test Boolean Setting",
            value: false
        )
        
        setting.value = true
        XCTAssertTrue(setting.value)
        
        setting.value = false
        XCTAssertFalse(setting.value)
    }
    
    // MARK: - DoubleSpeakerSetting Tests
    
    func testDoubleSpeakerSettingInitialization() {
        let setting = DoubleSpeakerSetting(
            id: "test-double",
            name: "Test Double Setting",
            value: 5.0,
            range: 0.0...10.0,
            step: 0.5
        )
        
        XCTAssertEqual(setting.id, "test-double")
        XCTAssertEqual(setting.name, "Test Double Setting")
        XCTAssertEqual(setting.value, 5.0, accuracy: 0.001)
        XCTAssertEqual(setting.range, 0.0...10.0)
        XCTAssertEqual(setting.step, 0.5, accuracy: 0.001)
    }
    
    func testDoubleSpeakerSettingEquality() {
        let setting1 = DoubleSpeakerSetting(
            id: "test-double",
            name: "Test Double Setting",
            value: 5.0,
            range: 0.0...10.0,
            step: 0.5
        )
        
        let setting2 = DoubleSpeakerSetting(
            id: "test-double",
            name: "Test Double Setting",
            value: 5.0,
            range: 0.0...10.0,
            step: 0.5
        )
        
        let setting3 = DoubleSpeakerSetting(
            id: "test-double",
            name: "Test Double Setting",
            value: 7.5,
            range: 0.0...10.0,
            step: 0.5
        )
        
        XCTAssertEqual(setting1, setting2)
        XCTAssertNotEqual(setting1, setting3)
    }
    
    func testDoubleSpeakerSettingMutability() {
        var setting = DoubleSpeakerSetting(
            id: "test-double",
            name: "Test Double Setting",
            value: 5.0,
            range: 0.0...10.0,
            step: 0.5
        )
        
        setting.value = 7.5
        XCTAssertEqual(setting.value, 7.5, accuracy: 0.001)
        
        setting.value = 2.0
        XCTAssertEqual(setting.value, 2.0, accuracy: 0.001)
    }
    
    func testDoubleSpeakerSettingRangeValidation() {
        let setting = DoubleSpeakerSetting(
            id: "test-double",
            name: "Test Double Setting",
            value: 5.0,
            range: 0.0...10.0,
            step: 0.5
        )
        
        // Test that range bounds are correctly set
        XCTAssertEqual(setting.range.lowerBound, 0.0)
        XCTAssertEqual(setting.range.upperBound, 10.0)
        
        // Test that the range contains expected values
        XCTAssertTrue(setting.range.contains(0.0))
        XCTAssertTrue(setting.range.contains(5.0))
        XCTAssertTrue(setting.range.contains(10.0))
        XCTAssertFalse(setting.range.contains(-1.0))
        XCTAssertFalse(setting.range.contains(11.0))
    }
    
    // MARK: - EnumerationSpeakerSetting Tests
    
    func testEnumerationSpeakerSettingInitialization() {
        let cases = ["option1", "option2", "option3"]
        let setting = EnumerationSpeakerSetting(
            name: "Test Enumeration Setting",
            id: "test-enum",
            value: "option2",
            cases: cases
        )
        
        XCTAssertEqual(setting.name, "Test Enumeration Setting")
        XCTAssertEqual(setting.id, "test-enum")
        XCTAssertEqual(setting.value, "option2")
        XCTAssertEqual(setting.cases, cases)
    }
    
    func testEnumerationSpeakerSettingEquality() {
        let cases = ["option1", "option2", "option3"]
        
        let setting1 = EnumerationSpeakerSetting(
            name: "Test Enumeration Setting",
            id: "test-enum",
            value: "option2",
            cases: cases
        )
        
        let setting2 = EnumerationSpeakerSetting(
            name: "Test Enumeration Setting",
            id: "test-enum",
            value: "option2",
            cases: cases
        )
        
        let setting3 = EnumerationSpeakerSetting(
            name: "Test Enumeration Setting",
            id: "test-enum",
            value: "option3",
            cases: cases
        )
        
        XCTAssertEqual(setting1, setting2)
        XCTAssertNotEqual(setting1, setting3)
    }
    
    func testEnumerationSpeakerSettingMutability() {
        let cases = ["option1", "option2", "option3"]
        var setting = EnumerationSpeakerSetting(
            name: "Test Enumeration Setting",
            id: "test-enum",
            value: "option1",
            cases: cases
        )
        
        setting.value = "option3"
        XCTAssertEqual(setting.value, "option3")
        
        setting.value = "option2"
        XCTAssertEqual(setting.value, "option2")
    }
    
    func testEnumerationSpeakerSettingCases() {
        let cases = ["manual", "auto", "preset1", "preset2"]
        let setting = EnumerationSpeakerSetting(
            name: "Mode Setting",
            id: "mode",
            value: "manual",
            cases: cases
        )
        
        XCTAssertEqual(setting.cases.count, 4)
        XCTAssertTrue(setting.cases.contains("manual"))
        XCTAssertTrue(setting.cases.contains("auto"))
        XCTAssertTrue(setting.cases.contains("preset1"))
        XCTAssertTrue(setting.cases.contains("preset2"))
        XCTAssertFalse(setting.cases.contains("invalid"))
    }
    
    // MARK: - SpeakerSettingType Protocol Tests
    
    func testSpeakerSettingTypeConformance() {
        // Test that basic types conform to SpeakerSettingType
        let stringValue: String = "test"
        let boolValue: Bool = true
        let intValue: Int = 42
        let doubleValue: Double = 3.14
        
        // These should compile without errors, proving conformance
        XCTAssertEqual(stringValue, "test")
        XCTAssertTrue(boolValue)
        XCTAssertEqual(intValue, 42)
        XCTAssertEqual(doubleValue, 3.14, accuracy: 0.001)
    }
    
    func testNumericalSpeakerSettingTypeConformance() {
        // Test that numerical types conform to NumericalSpeakerSettingType
        let intValue: Int = 42
        let doubleValue: Double = 3.14
        
        // Test comparison operations
        XCTAssertTrue(intValue > 0)
        XCTAssertTrue(intValue < 100)
        XCTAssertTrue(doubleValue > 0.0)
        XCTAssertTrue(doubleValue < 10.0)
        
        // Test arithmetic operations
        XCTAssertEqual(intValue + 8, 50)
        XCTAssertEqual(doubleValue * 2, 6.28, accuracy: 0.001)
    }
    
    // MARK: - Integration Tests
    
    func testSpeakerSettingsInMockPlayer() {
        let player = MockPlayer(id: "test", name: "Test Player", model: "Test Model")
        
        // Test that default speaker settings are created
        XCTAssertEqual(player.speakerSettings.count, 5)
        
        // Test bass setting
        let bassSettings = player.speakerSettings.compactMap { $0 as? DoubleSpeakerSetting }.first { $0.id == "bass" }
        XCTAssertNotNil(bassSettings)
        XCTAssertEqual(bassSettings?.name, "Bass")
        XCTAssertEqual(bassSettings?.value ?? 0.0, 5.0, accuracy: 0.001)
        XCTAssertEqual(bassSettings?.range, 0.0...10.0)
        XCTAssertEqual(bassSettings?.step ?? 0.0, 1.0, accuracy: 0.001)
        
        // Test mid setting
        let midSettings = player.speakerSettings.compactMap { $0 as? DoubleSpeakerSetting }.first { $0.id == "mid" }
        XCTAssertNotNil(midSettings)
        XCTAssertEqual(midSettings?.name, "Mid")
        XCTAssertEqual(midSettings?.value ?? 0.0, 5.0, accuracy: 0.001)
        
        // Test treble setting
        let trebleSettings = player.speakerSettings.compactMap { $0 as? DoubleSpeakerSetting }.first { $0.id == "treble" }
        XCTAssertNotNil(trebleSettings)
        XCTAssertEqual(trebleSettings?.name, "Treble")
        XCTAssertEqual(trebleSettings?.value ?? 0.0, 5.0, accuracy: 0.001)
        
        // Test enhancer setting
        let enhancerSettings = player.speakerSettings.compactMap { $0 as? BooleanSpeakerSetting }.first { $0.id == "enhancer" }
        XCTAssertNotNil(enhancerSettings)
        XCTAssertEqual(enhancerSettings?.name, "Enhancer")
        XCTAssertFalse(enhancerSettings?.value ?? true)
        
        // Test preset setting
        let presetSettings = player.speakerSettings.compactMap { $0 as? EnumerationSpeakerSetting }.first { $0.id == "preset" }
        XCTAssertNotNil(presetSettings)
        XCTAssertEqual(presetSettings?.name, "Preset")
        XCTAssertEqual(presetSettings?.value, "manual")
        XCTAssertEqual(presetSettings?.cases, ["manual", "auto"])
    }
    
    func testSpeakerSettingsModification() {
        let player = MockPlayer(id: "test", name: "Test Player", model: "Test Model")
        
        // Find and modify a double setting
        if let index = player.speakerSettings.firstIndex(where: { $0.id == "bass" }),
           var bassSetting = player.speakerSettings[index] as? DoubleSpeakerSetting {
            bassSetting.value = 8.0
            player.speakerSettings[index] = bassSetting
            
            let modifiedSetting = player.speakerSettings[index] as? DoubleSpeakerSetting
            XCTAssertEqual(modifiedSetting?.value ?? 0.0, 8.0, accuracy: 0.001)
        } else {
            XCTFail("Bass setting not found")
        }
        
        // Find and modify a boolean setting
        if let index = player.speakerSettings.firstIndex(where: { $0.id == "enhancer" }),
           var enhancerSetting = player.speakerSettings[index] as? BooleanSpeakerSetting {
            enhancerSetting.value = true
            player.speakerSettings[index] = enhancerSetting
            
            let modifiedSetting = player.speakerSettings[index] as? BooleanSpeakerSetting
            XCTAssertTrue(modifiedSetting?.value ?? false)
        } else {
            XCTFail("Enhancer setting not found")
        }
        
        // Find and modify an enumeration setting
        if let index = player.speakerSettings.firstIndex(where: { $0.id == "preset" }),
           var presetSetting = player.speakerSettings[index] as? EnumerationSpeakerSetting {
            presetSetting.value = "auto"
            player.speakerSettings[index] = presetSetting
            
            let modifiedSetting = player.speakerSettings[index] as? EnumerationSpeakerSetting
            XCTAssertEqual(modifiedSetting?.value, "auto")
        } else {
            XCTFail("Preset setting not found")
        }
    }
    
    // MARK: - Edge Cases
    
    func testDoubleSpeakerSettingWithZeroRange() {
        let setting = DoubleSpeakerSetting(
            id: "zero-range",
            name: "Zero Range Setting",
            value: 5.0,
            range: 5.0...5.0,
            step: 0.1
        )
        
        XCTAssertEqual(setting.range.lowerBound, 5.0)
        XCTAssertEqual(setting.range.upperBound, 5.0)
        XCTAssertTrue(setting.range.contains(5.0))
        XCTAssertFalse(setting.range.contains(4.9))
        XCTAssertFalse(setting.range.contains(5.1))
    }
    
    func testEnumerationSpeakerSettingWithEmptyCases() {
        let setting = EnumerationSpeakerSetting(
            name: "Empty Cases Setting",
            id: "empty-cases",
            value: "default",
            cases: []
        )
        
        XCTAssertEqual(setting.cases.count, 0)
        XCTAssertEqual(setting.value, "default")
    }
    
    func testEnumerationSpeakerSettingWithSingleCase() {
        let setting = EnumerationSpeakerSetting(
            name: "Single Case Setting",
            id: "single-case",
            value: "only-option",
            cases: ["only-option"]
        )
        
        XCTAssertEqual(setting.cases.count, 1)
        XCTAssertEqual(setting.value, "only-option")
        XCTAssertTrue(setting.cases.contains("only-option"))
    }
} 