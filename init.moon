import command from howl
import Process from howl.io


get_proj_name = (path) ->
  project = path
  for word in string.gmatch(path, '([^/]+)')
    project = word
  return project

build_handler = () ->
  proj = howl.Project.for_file(howl.app.editor.buffer.file)
  if proj == nil
    print 'There is no project'
    return
  run_process = Process({
    cmd: "stack build"
    working_directory: proj.root.path
    read_stdout: true
    read_stderr: true
  })
  bf = howl.ui.ProcessBuffer(run_process)

  howl.app\add_buffer bf
  bf\pump!


command.register({
  name: 'sbuild'
  description: 'Build the Haskell Stack project '
  handler: build_handler
})



exec_handler = (args) ->
  proj = howl.Project.for_file(howl.app.editor.buffer.file)
  if proj == nil
    print 'There is no project'
    return
  -- buffer = howl.ui.ActionBuffer()
  pname = get_proj_name proj.root.path
  shell = howl.sys.env.SHELL or '/bin/sh'

  run_process = Process({
    cmd: "stack exec " .. pname .." "..args
    :shell
    working_directory: proj.root.path
    read_stdout: true
    read_stderr: true
  })
  bf = howl.ui.ProcessBuffer(run_process)

  howl.app\add_buffer bf
  bf\pump!


command.register({
  name: 'sexec'
  description: 'Run the Haskell Stack project'
  input: howl.interact.read_text
  handler: exec_handler
})


unload = () ->
  command.unregister 'sbuild'

-- append the HASKELL API to howl
-- h_api = bundle_load('haskell_api')
-- howl.mode.by_name('lua').api.haskell

return {
  info:
    author: 'Martino Ferrari'
    description: 'Haskell Stack plugin'
    license: 'GPLv3'
  :unload
}
