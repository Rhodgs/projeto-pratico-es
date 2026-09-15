const { createDefaultPreset } = require("ts-jest");

const tsJestTransformCfg = createDefaultPreset().transform;

/** @type {import("jest").Config} **/
module.exports = {
  roots: ["<rootDir>/casos-de-testes"],
  testEnvironment: "node",
  transform: {
    ...tsJestTransformCfg,
  },
};
