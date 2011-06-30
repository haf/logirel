module Logirel
  VERSION = "0.0.x"
  begin
    require 'semver'
    class Version < SemVer
      def parse_numeric(str)
        str.scan(/(\d{1,5}).?/).flatten.collect{|x| x.to_i}
      end
    end
  rescue LoadError
    puts 'First time installing, eh? Just run "bundle install"! (unless this is you running it right now!)'
  end

end
