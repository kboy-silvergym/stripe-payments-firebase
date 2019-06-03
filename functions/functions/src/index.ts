import * as functions from 'firebase-functions';

const stripe = require('stripe')(functions.config().stripe.token);

// MARK: - Create stripe customer and return customerId to your app
exports.createStripeCustomer = functions.https.onCall(async (data, context) => {
    const email = data.email;
    const customer = await stripe.customers.create({email: email});
    const customerId = customer.id;
    return { customerId: customerId }
});

// MARK: - Create one time token for stripe
exports.createStripeEphemeralKeys = functions.https.onCall((data, context) => {
    const customerId = data.customerId;
    const stripe_version = data.stripe_version;
    return stripe.ephemeralKeys
        .create({
            customer: customerId,
            stripe_version: stripe_version
        })
});

// MARK: - create Stripe charge
exports.createStripeCharge = functions.https.onCall((data, context) => {
    const customer = data.customerId;
    const source = data.sourceId;
    const amount = data.amount;

    return stripe.charges.create({
        customer: customer,
        source: source,
        amount: amount,
        currency: "jpy",
    })
});
