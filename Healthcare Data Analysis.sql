Create database healthcare;
use healthcare;
create table Patients(
patient_id int not null,
name text,
age int,
gender text,
blood_type text);
create table medical_records(
record_id int not null,
patient_id int,
medical_condition text,
medication text,
test_results text);
create table admission(
admission_id int not null,
patient_id int,
date_of_admission date,
doctor text,
hospital text,
room_number int,
admission_type text,
discharge_date date);
create table billing(
billing_id int not null,
patient_id int,
insurance_provider text,
billing_amount float);

-- What is the total number of patients in the dataset?
Select count(distinct patient_id) as Num_of_patients from patients;

-- How many patients were admitted in each hospital?
Select hospital,count(distinct Patient_id) as Num_of_patients from admission group by hospital;

-- What are the top 5 most common medical conditions?
Select medical_condition,count(medical_condition) as Num_of_Cases from medical_records group by medical_condition order by Num_of_Cases desc limit 5;

-- What is the average billing amount per hospital?
Select Hospital,round(Avg(billing_amount),2) as Avg_bill from billing inner join admission on admission.patient_id=billing.patient_id group by Hospital order by Avg_bill desc;

-- Which insurance provider has the highest total billing amount?
Select Insurance_provider,round(sum(billing_amount),2) as Highest_tot_billing from billing group by Insurance_provider order by Highest_tot_billing desc limit 1;

-- How many patients were admitted each year?
Select year(date_of_admission) as Admission_Year,count(patient_id) as Num_of_patients from admission group by year(date_of_admission) order by Admission_Year asc;

-- What is the average length of stay for each admission type?
Select admission_type,avg(datediff(discharge_date,date_of_admission)) as avg_stay_length from admission group by admission_type;

-- What is the distribution of patients by age group?
Select case
			when age<18 then '0-17'
            when age between 18 and 35 then '18-35'
            when age between 36 and 55 then '36-55'
            when age between 56 and 70 then '56-70'
            else '70+'
            end as age_group , count(patient_id) as Num_of_patients from patients group by age_group order by age_group asc;
            
-- How does billing amount vary by gender and medical condition?
Select gender,medical_condition, round(sum(billing_amount),2) as tot_bill from billing inner join medical_records on medical_records.patient_id=billing.patient_id inner join patients on patients.patient_id=billing.patient_id group by medical_condition,gender order by tot_bill desc ;

-- Which month has the highest number of admissions?
Select monthname(date_of_admission) as Admission_month, count(patient_id) as Num_of_patients from admission group by Admission_month order by Num_of_patients desc limit 1;

-- What is the average billing amount by year?
Select Year(date_of_admission) as Year, round(avg(billing_amount),2) as Avg_bill from billing inner join admission on admission.patient_id=billing.patient_id group by year order by year asc; 

-- Which doctor has handled the most cases?
Select doctor, count(patient_id)as Num_of_cases from admission group by doctor order by Num_of_cases desc limit 1;

-- Which hospital has the highest average billing per patient?
Select hospital, round(avg(billing_amount),2) as avg_bill from billing inner join admission on admission.patient_id=billing.patient_id group by hospital order by avg_bill desc limit 1;

-- Which doctor has the shortest average patient stay?
Select doctor, avg(datediff(discharge_date,date_of_admission)) as avg_stay from admission group by doctor order by avg_stay asc limit 1;

-- What is the distribution of test results by medical condition?
Select test_results,medical_condition,count(patient_id) as distribution from medical_records group by test_results,medical_condition order by distribution desc;

-- Which medication is prescribed most frequently per condition?
Select medication,medical_condition,count(patient_id) as num_of_prescription from medical_records group by medication,medical_condition order by num_of_prescription desc;

-- Which insurance providers cover the most patients?
Select distinct insurance_provider, count(patient_id) as Num_of_patients from billing group by insurance_provider order by Num_of_patients desc;

