require "asana-cli/version"
require 'colorize'
require 'asana'

module Asana
  class CLIError < StandardError; end
  module CLI
    class << self
      def close(task_id)
        task = Asana::Task.find(task_id)
        task.create_story :text => opts[:message] if opts[:message]
        task.modify(:completed => true)
        puts "Task %s closed!".light_green % task_id
      end

      def comment(task_id, message)
        task = Asana::Task.find(task_id)
        task.create_story :text => message
      end

      def project_tasks(project_id, workspace_id = nil)
        projects = resolve workspace_id, project_id, nil
        raise CLIError.new "Unable to find a project named #{project_id}" if projects.empty?

        projects.each do |project|
          puts "\n"
          puts "%s\t Tasks" % project.name.light_green
          puts ("-" * 60).light_white
          project.tasks.each do |task|
            puts "%s\t%s" % [task.id.to_s.light_yellow, task.name.light_white]
          end
          puts "\n"
        end
      end

      def workspace_tasks(workspace_id)
        workspaces = resolve workspace_id, nil, nil

        raise CLIError.new "Unable to find a workspace named #{workspace_id}" if workspaces.empty?
        workspaces.each do |workspace|
          puts "\n"
          puts "%s\tProjects" % workspace.name.light_green
          puts ("-" * 60).light_white
          workspace.projects.each do |project|
            puts "%s\t%s" % [project.id.to_s.light_yellow, project.name.light_white]
          end
          puts "\n"
        end
      end

      def list_workspaces
        puts "\n"
        puts "Workspaces".light_green
        puts ("-" * 60).light_white
        Asana::Workspace.all.each do |workspace|
          puts "%s\t%s" % [workspace.id.to_s.light_yellow, workspace.name.light_white]
        end
      end

      def show_task(task_id, project_id = nil, workspace_id = nil)
        tasks = resolve workspace_id, project_id, task_id
        tasks.each do |task|
          puts task.name.light_green
          puts "-" * 60
          task.attributes.each do |key, val|
            vals = val
            if val.is_a? Array
              vals = val.map {|v| v.respond_to?(:name) ? v.name : v.inspect }
            elsif val.is_a? Asana::Workspace or val.is_a? Asana::Task::Assignee
              vals = val.name
            end

            vals = vals.join(", ") if vals.is_a? Array
            puts "%20s\t%s" % [key, vals.to_s.light_white]
          end
          puts "\n"
        end
      end

      def resolve(w, p, t)
        w_id = w.to_i if w and w.match(/^\d+$/)
        p_id = p.to_i if p and p.match(/^\d+$/)
        t_id = t.to_i if t and t.match(/^\d+$/)

        if t
          if t_id
            return [Asana::Task.find(t_id)]
          elsif p_id
            Asana::Project.find(p_id).tasks.select {|_t| _t.name.downcase[t.downcase] }
          else
            if w_id
              projects = Asana::Workspace.find(w_id).projects
            else
              projects = Asana::Workspace.all.flat_map &:projects
            end
            projects = projects.select {|_p| _p.name.downcase[p.downcase] } if p
            return projects.flat_map do |project|
              puts project.name
              project.tasks.select {|_t| _t.name.downcase[t.downcase] }
            end
          end
        elsif p
          if p_id
            return [Asana::Project.find(p_id)]
          else
            if w_id
              projects = Asana::Workspace.find(w_id).projects
            else
              projects = Asana::Workspace.all.flat_map &:projects
            end
            return projects.select {|_p| _p.name.downcase[p.downcase] }
          end
        elsif w
          if w_id
            return [Asana::Workspace.find(w_id)]
          else
            Asana::Workspace.all.select {|_w| _w.name.downcase[w.downcase] }
          end
        end
      end
    end
  end
end
