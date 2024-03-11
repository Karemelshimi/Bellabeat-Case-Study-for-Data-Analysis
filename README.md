# Bellabeat-Case-Study-for-Data-Analysis

Title: Bellabeat Case Study

Author: Kareem Mohamed

Date: March 8,2024

## Reference

1 <a href="#ask" id="toc-ask">Ask</a>

2 <a href="#prepare" id="toc-ask">Prepare</a>

3 <a href="#process" id="toc-ask">Process</a>

4 <a href="#analyze" id="toc-ask">Analyze</a>

5 <a href="#share" id="toc-ask">Share</a>

6 <a href="#act" id="toc-ask">Act</a>


## Scenario
Bellabeat is a high-tech manufacturer of health-focused products for women it believes that analyzing smart device fitness data could help unlock new growth opportunities for the company.
I have been asked to focus on one of Bellabeat’s products and analyze smart device data to gain insight into how consumers are using their smart devices, then using these insights it will help guide the marketnig strategy for the company.

# Ask
Business Task: Analyzing the smart device usage data by Fitbit and get valuable insights then making recommendations based on these trend to help guide the marketing strategy.

#### Key Stakeholders

##### Primary
Urška Sršen: Bellabeat’s cofounder and Chief Creative Officer.

Sando Mur: Mathematician and Bellabeat’s cofounder; key member of the Bellabeat executive team.

##### Secondary
Bellabeat marketing analytics team.

# Prepare
This Kaggle data set contains personal fitness tracker from thirty fitbit users https://www.kaggle.com/datasets/arashnic/fitbit by Mobius.

Thirty eligible Fitbit users consented to the submission of personal tracker data.
It contains 18 CSV files that iclude daily activity, daily steps, daily calories, daily intensities, hourly steps, hourly intensities, hourly calories, heartrat seconds, minute calories narrow and wide, minute intensities narrow and wide, minute steps narrow and wide, sleep day, and weight log info.

The data is stored in csv files, the data contains files that have data long and wide format but most of the csv files are long formated.
I measured the data and its credibility and it is not reliable as it only contains data about 30 fitbit users, which is not enough to make reliable insights.
the originality of the data is derived from 30 legit fitbit users who participated in a survey via Amazon Mechanical Turk between 3/12/2016 and 5/12/2016.
The data is biased and not comprehensive as the sample size is small and should have been bigger to make better predictions and eliminate the bias in the data, and the data also is outdated as it was collected in 2016 and it should contain data from march to may of 2016 but it only shows data for 31 one day from april to may so it has some missing data.

The data is not cited or lincenced.

# Process
What tools did i choose and why?

I cleaned the data using Excel and SQL because its easy to manipulate the data there and clean it because it is stored as csv files. 
I also did some cleaning in R that will be documented as well.

### Documantation of data cleaning in Excel :
---------------------------------------------
- I started by changing the data format for each file because the date was formated wrong as it was general and it was writen in a format dd/mm/yyyy which made the date to be for december and janury rather than being for april and may, i changed the format by using text to colmns and turned all the dates in the files to date in the correct format mm/dd/yyy.
- I sorted the data by date from oldest to newest.
- Then i checked for duplicated in each file ( Dailysteps had only 1 duplicate/ hourly calories had 987 duplicates/ hourly intensities had 1108 duplicated/ hourly steps had 1075 duplicates/ sleep day had 3 duplicates/ minute sleep had 629 duplicates ) and i removed them from the sheets.
- In the sleep day sheet i added a column named (hoursofsleep) by deviding the total minutes asleep by 60 to know how many ours each user sleeps.

### Documantation of data cleaned in SQL :
---------------------------------------------
- Then i used SQL to clean the data more and join some tables, i joined tables to see if there is any data that is not needed so i joined daily_activity with daily_steps and daily_intensitites and daily_clories. daily_activity had the same data that was in the other 3 tables so i dropped the other 3 tables (daily_steps - daily_calories - daily_intensities) because they wont be needed any more as daily_activity contains all of them combined.
- I used Count function in SQL to identify the distinct users in each table.
- The daily_activity, hourly_steps, hourly_calories and hourly_intensities tables showed {33} distinct users and sleep_day showed {24} distinct users , weight_loginfo showed only {8} distinct users.

### Documantation of data cleaned in RStudio
---------------------------------------------
- I start by incpecting the data and checking if there is anything that needs any adjustments.
```{r}
str(daily_activity)
glimpse(daily_activity)
colnames(daily_activity)
sapply(daily_activity, class)
```
- Change Data Type to Date in Dataframes

