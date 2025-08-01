
--Display The Table
Select * from PortfolioProject.dbo.NashvilleHousing


-- Standardize Date Format 

Select SaleDate, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NASHVILLEHOUSING
ADD SaleDateConverted Date;

Update NashvilleHousing 
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Property Address data

Select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID


--POPULATE NULL ADDRESS WITH PROPER ADDRESS WHERE SAME PARCELID 
Select *
from PortfolioProject..NashvilleHousing A 
JOIN PortfolioProject..NashvilleHousing B
ON A.ParcelID = B.ParcelID



Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
from PortfolioProject..NashvilleHousing A 
JOIN PortfolioProject..NashvilleHousing B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ]  <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL


-- run this update and then run the above Query to check for no null 
Update a
SET PropertyAddress  = ISNULL(A.PropertyAddress,B.PropertyAddress) 
from PortfolioProject..NashvilleHousing A 
JOIN PortfolioProject..NashvilleHousing B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ]  <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL


-- Breaking out Address into Individual Columns - Address, City, State

Select PropertyAddress from 
PortfolioProject..NashvilleHousing


-- Using DELIMITER IMPORTANT--

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
from PortfolioProject..NashvilleHousing


