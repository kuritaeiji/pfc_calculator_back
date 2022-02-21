path = Rails.root.join('db', 'seeds', "#{Rails.env}.rb")
require(path)
