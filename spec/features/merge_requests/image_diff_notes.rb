require 'spec_helper'

feature 'Diff note avatars', js: true do
  include NoteInteractionHelpers

  let(:user)          { create(:user) }
  let(:project)       { create(:project, :public, :repository) }
  let(:merge_request) { create(:merge_request_with_diffs, source_project: project, author: user, title: "Bug NS-04") }
  let(:path)          { "files/images/6049019_460s.jpg" }
  let(:position) do
    Gitlab::Diff::Position.new(
      old_path: path,
      new_path: path,
      width: 100,
      height: 100,
      x_axis: 1,
      y_axis: 1,
      position_type: "image",
      diff_refs: merge_request.diff_refs
    )
  end

  let!(:note) { create(:diff_note_on_merge_request, project: project, noteable: merge_request, position: position) }

  before do
    project.team << [user, :master]
    sign_in user

    page.driver.set_cookie('sidebar_collapsed', 'true')
  end

  context 'commit view' do
    before do
      visit project_commit_path(project, merge_request.commits.first.id)
    end

    # same behavior as diff note
  end

  %w(inline parallel).each do |view|
    context "#{view} view" do

      describe 'creating a new diff note' do
        before do
          visit diffs_project_merge_request_path(project, merge_request, view: view)
          create_image_diff_note
        end

        it 'shows indicator badge on image diff', focus: true do
          indicator = find('.js-image-badge')

          expect(indicator).to have_content('1')
        end

        it 'shows the avatar badge on the new note' do
          badge = find('.image-diff-avatar-link .badge')

          expect(badge).to have_content('1')
        end

        it 'allows collapsing the discussion notes' do
          find('.js-diff-notes-toggle').click

          expect(page).not_to have_content('image diff test comment')
        end

        it 'allows expanding discussion notes' do
          find('.js-diff-notes-toggle').click
          find('.js-diff-notes-toggle').click

          expect(page).to have_content('image diff test comment')
        end
      end

      describe 'render diff notes' do
        before do
          # mock a couple separate comments on the image diff
        end

        it 'render diff indicators within the image frame' do
        end

        it 'shows the diff notes' do
        end

        it 'shows the diff notes with correct avatar badge numbers' do
        end
      end
    end
  end

  context 'discussion tab' do
    before do
      visit project_merge_request_path(project, merge_request)
    end

    it 'shows the image diff frame' do
      frame = find('.js-image-frame')
    end

    it 'shows the indicator on the frame' do
    end

    it 'shows the note with a generic comment icon' do
    end
  end

end

def create_image_diff_note
  find('.js-add-image-diff-note-button').click
  find('.note-textarea').native.send_keys('image diff test comment')
  click_button 'Comment'
  wait_for_requests
end