-- Which room number range is most frequently assigned?
Select case
when room_number<101 then '0-100'
when room_number between 101 and 200 then '100-200'
when room_number between 201 and 300 then '200-300'
when room_number between 301 and 400 then '300-400'
else '400-500'
end as room_number_range, count(*) as Num_of_cases from admission group by room_number_range order by Num_of_cases desc limit 1;

-- List the top 10 patients with the highest billing amount.
Select distinct Name, billing_amount from patients inner join billing on billing.patient_id=patients.patient_id order by billing_amount desc limit 10;

-- Find cases where the length of stay was unusually long (>30 days).
Select admission_id, datediff(discharge_date,date_of_admission) as len_of_stay from admission having len_of_stay>=30;

-- Which medical condition has the longest average hospital stay?
Select medical_condition, avg(datediff(discharge_date,date_of_admission)) as Avg_stay from medical_records inner join admission on admission.patient_id=medical_records.patient_id group by medical_condition order by avg_stay desc;

-- Which combination of condition and medication is most common?
Select medical_condition,medication, count(*) as Count from medical_records group by medical_condition,medication order by count desc;

-- What is the average age of patients for each condition?
Select medical_condition, avg(age) as avg_age from patients inner join medical_records on medical_records.patient_id=patients.patient_id group by medical_condition;

-- Which condition has the highest average billing amount?
Select medical_condition,round(avg(billing_amount),2) as avg_bill from billing inner join medical_records on medical_records.patient_id=billing.patient_id group by medical_condition;

-- Are emergency admissions costlier than elective or urgent?
Select avg(billing_amount)as avg_cost,admission_type from billing inner join admission on admission.patient_id=billing.patient_id group by admission_type order by avg_cost desc;

-- What is the correlation between length of stay and billing amount?
Select datediff(discharge_date,date_of_admission) as length_of_stay, billing_amount from admission inner join billing on billing.patient_id=admission.patient_id order by length_of_stay desc;

-- Do younger or older patients visit hospitals more often?
Select Case
when age<31 then 'young'
when age between 65 and 100 then 'old'
else 'regular'
end as age_group, Count(*) as Count from patients group by age_group;

-- Which gender has higher average medical costs?
Select gender, round(avg(billing_amount),2) as medical_cost from billing inner join patients on patients.patient_id=billing.patient_id group by gender order by medical_cost desc;

-- Which hospital has the lowest average length of stay?
Select Hospital, avg(datediff(discharge_date,date_of_admission)) as avg_stay from admission group by hospital order by avg_stay asc limit 1;

-- Find cases where patients with the same doctor had very different billing amounts.
Select doctor, min(billing_amount) as min_bill, max(billing_amount) as max_bill, max(billing_amount)-min(billing_amount) as diff_bill from billing inner join admission on admission.patient_id=billing.patient_id group by doctor having diff_bill>10000;

-- List doctors with the highest average billing per patient.
Select doctor, round(avg(billing_amount),2) as Avg_billing from admission inner join billing on billing.patient_id=admission.patient_id group by doctor order by Avg_billing desc;

-- Is there a difference in test results by age group?
Select case
when age<18 then '0-17'
when age between 18 and 31 then '18-30'
when age between 30 and 56 then '30-55'
when age between 55 and 76 then '55-75'
else '75+' end as age_group, test_results, count(*) as count from medical_records inner join patients on patients.patient_id=medical_records.patient_id group by age_group,test_results order by age_group;

-- Which hospital handles the most complex cases (most unique medical conditions)?
Select hospital,medical_condition,count(medical_condition) as cases from admission inner join medical_records on medical_records.patient_id=admission.patient_id group by hospital, medical_condition order by cases asc;

-- Which gender has a higher average length of hospital stay?
Select gender,avg(datediff(discharge_date,date_of_admission)) as avg_length_of_stay from admission inner join patients on patients.patient_id=admission.patient_id group by gender order by avg_length_of_stay desc limit 1;

