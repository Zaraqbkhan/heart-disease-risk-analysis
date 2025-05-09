# Load required packages

library(dplyr)    
library(ggplot2)    
library(readr)


# Import the dataset

dataset <- read_csv("C:\\Users\\47462\\OneDrive\\Desktop\\Data Analyst\\Data Projects Folder\\R\\Satistical Analysis\\heart.csv")

View(dataset)

# Question:1 "What is the average cholesterol level among patients, and how precise is our estimate?"


# View the structure to ensure 'Cholesterol' is present
glimpse(dataset)

# Remove missing values in 'Cholesterol' if any
cholesterol_data <- dataset %>%
  filter(!is.na(Cholesterol))

# Calculate sample size (n), mean, and standard deviation
n <- nrow(cholesterol_data)

n

mean_chol <- mean(cholesterol_data$Cholesterol)
mean_chol

sd_chol <- sd(cholesterol_data$Cholesterol)

sd_chol

# Set confidence level (e.g., 95%) and calculate t-critical value

conf_level <- 0.95

alpha <- 1 - conf_level

t_critical <- qt(1 - alpha/2, df = n - 1)

# Compute margin of error

se <- sd_chol / sqrt(n)

margin_error <- t_critical * se

# Compute confidence interval
ci_lower <- mean_chol - margin_error

ci_upper <- mean_chol + margin_error

# Print results

cat("Sample size (n):", n, "\n")

cat("Mean cholesterol level:", round(mean_chol, 2), "\n")

cat("95% Confidence Interval: [", round(ci_lower, 2), ",", round(ci_upper, 2), "]\n")

# Create a density plot with CI highlighted
ggplot(cholesterol_data, aes(x = Cholesterol)) +
  geom_density(fill = "lightblue", alpha = 0.6) +
  geom_vline(xintercept = mean_chol, color = "blue", linetype = "dashed", size = 1.2) +
  geom_vline(xintercept = ci_lower, color = "red", linetype = "dotted", size = 1) +
  geom_vline(xintercept = ci_upper, color = "red", linetype = "dotted", size = 1) +
  labs(
    title = "Distribution of Cholesterol Levels with 95% Confidence Interval",
    subtitle = paste("Mean =", round(mean_chol, 2), 
                     "| 95% CI: [", round(ci_lower, 2), ",", round(ci_upper, 2), "]"),
    x = "Cholesterol",
    y = "Density"
  )

# Question:2 "What proportion of the sample population has heart disease, and how precise is our estimate?"

# Inspect HeartDisease variable
table(dataset$HeartDisease)

# Calculate sample size and proportion of patients with heart disease
n <- nrow(dataset)
p_hat <- mean(dataset$HeartDisease == 1)  # proportion with heart disease

# Calculate standard error for a proportion
se <- sqrt((p_hat * (1 - p_hat)) / n)

# Calculate 95% confidence interval using normal approximation
z_critical <- qnorm(0.975)  # for 95% CI
margin_error <- z_critical * se

ci_lower <- p_hat - margin_error
ci_upper <- p_hat + margin_error

# Print results
cat("Sample size (n):", n, "\n")
cat("Proportion with heart disease:", round(p_hat, 4), "\n")
cat("95% Confidence Interval: [", round(ci_lower, 4), ",", round(ci_upper, 4), "]\n")


# Prepare a dataframe for plotting
prop_df <- data.frame(
  Condition = "Heart Disease",
  Proportion = p_hat,
  CI_lower = ci_lower,
  CI_upper = ci_upper
)

# Create the bar chart with error bars
ggplot(prop_df, aes(x = Condition, y = Proportion)) +
  geom_bar(stat = "identity", fill = "tomato", width = 0.5) +
  geom_errorbar(aes(ymin = CI_lower, ymax = CI_upper), width = 0.1, color = "black", linewidth = 1) +
  ylim(0, 1) +
  labs(
    title = "Proportion of Patients with Heart Disease",
    subtitle = paste("95% CI: [", round(ci_lower, 3), ",", round(ci_upper, 3), "]"),
    x = "",
    y = "Proportion"
  ) +
  theme_minimal()


# Question: 3 "What is the average age of patients diagnosed with heart disease?"

# Filter data for patients who have heart disease (HeartDisease == 1)
heart_patients <- dataset %>%
  filter(HeartDisease == 1, !is.na(Age))

# Calculate sample size, mean, and standard deviation
n <- nrow(heart_patients)
mean_age <- mean(heart_patients$Age)
sd_age <- sd(heart_patients$Age)

# Compute standard error and t-critical value for 95% confidence
se <- sd_age / sqrt(n)
t_critical <- qt(0.975, df = n - 1)
margin_error <- t_critical * se

