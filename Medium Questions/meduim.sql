---SQL-Practice Medium

--Show unique birth years from patients and order them by ascending.

SELECT distinct year(birth_date) as birth_year 
FROM patients
order by 1 asc;

/*Show unique first names from the patient's table which only occurs once in the list.

For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.
*/
SELECT distinct(first_name) 
FROM patients
group by first_name
having count(first_name) = 1

--Show patient_id and first_name from patients where their first_name starts and ends with 's' and is at least 6 characters long.

SELECT patient_id, first_name
FROM patients
where first_name like('s____%s');

/*Show patient_id, first_name, and last_name from patients whose diagnosis is 'Dementia'.

Primary diagnosis is stored in the admissions table.*/

SELECT p.patient_id, p.first_name, p.last_name
FROM patients p
join admissions a on p.patient_id = a.patient_id
where diagnosis = 'Dementia';

/*Display every patient's first name.
Order the list by the length of each name and then by alphabetically.
*/
SELECT first_name 
FROM patients
order by len(first_name),
	first_name;

/*Show the total amount of male patients and the total amount of female patients in the patients table.
Display the two results in the same row.
*/
SELECT 
	(select count(*) FROM patients where gender = 'M') as male_count,
    (select count(*) from patients where gender = 'F') as female_count
from patients
limit 1;

--Show the first and last names and allergies of patients who have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.

SELECT first_name, last_name, allergies 
FROM patients
where allergies = 'Penicillin' or allergies = 'Morphine'
order by 3,1,2;

--Show patient_id and diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

SELECT patient_id, diagnosis
FROM admissions
group by patient_id, diagnosis
having count(diagnosis) > 1;

/*Show the city and the total number of patients in the city.
Order from most to least patients and then by city name ascending.
*/
SELECT city, count(*) as num_patients 
FROM patients
group by city
order by num_patients desc, city;

/*Show the first name, last name, and role of every person who is either a patient or doctor.
The roles are either "Patient" or "Doctor"
*/
SELECT first_name, last_name, 'Patient' as role
FROM patients 
union all
select first_name, last_name, 'Doctor' as role
from doctors;

--Show all allergies ordered by popularity. Remove NULL values from the query.

SELECT allergies, count(allergies) as total_diagnosis
FROM patients
where allergies is not null
group by allergies
order by total_diagnosis desc

--Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.

SELECT first_name, last_name, birth_date
FROM patients
where birth_date between '1970-01-01' and '1979-12-31'
order by birth_date

/*We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in descending order
EX: SMITH, jane
*/
SELECT concat(upper(last_name), ',', lower(first_name)) as new_name_format
FROM patients
order by first_name desc;

--Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

SELECT province_id, sum(height) as sum_height
FROM patients
group by province_id
having sum_height > 7000
order by province_id, sum_height desc;

--Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

SELECT (max(weight) - min(weight)) as weight_delta
FROM patients
where last_name = 'Maroni';

--Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.

SELECT day(admission_date) as day_number, count(admission_date) as number_of_admissions
FROM admissions
group by day_number
order by number_of_admissions desc;

--Show all columns for patient_id 542's most recent admission_date.

SELECT *
FROM admissions
where patient_id = '542'
order by admission_date desc
limit 1;

/*Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
*/
SELECT patient_id, attending_doctor_id, diagnosis
FROM admissions
where (attending_doctor_id in(1,5,19) and patient_id % 2 <> 0)
or (attending_doctor_id like '%2%' and len(patient_id) = 3)

/*Show first_name, last_name, and the total number of admissions attended for each doctor.
Every admission has been attended by a doctor.
*/
SELECT d.first_name, d.last_name, count(d.doctor_id) as admissions_total
FROM admissions a
left join doctors d on a.attending_doctor_id = d.doctor_id
group by a.attending_doctor_id

--For each doctor, display their ID, full name, and the first and last admission date they attended.

SELECT 
	d.doctor_id, 
    concat(d.first_name, ' ', d.last_name) as full_name, 
    min(a.admission_date) as first_admission_date, 
    max(a.admission_date) as last_admission_date
FROM admissions a
left join doctors d on d.doctor_id = a.attending_doctor_id
group by d.doctor_id;

--Display the total amount of patients for each province. Order by descending.

SELECT pn.province_name, count(p.province_id) as patient_count
FROM patients p
Left join province_names pn on p.province_id = pn.province_id
group by pn.province_name
order by patient_count desc;

--For every admission, display the patient's full name, admission diagnosis, and the doctor's full name who diagnosed their problem.

SELECT concat(p.first_name, ' ', p.last_name) as patient_name, 
	diagnosis, 
    concat(d.first_name, ' ', d.last_name) as doctor_name
FROM patients p
join admissions a on p.patient_id = a.patient_id
join doctors d on d.doctor_id = a.attending_doctor_id;

/*Display the first name, last name, and number of duplicate patients based on their first name and last name.
Ex: A patient with an identical name can be considered a duplicate.
*/
SELECT first_name, last_name, count(*) as num_of_duplicate
FROM patients
group by first_name, last_name
having num_of_duplicate > 1;

/*Display the patient's full name,
height in the unit feet rounded to 1 decimal,
weight in the unit pounds rounded to 0 decimals,
birth_date,
gender non-abbreviated.
Convert CM to feet by dividing by 30.48.
Convert KG to pounds by multiplying by 2.205.
*/
SELECT concat(first_name,' ', last_name) as patient_name, 
	round(height/30.48, 1) as 'height "Feet"', 
    round(weight*2.205) as 'weight "Pounds"', 
    birth_date, 
    case 
    	when gender = 'M' then 'Male'
        when gender = 'F' Then 'Female'
    end as gender_type
FROM patients

--Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)

SELECT p.patient_id, first_name, last_name
FROM patients p
left join admissions a on p.patient_id = a.patient_id
-- The below solution will also work without using not in
-- where a.patient_id is null
where p.patient_id not in (
  select a.patient_id
  from admissions a
);
