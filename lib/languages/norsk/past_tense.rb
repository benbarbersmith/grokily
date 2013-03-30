# encoding: UTF-8

class NorskPastTense < NorskTense
  @keys = "past", "fortid"
  @class1  = /.+[bdfghjklmnprstvwz][bdfhjklmnprstwz]$/
  @class2a = /.+[aeiouyæøå](?:nn|mm|ll)$/
  @class2b = /.+[aeiouyæøå](?:nd|ld)$/
  @class2c = /.+[aeiouyæøå][bdfhjklmnprstwz]$/
  @class2d = /.+lg$/
  @class3  = /.+(?:ei|øy|au|oi|ai|g|v)$/
  @class4  = /.*[bdfghjklmnprstvwz][aeiouyæøå]$/
  @class5  = /^[bdfghjklmnprstvwz][bdfghjklmnprstvwz]$/

  def self.specific_conjugation(verb)
    stem = NorskStemTense.regular_conjugation(verb)
    case stem
       
      # Class 2: Stem ends in long vowel followed by a constonant. Should
      # be suffixed with -te.
      when @class2a then stem[0,stem.size-1] + "te"
      when @class2b then stem + "te"
      when @class2c then stem + "te"
      when @class2d then stem + "te"
      
      # Class 1: Stem ends in a double constonant. Should be suffixed with
      # -et or -a. Run after class 2 as it can steal matches
      # accidently.
      when @class1 then [stem + "et", stem + "a"]

      # Class 3: Stem ends in a dipthong, -g or -v. Should be suffixed
      # with -de.
      when @class3 then stem + "de"

      # Class 4: Stem ends in a stressed vowel. Should be suffixed with
      # -dde.
      when @class4 then stem + "dde" 

      # Class 5: Stem is two constonants. I made this one up. Should be
      # suffixed with -edde as far as I can see.
      when @class5 then stem + "edde"

    end
  end
 end
