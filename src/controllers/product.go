package controllers

import (
	"errors"
	"net/http"

	"example.com/api-product/database"
	"example.com/api-product/models"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type ProductRepo struct {
	Db *gorm.DB
}

func New() *ProductRepo {
	db := database.InitDb()
	db.AutoMigrate(&models.Product{})
	return &ProductRepo{Db: db}
}

//create Product
func (repository *ProductRepo) CreateProduct(c *gin.Context) {
	var Product models.Product
	c.BindJSON(&Product)
	err := models.CreateProduct(repository.Db, &Product)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	c.JSON(http.StatusOK, Product)
}

//get Products
func (repository *ProductRepo) GetProducts(c *gin.Context) {
	var Product []models.Product

	err := models.GetProducts(repository.Db, &Product)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	c.JSON(http.StatusOK, Product)
}

//get Product by id
func (repository *ProductRepo) GetProduct(c *gin.Context) {
	id, _ := c.Params.Get("id")
	var Product models.Product
	err := models.GetProduct(repository.Db, &Product, id)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.AbortWithStatus(http.StatusNotFound)
			return
		}

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	c.JSON(http.StatusOK, Product)
}

// update Product
func (repository *ProductRepo) UpdateProduct(c *gin.Context) {
	var Product models.Product
	id, _ := c.Params.Get("id")
	err := models.GetProduct(repository.Db, &Product, id)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.AbortWithStatus(http.StatusNotFound)
			return
		}

		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	c.BindJSON(&Product)
	err = models.UpdateProduct(repository.Db, &Product)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	c.JSON(http.StatusOK, Product)
}

// delete Product
func (repository *ProductRepo) DeleteProduct(c *gin.Context) {
	var Product models.Product
	id, _ := c.Params.Get("id")
	err := models.DeleteProduct(repository.Db, &Product, id)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Product deleted successfully"})
}