# Calculate confidence interval
ci_lower <- mean_age - margin_error
ci_upper <- mean_age + margin_error

# Display results
cat("Sample size (n):", n, "\n")
cat("Mean age of heart disease patients:", round(mean_age, 2), "\n")
cat("95% Confidence Interval: [", round(ci_lower, 2), ",", round(ci_upper, 2), "]\n")

# Create a boxplot of Age for heart disease patients, with mean and CI overlaid
ggplot(heart_patients, aes(x = "", y = Age)) +
  geom_boxplot(fill = "skyblue", width = 0.3, outlier.color = "red", outlier.shape = 8) +
  geom_point(aes(y = mean_age), color = "blue", size = 3, shape = 18) +
  geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper), width = 0.1, color = "black", linewidth = 1) +
  labs(
    title = "Age Distribution of Patients with Heart Disease",
    subtitle = paste("Mean Age:", round(mean_age, 2), "| 95% CI: [", round(ci_lower, 2), ",", round(ci_upper, 2), "]"),
    x = "",
    y = "Age"
  ) +
  theme_minimal()



                           ### One Sample Hypothesis Testing  ###

# Question: "Is the average resting blood pressure of patients significantly different from 130 mmHg?"


#  H_0: The mean resting blood pressure = 130 mmHg

# H_1: The mean resting blood pressure ≠ 130 mmHg (two-tailed test)


# Remove missing values from RestingBP
bp_data <- dataset %>%
  filter(!is.na(RestingBP))

# Calculate sample mean, standard deviation, and size
n <- nrow(bp_data)

mean_bp <- mean(bp_data$RestingBP)

sd_bp <- sd(bp_data$RestingBP)

# Define the hypothesized value

mu_0 <- 130

# Perform one-sample t-test

t_result <- t.test(bp_data$RestingBP, mu = mu_0)

# Print test results
print(t_result)


                 ### Two sample Hypothesis Testing  ###

# Question: "Do male and female patients have different average cholesterol levels?"


# Filter out missing values in Cholesterol or Sex
chol_sex_data <- dataset %>%
  filter(!is.na(Cholesterol), !is.na(Sex))

# Perform two-sample t-test (Welch's test for unequal variance)
chol_test <- t.test(Cholesterol ~ Sex, data = chol_sex_data)

# Print test result
print(chol_test)


# Calculate group means and sample sizes
group_stats <- chol_sex_data %>%
  group_by(Sex) %>%
  summarise(
    mean_chol = round(mean(Cholesterol), 2),
    n = n()
  )

# Get test result for p-value to display
p_val <- signif(chol_test$p.value, 3)

# Create the annotated boxplot
ggplot(chol_sex_data, aes(x = Sex, y = Cholesterol, fill = Sex)) +
  geom_boxplot(alpha = 0.6, outlier.color = "red", outlier.shape = 8) +
  geom_point(data = group_stats, aes(x = Sex, y = mean_chol), 
             color = "blue", size = 3.5, shape = 18) +
  geom_text(data = group_stats, aes(x = Sex, y = mean_chol + 5, 
                                    label = paste0("Mean: ", mean_chol, "\n(n = ", n, ")")), 
            color = "black", size = 3.5) +
  labs(
    title = "Cholesterol Levels by Sex",
    subtitle = paste0("Two-sample t-test result: p-value = ", p_val),
    x = "Sex",
    y = "Cholesterol (mg/dL)",
    caption = "Blue diamond = group mean. Red dots = outliers."
  ) +
  theme_minimal() +
  theme(legend.position = "none")

                          ### Linear Regression  ###



# Filter to remove missing values in MaxHR and Age
reg_data <- dataset %>%
  filter(!is.na(MaxHR), !is.na(Age))

# Fit linear regression model: MaxHR ~ Age
lm_model <- lm(MaxHR ~ Age, data = reg_data)

# View summary of the model
summary(lm_model)



# Create scatter plot with regression line
ggplot(reg_data, aes(x = Age, y = MaxHR)) +
  geom_point(alpha = 0.4, color = "darkgreen") +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "lightblue") +
  labs(
    title = "Linear Relationship Between Age and Maximum Heart Rate",
    subtitle = "Fitted regression line with 95% confidence interval",
    x = "Age (years)",
    y = "Maximum Heart Rate"
  ) +
  theme_minimal()


               ### Multiple Linear Regression  ###

## Question:  "Can we predict a patient’s maximum heart rate (MaxHR) using age, sex, and cholesterol levels?"



# Filter out missing values in relevant columns
multi_data <- dataset %>%
  filter(!is.na(MaxHR), !is.na(Age), !is.na(Sex), !is.na(Cholesterol))

