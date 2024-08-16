// Load the IBESDATA.xlsx file
import excel "/Users/merlin/Downloads/IBESDATA.xlsx", sheet("Sheet1") firstrow clear

// Data Cleaning
// Generate the age variable using 2016 as the reference year
gen age = 2016 - year

// Remove firms established before 1950 and after 2014
drop if year < 1950 | year > 2014


foreach x in legal_status region_name worker_sex profit_cat {
	encode `x', generate(new_`x')
}

// Generate a boxplot of the profit variable and comment on the result
graph box profi_main, title("Boxplot of Profit")

// Handle firms reporting zero profit and profit above GH₵19561.91
replace profi_main = . if profi_main == 0 | profi_main > 19561.91

// Generate a new boxplot after dealing with the problem
graph box profi_main, title("Boxplot of Profit After Cleaning")

// Data Exploration
// Generate a scatter plot of age and profit
scatter profi_main age, title("Scatter Plot of Age and Profit") xtitle("Age") ytitle("Profit")



// Generate another scatter plot of age and profit by region
twoway (scatter profi_main age, by(new_region_name)), xtitle("Age") ytitle("Profit")

// Generate a bar graph of profit (using the qualitative measure) and region with column percentages

ssc install catplot
catplot new_profit_cat  new_region_name  ,percent(new_region_name ) title("Bar Graph of Profit by Region - Column Percentages") 

// Generate a bar graph of profit (using the qualitative measure) and region with row percentages
catplot new_profit_cat  new_region_name  ,percent(new_profit_cat) title("Bar Graph of Profit by Region - Row Percentages")

// Hypothesis Testing and Linear Regression
// Test if men and women have equal job opportunities
ta new_worker_sex, generate(new_worker_sex)
prtest new_worker_sex1 == new_worker_sex2 


// Test if employing more males or females affects profit
ttest profi_main, by(new_worker_sex)

// Identify if male-dominated employees are more efficient than female-dominated employees
regress profi_main male_employees female_employees

// Relationship between region of operation and profitability
anova profi_main region

// Effect of age and number of male and female employees on profitability
regress profi_main age male_employees female_employees

