require 'spec_helper'

describe Participant do
  it "has a valid factory" do
    FactoryGirl.build(:participant).should be_valid
  end
  it "is invalid without a person" do
    FactoryGirl.build(:participant, person_id:nil).should_not be_valid
  end
  it "is invalid without a team" do
    FactoryGirl.build(:participant, team_id:nil).should_not be_valid
  end
  it "is invalid without a category" do
    FactoryGirl.build(:participant, category_id:nil).should_not be_valid
  end
  it "is invalid without a starting number" do
    FactoryGirl.build(:participant, starting_no:nil).should_not be_valid
  end
  it "is invalid with a duplicate starting number" do
    race=FactoryGirl.create(:race)
    category=FactoryGirl.create(:category, race:race)
    FactoryGirl.create(:participant, category:category, starting_no:123).should be_valid
    FactoryGirl.build(:participant, category:category, starting_no:123).should_not be_valid
  end
  it "provides a race filter" do
    participant=FactoryGirl.create(:participant)
    Participant.for_race(participant.race).first.id.should be == participant.id
  end
  it "provides sort query strings" do
    Participant.sort_by.should be == "starting_no"
    Participant.sort_by("team").should be == "counties.title"
    Participant.sort_by("category").should be == "categories.sort_order"
  end
  it "provides group query strings" do
    Participant.group_by.should be == "categories.sort_order"
    Participant.group_by("team").should be == "counties.title"
    Participant.group_by("category").should be == "categories.sort_order"
  end
  it "provides a filter_by method" do
    team=FactoryGirl.create(:team)
    participant=FactoryGirl.create(:participant,team:team)
    Participant.filter_by("team_#{team.id}").first.id.should be == participant.id
  end
end
