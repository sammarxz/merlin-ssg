project('merlin', ['c', 'vala'],
        version: '0.1.0',
        license: 'MIT')

glib_dep = dependency('glib-2.0')
gobject_dep = dependency('gobject-2.0')

sources = [
    'src/main.vala',
    'src/commands/build.vala'
]

executable('merlin',
    sources,
    dependencies: [
        glib_dep,
        gobject_dep
    ],
    install: true)