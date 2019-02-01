crumb :root do
  link "Home", root_path
end

crumb :cards do
  link 'Card list', cards_path
end

crumb :card do |card|
  link "Card detail", card_path(card)
  parent :cards
end

crumb :rings do
  link 'Ring list', rings_path
end

crumb :ring do |ring|
  link "Ring detail", ring_path(ring)
  parent :rings
end

crumb :check do
  link 'Check', pages_ring_select_for_check_path
end

crumb :check_logs do
  link 'Check log', check_logs_index_path
end


# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).