import getpass
import math
import socket
from pathlib import Path
from typing import Optional
import logging
import re

from paramiko import SSHConfig

from kitty.boss import Boss
from kitty.fast_data_types import Color, Screen, get_boss, get_options
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb
from kitty.utils import color_as_int
from kitty.window import Window

logger = logging.getLogger(__name__)

##############################################################################
# Config Begin
##############################################################################

# Path to SSH config file (should be standard), needed to lookup host names and retrieve
# corresponding user names
SSH_CONFIG_FILE = "~/.ssh/config"

##############################################################################
# Config End
##############################################################################

# Separators and status icons
LEFT_SEP = ""
RIGHT_SEP = ""
SOFT_SEP = "│"
PADDING = " "
USER_ICON = ""
HOST_ICON = "󱡶"
ACTIVE_TAB_ICON = ""
INACTIVE_TAB_ICON = ""
BELL_ICON = "󰂚"
ELLIPSIS = "..."
ZELLIJ = "󰰶"
VIM = ""

# Colors
SOFT_SEP_COLOR = Color(89, 89, 89)
FILLED_ICON_BG_COLOR = Color(89, 89, 89)
SSH_BG_COLOR = Color(30, 104, 199)
SSH_ICON_BG_COLOR = Color(53, 132, 228)

# Read ssh config
ssh_config = SSHConfig.from_path(str(Path(SSH_CONFIG_FILE).expanduser()))


class Opts:
    def __init__(self, draw_data: DrawData) -> None:
        opts = get_options()
        self.tab_title_max_length = opts.tab_title_max_length
        self.tab_bar_align = opts.tab_bar_align

        # active tab color related
        self.col_active_tab_fill_bg = opts.tab_bar_margin_color
        self.col_active_tab_fill_fg = draw_data.active_bg
        self.col_active_tab_icon = opts.color4  # blue
        self.col_active_tab_fg = draw_data.active_fg
        self.col_active_tab_bg = draw_data.active_bg

        # inactive tab color related
        self.col_inactive_tab_fill_bg = opts.tab_bar_margin_color
        self.col_inactive_tab_fill_fg = draw_data.inactive_bg
        self.col_inactive_tab_icon = draw_data.inactive_fg
        self.col_inactive_tab_fg = draw_data.inactive_fg
        self.col_inactive_tab_bg = draw_data.inactive_bg

        # common color related
        self.col_bell_icon = opts.color1  # red
        self.col_separator = SOFT_SEP_COLOR
        self.col_sep_bg = opts.tab_bar_margin_color

        # right tab color related
        self.col_icon_fg = draw_data.active_fg
        self.col_right_fg = draw_data.active_fg
        self.col_local_right_icon_bg = FILLED_ICON_BG_COLOR
        self.col_local_right_bg = draw_data.active_bg
        self.col_ssh_right_icon_bg = SSH_ICON_BG_COLOR
        self.col_ssh_right_bg = SSH_BG_COLOR


def _draw_text(screen: Screen, fg: Color, bg: Color, text: str):
    if text != "":
        screen.cursor.fg = as_rgb(color_as_int(fg))
        screen.cursor.bg = as_rgb(color_as_int(bg))
        screen.draw(text)


class SSHInfo:
    def __init__(self, user: str, host: str) -> None:
        self.user = user
        self.host = host


def _in_ssh(active_window: Window) -> Optional[SSHInfo]:
    for p in active_window.child.foreground_processes:
        cmd = p["cmdline"]
        # ssh process maybe in xxx-ssh format.
        if re.search(".*ssh$", cmd[0]) == None:
            continue

        maybe_host = ""

        for arg in cmd[1:]:
            # this is a -xxx arg
            if arg.startswith("-"):
                continue

            # this more like a command
            if " " in arg:
                continue

            user_and_host = arg.split("@")
            if len(user_and_host) == 2:
                return SSHInfo(user_and_host[0], user_and_host[1])

            # it maybe just a shortcut defined in ssh config
            host_config = ssh_config.lookup(arg)
            if "user" in host_config:
                return SSHInfo(host_config["user"], arg)

            maybe_host = arg

        logger.error(
            "can not find the user / host, maybe_host: %s, cmd: %s", maybe_host, cmd
        )

        maybe_host = maybe_host + "?"

        return SSHConfig("?", maybe_host)

    return None


