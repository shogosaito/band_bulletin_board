module SpecTestHelper
  def sign_in(user)
    post login_path, params: { session: {
      email: user.email,
      password: user.password,
    } }
  end
end
