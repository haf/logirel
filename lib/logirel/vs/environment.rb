module Logirel
  module VS
    class Environment
      attr_reader :owner
      attr_reader :organization
    
      def initialize
        @owner = registry_get 'SOFTWARE\Microsoft\Windows NT\CurrentVersion', 'RegisteredOwner' || 'OWNER'
        @organization = registry_get 'SOFTWARE\Microsoft\Windows NT\CurrentVersion', 'RegisteredOrganization' || 'ORGANIZATION'
      end
    
      private
      def registry_get(path, key)
	begin
	  require 'win32/registry'
          Win32::Registry::HKEY_LOCAL_MACHINE.open(path) do |reg|
            reg_typ, reg_val = reg.read(key)
            reg_val
	  end
	rescue LoadError
	  h = Hash.new "Not Available"
	  h['RegisteredOwner'] = `$OWNER`
	  h[key]	
        end
      end
    end
  end
end

