RedmineApp::Application.routes.draw do
    get 'plantuml/:name' => 'redmine_plantuml#filter'
end
