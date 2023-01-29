import i3
from focus_utils import get_current_window_details

def terminal_floating():
  details = get_current_window_details()
  curr = details['current_window']

  # print(str(curr))
  # todo not just current but first open a terminal, then make it float

  currently_floating = curr['floating'] != 'user_off'
  new_floating = 'disable' if currently_floating else 'enable'

  # print(curr['floating'])
  # print(new_floating)
  i3.floating(new_floating, con_id=str(curr['id']))

if __name__ == '__main__':
  terminal_floating()
