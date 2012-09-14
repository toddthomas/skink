module Skink
module Client

class Response
  def status_code
    raise NotImplementedError
  end

  def headers
    raise NotImplementedError
  end

  def body
    raise NotImplementedError
  end
end

end
end
