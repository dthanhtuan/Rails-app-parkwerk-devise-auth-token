class Rack::Attack
  # Throttle POST requests to /resend-confirmation by IP (5 requests per 10 minutes)
  throttle('resend_confirmation/ip', limit: 5, period: 10.minutes) do |req|
    if req.path == '/resend-confirmation' && req.post?
      req.ip
    end
  end

  self.throttled_response = lambda do |env|
    [ 429, { 'Content-Type' => 'application/json' }, [{ error: 'Too many requests. Please try again later.' }.to_json] ]
  end

end

