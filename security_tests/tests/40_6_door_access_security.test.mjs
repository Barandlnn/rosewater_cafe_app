import { after, before, beforeEach, test } from "node:test";

import { assertFails, assertSucceeds } from "@firebase/rules-unit-testing";

import {
  addDoc,
  collection,
  doc,
  serverTimestamp,
  setDoc,
} from "firebase/firestore";

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
  });
});

after(async () => {
  await testEnv.cleanup();
});

// ---------------------------------------------------------
// DOOR ACCESS SECURITY TESTS
// ---------------------------------------------------------

test("40.6.1 Alice can create valid door access request", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

  await assertSucceeds(
    addDoc(collection(aliceDb, "doorAccessRequests"), {
      userId: "alice",
      memberId: "MEMBER-ALICE",
      membershipPlan: "Basic",
      guestCount: 1,
      status: "pending",
      createdAt: serverTimestamp(),
      expiresAt,
    }),
  );
});

test("40.6.2 Alice cannot create door access request with wrong userId", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

  await assertFails(
    addDoc(collection(aliceDb, "doorAccessRequests"), {
      userId: "bob",
      memberId: "MEMBER-ALICE",
      membershipPlan: "Basic",
      guestCount: 1,
      status: "pending",
      createdAt: serverTimestamp(),
      expiresAt,
    }),
  );
});

test("40.6.3 Alice cannot create door access request with fake memberId", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

  await assertFails(
    addDoc(collection(aliceDb, "doorAccessRequests"), {
      userId: "alice",
      memberId: "FAKE-MEMBER-ID",
      membershipPlan: "Basic",
      guestCount: 1,
      status: "pending",
      createdAt: serverTimestamp(),
      expiresAt,
    }),
  );
});
test("40.6.4 Alice cannot create door access request with fake membershipPlan", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

  await assertFails(
    addDoc(collection(aliceDb, "doorAccessRequests"), {
      userId: "alice",
      memberId: "MEMBER-ALICE",
      membershipPlan: "VIP",
      guestCount: 1,
      status: "pending",
      createdAt: serverTimestamp(),
      expiresAt,
    }),
  );
});
test("40.6.5 Alice cannot create door access request with negative guestCount", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

  await assertFails(
    addDoc(collection(aliceDb, "doorAccessRequests"), {
      userId: "alice",
      memberId: "MEMBER-ALICE",
      membershipPlan: "Basic",
      guestCount: -1,
      status: "pending",
      createdAt: serverTimestamp(),
      expiresAt,
    }),
  );
});
test("40.6.6 Alice cannot create door access request above membership guest limit", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

  await assertFails(
    addDoc(collection(aliceDb, "doorAccessRequests"), {
      userId: "alice",
      memberId: "MEMBER-ALICE",
      membershipPlan: "Basic",
      guestCount: 2,
      status: "pending",
      createdAt: serverTimestamp(),
      expiresAt,
    }),
  );
});
test("40.6.7 Alice cannot create door access request with status != pending", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

  await assertFails(
    addDoc(collection(aliceDb, "doorAccessRequests"), {
      userId: "alice",
      memberId: "MEMBER-ALICE",
      membershipPlan: "Basic",
      guestCount: 1,
      status: "approved",
      createdAt: serverTimestamp(),
      expiresAt,
    }),
  );
});
test("40.6.8 Alice cannot create door access request with expired expiresAt", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const expiresAt = new Date(Date.now() - 60 * 1000);

  await assertFails(
    addDoc(collection(aliceDb, "doorAccessRequests"), {
      userId: "alice",
      memberId: "MEMBER-ALICE",
      membershipPlan: "Basic",
      guestCount: 1,
      status: "pending",
      createdAt: serverTimestamp(),
      expiresAt,
    }),
  );
});
test("40.6.9 Alice cannot create door access request with expiresAt over 10 minutes", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const expiresAt = new Date(Date.now() + 11 * 60 * 1000);

  await assertFails(
    addDoc(collection(aliceDb, "doorAccessRequests"), {
      userId: "alice",
      memberId: "MEMBER-ALICE",
      membershipPlan: "Basic",
      guestCount: 1,
      status: "pending",
      createdAt: serverTimestamp(),
      expiresAt,
    }),
  );
});
