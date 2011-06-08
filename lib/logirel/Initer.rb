module Logirel
  class Initer
    def init
	  cmd ||= []
	  cmd << "gem update"
	  cmd << "bundle install"
	end
  end
end