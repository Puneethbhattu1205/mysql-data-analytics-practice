-- DATA CLEANING

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null values or Blank values
-- 4. Remove any Column or Rows


SELECT * FROM layoffs ;

CREATE TABLE layoffs_staging LIKE layoffs ;

INSERT layoffs_staging 
SELECT * FROM layoffs ;

SELECT * FROM layoffs_staging ;

SELECT *, 
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
	AS Row_Num
FROM layoffs_staging ;

WITH duplicates_cte AS
(SELECT *, 
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
	AS Row_Num
FROM layoffs_staging
)
SELECT * FROM duplicates_cte 
WHERE row_num > 1 ; 

SELECT * FROM layoffs
WHERE company = 'casper' ;

CREATE TABLE `layoffs_staging2` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` int DEFAULT NULL,
  row_num INT)
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ;

INSERT INTO layoffs_staging2 
SELECT *, 
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
	AS Row_Num
FROM layoffs_staging ;

DELETE FROM layoffs_staging2 
WHERE row_num > 1;

SELECT * FROM layoffs_staging2 
WHERE row_num > 1;

SELECT company, TRIM(company)
FROM layoffs_staging2 ;

UPDATE layoffs_staging2
SET company = TRIM(company) ;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%' ;

SELECT DISTINCT industry
FROM layoffs_staging2 ;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1; 

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country) 
WHERE country LIKE 'United States%' ;

SELECT DISTINCT country 
FROM layoffs_staging2 ;

SELECT `date`, STR_TO_DATE (`date`, '%m/%d/%Y') AS `Date`
FROM layoffs_staging2 ; 

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y') ;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE ;

SELECT * FROM layoffs_staging2
WHERE company = 'Airbnb' ; 

UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '' ;

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2 
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL ;

UPDATE layoffs_staging2 t1 
JOIN layoffs_staging2 t2 
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL ;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL ;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num ;

SELECT * 
FROM layoffs_staging2 ;