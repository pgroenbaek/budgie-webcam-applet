budgie_dep = dependency('budgie-1.0', required: true)
gtk_dep = dependency('gtk+-3.0')
glib_dep = dependency('glib-2.0')

sources = ['webcam_whitebalance.vala']

executable('webcam_whitebalance',
  sources,
  dependencies: [budgie_dep, gtk_dep, glib_dep],
  install: true
)