to change the data type of `ActivityDay` from `Chr` to `Date` i had to make a new column for the date because when i changed the date type the date gets `N/A` values so i had to add a new column with the right data type.
```{r}
daily_activity$new_date <- dmy(daily_activity$ActivityDay)
hourly_calories$new_date <- dmy(hourly_calories$ActivityDay)
hourly_intensities$new_date <- dmy(hourly_intensities$ActivityDay)
hourly_steps$new_date <- dmy(hourly_steps$ActivityDay)
minute_sleep$new_date <- dmy(minute_sleep$date)
sleep_day$new_date <- dmy(sleep_day$SleepDay)
weight_loginfo$new_date <- dmy(weight_loginfo$Date)
```
- Adding Column for Month

using the `month()` function to add column for month to be used in the analysis 

```{r}
daily_activity$month <- month(daily_activity$new_date)
hourly_calories$month <- month(hourly_calories$new_date)
hourly_intensities$month <- month(hourly_intensities$new_date)
hourly_steps$month <- month(hourly_steps$new_date)
minute_sleep$month <- month(minute_sleep$new_date)
sleep_day$month <- month(sleep_day$new_date)
weight_loginfo$month <- month(weight_loginfo$new_date)
```
- Add Column for Weekdays
Adding weekdays column to study the different habits of users during the week and see if there are any patterns. 

```{r}
daily_activity$week_days <- weekdays(daily_activity$new_date)
sleep_day$week_days <- weekdays(sleep_day$new_date)
```

- Changing Column Names to Lowercase

changing column names to lowercase letters using `rename_with`.

```{r}
daily_activity_new <- daily_activity %>%
  rename_with(tolower)
hourly_calories_new <- hourly_calories %>%
  rename_with(tolower)
hourly_intensities_new <- hourly_intensities %>%
  rename_with(tolower)
hourly_steps_new <- hourly_steps %>%
  rename_with(tolower)
minute_sleep_new <- minute_sleep %>%
  rename_with(tolower)
sleep_day_new <- sleep_day %>%
  rename_with(tolower)
weight_loginfo_new <- weight_loginfo %>%
  rename_with(tolower)
```
-Renaming Columns
renaming the table `activitydate` to `date` in all data frames that needs to be adjusted
```{r}
names(daily_activity_new)[names(daily_activity_new)== "activityday"] <- "date"
names(hourly_calories_new)[names(hourly_calories_new)== "activityday"] <- "date"
names(hourly_intensities_new)[names(hourly_intensities_new)== "activityday"] <- "date"
names(hourly_steps_new)[names(hourly_steps_new)== "activityday"] <- "date"
```
- Checking Updates
```{r}
names(daily_activity_new)
names(hourly_calories_new)
names(hourly_intensities_new)
names(hourly_steps_new)
```
- Delete N/A values 

I deleted column dateday in `daily_activity_new` and i also deleted the columns in `sleep_day_new` data frame that had no values in them and as well all the `N/A` values in other data frames.

```{r}
daily_activity_new <- subset(daily_activity_new, select = -dateday)
sleep_day_new <- subset(sleep_day_new, select = -...8)
sleep_day_new <- subset(sleep_day_new, select = -...9)
sleep_day_new <- na.omit(sleep_day_new)
weight_loginfo_new <- na.omit(weight_loginfo_new)
hourly_steps_new <- na.omit(hourly_steps_new)
hourly_intensities_new <- na.omit(hourly_intensities_new)
minute_sleep_new <- na.omit((minute_sleep_new))
```
After deleting the N/A values from the `weight_loginfo_new` there are only two users that are left with complete data so this data frame will not be used because it is unreliable.

- Drop Dataframes

now that i have the new updated and cleaned data frames i will delete the original once because they are not needed for the analysis, and i also deleted `weight_loginfo_new` and `minute_sleep_new` because they are not usefule in the analysis.
```{r}
rm(daily_activity)
rm(hourly_calories)
rm(hourly_intensities)
rm(hourly_steps)
rm(minute_sleep)
rm(sleep_day)
rm(weight_loginfo)
rm(weight_loginfo_new)
rm(minute_sleep_new)
```
# Analyze
First i start the analyzing by doing summary on all the data frames that i have using the `summary()` function to know the `min`, `max`, `median`, and `mean` of the data to get some valuble insights.

