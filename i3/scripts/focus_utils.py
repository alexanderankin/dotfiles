import i3

def get_current_window_details():
  num = i3.filter(i3.get_workspaces(), focused=True)[0]['num']

  ws_nodes = i3.filter(num=num)[0]['nodes'] + \
    i3.filter(num=num)[0]['floating_nodes']

  curr = i3.filter(ws_nodes, focused=True)[0]
  return {
    'current_window': curr,
    'nodes': ws_nodes,
  }

def focus_nth_next_window(n_value):
  """focus nth next window

  @param n_value - how many windows to move over

  cycles through windows and selects one by adding the specified number

  from https://faq.i3wm.org/question/389/focus-next-window/
  """
  details = get_current_window_details()
  ws_nodes = details['nodes']
  curr = details['current_window']

  ids = [win['id'] for win in i3.filter(ws_nodes, nodes=[])]

  next_idx = (ids.index(curr['id']) + n_value) % len(ids)
  next_id = ids[next_idx]

  i3.focus(con_id=next_id)

def focus_next():
  focus_nth_next_window(1)

def focus_prev():
  focus_nth_next_window(-1)

def move_window_to_nth_next_workspace(n_value):
  workspace_current = i3.filter(i3.get_workspaces(), focused=True)[0]['num']
  workspace_next = workspace_current + n_value
  if (workspace_next < 1): return

  workspace_next_str = str(workspace_next)

  i3.move('workspace', workspace_next_str)
  i3.workspace('number', workspace_next_str)