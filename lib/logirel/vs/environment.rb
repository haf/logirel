require 'win32/registry'

module Logirel::VS
  class Environment
    attr_reader :owner
    attr_reader :organization

    def initialize
      @owner = registry_get 'SOFTWARE\Microsoft\Windows NT\CurrentVersion', 'RegisteredOwner' || 'OWNER'
      @organization = registry_get 'SOFTWARE\Microsoft\Windows NT\CurrentVersion', 'RegisteredOrganization' || 'ORGANIZATION'
    end

    private
    def registry_get(path, key)
      Win32::Registry::HKEY_LOCAL_MACHINE.open(path) do |reg|
        reg_typ, reg_val = reg.read(key)
        reg_val
      end
    end
  end
end

