class Spinach::Features::AwardEmoji < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedProject
  include SharedPaths
  include Select2Helper

  step 'I visit "Bugfix" issue page' do
    visit namespace_project_issue_path(@project.namespace, @project, @issue)
  end

  step 'I click to emoji-picker' do
<<<<<<< HEAD
    page.within ".awards-controls" do
      page.find(".add-award").click
=======
    page.within '.awards-controls' do
      page.find('.add-award').click
>>>>>>> 01824a0fac17331c7eacf40feb6882c508fe4880
    end
  end

  step 'I click to emoji in the picker' do
<<<<<<< HEAD
    page.within ".awards-menu" do
      page.first("img").click
=======
    page.within '.awards-menu' do
      page.first('img').click
>>>>>>> 01824a0fac17331c7eacf40feb6882c508fe4880
    end
  end

  step 'I can remove it by clicking to icon' do
<<<<<<< HEAD
    page.within ".awards" do
      page.first(".award").click
      expect(page).to_not have_selector ".award"
=======
    page.within '.awards' do
      page.first('.award').click
      expect(page).to_not have_selector '.award'
>>>>>>> 01824a0fac17331c7eacf40feb6882c508fe4880
    end
  end

  step 'I have award added' do
<<<<<<< HEAD
    page.within ".awards" do
      expect(page).to have_selector ".award"
      expect(page.find(".award .counter")).to have_content "1"
=======
    page.within '.awards' do
      expect(page).to have_selector '.award'
      expect(page.find('.award .counter')).to have_content '1'
>>>>>>> 01824a0fac17331c7eacf40feb6882c508fe4880
    end
  end

  step 'project "Shop" has issue "Bugfix"' do
<<<<<<< HEAD
    @project = Project.find_by(name: "Shop")
    @issue = create(:issue, title: "Bugfix", project: project)
=======
    @project = Project.find_by(name: 'Shop')
    @issue = create(:issue, title: 'Bugfix', project: project)
  end

  step 'I leave comment with a single emoji' do
    page.within('.js-main-target-form') do
      fill_in 'note[note]', with: ':smile:'
      click_button 'Add Comment'
    end
>>>>>>> 01824a0fac17331c7eacf40feb6882c508fe4880
  end
end