### Daily Activity
The average steps for users are 7638 step per day in an average distance of 5490 km.
The average very active distance is 1.5km in an average time of 21.16 minutes.
The max very active distance is 21.9 km in a max time of 3.5 hours.
The average moderately active distance is 0.5675 k, in an average time of 13.9 minutes.
The average sedentary active distance is 0.001606 and the average sedentary active distance is 17.6 hours or 1058 minutes.
The max sedentary distance is 0.110000 and the max sedentary minutes is 24 hours or 1440 minutes.
```{r}
 summary(daily_activity_new)
```
![Screenshot (129)](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/b5af4881-e1f9-48b3-a406-f230116e365a)
### Hourly Calories
Hourly minimum calories is 42 and the average calories per hour is 83, the max calories is 948 calories
```{r}
summary(hourly_calories_new)
```
![Screenshot (130)](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/e5c21c5b-467a-45d7-b92c-7fbe5f875729)
### Sleep Day
The minimum sleep records is 1 record and the max sleep record is 3 and the average is 1.12.
The min time asleep is 1 hour and the average time asleep is about 7 hours and the max time asleep is  13.3 hours.
```{r}
summary(sleep_day_new)
```
![Screenshot (131)](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/370e84f6-d35b-4502-acc0-ec50a9482d36)

### Hourly Steps
The average hourly steps is 333.5 step per hour.
The max recorded step is 10554.
```{r}
summary(hourly_steps_new)
```
![Screenshot (133)](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/240c1afc-b32b-4982-913d-a01e768f0a0e)

### Hourly Intensities
The average hourly intensities is 12.64.
The max hourly intensities is 180.
```{r}
summary(hourly_intensities_new)
```
![Screenshot (134)](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/d1f8f89b-0e10-4a0a-b1ae-16a44ffde34c)

# Share

### Daily Activity

##### Most Total Steps in Week Days

The next visualization shows what weekdays have the highest total steps to see when the users walked the, and as it shows using the `geom_smooth()` we can see that during  Sunday and Saturday had the highest total steps of all week days.
```{r}
ggplot(data = daily_activity_new, mapping = aes(x = totalsteps, y = week_days)) +
  geom_smooth(aes(color = week_days)) +
  labs(title = " Highest Total Steps in Weekdays") +
  labs(x = "Total Steps", y = "Week Days")
```
![Highest Total Steps in Weekdays](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/192b24e3-7be4-4676-9d9b-5a8562d71b28)

And this visualization shows week days with the most total steps, as you can see that Tuesday and Wednesday have the most total steps of the week days
i used the sum function to know which day has the most overall steps.
```{r}
ggplot(daily_activity_new, aes(x = week_days, y = sum(totalsteps), fill = week_days)) +
         geom_bar(stat = "identity") +
         labs(title = "Total Steps in Weekdays") +
         labs(x = "Week Days", y = "Total Steps")
```
![Total Steps in Weekdays](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/ef9b560a-fe5f-4fb7-96d0-b94fbcc17c90)

#### TotalSteps VS Calories

This visualization show the `TotalSteps vs Calories`as you can see that there is a positive  correlation between the total steps and the calories burned, as the steps increase the calorie burning increases, at the same time people could be in the same step range like others but burn more calories.
```{r}
ggplot(data = daily_activity_new, mapping = aes(x = totalsteps, y = calories, color = new_date)) +
  geom_point() + geom_smooth(aes(y = calories), color = "red") +
  labs(title = "Totalsteps vs Calories") +
  labs(x = "Total Steps", y = "Calories") +
  annotate("text", x = 32000, y = 2500, label = "Highst Total Steps") +
  annotate("text", x = 20000, y = 4700, label = "Highst Total Calories")
```
![TotalSteps VS Calories](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/fafc025a-4aef-4cb9-9b68-0739cef00464)

### Activiy Minutes vs Calories
These visualizations compare different types of activity minutes to the burned calories.
#### Lightly Active Minutes
The visualization shows how the lightly active minutes done by users affects the calories burned, you can see that when the minutes increase the calories being burned also increase.
But also it shows that some cases have more lightly activity minutes but at the same time they burn the same amount of calories as the users who did fewer minutes.

