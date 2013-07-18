clustername("#{@attribute[:environment][:name] =~ /production/i ? 'production' : 'stage'}")
environment_name(@attribute[:environment][:name])