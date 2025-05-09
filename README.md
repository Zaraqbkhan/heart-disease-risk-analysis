# 🩵 Heart Disease Risk Analysis and Prediction

## 📄 Project Summary
This project investigates clinical factors associated with heart disease using both statistical analysis and machine learning. It focuses on identifying risk patterns and building models that can support early diagnosis and prevention, especially for high-risk individuals.

## 📊 Dataset Overview
- **Source**: [UCI Heart Disease Repository](https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/)
- **Compiled From**: Cleveland, Hungarian, Switzerland, Long Beach VA, and Statlog datasets
- **Final Size**: 918 observations, 11 common features
- **Target Variable**: `HeartDisease` (1 = disease, 0 = no disease)

**Citation**:  
fedesoriano. (Sept 2021). *Heart Failure Prediction Dataset*. Retrieved from [Kaggle](https://www.kaggle.com/fedesoriano/heart-failure-prediction)

## 🌐 Objective
To extract insights and build predictive models that can estimate a patient's risk of heart disease using clinical attributes.

## ⚖️ Analytical Methods

### 1. Confidence Intervals
- Estimated 95% CIs for population means (e.g., Cholesterol, RestingBP)
- Example: Cholesterol 95% CI = [131.2, 133.6] mg/dL

### 2. Hypothesis Testing
- **One-sample t-test**: Tested if mean RestingBP ≠ 130 mmHg
- **Two-sample t-test**: Compared mean Cholesterol by Sex (F > M, p < 0.001)

### 3. Linear Regression
- **Simple**: MaxHR ~ Age (MaxHR decreases ~1 bpm/year)
- **Multiple**: MaxHR ~ Age + Sex + Cholesterol (Adjusted R² ≈ 0.20)
- **Polynomial**: Added Age² term to capture curvature in MaxHR decline

### 4. Random Forest Regression
- Modeled MaxHR using Age, Sex, and Cholesterol
- Improved flexibility and captured nonlinear interactions
- Variable importance: Age > Sex > Cholesterol

### 5. Logistic Regression
- Predicted `HeartDisease` using Age, Sex, MaxHR
- Odds Ratios:
  - Age: OR = 1.04
  - Sex (M): OR = 4.27
  - MaxHR: OR = 0.97 (protective)
- Visualized predicted probabilities by Age and MaxHR levels

## 📊 Key Insights
- Age and Sex are strong predictors: older males are at highest risk
- Higher MaxHR is associated with lower heart disease risk
- Linear models explain basic patterns; tree-based models capture deeper interactions

## 🛠️ Tools Used
- **Language**: R
- **Key Libraries**: `dplyr`, `ggplot2`, `randomForest`, `stats`, `mgcv`, `hexbin`
- **Methods**: t-tests, CI, regression, machine learning
- **Visuals**: boxplots, coefficient plots, hexbin density, probability curves

## 📂 Files Included
- `heart.csv`: cleaned dataset
- `statistical analysis.R`: main analysis script
- `README.md`: project documentation
- Visual plots: PNG files for model and statistical outputs
