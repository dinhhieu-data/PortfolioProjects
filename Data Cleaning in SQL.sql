-----------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field



/*
Cleaning Data in SQL Queries

*/


select *
from NashvilleHousing
	

---------------------------------------------------------------------------------------------------------

----- Standardize Data Format

--select SaleDate, CONVERT(date, saledate)
--from NashvilleHousing

--Update NashvilleHousing
--SET SaleDate = CONVERT(date, saledate)


Alter table NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = CONVERT(date, Saledate)

Select SaleDateConverted
from NashvilleHousing

----- Populate Property Address date

select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select  a.ParcelID
	  , a.PropertyAddress
	  , b.ParcelID
	  , b.PropertyAddress
	  , ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-----Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
substring(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Housing
from NashvilleHousing
 
Alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


Alter table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = substring(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


select *
from NashvilleHousing



select OwnerAddress
from NashvilleHousing

select
PARSENAME(replace(OwnerAddress, ',', '.'), 3)
,PARSENAME(replace(OwnerAddress, ',', '.'), 2)
,PARSENAME(replace(OwnerAddress, ',', '.'), 1)
From NashvilleHousing


Alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.'), 3)


Alter table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)


Alter table NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'), 1)



select *
from NashvilleHousing


-----------------------------------------------------------------------
----- Change Y and N to Yes and No in "Sold as Vacant" field
select distinct(SoldAsVacant), count(soldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
	CASE
	   when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE
	   when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end



---------------------------------------------------------------------------
-----Remove Duplicate

with RowNumCTE AS (
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
			     PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from NashvilleHousing
--order by ParcelID
)

select *
--DELETE
from RowNumCTE
where row_num > 1
order by ParcelID




---------------------------------------------------------------------------
-----Delete Unused Colums
Select *
From NashvilleHousing

Alter table NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table NashvilleHousing
Drop column saledate