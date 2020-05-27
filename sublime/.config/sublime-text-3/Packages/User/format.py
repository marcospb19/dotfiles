import sublime
import sublime_plugin
import subprocess


class formatEventListener(sublime_plugin.EventListener):
    """ Event listener that calls the command """

    def on_pre_save(self, view):
        view.run_command('format')


class formatCommand(sublime_plugin.TextCommand):
    """ Command that formats the python code using black """

    def run(self, edit):
        """ Simbora garaio """

        language = self.view.settings().get('syntax').split('/')[1]
        if language != 'Python':
            return

        code = self.view.substr(sublime.Region(0, self.view.size()))

        formatted_code, error, return_code = run_terminal_command(
            ['python', '-m', 'black', '--fast', '-Sc', code]
        )

        # print(formatted_code)

        if return_code == 0:
            # print('formatting!')
            self.view.replace(edit, sublime.Region(0, self.view.size()), formatted_code)
        else:
            # print(return_code, 'error: error while trying to format')
            # print(error)
            return


def run_terminal_command(command):
    p = subprocess.Popen(
        command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE
    )
    output, error = p.communicate()
    return (output.decode('utf-8'), error, p.returncode)


# def run_terminal_command(command, type_to_stdin: str):
#     p = subprocess.Popen(
#         command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE
#     )
#     output, error = p.communicate(type_to_stdin.encode('utf-8'))
#     return output.decode('utf-8')

