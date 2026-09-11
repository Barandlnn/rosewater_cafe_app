import { after, before, beforeEach, test } from "node:test";

import { assertFails, assertSucceeds } from "@firebase/rules-unit-testing";

import { doc, serverTimestamp, setDoc, updateDoc } from "firebase/firestore";

import { createTestEnvironment } from "../helpers/test_environment.mjs";

let testEnv;

before(async () => {
  testEnv = await createTestEnvironment();
});

beforeEach(async () => {
  await testEnv.clearFirestore();

  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();

    // ---------------------------------------------------------
    // PROFILE FIXTURES
    // ---------------------------------------------------------

    await setDoc(doc(db, "users", "alice"), {
      fullName: "Alice",
      email: "alice@example.com",
      phone: "1111111111",
      createdAt: new Date("2026-09-01T10:00:00Z"),
    });

    await setDoc(doc(db, "users", "bob"), {
      fullName: "Bob",
      email: "bob@example.com",
      phone: "2222222222",
      createdAt: new Date("2026-09-01T10:00:00Z"),
    });
  });
});

after(async () => {
  await testEnv.cleanup();
});

// ---------------------------------------------------------
// ALLOWED PROFILE UPDATES
// ---------------------------------------------------------

test("40.2.1 Alice can update own fullName", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertSucceeds(
    updateDoc(doc(db, "users", "alice"), {
      fullName: "Alice Updated",
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.2.2 Alice can update own phone", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertSucceeds(
    updateDoc(doc(db, "users", "alice"), {
      phone: "9999999999",
      updatedAt: serverTimestamp(),
    }),
  );
});

// ---------------------------------------------------------
// PROTECTED PROFILE FIELDS
// ---------------------------------------------------------

test("40.2.3 Alice cannot tamper with own email", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(doc(db, "users", "alice"), {
      email: "attacker@example.com",
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.2.4 Alice cannot tamper with createdAt", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(doc(db, "users", "alice"), {
      createdAt: new Date("2030-01-01T00:00:00Z"),
      updatedAt: serverTimestamp(),
    }),
  );
});

// ---------------------------------------------------------
// FIELD INJECTION / CROSS-USER ATTACKS
// ---------------------------------------------------------

test("40.2.5 Alice cannot inject unexpected profile field", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(doc(db, "users", "alice"), {
      isAdmin: true,
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.2.6 Alice cannot modify Bob profile", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(doc(db, "users", "bob"), {
      fullName: "Bob Hacked",
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.2.7 Anonymous cannot create profile", async () => {
  const db = testEnv.unauthenticatedContext().firestore();

  await assertFails(
    setDoc(doc(db, "users", "anonymous-user"), {
      fullName: "Anonymous User",
      email: "anonymous@example.com",
      phone: "0000000000",
      createdAt: serverTimestamp(),
    }),
  );
});
