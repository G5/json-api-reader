module FixturesHelper
  def fixture(fixture_path)
    open(File.join('spec', 'fixtures', fixture_path)).read
  end
end