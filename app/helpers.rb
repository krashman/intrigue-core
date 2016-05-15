module Intrigue
  module Task
    module Helper

      def task_result_uri(id)
        "/v1/task_results/#{id}"
      end

      def scan_result_uri(id)
        "/v1/scan_results/#{id}"
      end

      def entity_uri(id)
        "/v1/entities/#{id}"
      end

      ###
      ### Helper method for starting a task run
      ###
      def start_task_run(project_id, task_name, entity, options, handlers=[])

        # Create the task result, and associate our entity and options
        task_result = Intrigue::Model::TaskResult.create({
            :name => "#{task_name}",
            :task_name => task_name,
            :options => options,
            :base_entity => entity,
            :logger => Intrigue::Model::Logger.create(:project => Intrigue::Model::Project.get(project_id)),
            :project => Intrigue::Model::Project.get(project_id)
        })

        ###
        # Create the task and start it
        ###
        task = Intrigue::TaskFactory.create_by_name(task_result.task_name)
        task.class.perform_async task_result.id, handlers

      task_result.id
      end

end
end
end
