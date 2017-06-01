describe 'Disk' do

  def get_api_value(api, ohai, device, key)
    return nil if !(api && api[device] && api[device][key])
    return api[device][key] if !(api[device]['unstable_device_name'] && ohai[device] && ohai[device]['by_id'])
    return unstable_device_value(api, key, ohai[device])
  end

  # If devices names are unstable : reorder devices taken from the ref-api
  def unstable_device_value(api, key, v)
    api = api.values.select { |x| x['by_id'] == v['by_id'] }.first
    return api[key]
  end

  def get_ohai_value(_api, ohai, device, key)
    return nil if !(ohai && ohai[device] && ohai[device][key])
    return Utils.string_to_object(ohai[device][key].to_s)
  end

  api = nil
  tmpapi = RSpec.configuration.node.api_description['storage_devices']
  if tmpapi != nil
    api = {}
    tmpapi.each do |d|
      api[d['device']] = d
    end
  end

  #puts "DISK SPEC, OHAI DATA = #{RSpec.configuration.node.ohai_description.inspect}"

  ohai = RSpec.configuration.node.ohai_description["block_device"].select { |key, value| key =~ /[sh]d.*/ && value['model'] != 'vmDisk' }

  # If g5k-checks is called with "-m api" option, then api = nil
  # and we use ohai as a reference. Else we use api as a reference.
  reference = api.nil? ? ohai : api

  reference.each do |k, _v|
    # Need to check the API value here, in order to generate the key 'device'
    # in the yaml and json output files
    it 'should have the correct name' do
      name_api = api[k] if api
      expect(name_api).to_not eql(nil), "#{k}, not_exist, storage_devices, #{k}, device"
    end

    it 'should have the correct device id' do
      by_id_api = get_api_value(api, ohai, k, 'by_id')
      by_id_ohai = get_ohai_value(api, ohai, k, 'by_id')
      expect(by_id_api).to eql(by_id_ohai), "#{by_id_ohai}, #{by_id_api}, storage_devices, #{k}, by_id"
    end

    it 'should have the correct device path' do
      by_path_api = get_api_value(api, ohai, k, 'by_path')
      by_path_ohai = get_ohai_value(api, ohai, k, 'by_path')
      expect(by_path_api).to eql(by_path_ohai), "#{by_path_ohai}, #{by_path_api}, storage_devices, #{k}, by_path"
    end

    it 'should have the correct size' do
      size_api = get_api_value(api, ohai, k, 'size')
      size_ohai = 0
      size = get_ohai_value(api, ohai, k, 'size')
      size_ohai = size.to_i * 512 if !size.nil?
      expect(size_api).to eql(size_ohai), "#{size_ohai}, #{size_api}, storage_devices, #{k}, size"
    end

    it 'should have the correct model' do
      model_api = get_api_value(api, ohai, k, 'model')
      model_ohai = get_ohai_value(api, ohai, k, 'model')
      expect(model_api).to eql(model_ohai), "#{model_ohai}, #{model_api}, storage_devices, #{k}, model"
    end

    it 'should have the correct revision' do
      version_api = get_api_value(api, ohai, k, 'rev')
      # See github issue #6: api gets the 'rev' info from /sys/block/sda/device/rev and the data is actually truncated on some clusters. Use rev_from_hdparm instead when available
      version_ohai = get_ohai_value(api, ohai, k, 'rev')
      rev_from_hdparm = get_ohai_value(api, ohai, k, 'rev_from_hdparm')
      version_ohai = rev_from_hdparm if !rev_from_hdparm.nil?
      expect(version_api).to eql(version_ohai), "#{version_ohai}, #{version_api}, storage_devices, #{k}, rev"
    end

    it 'should have the correct vendor' do
      vendor_api = get_api_value(api, ohai, k, 'vendor')
      vendor_ohai = get_ohai_value(api, ohai, k, 'vendor')
      vendor_from_lshw = get_ohai_value(api, ohai, k, 'vendor_from_lshw')
      vendor_ohai = vendor_from_lshw  if !vendor_from_lshw.nil?
      expect(vendor_api).to eql(vendor_ohai), "#{vendor_ohai}, #{vendor_api}, storage_devices, #{k}, vendor"
    end
  end
end
