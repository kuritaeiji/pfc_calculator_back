module AuthToken
  class << self
    # tokenを返す
    def create_token(sub:, lifetime: default_lifetime)
      payload = { sub: sub, exp: lifetime.from_now.to_i }
      JWT.encode(payload, secret_key, algolithm)
    end

    # subとexpのhashを返す
    def decode(token:)
      payload = JWT.decode(token, secret_key, true, { algorithm: algolithm })[0]
      { sub: payload['sub'], exp: payload['exp'] }
    end

    # lifetimeを文字列に変換し、返す
    def lifetime_string(lifetime: default_lifetime)
      num, unit = lifetime.inspect.split(' ')
      unit.sub!(/s$/, '')
      "#{num}#{I18n.t("datetime.prompts.#{unit}")}間"
    end

    def default_lifetime
      1.year
    end

    private

    def secret_key
      Rails.application.credentials.secret_key_base
    end

    def algolithm
      'HS256'
    end
  end
end
