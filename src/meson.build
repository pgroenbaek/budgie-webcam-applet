# Webcam Whitebalance Applet build
budgie_dep = dependency('budgie-1.0', required: true)
gtk_dep = dependency('gtk+-3.0')
glib_dep = dependency('glib-2.0')
gettext_dep = dependency('gettext', required: false)


applet_webcamwhitebalance_sources = [
  'WebcamWhitebalanceApplet.vala',
  'WebcamWhitebalanceSettings.vala',
  'WebcamWhitebalanceWindow.vala',
]

applet_webcamwhitebalance_deps = [
  budgie_dep,
  gtk_dep,
  glib_dep,
  gettext_dep,
]

add_project_arguments('-DGETTEXT_PACKAGE="budgie-webcam-whitebalance-applet"', language: 'c')

shared_library('webcamwhitebalanceapplet',
  applet_webcamwhitebalance_sources,
  dependencies: applet_webcamwhitebalance_deps,
  install: true
)