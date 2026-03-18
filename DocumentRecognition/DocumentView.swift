//
//  DocumentView.swift
//  DocumentRecognition
//
//  Created by Quanpeng Yang on 3/17/26.
//

import SwiftUI
import Vision

struct DocumentView: View {
    @State private var textFound: String = "Recognizing..."
    
    var body: some View {
        VStack {
            ScrollView {
                Text(textFound)
                    .padding()
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
        .task {
            // 1. Load the image from the Asset Catalog
            guard let uiImage = UIImage(named: "letter"),
                  let cgImage = uiImage.cgImage else {
                textFound = "Image not found in Assets."
                return
            }
            
            do {
                // 2. Create the request
                let request = RecognizeTextRequest()
                
                // 3. Perform the request on the CGImage
                let observations = try await request.perform(on: cgImage)
                
                // 4. Extract and join the text
                let recognizedStrings = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                
                textFound = recognizedStrings.joined(separator: "\n")
                
                if textFound.isEmpty {
                    textFound = "No text detected."
                }
                
            } catch {
                textFound = "Error: \(error.localizedDescription)"
            }
        }
    }
}
