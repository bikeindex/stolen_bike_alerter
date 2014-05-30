require 'spec_helper'

describe Tweet do
    describe :validations do
    it { should validate_presence_of :twitter_account_id }
  end

  
end