-- Which medications are prescribed most often in emergency admissions?
Select medication, admission_type, count(*) as Count_of_prescription from medical_records inner join admission on admission.patient_id=medical_records.patient_id where admission_type like 'Emergency' group by medication, admission_type order by Count_of_prescription desc;

-- Which patients have been admitted more than once?
Select patient_id,name, count(patient_id) as admission_count from patients group by name, patient_id order by admission_count desc;

-- Which hospitals have the most recurring patients?
Select hospital, patient_id,count(patient_id) as Count_of_admission from admission group by hospital,patient_id order by Count_of_admission desc;

-- Which room number has had the most unique patients?
Select room_number, count(distinct patient_id) as Patient_count from admission group by room_number order by Patient_count desc limit 1;

-- Which combinations of gender and condition are most common?
Select gender,medical_condition,count(*) as Combination_count from patients inner join medical_records on medical_records.patient_id=patients.patient_id group by gender,medical_condition order by combination_count desc;

-- Are certain conditions more common in specific age groups?
Select case
when age<18 then '0-17'
when age between 18 and 31 then '18-30'
when age between 30 and 56 then '30-55'
when age between 55 and 76 then '55-75'
else '75+' end as age_group,medical_condition,count(*) as condition_count from patients inner join medical_records on medical_records.patient_id=patients.patient_id group by age_group,medical_condition order by medical_condition desc;

-- Identify the longest hospital stay recorded in the dataset.
Select max(datediff(discharge_date,date_of_admission)) as length_of_stay from admission;

-- Find any patients with future discharge dates (after today).
Select * from admission where discharge_date>current_date;

-- Which insurance provider has the highest average billing per patient?
Select insurance_provider, round(avg(billing_amount),2) as avg_bill from billing group by insurance_provider order by avg_bill desc;

-- Which insurance provider is most used per medical condition?
Select insurance_provider, medical_condition,count(*) as Num_of_cases from billing inner join medical_records on medical_records.patient_id=billing.patient_id;

-- Which insurance providers are most common for patients above 60?
Select insurance_provider, count(distinct patients.patient_id) as patient_count from patients inner join billing on billing.patient_id=patients.patient_id where age>60 group by insurance_provider order by patient_count desc;

-- Which doctor treats the widest variety of conditions?
Select doctor, medical_condition, count(medical_condition) as Condition_count from medical_records inner join admission on admission.patient_id=medical_records.patient_id group by doctor,medical_condition order by Condition_count desc;

-- Which doctors have the highest total billing across all patients?
Select doctor,round(sum(billing_amount),2) as tot_bill from billing inner join admission on admission.patient_id=billing.patient_id group by doctor order by tot_bill desc limit 1;

-- Which doctor has the highest average billing per case?
Select doctor,round(avg(billing_amount),2) as avg_bill from billing inner join admission on admission.patient_id=billing.patient_id group by doctor order by avg_bill desc limit 1;

-- Which medications are linked to the highest billing costs?
Select medication, billing_amount from billing inner join medical_records on medical_records.patient_id=billing.patient_id group by medication,billing_amount order by billing_amount desc;

-- What are the most common medication and condition pairs?
Select medication,medical_condition, count(*) as Count from medical_records group by medication,medical_condition order by count desc;

-- Find any entries where discharge date is before admission date.
Select patient_id from admission where date_of_admission>discharge_date;

-- Are there duplicate rows in the patients dataset?
Select count(patient_id)-count(distinct patient_id) as duplicate_rows from patients;

-- Which hospitals have the highest patient load per doctor?
Select hospital,doctor,count(patient_id) as patient_count from admission group by hospital,doctor order by patient_count desc;

-- Average number of days patients spend in each hospital.
Select hospital,avg(datediff(discharge_date,date_of_admission)) as avg_days from admission group by hospital order by avg_days desc;

-- Identify peak admission days of the week.
Select dayname(date_of_admission) as day_name, count(*)as admission_count from admission group by day_name order by admission_count desc;

