describe "Bios" do

  before(:all) do
    @api = RSpec.configuration.node.api_description["bios"]
    @system = RSpec.configuration.node.ohai_description.dmi["bios"]
  end

  it "should have the correct vendor" do
    vendor_api = ""
    vendor_api = @api['vendor'] if @api
    vendor_ohai = @system['vendor']
    vendor_ohai.should eql(vendor_api), "#{vendor_ohai}, #{vendor_api}, bios, vendor"
  end

  it "should have the correct version" do
    version_api = ""
    version_api = @api['version'] if @api
    version_ohai = @system['version'].gsub(/'/,'').strip
    version_ohai = version_ohai.to_f if version_ohai.to_f != 0.0
    version_api = version_api.to_f if version_api.to_f != 0.0
    version_ohai.should eql(version_api), "#{version_ohai}, #{version_api}, bios, version"
  end

  it "should have the correct release date" do
    release_api = ""
    release_api = @api['release_date'] if @api
    release_ohai = @system['release_date']
    release_ohai.should eql(release_api), "#{release_ohai}, #{release_api}, bios, release_date"
  end

  [:bios_ht_enabled, :bios_turboboost_enabled, :bios_c1e, :bios_cstates].each { |key|
    
    it "should have the correct value for #{key}" do
      key_ohai = @system[:cpu][key]
      
      key_api = nil
      key_api = @api[key.to_s] if @api
      
      key_ohai.should eq(key_api), "#{key_ohai}, #{key_api}, bios, #{key}"
    end
    
  }

end
