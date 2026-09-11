import { after, before, beforeEach, test } from "node:test";

import { assertFails, assertSucceeds } from "@firebase/rules-unit-testing";

import { doc, serverTimestamp, setDoc } from "firebase/firestore";

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
    // PRIVATE EVENT FIXTURE
    // ---------------------------------------------------------

    await setDoc(doc(db, "events", "private_event"), {
      isActive: true,
      minGuests: 1,
      maxGuests: 20,
      baseRate: 100,
      currency: "GBP",
    });
  });
});

after(async () => {
  await testEnv.cleanup();
});

// ---------------------------------------------------------
// RESERVATION SECURITY TESTS
// ---------------------------------------------------------

test("40.5.1 Alice can create a fully valid reservation", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertSucceeds(
    setDoc(doc(aliceDb, "reservations", "reservation-alice-valid-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 200,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.5.2 Alice cannot create reservation with wrong userId", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-wrong-user-001"), {
      userId: "bob",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 200,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});
test("40.5.3 Alice cannot create reservation with wrong eventId", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-wrong-event-001"), {
      userId: "alice",
      eventId: "fake_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 200,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.5.4 Alice cannot create reservation with empty eventType", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-empty-type-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "",
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 200,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.5.5 Alice cannot create reservation with eventType over 80 characters", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);
  const longEventType = "A".repeat(81);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-long-type-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: longEventType,
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 200,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});
test("40.5.6 Alice cannot create reservation with past eventDateTime", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const pastEventDate = new Date(Date.now() - 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-past-date-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: pastEventDate,
      duration: 2,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 200,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});
test("40.5.7 Alice cannot create reservation with duration <= 0", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-zero-duration-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 0,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 0,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});
test("40.5.8 Alice cannot create reservation with duration > 24", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-long-duration-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 25,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 2500,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});
test("40.5.9 Alice cannot create reservation with guestCount below minimum", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-low-guests-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 0,
      baseRate: 100,
      estimatedTotal: 200,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});
test("40.5.10 Alice cannot create reservation with guestCount above maximum", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-high-guests-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 21,
      baseRate: 100,
      estimatedTotal: 200,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});
test("40.5.11 Alice cannot manipulate reservation baseRate", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-fake-rate-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 10,
      baseRate: 1,
      estimatedTotal: 200,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});
test("40.5.12 Alice cannot manipulate reservation estimatedTotal", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-fake-total-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 1,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.5.13 Alice cannot manipulate reservation currency", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-fake-currency-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 200,
      currency: "USD",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});
test("40.5.14 Alice cannot create reservation with status != confirmed", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-wrong-status-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 200,
      currency: "GBP",
      status: "pending",
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
});

test("40.5.15 Alice cannot forge reservation createdAt", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-forged-created-at-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 200,
      currency: "GBP",
      status: "confirmed",
      createdAt: new Date("2020-01-01T00:00:00Z"),
      updatedAt: serverTimestamp(),
    }),
  );
});
test("40.5.16 Alice cannot forge reservation updatedAt", async () => {
  const aliceDb = testEnv.authenticatedContext("alice").firestore();

  const futureEventDate = new Date(Date.now() + 24 * 60 * 60 * 1000);

  await assertFails(
    setDoc(doc(aliceDb, "reservations", "reservation-forged-updated-at-001"), {
      userId: "alice",
      eventId: "private_event",
      eventType: "Birthday",
      eventDateTime: futureEventDate,
      duration: 2,
      guestCount: 10,
      baseRate: 100,
      estimatedTotal: 200,
      currency: "GBP",
      status: "confirmed",
      createdAt: serverTimestamp(),
      updatedAt: new Date("2020-01-01T00:00:00Z"),
    }),
  );
});
