module JsonApiReader
  class Error < StandardError
  end

  class RecordNotFoundError < Error
  end

  class UnprocessableEntityError < Error
  end
end