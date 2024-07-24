//
//  ContentView.swift
//  NotesApp
//
//  Created by Emmanuel Ugwuoke on 23/07/2024.
//

import SwiftUI

struct HomeView: View {
    @State var notes = [Note]()
    @State var showView = false;
    
    @State var showAlert = false
    
    @State var itemId: String = ""
    @State var itemNote: String = ""
    
    var alert: Alert {
        Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this note?"), primaryButton: .destructive(Text("Delete")){
            deleteNote(itemId)
        }, secondaryButton: .cancel())
    }
    
    var body: some View {
        NavigationStack {
            List(self.notes) {
                note in HStack {
                    Text(note.note).padding()
                    Spacer()
                  
                    Image(systemName: "pencil")
                        .frame(width: 20, height: 20)
                        .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                        .buttonBorderShape(.capsule)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(4.0)
                        .onTapGesture {
                            self.itemId = note._id
                            self.itemNote = note.note
                            self.showView.toggle()
                        }
                    
                }.onLongPressGesture {
                    self.itemId = note._id
                    self.showAlert.toggle()
                }
            }.navigationTitle("Notes")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button("Add") {
                            self.itemId = ""
                            self.showView.toggle()
                        }
                    }
                })
                .alert(isPresented: $showAlert, content: { alert })
                .sheet(isPresented: $showView, onDismiss: fetchNotes, content: {
                   if(self.itemNote == "") {
                        AddNoteView()
                   } else {
                       UpdateNoteView(text: self.$itemNote, id: self.$itemId)
                   }
                })
                .onAppear {
                    fetchNotes()
                }
        }
    }
    
    func fetchNotes(){
        let url = URL(string: ApiService.getNotes)!
        
        print("=== session url ===", url)
        
        let task = URLSession.shared.dataTask(with: url)  {
            data, res, err  in
            
            guard let data = data else { return }
            
            do {
                let notes = try JSONDecoder().decode([Note].self, from: data)
                self.notes = notes
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    func deleteNote(_ id:String?) {
        
        guard let id = id else {
            print("Note with ID doesn't exist.")
            return
        }
        
        let url = URL(string: ApiService.deleteNote(id))!
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       
       let task = session.dataTask(with: request) {
            data, res, err in
           guard err == nil else {
               print(err)
               return
           }
           
           print("Note deleted.")
            
        }
        task.resume()
        self.itemId = ""
        fetchNotes()
        
    }
}

struct Note: Identifiable, Codable {
    var id: String { _id }
    
    var _id: String
    var note: String
}

//#Preview {
//    ContentView()
//}
