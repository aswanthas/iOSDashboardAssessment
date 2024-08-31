//
//  UserCardView.swift
//  iOSDashboardAssessment
//
//  Created by Aswanth K on 29/08/24.
//

import SwiftUI

struct UserCardView: View {
    var body: some View {
        GeometryReader(content: { geometry in
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Hello, John")
                        .font(.title3.bold())
                        .foregroundStyle(.black)
                    Text(formattedCurrentDate())
                        .font(.headline.bold())
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(.icUser)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black)
                    )
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .frame(width: geometry.size.width)
        })
    }
}

#Preview {
    UserCardView()
}
