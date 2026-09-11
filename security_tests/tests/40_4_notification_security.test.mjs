import { after, before, beforeEach, test } from "node:test";

import { assertFails, assertSucceeds } from "@firebase/rules-unit-testing";

import {
  deleteDoc,
  doc,
  getDoc,
  serverTimestamp,
  setDoc,
  updateDoc,
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
    // ALICE NOTIFICATION FIXTURE
    // ---------------------------------------------------------

    await setDoc(
      doc(db, "users", "alice", "notifications", "reservation-alice-001"),
      {
        title: "Event Reservation Confirmed",
        message: "Your private event reservation has been confirmed.",
        type: "event",
        isRead: false,
        hasDetails: true,
        reservationId: "reservation-alice-001",
        createdAt: new Date("2026-09-01T10:00:00Z"),
        updatedAt: new Date("2026-09-01T10:00:00Z"),
      },
    );

    // ---------------------------------------------------------
    // BOB RESERVATION FIXTURE
    // ---------------------------------------------------------

    await setDoc(doc(db, "reservations", "reservation-bob-001"), {
      userId: "bob",
    });
  });
});

after(async () => {
  await testEnv.cleanup();
});

// ---------------------------------------------------------
// NOTIFICATION SECURITY TESTS
// ---------------------------------------------------------

test("40.4.1 Bob cannot read Alice notification", async () => {
  const bobDb = testEnv.authenticatedContext("bob").firestore();

  await assertFails(
    getDoc(
      doc(bobDb, "users", "alice", "notifications", "reservation-alice-001"),
    ),
  );
});

test("40.4.2 Bob cannot delete Alice notification", async () => {
  const bobDb = testEnv.authenticatedContext("bob").firestore();

  await assertFails(
    deleteDoc(
      doc(bobDb, "users", "alice", "notifications", "reservation-alice-001"),
    ),
  );
});

test("40.4.3 Alice can mark own notification as read", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertSucceeds(
    updateDoc(
      doc(aliceDb, "users", "alice", "notifications", "reservation-alice-001"),
      {
        isRead: true,
        updatedAt: serverTimestamp(),
      },
    ),
  );
});

test("40.4.4 Alice cannot modify notification title", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(
      doc(aliceDb, "users", "alice", "notifications", "reservation-alice-001"),
      {
        title: "Hacked Notification Title",
        isRead: true,
        updatedAt: serverTimestamp(),
      },
    ),
  );
});

test("40.4.5 Alice cannot modify notification message", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(
      doc(aliceDb, "users", "alice", "notifications", "reservation-alice-001"),
      {
        message: "Forged notification message",
        isRead: true,
        updatedAt: serverTimestamp(),
      },
    ),
  );
});

test("40.4.6 Alice cannot modify notification type", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    updateDoc(
      doc(aliceDb, "users", "alice", "notifications", "reservation-alice-001"),
      {
        type: "system",
        isRead: true,
        updatedAt: serverTimestamp(),
      },
    ),
  );
});

test("40.4.7 Alice cannot create fake reservation confirmation", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    setDoc(
      doc(aliceDb, "users", "alice", "notifications", "fake-reservation-001"),
      {
        title: "Event Reservation Confirmed",
        message: "Your private event reservation has been confirmed.",
        type: "event",
        isRead: false,
        hasDetails: true,
        reservationId: "fake-reservation-001",
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp(),
      },
    ),
  );
});

test("40.4.8 Alice cannot create notification for Bob reservation", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  await assertFails(
    setDoc(
      doc(aliceDb, "users", "alice", "notifications", "reservation-bob-001"),
      {
        title: "Event Reservation Confirmed",
        message: "Your private event reservation has been confirmed.",
        type: "event",
        isRead: false,
        hasDetails: true,
        reservationId: "reservation-bob-001",
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp(),
      },
    ),
  );
});
