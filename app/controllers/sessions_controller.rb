class SessionsController < ApplicationController
  def new
    # Track login attempts in session
    session[:login_attempts] ||= 0
    @login_attempts = session[:login_attempts]

    # Calculate remaining cooldown time if any
    @cooldown_remaining = calculate_cooldown_time
  end

  def create
    # Check if user is in cooldown period
    cooldown_remaining = calculate_cooldown_time
    if cooldown_remaining > 0
      flash[:alert] = "Too many failed login attempts. Please wait #{cooldown_remaining} seconds before trying again."
      redirect_to login_path and return
    end

    # Check for timestamp to prevent rapid submissions
    if params[:login_timestamp].present?
      timestamp = params[:login_timestamp].to_i
      time_diff = Time.now.to_i - timestamp

      # If form submitted too quickly (less than 1.5 seconds), likely a bot
      if time_diff < 1.5
        increment_login_attempts
        flash[:alert] = "Submission too rapid. Please try again."
        redirect_to login_path and return
      end
    end

    # Attempt to authenticate admin
    admin = Admin.find_by(email: params[:email]&.downcase)

    if admin && admin.authenticate(params[:password])
      # Reset login attempts on success
      session[:login_attempts] = 0
      session[:last_attempt_time] = nil

      # Log successful login attempt
      Rails.logger.info "Successful login for admin: #{admin.email} from IP: #{request.remote_ip}"

      # Set user session and redirect
      session[:admin_id] = admin.id
      redirect_to root_path, notice: "Logged in successfully"
    else
      # Increment failed login attempts
      increment_login_attempts

      # Log failed attempt
      Rails.logger.warn "Failed login attempt for email: #{params[:email]} from IP: #{request.remote_ip}"

      # Show generic error message
      flash[:alert] = "Invalid email or password"

      # Add timeout warning if approaching lockout
      attempts_remaining = 5 - session[:login_attempts]
      if attempts_remaining > 0 && attempts_remaining <= 2
        timeout_seconds = calculate_timeout_duration
        flash[:alert] = "Invalid email or password. After #{attempts_remaining} more #{attempts_remaining == 1 ? 'attempt' : 'attempts'}, you'll need to wait #{timeout_seconds} seconds before trying again."
      end

      # Use redirect instead of render to ensure consistent behavior
      redirect_to login_path
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to login_path, notice: "Logged out successfully"
  end

  private

  def increment_login_attempts
    session[:login_attempts] ||= 0
    session[:login_attempts] += 1
    session[:last_attempt_time] = Time.now.to_i
  end

  def calculate_timeout_duration
    # Exponential backoff: 30 seconds, 2 minutes, 5 minutes, 15 minutes, 30 minutes
    case session[:login_attempts]
    when 0..4
      30
    when 5..6
      120
    when 7..8
      300
    when 9..10
      900
    else
      1800
    end
  end

  def calculate_cooldown_time
    return 0 unless session[:last_attempt_time] && session[:login_attempts] >= 5

    elapsed = Time.now.to_i - session[:last_attempt_time]
    timeout = calculate_timeout_duration

    remaining = timeout - elapsed
    remaining > 0 ? remaining : 0
  end
end
