class Spinach::Features::TestFeature < Spinach::FeatureSteps
  step 'I am on the front page' do
    get '/'
  end

  step 'I should see a salutation' do
    p 'hehe'
  end

  step 'I click on the first link' do
    p 'hihi'
  end

  step 'I should see goodbye' do
    expect(parsed_body).to eql(hello: 'world')
  end
end
