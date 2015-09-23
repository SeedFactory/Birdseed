namespace :paperclip do

  task push: :environment do

    def upload model, method
      styles = model.attachment_definitions[method][:styles].keys + [:original]
      options = { progress: "#{model} #{method}", in_threads: 8 }
      Parallel.each(model.all, options) do |image|
        if (attachment = image.send(method)).present?
          styles.each do |style|
            remote_path = attachment.url(style)
            local_path = attachment.path(style)
            @bucket.objects[remote_path].write(file: local_path, acl: :public_read)
          end
        end
      end
    end

    @bucket = AWS::S3.new.buckets['birdseed']
    unless ENV['skip_attachment']
      @bucket.objects.with_prefix('spree/images').delete_all
      upload Spree::Image, :attachment
    end
    unless ENV['skip_icon']
      @bucket.objects.with_prefix('spree/taxons').delete_all
      upload Spree::Taxon, :icon
    end

  end

end
