# frozen_string_literal: true

class Auth0Client
  Error = Struct.new(:body, :status)
  Response = Struct.new(:decoded_token, :error)
  Token = Struct.new(:token) do
    def validate_permissions(permissions)
      required_permissions = Set.new permissions
      # JWT.decode returns an array like [payload, header]
      token_permissions = Set.new token[0]['permissions']
      # Returns true if required_permissions is a subset of token_permissions
      required_permissions <= token_permissions
    end
  end

  SIGNING_KEY_UNAVAILABLE = [{
    error: 'signing_key_unavailable',
    error_description: '',
    message: 'Unable to verify credentials'
  }, :internal_server_error].freeze

  def initialize(config)
    @config = config
  end

  def validate_token(token)
    domain_url = "https://#{@config.domain}/"
    jwks_uri = URI("#{domain_url}.well-known/jwks.json")
    jwks_response = Net::HTTP.get_response jwks_uri

    unless jwks_response.is_a? Net::HTTPSuccess
      return Response.new(
        nil,
        Error.new(SIGNING_KEY_UNAVAILABLE, :internal_server_error)
      )
    end

    jwks_hash = JSON.parse(jwks_response.body, { symbolize_names: true })

    decoded_token = JWT.decode(token, nil, true, {
                                 algorithm: 'RS256',
                                 iss: domain_url,
                                 verify_iss: true,
                                 aud: @config.audience,
                                 verify_aud: true,
                                 jwks: { keys: jwks_hash[:keys] }
                               })
    Response.new(Token.new(decoded_token), nil)
  rescue JWT::VerificationError, JWT::DecodeError => e
    Response.new(
      nil,
      Error.new({ error: 'invalid_token', error_description: e.message, message: 'Bad credentials' }, :unauthorized)
    )
  end

  private

  attr_reader :config
end
