namespace :db do

  task push: :environment do
    require 'pty'
    file = Tempfile.new(['birdseed_dev', '.dump'])
    `pg_dump -Fc --no-acl --no-owner birdseed_dev > #{file.path}`
    s3 = AWS::S3.new
    bucket = s3.buckets['birdseed']
    object = bucket.objects['birdseed_dev.dump']
    object.write(file: file.path)
    url = object.url_for(:read)
    # Use PTY and not `` or system because it throws a
    # Bundler::RubyVersionMismatch error
    PTY.spawn "heroku pg:backups restore '#{url}' HEROKU_POSTGRESQL_ONYX_URL --confirm"
    object.delete
  end

end
