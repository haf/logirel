module Logirel
  require 'semver'
  VERSION = SemVer.find.format "%M.%m.%p"
  
  class Version < SemVer
    def parse_numeric(str)
	  str.scan(/(\d{1,5}).?/).flatten.collect{|x| x.to_i}
	end
  end
end