-- Find common hospital-condition pairs where billing is above average.
Select hospital,medical_condition, billing_amount from admission inner join medical_records on medical_records.patient_id=admission.patient_id inner join billing on billing.patient_id=medical_records.patient_id having billing_amount> (select avg(billing_amount) from billing);

-- Monthly trend in admissions over the years.
Select year(date_of_admission) as yearly, monthname(date_of_admission) as monthly, count(*) as admissions from admission group by Monthly,Yearly order by yearly,monthly asc;

-- Which month has the highest average billing amount?
Select monthname(discharge_date)as month,round(avg(billing_amount),2) as avg_bill from admission inner join billing on billing.patient_id=admission.patient_id group by month order by avg_bill desc;

-- Average daily admissions (for operational planning).
Select date_of_admission,count(date_of_admission) as admission_count from admission group by date_of_admission order by date_of_admission;

-- Which patients had the longest length of stay per condition?
Select p.name,m.medical_condition, datediff(discharge_date,date_of_admission) as length_of_stay from medical_records m inner join admission a on a.patient_id=m.patient_id inner join patients p on p.patient_id=a.patient_id group by m.medical_condition, length_of_stay,a.patient_id,name order by length_of_stay desc;

-- How many unique medications are prescribed per patient?
Select distinct medication,name, count(*)as count_of_prescription from medical_records inner join patients on patients.patient_id=medical_records.patient_id group by medication,name order by count_of_prescription;

-- List all patients discharged on the same day they were admitted.
Select name from patients inner join admission on admission.patient_id=patients.patient_id where date_of_admission=discharge_date;

-- Which room numbers are assigned most frequently per hospital?
Select hospital,room_number,count(room_number) as Count_of_Assigned from admission group by hospital,room_number order by Count_of_Assigned desc;

-- Average patients per room (proxy for resource congestion).
Select room_number, count(distinct patient_id) as avg_patient from admission group by room_number;

-- Which age groups are most affected by each condition?
Select case
when age<19 then '0-18'
when age between 18 and 36 then '18-35'
when age between 35 and 56 then '35-55'
when age between 55 and 71 then '55-70'
else '70+' end as age_group, medical_condition,count(*) as counts from medical_records inner join patients on patients.patient_id=medical_records.patient_id group by age_group,medical_condition order by counts desc;

-- Compare cost per condition for males vs females.
Select gender, round(sum(billing_amount),2) as tot_bill from patients inner join billing on billing.patient_id=patients.patient_id group by gender order by tot_bill desc;

-- Top 3 conditions by cost in each hospital.
Select hospital,medical_condition,count(*) as count from medical_records inner join admission on admission.patient_id=medical_records.patient_id group by hospital,medical_condition order by count desc limit 3;

-- Do certain doctors prefer prescribing specific medications?
Select doctor,medication, count(*) as count_of_prescription from admission inner join medical_records on medical_records.patient_id=admission.patient_id group by medication,doctor order by count_of_prescription desc;

-- Rank patients by total amount billed using window functions.
Select patient_id, sum(billing_amount) as tot_bill, rank() over (order by sum(billing_amount)desc) as billing_rank from billing group by patient_id;

-- Find the average length of stay per doctor compared to overall average.
Select doctor, datediff(discharge_date,date_of_admission) as len_of_stay,avg(datediff(discharge_date,date_of_admission)) as avg_len_of_stay from admission group by doctor,len_of_stay;

-- Find doctors with above-average billing variability.
Select doctor, billing_amount from admission inner join billing on billing.patient_id=admission.patient_id having billing_amount>(select avg(billing_amount) from billing);

-- Outlier detection: patients with billing 3x the standard deviation above mean.
with outlier as (Select avg(billing_amount) as mean_bill, stddev(billing_amount) as std_bill from billing)
select * from billing,outlier where billing_amount>(mean_bill+3*std_bill);

