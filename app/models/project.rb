module Intrigue
  module Model
    class Project
      include DataMapper::Resource

      property :id,       Serial, :key => true
      property :name,     String

      def self.current_project
        if $project_name == "" # probably a new user, default to first project.
          current_project = Intrigue::Model::Project.first
        else # Grab it by name and if it doesn't exist, create it
          current_project = Intrigue::Model::Project.all(:name => "#{$project_name}").first ||
            Intrigue::Model::Project.create(:name => "#{$project_name}")
        end
      current_project
      end

      def entity_count
        Intrigue::Model::Entity.all(:project_id => @id).count
      end

      def entities
        Intrigue::Model::Entity.all(:project_id => @id)
      end

      def task_results
        Intrigue::Model::TaskResult.all(:project_id => @id)
      end

      def scan_results
        Intrigue::Model::ScanResult.all(:project_id => @id)
      end

    end
  end
end