```{r } 
ggplot(data = daily_activity_new, mapping = aes(x = calories, y = lightlyactiveminutes, color = new_date)) +
  geom_point() +
  geom_smooth(aes(y = lightlyactiveminutes), color = "green") +
  labs(title = "Lightly Active Minutes vs Calories") +
  labs(x ="Calories", y = "LightlyActiveMinutes")
```
![Lightly Active Minutes](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/ac7f3b32-2001-4b0e-86f3-d0f0441ec938)
#### Very Active Minutes
This visualization compares the `Very Active Minutes` show that when the activity minutes increase the burned calories also increase indicating that there is a positive correlation between very active minutes and calories burned, but at the same time people with 0 minutes that are very active also burn calories a lot.
```{r}
ggplot(data = daily_activity_new, mapping = aes(x = calories, y = veryactiveminutes, color = new_date)) +
  geom_point() +
  geom_smooth(aes(y = veryactiveminutes), color = "yellow") +
  labs(title = "Very Active Minutes vs Calories") +
  labs(x = "Calories", y = "VeryActiveMinutes")
```
![Very Active Minutes](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/37304dd3-42e1-419d-9a11-95ced82b8a2e)
#### Fairly Active Minutes
There is also a positive correlation between fairly active minutes and calories burned, as the minutes increase the calories burned also increase.
```{R}
ggplot(data =daily_activity_new , mapping = aes(x = calories, y = fairlyactiveminutes, color = new_date)) +
  geom_point() +
  geom_smooth(aes(y = fairlyactiveminutes), color = "orange") +
  labs(title = "Fairly Active Minutes vs Calories") +
  labs(x = "Calories", y = "FairlyActiveMinutes")
```
![Fairly Active Minutes](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/24f17d98-f4bb-45dc-ae45-748e921a2bcd)
#### Sedentary Minutes
The visualizations indicates that people who spend little time in sedentary activity burn calories but it as well shows that people with higher sedentary minutes also burn the same amount of calories, so there is no correlation between sedentary minutes and burning calories. 
This could mean that the sedentary minutes in some cases affect the calories burned or doesn't affect it, it's hard to make that decision based on this information so i would not rely on it.
```{r}
ggplot(data = daily_activity_new, mapping = aes(x = calories, y = sedentaryminutes, color = new_date)) +
  geom_point() +
  geom_smooth(aes(y = sedentaryminutes), color = "red")+
  labs(title = "Sedentary Minutes vs Calories") +
  labs(x ="Calories", y = "SedentaryMinutes")
```
![Sedentary Minutes](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/3e21d788-db1e-48e4-8360-981ce4b4749f)

## Sleep Day
Merging two data frames together `sleep_day_new` and `daily_activity_new` to see if the sleeping hours affect the burning fo calories or not.
First merging the data using merge() and creating a new data frame called `sleep_X_activity`.
```{r}
sleep_X_activity <- merge(sleep_day_new, daily_activity_new, by = c('id', 'new_date'))
```
#### Sleeping Hours vs Calories
This visualization show that the sleeping hours has no impact on the calories burned as there is no clear pattern, it changes randomly so its not a direct factor.
```{r}
ggplot(data = sleep_X_activity, mapping = aes(x = hoursofsleep, y = calories, color = calorie))+
  geom_smooth(color = "red") +
  labs(title = "Hours of Sleep vs Calories") +
  labs(x = "HoursOfSleep", y = "Calories")
```
![Sleeping Hours vs Calories](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/555f7485-005a-4d45-ba8b-095a03fd8a67)


#### Total Minutes Asleep in Week Days
The visualization shows that Wednesday's are the most days in the week that users have the highest total minutes asleep in.
```{r}
ggplot(data = sleep_day_new, mapping = aes(x = week_days, y = totalminutesasleep, fill = week_days)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Minutes Asleep in Week Days") +
  labs(x = "Week Days", y = "Minutes Asleep")
```
![Total Minutes Asleep in Week Days](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/d3ee6608-e2ad-48a2-b59e-b34145184d6a)

## Hourly Steps

#### Activity Hour With the Most Steps
With this visualization you can see what activity hour of the day the users do the most steps in, as you can see using the `geom_col()` the visualization shows that users do the most steps between 12pm and 7pm users do the most steps, and the lowest is between 12am and 4am.
```{r}
ggplot(data = hourly_steps_new, mapping = aes(x = activityhour, y = steptotal, fill = activityhour)) +
  geom_bar(stat = "identity")+
  labs(title = " Most Steps During The Day") +
  labs(x = "Activity Hour", y = "Step Total")
```
![Activity Hour With the Most Steps](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/a69ebbe3-855f-4831-853d-2f0a6d7b4f74)

