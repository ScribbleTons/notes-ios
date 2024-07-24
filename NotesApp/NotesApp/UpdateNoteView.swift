//
//  UpdateNoteView.swift
//  NotesApp
//
//  Created by Emmanuel Ugwuoke on 24/07/2024.
//

import SwiftUI

struct UpdateNoteView: View {
    @Binding var text: String
    @Binding var id: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Type note...", text: self.$text).padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .frame(minHeight: 80, alignment: .topLeading)
                .foregroundColor(.black)
                .background(.yellow.opacity(0.35))
                .cornerRadius(8.0)
            
            Button(action: {
                updateNote(self.id)
                
            }, label: { Text("Update").fontWeight(.bold).padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))}) .background(.blue).foregroundColor(.white).cornerRadius(10)
        }.padding()
    }
    
    
    func updateNote (_ id:String?) {
        
        guard let id = id else { return }
        
        let param = ["note": self.text] as [String: String]
        
        let url = URL(string: ApiService.patchNote(id))!
        
        let session = URLSession.shared
    
        var request = URLRequest(url: url)
        
        request.httpMethod = "PATCH"
       
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
                print("updated")
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
        self.text = ""
        self.id = ""
        presentationMode.wrappedValue.dismiss()
        
    }
}
