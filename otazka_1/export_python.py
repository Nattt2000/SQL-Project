# knihovny
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

# import dat
df = pd.read_csv(r"C:\Users\42070\export_sql.csv", encoding="utf-8")

# pivotka
pivot = df.pivot(index='payroll_year', columns='industry_branch_name', values='avg_payroll')

# graf
columns = pivot.columns      
n_cols = 5                       
n_rows = (len(columns) + n_cols - 1) // n_cols 

fig, axes = plt.subplots(n_rows, n_cols, figsize=(n_cols*4, n_rows*3), sharey=True)
axes = axes.flatten()

for i, col in enumerate(columns):
    axes[i].plot(pivot.index, pivot[col], marker='o')
    axes[i].set_title(col, fontsize=9)
    axes[i].grid(True)
    axes[i].tick_params(labelbottom=False)

plt.tight_layout()
plt.show()

# regrese
results = {}
for col in pivot.columns:
    X = pivot.index.values.reshape(-1, 1)  
    y = pivot[col].values              
    model = LinearRegression()
    model.fit(X, y)
    slope = model.coef_[0] 
    results[col] = slope

# vypsání výsledků
oddelovac = "--------------------------------------------------------------------"
slopes_trends = {}
for col, slope in results.items():
    slope_int = round(slope) 
    if slope > 0:
        trend = "rostoucí"
    elif slope < 0:
        trend = "klesající"
    else:
        trend = "stabilní"
    slopes_trends[col] = (slope_int, trend)

slopes_only = []
for val in slopes_trends.values():
    slopes_only.append(val[0])
min_slope = min(slopes_only)
max_slope = max(slopes_only)

for key, (val0, val1) in slopes_trends.items():
    if val0 == min_slope:
        min_odvetvi = key
    if val0 == max_slope:
        max_odvetvi = key

print(oddelovac)
print(f"Nejrychlejší růst: {max_odvetvi} (slope = {max_slope})")
print(f"Nejpomalejší růst: {min_odvetvi} (slope = {min_slope})")
print(oddelovac)

for key, (val0, val1) in slopes_trends.items():
    print(f"{key:<{70}} slope: {val0:<{10}} trend: {val1}")

