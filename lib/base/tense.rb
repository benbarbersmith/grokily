# encoding: UTF-8

class Tense

  private

  def self.to_sym
    @keys[0].to_sym
  end
  
  public

  def self.register language
    @keys.each {|key| language.register_tense(key, self) }
  end

  def self.to_hash
    { @keys[0] => @keys }
  end

  def self.to_s
    @keys.join(", ")
  end
end
