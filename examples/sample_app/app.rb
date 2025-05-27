# frozen_string_literal: true

# Simple Rack app for testing
class SampleApp
  def call(env)
    request = Rack::Request.new(env)

    case request.path_info
    when '/'
      [200, { 'Content-Type' => 'text/html' }, [homepage]]
    when '/users/new'
      [200, { 'Content-Type' => 'text/html' }, [registration_form]]
    when '/users'
      if request.post?
        [200, { 'Content-Type' => 'text/html' }, [success_page]]
      else
        [404, { 'Content-Type' => 'text/plain' }, ['Not Found']]
      end
    else
      [404, { 'Content-Type' => 'text/plain' }, ['Not Found']]
    end
  end

  private

  def homepage
    <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>Sample App</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 40px; }
          .container { max-width: 600px; margin: 0 auto; }
          a { color: #0066cc; text-decoration: none; }
          a:hover { text-decoration: underline; }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>Welcome to Sample App</h1>
          <p>This is a simple app for testing capybara-demo gem.</p>
          <p><a href="/users/new">Sign Up</a></p>
        </div>
      </body>
      </html>
    HTML
  end

  def registration_form
    <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>Sign Up - Sample App</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
          .container { max-width: 400px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; }
          .form-group { margin-bottom: 20px; }
          label { display: block; margin-bottom: 5px; font-weight: bold; }
          input[type="email"], input[type="password"] { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
          button { background: #28a745; color: white; border: none; padding: 12px 24px; border-radius: 4px; cursor: pointer; width: 100%; font-size: 16px; }
          button:hover { background: #218838; }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>Sign Up</h1>
          <form action="/users" method="post">
            <div class="form-group">
              <label for="email">Email</label>
              <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
              <label for="password">Password</label>
              <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">Create Account</button>
          </form>
        </div>
      </body>
      </html>
    HTML
  end

  def success_page
    <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>Welcome - Sample App</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 40px; }
          .container { max-width: 600px; margin: 0 auto; text-align: center; }
          .success { background: #d4edda; color: #155724; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="success">
            <h1>Welcome!</h1>
            <p>Your account has been created successfully.</p>
          </div>
          <p><a href="/">Back to Home</a></p>
        </div>
      </body>
      </html>
    HTML
  end
end
