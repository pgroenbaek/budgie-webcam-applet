# Webcam Applet build
budgie_dep = dependency('budgie-1.0', required: true)
gtk_dep = dependency('gtk+-3.0')
glib_dep = dependency('glib-2.0')
gudev_dep = dependency('gudev-1.0')
gettext_dep = dependency('gettext', required: false)

applet_webcam_sources = [
  'WebcamApplet.vala',
  'WebcamAppletSettings.vala',
  'WebcamAppletWindow.vala',
  'ioctl_wrapper.c',
]

applet_webcam_deps = [
  budgie_dep,
  gtk_dep,
  glib_dep,
  gudev_dep,
  gettext_dep,
]

add_project_arguments('--pkg=posix', language: 'vala')
add_project_arguments('--pkg=v4l2', language: 'vala')
add_project_arguments('--pkg=ioctl_wrapper', language: 'vala')
add_project_arguments('--vapidir=' + vapidir, language: 'vala')
add_project_arguments('-DGETTEXT_PACKAGE="budgie-webcam-applet"', language: 'c')

shared_library('webcamapplet',
  applet_webcam_sources,
  dependencies: applet_webcam_deps,
  install: true
)