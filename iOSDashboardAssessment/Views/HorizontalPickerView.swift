//
//  HorizontalPickerView.swift
//  iOSDashboardAssessment
//
//  Created by Aswanth K on 30/08/24.
//

import SwiftUI

struct HorizontalPickerView: View {
    @Binding var selected: Int
    let option: [String]
    @Namespace var line
    @State private var scrollViewProxy: ScrollViewProxy?
    @State private var hasReachedEnd = false
    var action: (Int) -> Void
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollView in
                VStack(spacing: 0) {
                    LazyHStack(spacing: 16) {
                        ForEach(option.indices, id: \.self) { index in
                            VStack {
                                Button {
                                    selected = index
                                    action(index)
                                    withAnimation {
                                        scrollToItem(scrollView: scrollView, index: index)
                                    }
                                } label: {
                                    VStack {
                                        Text(option[index])
                                            .foregroundColor(Color.black.opacity(selected == index ? 1 : 0.8))
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                }
                                .id(index)
                                ZStack {
                                    Rectangle().fill(Color.red)
                                        .frame(height: 1)
                                        .opacity(0)
                                    if selected == index {
                                        Rectangle().fill(Color.purple)
                                            .frame(height: 3)
                                            .matchedGeometryEffect(id: index, in: line)
                                    }
                                }
                            }
                            .fixedSize()
                        }
                    }
                    .padding(.horizontal, 10)
                    Rectangle().frame(height: 1).foregroundColor(Color.gray.opacity(0.5))
                }
                .onAppear {
                    scrollViewProxy = scrollView
                }
            }
        }
    }
    private func scrollToItem(scrollView: ScrollViewProxy, index: Int) {
        withAnimation {
            scrollView.scrollTo(index, anchor: .center)
        }
    }
    
}

struct pickerMainView: View {
    @State var selectedId = 0
    var body: some View {
        VStack {
            HorizontalPickerView(selected: $selectedId, option: ["first", "second second", "third third third"]) { id in
                print("Selction changed to postion \(id)")
            }
            .frame(height: 90)
            Spacer()
        }
    }
}
struct HorizontalPickerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            pickerMainView()
        }
    }
}
