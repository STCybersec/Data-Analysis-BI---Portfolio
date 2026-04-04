## Data Generation Notes

The fact_service_requests table contains 500,000 rows
generated using Python with the following parameters:

- Date range: 2021-2025
- SLA compliance: 60% within target
- Status split: 60% Resolved, 20% Open, 10% Escalated, 10% Closed
- Budget variance: ±30% around allocated amount
- Satisfaction scores: 1-5 (resolved requests only)

To recreate the dataset run the full generation script
available on request via thusisanelelele@gmail.com
