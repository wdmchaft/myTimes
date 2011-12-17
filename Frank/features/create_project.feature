Feature: 
  As an user I want to create a new project with a task.

Scenario:
	Start the app.
Given I launch the app

Scenario: 
	Create and save a new project.
When I touch "add icon 19x19"
Then I wait to see a navigation bar titled "Project"
When I type "Sample project" into the "<Name>" text field
And I touch "Save"
Then I wait to see a navigation bar titled "Projects"
Then I should see 1 rows
Then I should see "Sample project"

Scenario:
	Dig into project.
When I touch "Sample project"
Then I wait to see a navigation bar titled "Sample project"

Scenario:
	Create a subproject.
When I touch "add icon 19x19"
Then I wait to see a navigation bar titled "Task"
When I type "Sub project" into the "<Name>" text field
And I touch "Save"
Then I wait to see a navigation bar titled "Projects"
Then I should see 1 rows
Then I should see "Sub project"

Scenario:
	Add a description for the task and save the task.
When I touch the button marked "More info"
Then I wait to see "Empty list"
When I touch "Beschreibung"
When I insert "Beschreibung" into the "textInput" text field
And I touch "Save"


Scenario:
	Go back to task view.
When I touch "Back"
When I touch "Sample project"
Then I wait to see a navigation bar titled "Sample project"


Scenario:
	Go back to projects view.
When I touch "Projects"
Then I wait to see a navigation bar titled "Projects"

Scenario:
	Delete the created project item.
When I delete the table view cell marked "Sample project"
Then I should see 0 rows
