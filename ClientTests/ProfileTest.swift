/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

@testable import Client
import Foundation
import Shared
import Storage
import SwiftKeychainWrapper

import XCTest

/*
 * A base test type for tests that need a profile.
 */
class ProfileTest: XCTestCase {
    func withTestProfile(_ callback: (_ profile: Client.Profile) -> Void) {
        let profile = MockProfile(databasePrefix: "profile-test")
        profile._reopen()
        callback(profile)
        profile._shutdown()
    }

    func testNewProfileClearsExistingAuthenticationInfo() {
        // TODO: Disable this test in CI
        let authInfo = AuthenticationKeychainInfo(passcode: "1234")
        KeychainWrapper.sharedAppContainerKeychain.setAuthenticationInfo(authInfo)
        XCTAssertNotNil(KeychainWrapper.sharedAppContainerKeychain.authenticationInfo())
        let _ = BrowserProfile(localName: "my_profile", clear: true)
        XCTAssertNil(KeychainWrapper.sharedAppContainerKeychain.authenticationInfo())
    }
}
