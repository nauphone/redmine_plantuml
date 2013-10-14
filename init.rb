#encoding: utf-8

require 'redmine'
require 'digest/sha2'

::Rails.logger.info 'Starting plantuml plugin for Redmine'

Redmine::Plugin.register :redmine_plantuml do
  name 'Plantuml Plugin'
  author 'Alexei Margasov'
  version '0.0.1'

  module WikiMacros
    Redmine::WikiFormatting::Macros.register do
      desc "Plantuml Macro"
      macro :plantuml do |obj, args, text|
        if !text
          return "{{plantuml}}"
        end
        ::Rails.logger.debug 'MACROS PLANTUML'
        ::Rails.logger.debug "MACOS TEXT: #{text}"
        ::Rails.logger.debug 'MACROS PLANTUML'

        name = Digest::SHA256.hexdigest(text)

        dir_name = Rails.root.join('tmp', 'plantuml')
        if !Dir::exist?(dir_name)
          Dir::mkdir(dir_name)
        end

        uml_text = "@startuml\n#{text}\n\@enduml"
        ::Rails.logger.debug "MACOS TEXT: #{uml_text}"
        file_name_txt = name + '.txt'
        file_name_png = name + '.png'
        if !File.exist?(Rails.root.join(dir_name, file_name_txt))
          File.open(Rails.root.join(dir_name, file_name_txt), "w"){ |f| f.write uml_text}
        end

        if !File.exist?(Rails.root.join(dir_name, file_name_png))
          cmd = "/usr/bin/sudo /usr/bin/java -Djava.awt.headless=true -Dfile.encoding=UTF-8 -jar '/usr/share/plantuml/lib/plantuml.jar' -charset UTF-8 #{Rails.root.join(dir_name, file_name_txt)}"
          IO.popen(cmd, "w+")
        end

        url = "/redmine/plantuml/#{file_name_png}"
        content_tag( :img, "", :src=>url)

      end
    end
  end
end
