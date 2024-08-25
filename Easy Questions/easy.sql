-- Show first name, last name, and gender of patients whose gender is 'M'

SELECT first_name, last_name, gender
FROM patients
where gender = 'M';

-- Show first name and last name of patients who do not have allergies. (null)

SELECT first_name, last_name
FROM patients
where allergies is null;

-- Show the first name of patients that start with the letter 'C'

SELECT first_name
FROM patients
where first_name like ('C%');

-- Show the first name and last name of patients that weigh within the range of 100 to 120 (inclusive)

SELECT first_name, last_name
FROM patients
where weight between 100 and 120;

-- Update the patient's table for the allergies column. If the patient's allergies are null then replace it with 'NKA'

update patients
set allergies = 'NKA'
where allergies is null;

-- Show the first name and last name concatenated into one column to show their full name.

select concat(first_name, ' ', last_name) as full_name
from patients;

/* Show first name, last name, and the full province name of each patient.

Example: 'Ontario' instead of 'ON' */

select first_name, last_name, province_name
from patients
left join province_names on patients.province_id = province_names.province_id;

-- Show how many patients have a birth_date with 2010 as the birth year.

SELECT count(birth_date) as total_patients
FROM patients
where birth_date like('2010%');

-- Show the first_name, last_name, and height of the patient with the greatest height.

SELECT first_name, last_name, max(height) as height
FROM patients;

/* Show all columns for patients who have one of the following patient_ids:
1,45,534,879,1000 */

SELECT * 
FROM patients
where patient_id in (1,45,534,879,1000);

-- Show the total number of admissions

SELECT count(patient_id) as total_admissions
FROM admissions;

-- Show all the columns from admissions where the patient was admitted and discharged on the same day.

SELECT *
FROM admissions
where admission_date = discharge_date;

-- Show the patient id and the total number of admissions for patient_id 579.

SELECT patient_id, count(admission_date) 
FROM admissions
where patient_id = 579;

-- Based on the cities that our patients live in, show unique cities that are in province_id 'NS'.

SELECT distinct(city) as unique_cities
FROM patients
where province_id = 'NS'

-- Write a query to find the first_name, last name, and birth date of patients who have a height greater than 160 and weight greater than 70

SELECT first_name, last_name, birth_date
FROM patients
where height > 160 and weight > 70

/* Write a query to find the list of the patient's first_name, last_name, and allergies where allergies are not null and are from the city of 'Hamilton' */

SELECT first_name, last_name, allergies 
FROM patients
where city = 'Hamilton' and allergies not null;
