# from focus_utils import move_container_to_nth_next_workspace

# if __name__ == '__main__':
#   move_container_to_nth_next_workspace(1)

import i3

# workspace_current = i3.filter(i3.get_workspaces(), focused=True)[0]['num']
# workspace_next = workspace_current + n_value
# if (workspace_next < 1): return

# workspace_next_str = str(workspace_next)

# i3.move('workspace', workspace_next_str)
# i3.workspace('number', workspace_next_str)

import json

ws = i3.get_workspaces()
print(json.dumps(ws))