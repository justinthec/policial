module Policial
  # Public: Load and parse config files from GitHub repo.
  class RepoConfig
    def initialize(commit)
      @commit = commit
    end

    def enabled_for?(style_guide)
      Policial.enabled_style_guides.include?(style_guide.class)
    end

    def for(style_guide)
      config_file = style_guide.class::CONFIG_FILE

      if config_file
        load_file(config_file)
      else
        {}
      end
    end

    private

    def load_file(file)
      config_file_content = @commit.file_content(file[:path])

      if config_file_content.present?
        send("parse_#{file[:type]}", config_file_content)
      else
        {}
      end
    end

    def parse_yaml(content)
      YAML.load(content)
    rescue Psych::SyntaxError
      {}
    end
  end
end
