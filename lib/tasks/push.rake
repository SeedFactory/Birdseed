namespace :push do

  task all: [:db, :paperclip]

  task db: :environment do
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

  task paperclip: :environment do

    def upload model, method
      styles = model.attachment_definitions[method][:styles].keys + [:original]
      options = { progress: "#{model} #{method}", in_threads: 8 }
      Parallel.each(model.all, options) do |image|
        if (attachment = image.send(method)).present?
          styles.each do |style|
            remote_path = attachment.url(style, timestamp: false)[1..-1]
            local_path = attachment.path(style)
            @bucket.objects[remote_path].write(file: local_path, acl: :public_read)
          end
        end
      end
    end

    @bucket = AWS::S3.new.buckets['birdseed']
    @bucket.objects.with_prefix('spree').delete_all
    Paperclip::AttachmentRegistry.each_definition do |klass, name|
      upload klass, name
    end

  end

end
