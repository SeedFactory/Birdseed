function LiveReloadPluginERB(window, host) {
  this.window = window;
  this.host = host;
}

LiveReloadPluginERB.prototype.reload = function(path, options) {
  if(path.match(/\.erb$/)) {
    Turbolinks.visit(document.location.href);
    return true;
  }
  return false;
}

LiveReload.addPlugin(LiveReloadPluginERB)