# Fit multiple regression model
multi_model <- lm(MaxHR ~ Age + Sex + Cholesterol, data = multi_data)

# View model summary
summary(multi_model)


# Add predicted values and residuals
multi_data$Predicted_MaxHR <- predict(multi_model)

# Plot actual vs predicted MaxHR
ggplot(multi_data, aes(x = Predicted_MaxHR, y = MaxHR)) +
  geom_point(alpha = 0.4, color = "darkblue") +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "solid") +
  labs(
    title = "Actual vs Predicted Maximum Heart Rate",
    subtitle = "From multiple regression model using Age, Sex, and Cholesterol",
    x = "Predicted MaxHR",
    y = "Actual MaxHR"
  ) +
  theme_minimal()


          ### Random forrest Model ###

# Install and load package if not already
install.packages("randomForest")
library(randomForest)

# Ensure Sex is treated as a factor (categorical)
multi_data$Sex <- as.factor(multi_data$Sex)

# Fit the Random Forest model
set.seed(123)
rf_model <- randomForest(MaxHR ~ Age + Sex + Cholesterol, data = multi_data, importance = TRUE)

# View model summary
print(rf_model)

# Extract variable importance
importance_df <- as.data.frame(importance(rf_model))
importance_df$Variable <- rownames(importance_df)

# Bar plot of variable importance
library(ggplot2)

ggplot(importance_df, aes(x = reorder(Variable, `%IncMSE`), y = `%IncMSE`)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Variable Importance in Predicting MaxHR (Random Forest)",
    subtitle = "% Increase in MSE if variable is removed",
    x = "Predictor",
    y = "% Increase in MSE"
  ) +
  theme_minimal()


# Add predicted MaxHR from the random forest model
multi_data$RF_Predicted_MaxHR <- predict(rf_model)


ggplot(multi_data, aes(x = RF_Predicted_MaxHR, y = MaxHR)) +
  geom_point(alpha = 0.4, color = "darkgreen") +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(
    title = "Random Forest: Predicted vs Actual MaxHR",
    subtitle = "Dashed line indicates perfect prediction",
    x = "Predicted MaxHR (bpm)",
    y = "Actual MaxHR (bpm)"
  ) +
  theme_minimal()

# Optional: install if needed
install.packages("hexbin")
library(hexbin)

ggplot(multi_data, aes(x = RF_Predicted_MaxHR, y = MaxHR)) +
  geom_hex(bins = 30) +
  geom_abline(slope = 1, intercept = 0, color = "white", linetype = "dashed") +
  scale_fill_viridis_c(option = "C") +
  labs(
    title = "Random Forest Predicted vs Actual MaxHR (Hexbin View)",
    subtitle = "Brighter regions indicate denser predictions",
    x = "Predicted MaxHR",
    y = "Actual MaxHR"
  ) +
  theme_minimal()

   #### Logistic Regression ####

## Question : Can we predict the probability of heart disease based on Age, Sex, and MaxHR?


# Ensure variables are in the correct format
multi_data$HeartDisease <- as.factor(multi_data$HeartDisease)
multi_data$Sex <- as.factor(multi_data$Sex)

# Fit the model with Age, Sex, and MaxHR
logit_maxhr <- glm(HeartDisease ~ Age + Sex + MaxHR, 
                   data = multi_data, 
                   family = "binomial")

# View the model summary
summary(logit_maxhr)


exp(coef(logit_maxhr))  # Odds ratios


# Create sequences for Age and MaxHR
age_seq <- seq(min(multi_data$Age), max(multi_data$Age), length.out = 100)
maxhr_seq <- quantile(multi_data$MaxHR, probs = c(0.25, 0.5, 0.75), na.rm = TRUE)  # Use typical MaxHR levels

# Create grid for predictions
plot_data <- expand.grid(
  Age = age_seq,
  MaxHR = as.numeric(maxhr_seq),
  Sex = factor(c("M", "F"), levels = levels(multi_data$Sex))
)

# Predict probabilities
plot_data$HeartDisease_Prob <- predict(logit_maxhr, newdata = plot_data, type = "response")


# Label MaxHR levels for clarity in plot
plot_data$MaxHR_Label <- factor(
  paste("MaxHR =", round(plot_data$MaxHR)),
  levels = paste("MaxHR =", round(maxhr_seq))
)

ggplot(plot_data, aes(x = Age, y = HeartDisease_Prob, color = Sex)) +
  geom_line(size = 1.2) +
  facet_wrap(~ MaxHR_Label) +
  labs(
    title = "Predicted Probability of Heart Disease",
    subtitle = "By Age, Sex, and MaxHR Level",
    x = "Age (years)",
    y = "Probability of Heart Disease",
    color = "Sex"
  ) +
  theme_minimal()


