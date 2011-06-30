require 'logirel/queries'

module Logirel
  class Querier
    def include_package_for(projects)
      projects.
          map { |p| Logirel::Queries::BoolQ.new("Would you like to include the '#{p}' project, dear Sir?", p) }
    end
  end
end