# frozen_string_literal: true

require_relative "test_helper"

class UserRegistrationTest < SystemTestCase
  def test_user_can_register_successfully
    visit "/"
    assert_text "Welcome to Sample App"
    
    click_link "Sign Up"
    assert_text "Sign Up"
    assert_selector "input[name='email']"
    assert_selector "input[name='password']"
    
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "secretpassword123"
    presenter_milestone("Form Complete", "All required fields filled")
    
    click_button "Create Account"
    
    assert_text "Welcome!"
    assert_text "Your account has been created successfully"
    presenter_milestone("Registration Success", "User account created successfully")
  end

  def test_registration_form_has_required_fields
    visit "/users/new"
    
    # Test form elements exist
    assert_selector "label", text: "Email"
    assert_selector "label", text: "Password"
    assert_selector "input[type='email'][required]"
    assert_selector "input[type='password'][required]"
    assert_selector "button[type='submit']", text: "Create Account"
    
    presenter_milestone("Form Validation", "Verified all required form fields exist")
  end
end