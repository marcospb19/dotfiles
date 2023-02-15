import sublime
import sublime_plugin
import subprocess
import re

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

        """
        let vec = vec![5];
        """

        # if self.view.get_regions('asd'):
        #     print('erasin')
        #     self.view.erase_regions('asd')
        # else:
        #     print('addin')
        #     region = sublime.Region(1, 10)
        #     self.view.add_regions('asd', [region], 'string', 'asd', 0)

        # print()
        # print(self.view.insert(edit, 3, "hello"))

        file_name = self.view.file_name().split('/')[-1:]
        print('Formatting', file_name)

        if language == 'Python':
            return
            formatted_code, error, return_code = _run_terminal_command(
                'python -m black --fast -Sc'.split(' ') + [code]
            )
        else:
            formatted_code, error, return_code = _run_terminal_command(
                f'clang-format --assume-filename'.split(' ') + file_name,
                code,
            )

        if return_code == 0:
            self.view.replace(
                edit, sublime.Region(0, self.view.size()), formatted_code
            )
        else:
            print(f'error: failed while trying to format (exit code {return_code}): {error}')




"""

        if self.view.get_regions('asd'):
            print('erasin')
            self.view.erase_regions('asd')
        else:
            self.view.erase_phantoms('asd')
            print('addin')
            text = \"""<body id="my-plugin-feature">
    <style>
        h6.error {
            background-color: #11223300;
            text-color: #555;
            margin: 0px;
            padding-top: 4px;
        }
    </style>
    <h6 class="error">: Vec(Option(i32))</p>
</body>\"""
            # text = \""": Vec(Option(i32))\"""
            region = sublime.Region(100, 100)
            self.view.add_phantom('asd', region, text, sublime.LAYOUT_INLINE)



"""
