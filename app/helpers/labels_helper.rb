module LabelsHelper
    def issue_label_names
        @project.issues_labels.map(&:name)
    end

    def labels_autocomplete_source
        labels = @project.issues_labels
        labels = labels.map{ |l| { label: l.name, value: l.name } }
        labels.to_json
    end

    def label_css_class(name)
        klass = Gitlab::IssuesLabels

        case name.downcase
        when *klass.warning_labels
            'label-warning'
        when *klass.neutral_labels
            'label-primary'
        when *klass.positive_labels
            'label-success'
        when *klass.important_labels
            'label-danger'
        when *klass.info_labels
            'label-info'
        when *klass.adm_labels
            'label-info'
        when *klass.rh_labels
            'label-warning'
        when *klass.edu_labels
            'label-success'
        else
            'label-default'
        end
    end
end