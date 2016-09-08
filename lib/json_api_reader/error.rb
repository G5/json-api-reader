module JsonApiReader
  class Error < StandardError
  end

  class RecordNotFoundError < Error
  end

  class NotAuthorizedError < Error

  end
end