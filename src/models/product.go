package models

import "gorm.io/gorm"

type Product struct {
	gorm.Model
	ID     string  `json:"ID"`
	Name   string  `json:"name"`
	Price  float64 `json:"value"`
	Active bool    `json:"active"`
}

func CreateProduct(db *gorm.DB, Product *Product) (err error) {
	err = db.Create(Product).Error
	if err != nil {
		return err
	}
	return nil
}

func GetProducts(db *gorm.DB, Product *[]Product) (err error) {
	err = db.Find(Product).Error
	if err != nil {
		return err
	}
	return nil
}

func GetProduct(db *gorm.DB, Product *Product, id string) (err error) {
	err = db.Where("id = ?", id).First(Product).Error
	if err != nil {
		return err
	}
	return nil
}

func UpdateProduct(db *gorm.DB, Product *Product) (err error) {
	db.Save(Product)
	return nil
}

func DeleteProduct(db *gorm.DB, Product *Product, id string) (err error) {
	db.Where("id = ?", id).Delete(Product)
	return nil
}
