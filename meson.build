project(
  'budgie-webcam-applet',
  'vala',
  version: '1.0.4',
  default_options: ['warning_level=2']
)

vapidir = join_paths(meson.project_source_root(), 'vapi')
prefix = get_option('prefix')
libdir = join_paths(prefix, get_option('libdir'))
budgielib = get_option('budgielib')
PLUGINS_INSTALL_DIR = join_paths(libdir, 'budgie-desktop', 'plugins', 'budgie-webcam')
subdir('src')
subdir('data')