class RightTab:
    def __init__(self, icon: str, text: str, is_ssh: bool) -> None:
        self.icon = icon + PADDING
        self.text = PADDING + text
        self.is_ssh = is_ssh

    def draw_length(self) -> int:
        return len(LEFT_SEP) + len(self.icon) + len(self.text) + len(RIGHT_SEP)

    def draw(self, screen: Screen, opts: Opts) -> None:
        # 1. choose color
        left_bg = opts.col_sep_bg
        left_fg = opts.col_local_right_icon_bg
        icon_bg = opts.col_local_right_icon_bg
        fg = opts.col_right_fg
        text_bg = opts.col_local_right_bg
        right_fg = opts.col_local_right_bg
        right_bg = opts.col_sep_bg

        if self.is_ssh:
            left_fg = opts.col_ssh_right_icon_bg
            icon_bg = opts.col_ssh_right_icon_bg
            text_bg = opts.col_ssh_right_bg
            right_fg = opts.col_ssh_right_bg

        _draw_text(screen, left_fg, left_bg, LEFT_SEP)
        _draw_text(screen, fg, icon_bg, self.icon)
        _draw_text(screen, fg, text_bg, self.text)
        _draw_text(screen, right_fg, right_bg, RIGHT_SEP)


class RightTabs:
    def __init__(self, name: RightTab, host: RightTab) -> None:
        self.name = name
        self.host = host

    def draw_length(self) -> int:
        return self.name.draw_length() + len(PADDING) + self.host.draw_length()

    def draw(self, screen: Screen, opts: Opts) -> None:
        self.name.draw(screen, opts)
        _draw_text(screen, opts.col_separator, opts.col_sep_bg, PADDING)
        self.host.draw(screen, opts)


def _right_tab_username(username: str, is_ssh: bool) -> RightTab:
    return RightTab(USER_ICON, username, is_ssh)


def _right_tab_host(host: str, is_ssh: bool) -> RightTab:
    if is_ssh:
        return RightTab(HOST_ICON, host, is_ssh)

    localhost = "localhost"
    if len(host) > len(localhost):
        host = localhost
    return RightTab(HOST_ICON, host, is_ssh)


class SysInfo:
    def __init__(self, active_window: Window) -> None:
        # Local info (and fallback for errors on remote info)
        self.user = getpass.getuser()
        self.host = socket.gethostname()
        # check if in ssh
        self.ssh = _in_ssh(active_window)

    def to_right_tab(self) -> RightTabs:
        if self.ssh != None:
            return RightTabs(
                _right_tab_username(self.ssh.user, True),
                _right_tab_host(self.ssh.host, True),
            )
        return RightTabs(
            _right_tab_username(self.user, False), _right_tab_host(self.host, False)
        )


class BarState:
    def __init__(
        self,
        before: int,
        max_tab_length: int,
    ) -> None:
        self.before = before
        self.max_tab_length = max_tab_length


def _separator(tab: TabBarData, extra_data: ExtraData):
    # if no next tab, no separator is needed.
    if not extra_data.next_tab:
        return ""

    # this tab is not active and next tab is not active, use stroke separator.
    if not tab.is_active and not extra_data.next_tab.is_active:
        return SOFT_SEP + PADDING

    return PADDING


