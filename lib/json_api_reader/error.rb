module JsonApiReader
  class Error < StandardError
  end

  class RecordNotFoundError < Error
  end
end