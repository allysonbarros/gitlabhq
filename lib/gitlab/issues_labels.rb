module Gitlab
    class IssuesLabels
        class << self
            def important_labels
                %w(bug critical confirmed)
            end

            def warning_labels
                %w(documentation support)
            end

            def neutral_labels
                %w(comum)
            end

            def positive_labels
                %w(feature enhancement)
            end

            def info_labels
                %w(discussion suggestion)
            end

            def default_labels
                %w(demanda)
            end

            def adm_labels
                %w(adm)
            end

            def rh_labels
                %w(rh)
            end

            def edu_labels
                %w(edu)
            end

            def feedback_labels
                %w(feedback)
            end

            def generate(project)
                labels = important_labels + warning_labels + neutral_labels + positive_labels + info_labels + default_labels + adm_labels + rh_labels + edu_labels + feedback_labels

                project.issues_default_label_list = labels
                project.save
            end
        end
    end
end