-- 1. 
--     a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
	-- SELECT DISTINCT npi
	-- 	,	SUM(total_claim_count) as total_claims
	-- FROM prescription
	-- GROUP BY npi
	-- ORDER BY total_claims DESC
	-- LIMIT 1;
--		Answer: NPI 1881634483 had 99707 claims

--     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.
	-- SELECT prescriber.nppes_provider_first_name
	-- 	,	prescriber.nppes_provider_last_org_name
	-- 	,	prescriber.specialty_description
	-- 	,	SUM(prescription.total_claim_count) as total_claims
	-- FROM prescriber
	-- 	INNER JOIN prescription
	-- 		USING (npi)
	-- GROUP BY prescriber.nppes_provider_first_name
	-- 	,	prescriber.nppes_provider_last_org_name
	-- 	,	prescriber.specialty_description
	-- ORDER BY total_claims DESC
	-- LIMIT 1;

-- 2. 
--     a. Which specialty had the most total number of claims (totaled over all drugs)?
	-- SELECT prescriber.specialty_description
	-- 	,	SUM(prescription.total_claim_count) as total_claims
	-- FROM prescriber
	-- 	INNER JOIN prescription
	-- 		USING (npi)
	-- GROUP BY prescriber.specialty_description
	-- ORDER BY total_claims DESC
	-- LIMIT 1;
--		Answer: Family Pracice with 9752347 total claims

--     b. Which specialty had the most total number of claims for opioids?
	-- SELECT prescriber.specialty_description
	-- 	,	SUM(prescription.total_claim_count) as total_claims
	-- FROM prescriber
	-- 	INNER JOIN prescription
	-- 		USING (npi)
	-- 	INNER JOIN drug
	-- 		USING (drug_name)
	-- WHERE opioid_drug_flag LIKE 'Y'
	-- GROUP BY prescriber.specialty_description
	-- ORDER BY total_claims DESC
	-- LIMIT 1;
--		Answer: Nurse Practitioner with 900845 claims

--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?
	-- SELECT prescriber.specialty_description
	-- 	,	COUNT(prescription.drug_name) AS prescribed_drugs_total
	-- FROM prescriber
	-- 	LEFT JOIN prescription
	-- 		USING (npi)
	-- GROUP BY prescriber.specialty_description
	-- HAVING COUNT(prescription.drug_name) = 0

--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

-- 3. 
--     a. Which drug (generic_name) had the highest total drug cost?
	-- SELECT drug.generic_name
	-- 	,	prescription.total_drug_cost::MONEY
	-- FROM prescription
	-- 	INNER JOIN drug
	-- 		USING (drug_name)
	-- ORDER BY prescription.total_drug_cost DESC
	-- LIMIT 1;
--		Answer: Pirfenidone has the highest drug cost at $2,829,174.30

--     b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**
	-- SELECT drug.generic_name
	-- 	,	ROUND((SUM(prescription.total_drug_cost))/(365*4),2) AS daily_drug_cost
	-- FROM prescription
	-- 	INNER JOIN drug
	-- 		USING (drug_name)
	-- GROUP BY drug.generic_name
	-- ORDER BY daily_drug_cost DESC
	-- LIMIT 1;
		-- Answer: Insulin has the highest cost per day at $71413.74

-- 4. 
--     a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. **Hint:** You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/ 
	-- SELECT drug.drug_name
	-- 	,	CASE
	-- 		WHEN drug.opioid_drug_flag = 'Y' THEN 'opioid'
	-- 		WHEN drug.antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	-- 		ELSE 'neither'
	-- 		END AS drug_type
	-- FROM drug

--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.
	-- SELECT SUM(prescription.total_drug_cost)::MONEY AS sum_total_cost
	-- 	,	CASE
	-- 			WHEN drug.opioid_drug_flag = 'Y' THEN 'opioid'
	-- 			WHEN drug.antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	-- 			ELSE 'neither'
	-- 				END AS drug_type
	-- FROM prescription
	-- 	INNER JOIN drug
	-- 		USING (drug_name)
	-- GROUP BY drug_type
	-- ORDER BY sum_total_cost DESC
--		Answer: Opioids had more spent on them, by roughly 65 million dollars.

-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.
	-- SELECT COUNT(cbsa)
	-- FROM cbsa
	-- WHERE cbsaname ILIKE '%TN'
	-- 	Answer: 33

--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
	-- SELECT cbsa.cbsaname
	-- 	,	SUM(population.population) AS total_pop
	-- FROM zip_fips
	-- 	INNER JOIN cbsa
	-- 		USING (fipscounty)
	-- 	INNER JOIN population
	-- 		USING (fipscounty)
	-- GROUP BY cbsa.cbsaname
	-- ORDER BY total_pop DESC
--		Answer: Memphis, TN-MS-AR has the highest with 67870189. Morristown, TN has the lowest with 1163520.

--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.
	-- SELECT fips_county.county
	-- 	,	fips_county.state
	-- 	,	population.population
	-- FROM fips_county
	-- 	INNER JOIN population
	-- 		USING (fipscounty)
	-- 	LEFT OUTER JOIN cbsa
	-- 		USING (fipscounty)
	-- WHERE cbsa.cbsa IS NULL
	-- ORDER BY population.population DESC
	-- LIMIT 1;
--		Answer: Sevier county has the highest population not included in a CBSA, at 95523.

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.
	-- SELECT prescription.drug_name
	-- 	,	prescription.total_claim_count
	-- FROM prescription
	-- WHERE total_claim_count >= 3000

--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
	-- SELECT prescription.drug_name
	-- 	,	prescription.total_claim_count
	-- 	,	drug.opioid_drug_flag
	-- FROM prescription
	-- 	INNER JOIN drug
	-- 		USING (drug_name)
	-- WHERE total_claim_count >= 3000

--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.
	-- SELECT prescriber.nppes_provider_first_name
	-- 	,	prescriber.nppes_provider_last_org_name
	-- 	,	prescription.drug_name
	-- 	,	prescription.total_claim_count
	-- 	,	drug.opioid_drug_flag
	-- FROM prescription
	-- 	INNER JOIN drug
	-- 		USING (drug_name)
	-- 	INNER JOIN prescriber
	-- 		USING (npi)
	-- WHERE total_claim_count >= 3000

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
    
--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.