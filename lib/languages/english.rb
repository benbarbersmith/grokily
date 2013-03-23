# encoding: UTF-8

class English < Language
  def initialize
    @subjects = ["I", "You", "He", "She", "One", "We", "They"]
    @default_subject = @subjects[0]
    @cheers = "say cheers!"
  end
end
