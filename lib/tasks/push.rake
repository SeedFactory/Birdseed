namespace :push do

  task all: [:db, :paperclip]

  task db: :environment do
    file = Tempfile.new(['birdseed_dev', '.dump'])
    `pg_dump -c --no-acl --no-owner birdseed_dev > #{file.path}`
    `psql -p 5432 -h aa1b7ifvna6kjoa.caz3zkhmkymo.us-west-1.rds.amazonaws.com -U birdseed ebdb < #{file.path}`
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
    upload Spree::Image, :attachment
    upload Spree::Taxon, :icon
    upload Spree::FeaturedItem, :image

  end

end
