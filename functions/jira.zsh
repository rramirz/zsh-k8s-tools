function jira_start() {
  local summary="$*"
  if [[ -z "$summary" ]]; then
    echo "Usage: jira_start <summary>"
    return 1
  fi

  local board_id="662"

  # Get the active sprint ID from plain table output, scoped to the board ID
  local sprint_id=$(jira sprint list --board "$board_id" --table --plain | awk '/active$/ {print $1}')
  if [[ -z "$sprint_id" ]]; then
    echo "❌ No active sprint found on board $board_id"
    return 1
  fi

  # Create the Jira issue
  local issue_output=$(jira issue create -t Task -s "$summary" -a "$(jira me)" --no-input)
  local issue_key=$(echo "$issue_output" | grep -oE '[A-Z]+-[0-9]+')
  if [[ -z "$issue_key" ]]; then
    echo "❌ Failed to create Jira issue"
    return 1
  fi

  echo "✅ Created Jira issue: $issue_key"

  # Add issue to sprint
  jira sprint add "$sprint_id" "$issue_key"
  echo "🌀 Added $issue_key to sprint ID $sprint_id"

  # Create and switch to Git branch
  local branch="${issue_key}"
  git checkout -b "$branch"
  echo "🌿 Switched to branch: $branch"
}
