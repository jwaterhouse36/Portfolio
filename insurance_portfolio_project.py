# use 'insurance/csv' to perform exploratory data analysis

import csv

# create data variables to be used later
regions = []
location_count = {'northwest': 0, 'southwest': 0,
                  'northeast': 0, 'southeast': 0}
total_males = 0
total_males_bmi = 0
total_females = 0
total_females_bmi = 0

# open 'insurance.csv'
with open('insurance.csv') as insurance_csv:
    # convert insurance_csv into a usable dictionary
    insurance_reader = csv.DictReader(insurance_csv)
    for row in insurance_reader:
        # confirm the names of unique regions
        if row['region'] not in regions:
            regions.append(row['region'])
        # create a count of individuals in each region
        if row['region'] == 'northwest':
            location_count['northwest'] += 1
        if row['region'] == 'southwest':
            location_count['southwest'] += 1
        if row['region'] == 'northeast':
            location_count['northeast'] += 1
        if row['region'] == 'southeast':
            location_count['southeast'] += 1
        # find total number of males and females in data set
        if row['sex'] == 'male':
            total_males += 1
        if row['sex'] == 'female':
            total_females += 1
        # calculate sum of bmis for males and females
        if row['sex'] == 'male':
            total_males_bmi += round(float(row['bmi']), 2)
        if row['sex'] == 'female':
            total_females_bmi += round(float(row['bmi']), 2)

print('Sum of Male BMIs: ' + str(total_males_bmi) +
      ', Sum of Female BMIs: ' + str(total_females_bmi))
print('Total Males: ' + str(total_males) +
      ', Total Females: ' + str(total_females))


# create a function that will output the region with the most individuals
def max_individuals_location(location_count):
    max_location = ''
    max_location_count = 0
    for location in location_count:
        if location_count[location] > max_location_count:
            max_location_count = location_count[location]
            max_location = location
    return max_location, max_location_count


max_location, max_location_count = max_individuals_location(location_count)
print('\nThe region with the greatest number of individuals is ' + max_location + ' with a count of ' + str(
    max_location_count) + '.')


# create two functions that will output the average male and female bmis
def avg_male_bmi_calc(total_males_bmi, total_males):
    avg_male_bmi = round(total_males_bmi / total_males, 2)
    return avg_male_bmi


def avg_female_bmi_calc(total_females_bmi, total_females):
    avg_female_bmi = round(total_females_bmi / total_females, 2)
    return avg_female_bmi


avg_male_bmi = avg_male_bmi_calc(total_males_bmi, total_males)
avg_female_bmi = avg_female_bmi_calc(total_females_bmi, total_females)

print('\nAverage Male BMI: ' + str(avg_male_bmi))
print('Average Female BMI: ' + str(avg_female_bmi))
