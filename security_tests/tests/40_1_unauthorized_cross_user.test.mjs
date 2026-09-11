import { after, before, beforeEach, test } from "node:test";

import { assertFails, assertSucceeds } from "@firebase/rules-unit-testing";

import { doc, getDoc, setDoc } from "firebase/firestore";

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
    // USER FIXTURES
    // ---------------------------------------------------------

    await setDoc(doc(db, "users", "alice"), {
      fullName: "Alice",
      email: "alice@example.com",
      phone: "1111111111",
      createdAt: new Date(),
    });

    await setDoc(doc(db, "users", "bob"), {
      fullName: "Bob",
      email: "bob@example.com",
      phone: "2222222222",
      createdAt: new Date(),
    });

    // ---------------------------------------------------------
    // MEMBERSHIP FIXTURES
    // ---------------------------------------------------------

    await setDoc(doc(db, "memberships", "alice"), {
      plan: "Basic",
      status: "active",
      memberId: "MEMBER-ALICE",
      maxGuests: 1,
      validUntil: new Date("2030-01-01T00:00:00Z"),
    });

    await setDoc(doc(db, "memberships", "bob"), {
      plan: "VIP",
      status: "active",
      memberId: "MEMBER-BOB",
      maxGuests: 2,
      validUntil: new Date("2030-01-01T00:00:00Z"),
    });

    // ---------------------------------------------------------
    // USAGE FIXTURES
    // ---------------------------------------------------------

    await setDoc(doc(db, "usage", "alice", "months", "2026-09"), {
      hookahUsed: 0,
      drinksUsed: 0,
    });

    await setDoc(doc(db, "usage", "bob", "months", "2026-09"), {
      hookahUsed: 0,
      drinksUsed: 0,
    });
  });
});

after(async () => {
  await testEnv.cleanup();
});

// ---------------------------------------------------------
// PROFILE READ TESTS
// ---------------------------------------------------------

test("40.1.1 Anonymous cannot read Alice profile", async () => {
  const db = testEnv.unauthenticatedContext().firestore();

  await assertFails(getDoc(doc(db, "users", "alice")));
});

test("40.1.2 Alice can read own profile", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertSucceeds(getDoc(doc(db, "users", "alice")));
});

test("40.1.3 Alice cannot read Bob profile", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(getDoc(doc(db, "users", "bob")));
});

// ---------------------------------------------------------
// MEMBERSHIP READ TESTS
// ---------------------------------------------------------

test("40.1.4 Alice can read own membership", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertSucceeds(getDoc(doc(db, "memberships", "alice")));
});

test("40.1.5 Alice cannot read Bob membership", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(getDoc(doc(db, "memberships", "bob")));
});

// ---------------------------------------------------------
// USAGE READ TESTS
// ---------------------------------------------------------

test("40.1.6 Alice can read own usage", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertSucceeds(getDoc(doc(db, "usage", "alice", "months", "2026-09")));
});

test("40.1.7 Alice cannot read Bob usage", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(getDoc(doc(db, "usage", "bob", "months", "2026-09")));
});

test("40.1.8 Unknown collection read is denied", async () => {
  const db = testEnv.authenticatedContext("alice").firestore();

  await assertFails(getDoc(doc(db, "unknownCollection", "testDocument")));
});
