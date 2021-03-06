require 'spec_helper'

describe Category do
  context "Model basics" do
    it "has a valid factory" do
      FactoryGirl.build(:category).should be_valid
    end
    it "is invalid without a race" do
      FactoryGirl.build(:category, race_id:nil).should_not be_valid
    end
    it "is invalid without a title" do
      FactoryGirl.build(:category, title:nil).should_not be_valid
    end
    it "provides a scope for current race" do
      race=FactoryGirl.create(:race)
      category=FactoryGirl.create(:category,race:race)
      race.categories.should be == Category.for_race(race)
    end
  end
  context "Complex Interactions" do
    before(:each) do
      #ActiveRecord::Base.observers.enable :all
      #DatabaseCleaner.clean
      @race=FactoryGirl.create(:race)
      @muzi=FactoryGirl.create(:category,title:"Muzi",race:@race)
      FactoryGirl.create(:constraint,category:@muzi,restrict:"gender",string_value:"male")
      @zeny=FactoryGirl.create(:category,title:"Zeny",race:@race)
      FactoryGirl.create(:constraint,category:@zeny,restrict:"gender",string_value:"female")
      @zeny.constraints.reload
      @seniori=FactoryGirl.create(:category,title:"Seniori",race:@race)
      FactoryGirl.create(:constraint,category:@seniori,restrict:"gender",string_value:"male")
      FactoryGirl.create(:constraint,category:@seniori,restrict:"min_age",integer_value:60)
      @seniori.constraints.reload
      @juniori=FactoryGirl.create(:category,title:"Juniori",race:@race)
      FactoryGirl.create(:constraint,category:@juniori,restrict:"max_age",integer_value:20)
      FactoryGirl.create(:constraint,category:@juniori,restrict:"gender",string_value:"male")
      @juniori.constraints.reload
    end
    it "calculates own difficulty based on restrictions" do
      @seniori.difficulty.should be < @muzi.difficulty
    end
    it "provides gender specific scope" do
      @race.categories.for_gender("female").count.should eq 1
    end
    it "provides age specific scope" do
      @race.categories.for_gender("male").for_age(70).count.should eq 2
      @race.categories.for_gender("male").for_age(30).count.should eq 1
      @race.categories.for_gender("male").for_age(15).count.should eq 2
    end
    it "provides a short description of its restrictions" do
      @seniori.restriction.should be == "M60+"
      @zeny.restriction.should be == "F"
      @juniori.restriction.should be == "M20-"
    end

    it "provides a list of DNF participants" do
      a=FactoryGirl.create(:participant,category:@juniori, starting_no:123)
      b=FactoryGirl.create(:participant,category:@juniori, starting_no:456)
      FactoryGirl.create(:result,participant:a)
      @juniori.dnfs.should include b
      @juniori.dnfs.should_not include a
    end
  end
end
