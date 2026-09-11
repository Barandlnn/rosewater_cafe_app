import { after, before, beforeEach, test } from "node:test";

import { assertFails, assertSucceeds } from "@firebase/rules-unit-testing";

import { deleteDoc, doc, getDoc, setDoc, updateDoc } from "firebase/firestore";

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
    // ALICE ACTIVE MEMBERSHIP FIXTURE
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
    // CHARLIE EXPIRED MEMBERSHIP FIXTURE
    // ---------------------------------------------------------

    await setDoc(doc(db, "memberships", "charlie"), {
      plan: "Basic",
      status: "active",
      memberId: "MEMBER-CHARLIE",
      startedAt: new Date("2025-09-01T10:00:00Z"),
      validUntil: new Date("2026-09-01T10:00:00Z"),
      maxGuests: 1,
      createdAt: new Date("2025-09-01T10:00:00Z"),
      updatedAt: new Date("2026-09-01T10:00:00Z"),
    });

    // ---------------------------------------------------------
    // PRIVATE EVENT FIXTURE
    // ---------------------------------------------------------

    await setDoc(doc(db, "events", "private_event"), {
      isActive: true,
      minGuests: 1,
      maxGuests: 20,
      baseRate: 100,
      currency: "GBP",
    });
    // ---------------------------------------------------------
    // DEFAULT DENY TEST FIXTURE
    // ---------------------------------------------------------

    await setDoc(doc(db, "unlistedCollection", "secret-001"), {
      secret: "This document must not be accessible from the client.",
    });
  });
});

after(async () => {
  await testEnv.cleanup();
});

// ---------------------------------------------------------
// EVENTS + DEFAULT DENY SECURITY TESTS
// ---------------------------------------------------------

test("40.7.1 Alice with active membership can read private event", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertSucceeds(getDoc(doc(aliceDb, "events", "private_event")));
});

test("40.7.2 Bob without membership cannot read private event", async () => {
  const bobDb = testEnv.authenticatedContext("bob").firestore();

  await assertFails(getDoc(doc(bobDb, "events", "private_event")));
});

test("40.7.3 Charlie with expired membership cannot read private event", async () => {
  const charlieDb = testEnv.authenticatedContext("charlie").firestore();

  await assertFails(getDoc(doc(charlieDb, "events", "private_event")));
});

test("40.7.4 Alice cannot create event", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    setDoc(doc(aliceDb, "events", "fake_event"), {
      isActive: true,
      minGuests: 1,
      maxGuests: 20,
      baseRate: 100,
      currency: "GBP",
    }),
  );
});
test("40.7.5 Alice cannot update existing event", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(doc(aliceDb, "events", "private_event"), {
      baseRate: 1,
    }),
  );
});

test("40.7.6 Alice cannot delete existing event", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(deleteDoc(doc(aliceDb, "events", "private_event")));
});

test("40.7.7 Alice cannot read document from unlisted collection", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(getDoc(doc(aliceDb, "unlistedCollection", "secret-001")));
});
test("40.7.8 Alice cannot write to unlisted collection", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    setDoc(doc(aliceDb, "unlistedCollection", "forged-001"), {
      secret: "Client should not be able to create this document.",
    }),
  );
});
test("40.7.9 Unauthenticated client cannot read unlisted collection", async () => {
  const unauthDb = testEnv.unauthenticatedContext().firestore();

  await assertFails(getDoc(doc(unauthDb, "unlistedCollection", "secret-001")));
});
