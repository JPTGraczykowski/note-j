require 'rails_helper'

RSpec.describe Notes::FilterQuery do
  it "returns all notes when no filters are applied" do
    user = create(:user)
    folder1 = create(:folder, name: "Folder 1", user: user)
    tag1 = create(:tag, name: "Tag 1", user: user)

    note1 = create(:note, title: "Meeting notes", user: user)
    note2 = create(:note, title: "Project ideas", user: user, folder: folder1)
    note3 = create(:note, title: "Todo list", user: user, folder: folder1)
    NotesTag.create(note: note3, tag: tag1, user: user)

    query = Notes::FilterQuery.new(notes: user.notes)
    results = query.results

    expect(results.pluck(:id)).to contain_exactly(note1.id, note2.id, note3.id)
  end

  it "filters notes by specific folder" do
    user = create(:user)
    work_folder = create(:folder, name: "Work", user: user)
    personal_folder = create(:folder, name: "Personal", user: user)

    work_note = create(:note, title: "Team meeting", folder: work_folder, user: user)
    personal_note = create(:note, title: "Grocery list", folder: personal_folder, user: user)
    unfiled_note = create(:note, title: "Random thoughts", folder: nil, user: user)

    query = Notes::FilterQuery.new(notes: user.notes, folder_id: work_folder.id)
    results = query.results

    expect(results.pluck(:id)).to contain_exactly(work_note.id)
  end

  it "filters notes without folder when folder_id is 'none'" do
    user = create(:user)
    work_folder = create(:folder, name: "Work", user: user)

    work_note = create(:note, title: "Team meeting", folder: work_folder, user: user)
    unfiled_note1 = create(:note, title: "Random thoughts", folder: nil, user: user)
    unfiled_note2 = create(:note, title: "Quick notes", folder: nil, user: user)

    query = Notes::FilterQuery.new(notes: user.notes, folder_id: "none")
    results = query.results

    expect(results.pluck(:id)).to contain_exactly(unfiled_note1.id, unfiled_note2.id)
  end

  it "filters notes by tag" do
    user = create(:user)
    urgent_tag = create(:tag, name: "urgent", user: user)
    work_tag = create(:tag, name: "work", user: user)

    urgent_note = create(:note, title: "Important deadline", user: user)
    NotesTag.create(note: urgent_note, tag: urgent_tag, user: user)

    work_note = create(:note, title: "Team standup", user: user)
    NotesTag.create(note: work_note, tag: work_tag, user: user)

    untagged_note = create(:note, title: "Random ideas", user: user)

    query = Notes::FilterQuery.new(notes: user.notes, tag_id: urgent_tag.id)
    results = query.results

    expect(results.pluck(:id)).to contain_exactly(urgent_note.id)
  end

  it "filters notes by both folder and tag" do
    user = create(:user)
    work_folder = create(:folder, name: "Work", user: user)
    urgent_tag = create(:tag, name: "urgent", user: user)

    work_urgent_note = create(:note, title: "Critical bug fix", folder: work_folder, user: user)
    NotesTag.create(note: work_urgent_note, tag: urgent_tag, user: user)

    work_note = create(:note, title: "Regular task", folder: work_folder, user: user)

    urgent_note = create(:note, title: "Personal urgent", folder: nil, user: user)
    NotesTag.create(note: urgent_note, tag: urgent_tag, user: user)

    query = Notes::FilterQuery.new(
      notes: user.notes,
      folder_id: work_folder.id,
      tag_id: urgent_tag.id
    )
    results = query.results

    expect(results.pluck(:id)).to contain_exactly(work_urgent_note.id)
  end
end
