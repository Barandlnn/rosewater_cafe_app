import { readFileSync } from "node:fs";
import { initializeTestEnvironment } from "@firebase/rules-unit-testing";

const PROJECT_ID = "demo-rosewater-cafe";

const firestoreRules = readFileSync(
  new URL("../../firestore.rules", import.meta.url),
  "utf8",
);

export async function createTestEnvironment() {
  return initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: {
      rules: firestoreRules,
    },
  });
}

export { PROJECT_ID };
