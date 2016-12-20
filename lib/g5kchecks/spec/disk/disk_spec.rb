describe "Disk" do

  before(:all) do
    tmpapi = RSpec.configuration.node.api_description["storage_devices"]
    if tmpapi != nil
      @api = {}
      tmpapi.each{ |d|
        @api[d["device"]] = d
      }
    end
  end

  RSpec.configuration.node.ohai_description.block_device.select { |key,value| key =~ /[sh]d.*/ and value["model"] != "vmDisk" }.each { |k,v|

    it "should have the correct name" do
      name_api = @api[k] if @api
      name_api.should_not eql(nil), "#{k}, not_exist, storage_devices, #{k}, device"
    end

    it "should have the correct device id" do
      device_by_id_ohai = v['device_by_id']
      device_by_id_api = ''
      device_by_id_api = @api[k]['device_by_id'] if (@api and @api[k] and @api[k]['device_by_id'])
      device_by_id_ohai.should eql(device_by_id_api), "#{device_by_id_ohai}, #{device_by_id_api}, storage_devices, #{k}, device_by_id"
    end

    it "should have the correct device path" do
      device_by_path_ohai = ''
      device_by_path_ohai = v['device_by_path'] if v.key?('device_by_path') && v['device_by_path'] != nil
      device_by_path_api = ''
      device_by_path_api = @api[k]['device_by_path'] if (@api and @api[k] and @api[k]['device_by_path'])
      device_by_path_ohai.should eql(device_by_path_api), "#{device_by_path_ohai}, #{device_by_path_api}, storage_devices, #{k}, device_by_path"
    end

    it "should have the correct size" do
      size_ohai = v["size"].to_i*512
      size_api = 0
      size_api = @api[k]["size"].to_i if (@api and @api[k] and @api[k]["size"])
      size_ohai.should eql(size_api), "#{size_ohai}, #{size_api}, storage_devices, #{k}, size"
    end

    it "should have the correct model" do
      model_ohai = v['model']
      model_api = ""
      model_api = @api[k]['model'] if (@api and @api[k] and @api[k]['model'])
      model_ohai.should eql(model_api), "#{model_ohai}, #{model_api}, storage_devices, #{k}, model"
    end

    it "should have the correct revision" do
      version_ohai = v["rev"]
      # See github issue #6: ohai gets the 'rev' info from /sys/block/sda/device/rev and the data is actually truncated on some clusters. Use rev_from_hdparm instead when available
      version_ohai = v["rev_from_hdparm"] if v.key?("rev_from_hdparm") && v["rev_from_hdparm"] != nil

      version_api = ""
      version_api = @api[k]['rev'] if (@api and @api[k] and @api[k]['rev'])
      version_api = version_api.to_s
      version_ohai = version_ohai.to_s
      version_ohai.should eql(version_api), "#{version_ohai}, #{version_api}, storage_devices, #{k}, rev"
    end

    it "should have the correct vendor" do
      vendor_ohai = v["vendor"]
      vendor_ohai = v["vendor_from_lshw"] if v.key?("vendor_from_lshw") && v["vendor_from_lshw"] != nil

      vendor_api = ""
      vendor_api = @api[k]['vendor'] if (@api and @api[k] and @api[k]['rev'])
      vendor_ohai.should eql(vendor_api), "#{vendor_ohai}, #{vendor_api}, storage_devices, #{k}, vendor"
    end

  }

end
