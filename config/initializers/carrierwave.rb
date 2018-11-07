CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     'AKIAI4YPFVDFAVLAKXTA',                        # required unless using use_iam_profile
    aws_secret_access_key: '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',                        # required unless using use_iam_profile
    # use_iam_profile:       true,                         # optional, defaults to false
    region:                'ca-central-1',                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'myrecipes-galati'                                      # required

end
