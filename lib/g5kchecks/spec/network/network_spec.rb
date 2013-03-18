describe "Network" do

  before(:all) do
    @api = RSpec.configuration.node.api_description["network_adapters"]
  end

  RSpec.configuration.node.ohai_description[:network][:interfaces].to_hash.select { |d,i| %w{ eth br ib myri }.include?(i[:type]) }.each_with_index do |dev,i|

    it "should be the correct interface name" do
      name_api = ""
      name_api = @api[i]['interface'] if @api
      name_ohai = Utils.interface_name(dev[1][:type])
      name_ohai.should eql(name_api), "#{name_ohai}, #{name_api}, network_interfaces, #{dev[0]}, interface"
    end

    it "should have the correct IPv4" do
      ip_api = ""
      ip_api = @api[i]['ip'] if @api
      ip_ohai = dev[1][:ip]
      ip_ohai.should eql(ip_api), "#{ip_ohai}, #{ip_api}, network_interfaces, #{dev[0]}, ip"
    end

    it "should have the correct IPv6" do
      ip_api = ""
      ip_api = @api[i]['ip6'] if @api
      ip_ohai = dev[1][:ip6]
      ip_ohai.should eql(ip_api), "#{ip_ohai}, #{ip_api}, network_interfaces, #{dev[0]}, ip6"
    end

    it "should have the correct Driver" do
      driver_api = ""
      driver_api = @api[i]['driver'] if @api
      driver_ohai = dev[1][:driver]
      driver_ohai.should eql(driver_api), "#{driver_ohai}, #{driver_api}, network_interfaces, #{dev[0]}, driver"
    end

    if dev[0] =~ /ib/
      it "should have the correct guid" do
      mac_api = ""
      mac_api = @api[i]['guid'] if @api
      mac_ohai = dev[1][:mac]
      mac_ohai.should eql(mac_api), "#{mac_ohai}, #{mac_api}, network_interfaces, #{dev[0]}, guid"
    end
    else
      it "should have the correct Mac Address" do
        mac_api = ""
        mac_api = @api[i]['mac'] if @api
        mac_ohai = dev[1][:mac]
        mac_ohai.should eql(mac_api), "#{mac_ohai}, #{mac_api}, network_interfaces, #{dev[0]}, mac"
      end
    end

    it "should have the correct Rate" do
      rate_api = ""
      rate_api = @api[i]['rate'] if @api
      if dev[1][:rate] == ""
      rate_ohai = dev[1][:rate]
      else
        rate_ohai = dev[1][:rate].to_i
      end
      rate_ohai.should eql(rate_api), "#{rate_ohai}, #{rate_api}, network_interfaces, #{dev[0]}, rate"
    end

    it "should have the correct version" do
      ver_api = ""
      ver_api = @api[i]['version'] if @api
      ver_ohai = dev[1][:version]
      ver_ohai.should eql(ver_api), "#{ver_ohai}, #{ver_api}, network_interfaces, #{dev[0]}, version"
    end

    it "should have the correct vendor" do
      ven_api = ""
      ven_api = @api[i]['vendor'] if @api
      ven_ohai = dev[1][:vendor]
      ven_ohai.should eql(ven_api), "#{ven_ohai}, #{ven_api}, network_interfaces, #{dev[0]}, vendor"
    end

    it "should have the correct enabled mode" do
      ven_api = nil
      ven_api = @api[i]['enabled'] if @api
      ven_ohai = dev[1][:enabled]
      ven_ohai.should eql(ven_api), "#{ven_ohai}, #{ven_api}, network_interfaces, #{dev[0]}, enabled"
    end

    it "should have the correct mountable mode" do
      ven_api = nil
      ven_api = @api[i]['mountable'] if @api
      ven_ohai = dev[1][:mountable]
      ven_ohai.should eql(ven_api), "#{ven_ohai}, #{ven_api}, network_interfaces, #{dev[0]}, mountable"
    end

    it "should have the correct mounted mode" do
      ven_api = nil
      ven_api = @api[i]['mounted'] if @api
      ven_ohai = dev[1][:mounted]
      ven_ohai.should eql(ven_api), "#{ven_ohai}, #{ven_api}, network_interfaces, #{dev[0]}, mounted"
    end

    it "should not be a management card" do
      mgt_api = nil
      mgt_api = @api[i]['management'] if @api
      mgt_ohai = dev[1][:management]
      mgt_ohai.should eql(mgt_api), "#{mgt_ohai}, #{mgt_api}, network_interfaces, #{dev[0]}, management"
    end

  end

end
