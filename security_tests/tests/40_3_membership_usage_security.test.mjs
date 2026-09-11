import { after, before, beforeEach, test } from "node:test";

import { assertFails } from "@firebase/rules-unit-testing";

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
    // MEMBERSHIP FIXTURE
    // ---------------------------------------------------------

    await setDoc(doc(db, "memberships", "alice"), {
      plan: "Basic",
      status: "active",
      memberId: "MEMBER-ALICE",
      startedAt: new Date("2026-09-01T10:00:00Z"),
      validUntil: new Date("2027-09-01T10:00:00Z"),
      maxGuests: 1,
      createdAt: new Date("2026-09-01T10:00:00Z"),
      updatedAt: new Date("2026-09-01T10:00:00Z"),
    });

    // ---------------------------------------------------------
    // USAGE FIXTURE
    // ---------------------------------------------------------

    await setDoc(doc(db, "usage", "alice", "months", "2026-09"), {
      hookahUsed: 0,
      drinksUsed: 0,
      createdAt: new Date("2026-09-01T10:00:00Z"),
      updatedAt: new Date("2026-09-01T10:00:00Z"),
    });
  });
});

after(async () => {
  await testEnv.cleanup();
});

// ---------------------------------------------------------
// MEMBERSHIP MANIPULATION TESTS
// ---------------------------------------------------------

test("40.3.1 Alice cannot upgrade Basic membership to VIP", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(doc(db, "memberships", "alice"), {
      plan: "VIP",
    }),
  );
});

test("40.3.2 Alice cannot manipulate membership status", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(doc(db, "memberships", "alice"), {
      status: "inactive",
    }),
  );
});

test("40.3.3 Alice cannot manipulate maxGuests", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(doc(db, "memberships", "alice"), {
      maxGuests: 999,
    }),
  );
});

test("40.3.4 Alice cannot manipulate memberId", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(doc(db, "memberships", "alice"), {
      memberId: "FORGED-MEMBER-ID",
    }),
  );
});

test("40.3.5 Alice cannot update existing membership", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(doc(db, "memberships", "alice"), {
      validUntil: new Date("2030-01-01T00:00:00Z"),
    }),
  );
});

test("40.3.6 Bob cannot modify Alice membership", async () => {
  const db = testEnv.authenticatedContext("bob").firestore();

  await assertFails(
    updateDoc(doc(db, "memberships", "alice"), {
      plan: "VIP",
    }),
  );
});

// ---------------------------------------------------------
// USAGE SECURITY TESTS
// ---------------------------------------------------------

test("40.3.7 Alice cannot manipulate hookahUsed on usage creation", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    setDoc(doc(aliceDb, "usage", "alice", "months", "2026-10"), {
      hookahUsed: 1,
      drinksUsed: 0,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.3.8 Alice cannot manipulate drinksUsed on usage creation", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    setDoc(doc(aliceDb, "usage", "alice", "months", "2026-10"), {
      hookahUsed: 0,
      drinksUsed: 1,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.3.9 Alice cannot create usage with negative hookahUsed", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    setDoc(doc(aliceDb, "usage", "alice", "months", "2026-10"), {
      hookahUsed: -1,
      drinksUsed: 0,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.3.10 Alice cannot create usage with negative drinksUsed", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    setDoc(doc(aliceDb, "usage", "alice", "months", "2026-10"), {
      hookahUsed: 0,
      drinksUsed: -1,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.3.11 Alice cannot update existing usage", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(doc(aliceDb, "usage", "alice", "months", "2026-09"), {
      hookahUsed: 1,
    }),
  );
});
test("40.3.12 Bob cannot modify Alice usage", async () => {
  const bobDb = testEnv.authenticatedContext("bob").firestore();

  await assertFails(
    updateDoc(doc(bobDb, "usage", "alice", "months", "2026-09"), {
      hookahUsed: 1,
    }),
  );
});
