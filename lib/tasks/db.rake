namespace :db do

  connection_options = '-p 5432 -h aa1b7ifvna6kjoa.caz3zkhmkymo.us-west-1.rds.amazonaws.com -U birdseed ebdb'
  dump_options = '-c --no-acl --no-owner'

  task push: :environment do
    `pg_dump #{dump_options} birdseed_dev | psql #{connection_options}`
  end

  task pull: :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    `pg_dump #{dump_options} #{connection_options} | psql birdseed_dev`
  end

end