-- Build features: patient age group, condition, length of stay, and total billing.
Select case
when age<19 then '0-18'
when age between 18 and 36 then '18-35'
when age between 35 and 61 then '35-60'
when age between 60 and 76 then '60-75'
else '75+' end as age_group,medical_condition,datediff(discharge_date,date_of_admission) as len_of_stay,sum(billing_amount) as tot_bill from medical_records as m inner join admission a on a.patient_id=m.patient_id inner join billing b on b.patient_id=a.patient_id inner join patients p on p.patient_id=b.patient_id group by age_group, medical_condition,len_of_stay order by age_group asc;

-- Correlation base: Length of stay vs Billing amount.
Select datediff(discharge_date,date_of_admission) as len_of_stay, billing_amount from admission inner join billing on billing.patient_id=admission.patient_id order by len_of_stay asc;

-- Create billing summary rollups by hospital and condition.
Select hospital,medical_condition,count(*) as patient_count,round(sum(billing_amount),2) as tot_bill from medical_records inner join admission on admission.patient_id=medical_records.patient_id inner join billing on billing.patient_id=admission.patient_id group by medical_condition,hospital order by patient_count desc;

-- Group average billing by year and gender.
Select year(date_of_admission) as year, gender, round(avg(billing_amount),2) as avg_bill from billing inner join admission on admission.patient_id=billing.patient_id inner join patients on patients.patient_id=billing.patient_id group by year,gender order by year asc;

-- Compare average cost and stay for patients with ‘Normal’ vs ‘Abnormal’ test results.
Select test_results,round(avg(billing_amount),2) as avg_bill,avg(datediff(discharge_date,date_of_admission)) as avg_stay from medical_records inner join admission on admission.patient_id=medical_records.patient_id inner join billing on billing.patient_id=admission.patient_id group by test_results;

-- Build a cohort: All patients with ‘Diabetes’ treated by a specific doctor.
Select * from medical_records inner join admission on admission.patient_id=medical_records.patient_id where medical_condition='diabetes' and doctor='Katrina Luna';

-- Which condition-medication pairs have the highest repeat patients?
Select medical_condition,medication,count(distinct patient_id) as patient_count from medical_records group by medical_condition,medication order by patient_count desc;

-- For each doctor, what is the most frequent medication prescribed?
Select doctor,medication,count(medication) as prescription_freq from admission inner join medical_records on medical_records.patient_id=admission.patient_id group by doctor,medication order by prescription_freq desc;

-- Doctor performance index: total patients, avg billing, avg stay.
Select doctor, count(distinct admission.patient_id) as patient_count, round(avg(billing_amount),2) as avg_bill, avg(datediff(discharge_date,date_of_admission)) as avg_stay from admission inner join billing on billing.patient_id=admission.patient_id group by doctor order by patient_count desc;

-- Insurance efficiency: cost per day per patient.
Select Insurance_provider, round(avg(billing_amount/datediff(discharge_date,date_of_admission)),2) as Cost_per_day from billing inner join admission on admission.patient_id=billing.patient_id group by insurance_provider;

-- Lifetime value estimation (total billed per patient).
Select distinct patient_id, sum(billing_amount) as lifetime_value from billing group by patient_id order by lifetime_value desc;

-- Which admission types most often result in abnormal test results?
Select admission_type, test_results from admission inner join medical_records on medical_records.patient_id=admission.patient_id where test_results= 'abnormal';

-- Find hospitals where billing amount is very inconsistent.
Select hospital, min(billing_amount) as min_bill,max(billing_amount)as max_bill, max(billing_amount)-min(billing_amount) as Inconsistent_billing from billing inner join admission on admission.patient_id=billing.patient_id group by hospital order by inconsistent_billing desc;

-- Find records where billing is high but stay is short (possible outliers).
Select billing_id,billing_amount,datediff(discharge_date,date_of_admission) as len_of_stay from billing inner join admission on admission.patient_id=billing.patient_id where datediff(discharge_date,date_of_admission)<5 and billing_amount>40000;
