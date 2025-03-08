import Foundation
import Ignite
import SharedModels

struct TimetableComponent: RootHTML {
  let conference: Conference
  private let imageSize = 50

  var body: some HTML {
    Text(conference.title)
      .font(.title2)
      .fontWeight(.bold)
      .foregroundStyle(.bootstrapPurple)

    ForEach(conference.schedules) { schedule in
      Card {
        ForEach(schedule.sessions) { session in
          ZStack(alignment: .topLeading) {
            if let speakers = session.speakers {
              ForEach(speakers) { speaker in
                Image(speaker.imageFilename, description: speaker.name)
                  .resizable()
                  .frame(maxWidth: imageSize, maxHeight: imageSize)
                  .cornerRadius(imageSize / 2)
              }
            }
            Text(session.title)
              .font(.lead)
              .fontWeight(.bold)
              .foregroundStyle(.dimGray)
              .margin(.leading, .px(imageSize + 20))
              .margin(.vertical, .px(8))
          }
          .padding(.all, .px(8))
          .onClick {
            ShowModal(id: session.modalId)
          }
        }
      } header: {
        schedule.time.formattedTimeString()
      }
    }.margin(.bottom, .px(8))
  }
}

struct SessionDetailModal: HTML {
  let session: Session
  let language: SupportedLanguage

  var body: some HTML {
    Modal(
      id: session.modalId,
      body: {
        if let description = session.description, !description.isEmpty {
          Text(description)
            .font(.lead)
            .foregroundStyle(.dimGray)
            .margin(.horizontal, .px(16))
        }
        if let speakers = session.speakers {
          ForEach(speakers) { speaker in
            SpeakerDetailComponent(speaker: speaker, language: language)
              .background(.lightGray)
              .cornerRadius(8)
              .margin(.bottom, .px(8))
          }
        }
        ModalFooterComponent(modalId: session.title, language: language)
          .padding(.all, .px(16))
      },
      header: {
        Text(session.title)
          .font(.title2)
          .fontWeight(.bold)
          .foregroundStyle(.bootstrapPurple)
      }
    ).size(.large)
  }
}

extension Session {
  var modalId: String {
    title.replacingOccurrences(of: "'", with: "")
  }
}

extension Date {
  func formattedDateString(language: SupportedLanguage) -> String {
    let formatter = DateFormatter()
    switch language {
    case .en:
      let day = Calendar.current.component(.day, from: self)
      let ordinal = NumberFormatter.localizedString(from: NSNumber(value: day), number: .ordinal)
      formatter.dateFormat = "MMMM"
      return formatter.string(from: self) + " \(ordinal)"
    case .ja:
      formatter.dateFormat = "M月d日"
      return formatter.string(from: self)
    }
  }

  func formattedTimeString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: self)
  }
}
