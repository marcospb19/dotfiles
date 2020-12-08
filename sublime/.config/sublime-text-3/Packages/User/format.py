import sublime
import sublime_plugin
import subprocess
import re

regex = re.compile(r'#define[^\n]\n')

def _run_terminal_command(command, stdin=''):
    p = subprocess.Popen(
        command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE
    )
    output, error = p.communicate(stdin.encode('utf-8'))
    return (output.decode('utf-8'), error, p.returncode)


class formatEventListener(sublime_plugin.EventListener):
    """ Event listener that calls the command """

    def on_pre_save(self, view):
        view.run_command('format')


class formatCommand(sublime_plugin.TextCommand):
    """ Command that formats the python code using black """

    def run(self, edit):
        language = self.view.settings().get('syntax').split('/')[1]
        if not language in ['C++', 'C', 'Python']:
            return

        code = self.view.substr(sublime.Region(0, self.view.size()))

        file_name = self.view.file_name().split('/')[-1:]
        print('Formatting', file_name)

        if language == 'Python':
            return
            formatted_code, error, return_code = _run_terminal_command(
                'python -m black --fast -Sc'.split(' ') + [code]
            )
        else:
            formatted_code, error, return_code = _run_terminal_command(
                'clang-format --style file --assume-filename'.split(' ') + file_name,
                code,
            )

        if return_code == 0:
            self.view.replace(
                edit, sublime.Region(0, self.view.size()), formatted_code
            )
        else:
            print(return_code, 'error: error while trying to format')
