module Rake

  # Same as a regular task, but is only needed if one if its prerequisite tasks
  # is needed, and takes on the earliest timestamp of its prerequisite tasks.
  #
  class PseudoTask < Task
    def needed?
      prerequisite_tasks.any?(&:needed?)
    end

    def timestamp
      prerequisite_tasks.map(&:timestamp).min
    end
  end

end

def pseudotask(*args, &block)
  Rake::PseudoTask.define_task(*args, &block)
end
