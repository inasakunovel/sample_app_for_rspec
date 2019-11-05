module LoginMacros
  def login(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '000000'
    click_button "Login"
    expect(page).to have_content 'Login successful'
  end

  def logout
    click_link 'Login'
    expect(page).to have_content 'Logged out'
  end
end