# Class used to hold bookmarking logic
require 'mongoid'

class Note
  include Mongoid::Document
  store_in :notes
  field :content, :type => String
end
