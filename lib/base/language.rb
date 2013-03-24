# encoding: UTF-8
require_relative 'tense'

class Language
  public

  def register_tense(key, tense)
    @tenses[key] = tense
  end

  private

  def has_subject? subject
    @subjects.each {|s| return subject if [s.upcase, s.downcase, s].include? subject }
    raise LanguageException, "Unknown subject #{subject}"
  end

  def has_tense? tense
    @tenses.key? tense or raise LanguageException, "Unknown tense #{tense}"
  end

  def has_verb? verb
    @verbs.key? verb or raise LanguageException, "Unknown verb #{verb}"
  end
end

class LanguageException < Exception
end