class Tab:
    def __init__(self, index: int, tab: TabBarData, extra_data: ExtraData) -> None:
        self.index = index
        self.title = tab.title
        self.is_active = tab.is_active

        if tab.is_active:
            self.icon = ACTIVE_TAB_ICON + PADDING
            self.left = LEFT_SEP
            self.right = RIGHT_SEP
            # we don't need index for active tab
            self.index_text = ""
        else:
            self.icon = INACTIVE_TAB_ICON + PADDING
            self.index_text = str(index) + PADDING
            self.left = ""
            self.right = ""

        if tab.needs_attention or tab.has_activity_since_last_focus:
            self.bell_icon = BELL_ICON
        else:
            # we don't need bell
            self.bell_icon = ""

        self.separator = _separator(tab, extra_data)
        self.app_aware()

    def app_aware(self) -> None:
        """
        shorten the title and change icon based on app aware title
        - [$username] ...: when ssh to remote and go to fish, TODO: maybe improve this in fish config
        - zellij ($session) ...: when in zellij, only session name is useful
        - v / vi / vim / nvim: in vim
        """

        # use local name works for most case. if remote machine is not using local name, I prefer to keep it.
        user = getpass.getuser()
        user_prefix = "[" + user + "] "
        if self.title.startswith(user_prefix):
            self.title = self.title.removeprefix(user_prefix)
            return

        find_zellij = re.search("^Zellij \((.*)\)", self.title)
        if find_zellij:
            self.icon = ZELLIJ + PADDING
            self.title = find_zellij.group(1)
            return

        vim_re = "^(v|vi|vim|nvim) "
        find_vim = re.search(vim_re, self.title)
        if find_vim:
            self.icon = VIM + PADDING
            self.title = re.sub(vim_re, "", self.title)

    def draw_length(self) -> int:
        return (
            len(self.left)
            + len(self.bell_icon)
            + len(self.icon)
            + len(self.index_text)
            + len(self.title)
            + len(PADDING)
            + len(self.right)
            + len(self.separator)
        )

    def draw(self, screen: Screen, opts: Opts, state: BarState) -> None:
        # the format will be:
        #  [bell: if needed] <icon> [index: if not curr] <shortern title> <space>  <sep>

        # 1. we need to compute the current tab len, if too long, shortern the title:
        #
        # too long: > tab_title_max_length
        # TODO: state.max_tab_length ? dont know how to use

        shortern_title = self.title
        allowance = opts.tab_title_max_length

        l = self.draw_length()
        diff = 0

        if allowance > 0 and l > allowance:
            diff = l - allowance
            # this means we cannot fix this by shortern the title, we can actually do nothng.
            if diff >= len(self.title):
                shortern_title = ELLIPSIS
            else:
                end = len(self.title) - diff - len(ELLIPSIS) + 1
                if end < 0 or end > len(self.title):
                    shortern_title = ELLIPSIS
                else:
                    shortern_title = self.title[:end] + "..."

        if self.title != shortern_title:
            logger.debug(
                "allowance: %d, len: %d, diff: %d, title: %s, shorten: %s",
                allowance,
                l,
                diff,
                self.title,
                shortern_title,
            )

        # 2. grab the color
        fill_bg = opts.col_active_tab_fill_bg
        fill_fg = opts.col_active_tab_fill_fg
        icon = opts.col_active_tab_icon
        fg = opts.col_active_tab_fg
        bg = opts.col_active_tab_bg
        if not self.is_active:
            fill_bg = opts.col_inactive_tab_fill_bg
            fill_fg = opts.col_inactive_tab_fill_fg
            icon = opts.col_inactive_tab_icon
            fg = opts.col_inactive_tab_fg
            bg = opts.col_inactive_tab_bg

        # 3. draw
        _draw_text(screen, fill_fg, fill_bg, self.left)
        _draw_text(screen, opts.col_bell_icon, bg, self.bell_icon)
        _draw_text(screen, icon, bg, self.icon)
        _draw_text(screen, fg, bg, self.index_text)
        _draw_text(screen, fg, bg, shortern_title + " ")
        _draw_text(screen, fill_fg, fill_bg, self.right)
        _draw_text(screen, opts.col_separator, opts.col_sep_bg, self.separator)

        return screen.cursor.x


def _draw_right_tabs(screen: Screen, opts: Opts, before: int) -> int:
    # 1. get sys info to generate right tabs
    boss: Boss = get_boss()
    active_window = boss.active_window
    assert isinstance(active_window, Window)

    sys_info = SysInfo(active_window)
    right_tabs = sys_info.to_right_tab()

    # 2. adjust the cursor for right align
    right_tabs_len = right_tabs.draw_length()
    if opts.tab_bar_align == "center":
        screen.cursor.x = math.ceil(screen.columns / 2 + before / 2) - right_tabs_len
    else:  # opts.tab_bar_align == "left"
        screen.cursor.x = screen.columns - right_tabs_len

    right_tabs.draw(screen, opts)

    return screen.cursor.x


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    """Draw tab.

    Args:
        draw_data (DrawData): Tab context.
        screen (Screen): Screen objects.
        tab (TabBarData): Tab bar context.
        before (int): Current cursor position, before drawing tab.
        max_tab_length (int): User-specified maximum length of tab.
        index (int): Tab index.
        is_last (bool): Whether this is the last tab to draw.
        extra_data (ExtraData): Additional context.

    Returns:
        int: Cursor positions after drawing current tab.
    """

    curr_tab = Tab(index, tab, extra_data)
    opts = Opts(draw_data)
    state = BarState(before, max_tab_length)

    try:
        end = curr_tab.draw(screen, opts, state)
    except Exception as e:
        logger.error("Exception: %s", e)

    # Draw right-hand side status
    if is_last:
        try:
            end = _draw_right_tabs(screen, opts, end)
        except Exception as e:
            logger.error("Exception: %s", e)

    return end
