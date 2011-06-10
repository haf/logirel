module Logirel
  begin
    require 'semver'
    VERSION = SemVer.find.format "%M.%m.%p"
	class Version < SemVer
      def parse_numeric(str)
	    str.scan(/(\d{1,5}).?/).flatten.collect{|x| x.to_i}
	  end
    end
  rescue LoadError => e
    puts 'First time installing, eh? Just run "bundle install", unless this is you running it! :) :) :)'
    VERSION = "0.0.0"
  end
end
