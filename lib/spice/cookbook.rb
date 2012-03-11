require 'spice/persistence'

module Spice
  class Cookbook
    include Virtus
    include Aequitas
    include Spice::Persistence
    extend Spice::Persistence

    endpoint "cookbooks"

    # @macro [attach] attribute
    # @attribute [rw]
    # @return [$2] the $1 attribute
    attribute :name, String
    attribute :versions, Array, :default => []

    validates_presence_of :name
    
    def self.get(name)
      connection.cookbook(name)
    end
    
    # Check if the cookbook exists on the Chef server
    def new_record?
      begin
        connection.get("/cookbooks/#{name}")
        return false
      rescue Spice::Error::NotFound
        return true
      end
    end
  end
end