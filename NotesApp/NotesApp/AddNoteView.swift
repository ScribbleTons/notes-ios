//
//  AddNoteView.swift
//  NotesApp
//
//  Created by Emmanuel Ugwuoke on 23/07/2024.
//

import SwiftUI

struct AddNoteView: View {
    @State var note: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Type note...", text: $note).padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .frame(minHeight: 80, alignment: .topLeading)
                .foregroundColor(.black)
                .background(.yellow.opacity(0.35))
                .cornerRadius(8.0)
            
            Button(action: postNote, label: { Text("Add").fontWeight(.bold).padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))}) .background(.blue).foregroundColor(.white).cornerRadius(10)
        }.padding()
    }
    
    func postNote () {
        let param = ["note": self.note] as [String: String]
        
        let url = URL(string: ApiService.createNote)!
        
        let session = URLSession.shared
    
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
       
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        } catch {
            print(error)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) {
            data, res, err in
            guard err == nil else { return }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print(json)
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
        self.note = ""
        presentationMode.wrappedValue.dismiss()
        
    }
    
}

//#Preview {
//    AddNoteView()
//}
