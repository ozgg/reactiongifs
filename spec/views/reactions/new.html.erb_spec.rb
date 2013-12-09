require 'spec_helper'

describe 'reactions/new.html.erb' do
  it 'displays form with title and image fields' do
    render
    form_parameters = {
      method: 'post',
      action: reactions_path
    }
    expect(rendered).to have_selector('form', form_parameters) do |form|
      expect(form).to have_selector('input', name: 'reaction[title]', type: 'text')
      expect(form).to have_selector('input', name: 'reaction[image]', type: 'file')
      expect(form).to have_selector('button', type: 'submit')
    end
  end
end