## Hourly Calories
This visualization shows the hourly calories burned and as we can see that the most calories burned is between 4pm and 8pm and then gradualy goes down.
The lowest calorie burning is between 12am and 4am.
```{r}
ggplot(data = hourly_calories_new, mapping = aes(x = activityhour, y = calories, color = calories)) +
  geom_smooth(color = "red") +
  labs(title = "Hourly Calories Burned") +
  labs(x = "Activity Hour", y ="Calories")
```
![Hourly Calories](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/fdef219a-e165-48d6-8684-f80baf8c219d)
## Hourly Intensities
The intensities match the hourly burning calories as the highest intensities the user have during the day are between 12pm and 7pm and then starts to go down after that.
The lowest intensity is between 12am and 4am.
```{r}
ggplot(data = hourly_intensities_new, mapping = aes(x = activityhour, y = totalintensity, fill = activityhour))+
  geom_bar(stat = "identity") +
  labs(title = "Hourly Intensities") +
  labs(x = "Activity Hour", y = "Total Intensity")
```
![Hourly Intensities](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/482a4b5f-77c8-4991-a78b-9502fb2d3db2)

Now we will merge two data frames together to get insight about the calories burned and the intensities.
```{r}
calories_x_intensity <- merge(hourly_calories_new, hourly_intensities_new, by = c('id', 'new_date'))
```
As you can see when the total intensity goes higher the burned calories increas so there is a positive correlation between the two factors.
```{r}
ggplot(data = calories_x_intensity, mapping = aes(x = calories, y = totalintensity)) +
  geom_smooth()+
  labs(title = "Total Intensity vs Calories")+
  labs(x = "Calories", y= "Total Intensity")
```
![Calories vs Intensities](https://github.com/Karemelshimi/Bellabeat-Case-Study-for-Data-Analysis/assets/153403784/3147a8b5-5d40-4111-8110-591f83b64551)

# Act

After analyzing the data as you can see that fitbit can know their users habits and how active they are, how their day usualy looks like and how it organized by their activity as in light, fair, very, or just in sedentary. Knowing how the consumer sleeps and their habits and when they go to sleep , how much time do they take to actualy go to sleep all of this information can help them understand their user's. fitbit having this data can use it to actualy connect with their users and know them better and even help them in their daily life. Bellabeat should use the same information gathering methods, if bellabeat had access to same data for the users that they have they would help women by inetracting with them, telling them what they are lacking and what is best for them to improve their health and general life style, as well as connecting with them and creating strong customer bond and a great realtionship by making women trust them when they see a significant change in their life based on the recommendations that bellabeat can make for each one of them according to the user's statistics.

### Statistical summary of the analysis show these device usage trends :
- The highest total steps were on sunday's and saturday's.
- The most total steps of the week days were on tuesday's and wednesday's.
- The users spend 3 hours of their day in lightly activity which made them burn calories adn stay healthy.
- The users spend at least 20 minutes doing very active activity.
- The users spend an average of 13 min daily on fairly activity.
- On the average the users spend 16.5 hours in sedentary avtivity which is 68.7% of the day.
- users sleep on average 7 hours and they spend around 30 minutes in bed before they sleep and they sleep more hours on wednesday's.
- users are most active between 12pm and 7pm as they do the most steps that time.
- users tend to burn the most calories from 12pm and 7pm and the lowest calories they burn is between 12am and 4am, they match their calorie burning with their intensity hours, the highest intensity of their day is between 12pm and 7pm and the lowest intensity is between 12am and 4am.

### Recommendations

By using the welnees tracker bellabeat can gather data to know their user's behavior like fitbit and using this information they can inform their users after watching their habit for a month with what they should adjust to make their life better and healthier For Example:

- Knowing their bad days of sleep and finding a pattern like for example they sleep less on monday's because they tend to stay up more and they go to bed late so they sleep less hours than the rest of the week, so bellabeat can find this pattern when gathering the data and build a health check summary every week for their users with the most impartant changes and stuff that affect their welnees to notify them about these changes and it can be used for alot of other stuff to notify them about not just the sleeping hours.
- They can inform their users if they are sitting long time by checking the step counter if it havent moved for specific amount of time and giving them notification on the app so they would know that they should be more active and get up.
- Letting them know that the day is almost ending if they haven't done their average steps for the day.
- showing the user's their intensity counter and setting a goal for them to achive it daily.
- Doing competitions on the app for example for hitting a max intensity or max steps and giving them a specific gift or just making it to creat a motivational environment for them to achieve what they need.
