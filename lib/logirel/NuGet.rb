module Logirel
  class NuGet
    def remote_ver
	  ver = Version.new
	  ver.parse_numeric(`gem query -r -n nuget`)
	end
  end
end