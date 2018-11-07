CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV["AWS_KEY"],                        # required unless using use_iam_profile
    aws_secret_access_key: ENV["AWS_SKEY"],                        # required unless using use_iam_profile
    # use_iam_profile:       true,                         # optional, defaults to false
    region:                'ca-central-1',                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = ENV["AWS_BUCKET"]                                      # required

end
