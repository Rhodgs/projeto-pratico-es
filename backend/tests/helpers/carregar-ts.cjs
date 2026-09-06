const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const { stripTypeScriptTypes } = require('node:module');

module.exports = async function carregar(arquivo, { mocks = {}, source, globals = {} } = {}) {
  const context = vm.createContext({ Date, Error, console, ...globals });
  const cache = new Map();
  function obter(nome) {
    if (cache.has(nome)) return cache.get(nome);
    const mock = mocks[nome] ?? mocks[path.basename(nome)];
    const mod = mock ? new vm.SyntheticModule(Object.keys(mock), function () {
      for (const [key, value] of Object.entries(mock)) this.setExport(key, value);
    }, { context }) : new vm.SourceTextModule(stripTypeScriptTypes(
      nome === arquivo && source !== undefined ? source : fs.readFileSync(nome, 'utf8'),
    ), { context, identifier: nome });
    cache.set(nome, mod);
    return mod;
  }
  const raiz = obter(arquivo);
  await raiz.link((specifier, parent) => obter(specifier.startsWith('.')
    ? path.resolve(path.dirname(parent.identifier), `${specifier}.ts`) : specifier));
  await raiz.evaluate();
  return raiz.namespace;
};
