# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import (absolute_import, division, print_function)

# You can import any python module as needed.
import os

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command


# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!
class my_edit(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.acitons, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    # tabnum is 1 for <TAB> and -1 for <S-TAB> by default
    def tab(self, tabnum):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()

from ranger.api.commands import Command
import subprocess, os

class wlcopyfile(Command):
    """
    :wlcopyfile
    Copy selected file(s) to Wayland clipboard so they can be pasted into messengers or file managers.
    """
    def execute(self):
        import subprocess

        selection = self.fm.thistab.get_selection()
        files = [f"file://{os.path.abspath(f.path)}" for f in selection]
        uris = "\n".join(files)

        # Запускаем без ожидания зависания
        try:
            subprocess.Popen(
                ["wl-copy", "--type", "text/uri-list"],
                stdin=subprocess.PIPE,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            ).communicate(uris.encode())
        except Exception as e:
            self.fm.notify(f"wl-copy error: {e}", bad=True)

        # ranger уведомление
        names = ", ".join([os.path.basename(f.path) for f in selection])
        self.fm.notify(f"Copied {len(files)} file(s): {names}")

        # notify-send (без блокировки)
        try:
            subprocess.Popen([
                "notify-send",
                "📋 Ranger",
                "-a", "Ranger",
                "-i", "folder",
                f"Copied {len(files)} file(s):\n{names}"
            ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except:
            pass

import subprocess, os, shlex, time
from ranger.api.commands import Command

class wlpastefile(Command):
    """
    :wlpastefile
    Paste clipboard contents into current directory:
    - files (URI)
    - images (png/jpeg/webp)
    - text (first 10 tokens as filename)
    - other binary (timestamped .bin)
    """

    MEDIA_EXTS = {"image/png": "png", "image/jpeg": "jpg", "image/webp": "webp"}

    def execute(self):
        cwd = self.fm.thisdir.path

        try:
            types = subprocess.check_output(
                ["wl-paste", "--list-types"], stderr=subprocess.DEVNULL
            ).decode().strip().splitlines()
        except subprocess.CalledProcessError:
            self.fm.notify("Clipboard is empty or inaccessible", bad=True)
            return

        # 1) Files
        if "text/uri-list" in types:
            try:
                uris = subprocess.check_output(
                    ["wl-paste", "--type", "text/uri-list"], stderr=subprocess.DEVNULL
                ).decode().strip().splitlines()
                for uri in uris:
                    if uri.startswith("file://"):
                        path = uri[7:]
                        if os.path.exists(path):
                            dest = os.path.join(cwd, os.path.basename(path))
                            subprocess.run(["cp", "-r", path, dest])
                self.fm.notify("Pasted file(s) from clipboard.")
                self.fm.thisdir.load_content()
                return
            except Exception as e:
                self.fm.notify(f"Failed to paste file: {e}", bad=True)
                return

        # 2) Images
        for mime, ext in self.MEDIA_EXTS.items():
            if mime in types:
                try:
                    data = subprocess.check_output(["wl-paste", "--type", mime])
                    timestamp = time.strftime("%Y%m%d_%H%M%S")
                    dest = os.path.join(cwd, f"clipboard_{timestamp}.{ext}")
                    with open(dest, "wb") as f:
                        f.write(data)
                    self.fm.notify(f"Pasted image → {os.path.basename(dest)}")
                    self.fm.thisdir.load_content()
                    return
                except Exception as e:
                    self.fm.notify(f"Failed to paste image: {e}", bad=True)
                    return

        # 3) Text
        if "text/plain" in types:
            try:
                text = subprocess.check_output(["wl-paste", "--type", "text/plain"]).decode()
                tokens = text.strip().split()
                fname = "_".join(tokens[:10]) or "clipboard"
                fname = "".join(c for c in fname if c.isalnum() or c in "-_")
                dest = os.path.join(cwd, f"{fname}.txt")
                with open(dest, "w") as f:
                    f.write(text)
                self.fm.notify(f"Pasted text → {os.path.basename(dest)}")
                self.fm.thisdir.load_content()
                return
            except Exception as e:
                self.fm.notify(f"Failed to paste text: {e}", bad=True)
                return

        # 4) Fallback binary
        try:
            data = subprocess.check_output(["wl-paste"])
            timestamp = time.strftime("%Y%m%d_%H%M%S")
            dest = os.path.join(cwd, f"clipboard_{timestamp}.bin")
            with open(dest, "wb") as f:
                f.write(data)
            self.fm.notify(f"Pasted binary blob → {os.path.basename(dest)}")
            self.fm.thisdir.load_content()
        except Exception as e:
            self.fm.notify(f"Failed to paste binary: {e}", bad=True)

