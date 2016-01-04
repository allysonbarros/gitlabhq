require 'spec_helper'

<<<<<<< HEAD
describe Gitlab::SQL::Union do
=======
describe Gitlab::SQL::Union, lib: true do
>>>>>>> 01824a0fac17331c7eacf40feb6882c508fe4880
  describe '#to_sql' do
    it 'returns a String joining relations together using a UNION' do
      rel1  = User.where(email: 'alice@example.com')
      rel2  = User.where(email: 'bob@example.com')
      union = described_class.new([rel1, rel2])

      sql1 = rel1.reorder(nil).to_sql
      sql2 = rel2.reorder(nil).to_sql

      expect(union.to_sql).to eq("#{sql1}\nUNION\n#{sql2}")
    end
  end
end
