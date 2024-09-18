//
//  UnitTestView.swift
//  UnitTest
//
//  Created by Farido on 18/09/2024.
//

import SwiftUI

struct UnitTestView: View {
    @StateObject private var vm: UnitTestViewModel

    init(isPremium: Bool) {
        _vm = StateObject(wrappedValue: UnitTestViewModel(isPremium: isPremium))
    }

    var body: some View {
        Text(vm.isPremium.description)
    }
}

#Preview {
    UnitTestView(isPremium: false)
}
