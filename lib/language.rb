# encoding: UTF-8

class Language
  def conjugate(verb, tense)
    if is_verb? verb 
      @cheers
    else false end
  end

  def subjectify(conjugated_verb, subject)
    "#{is_subject? subject or @default_subject} #{conjugated_verb}"
  end

  private

  def is_verb? verb
    @verbs.include? verb
  end

  def is_subject? subject
    @subjects.each {|s| return subject if [s.upcase, s.downcase, s].include? subject }
    return false
  end
end
