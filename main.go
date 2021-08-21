package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// entity
type product struct {
	ID     string  `json:"id"`
	Name   string  `json:"name"`
	Price  float64 `json:"value"`
	Active bool    `json:"active"`
}

var albums = []product{
	{ID: "1", Name: "Bike TSW", Price: 5006.99, Active: true},
	{ID: "2", Name: "Laptop MacBook Pro", Price: 10500.00, Active: true},
	{ID: "3", Name: "Laptop Asus", Price: 4500.00, Active: false},
}

func getProducts(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, albums)
}

func postProduct(c *gin.Context) {
	var newProduct product

	if err := c.BindJSON(&newProduct); err != nil {
		return
	}

	albums = append(albums, newProduct)
	c.IndentedJSON(http.StatusCreated, newProduct)
}

func getProductByID(c *gin.Context) {
	id := c.Param("id")

	for _, a := range albums {
		if a.ID == id {
			c.IndentedJSON(http.StatusOK, a)
			return
		}
	}
	c.IndentedJSON(http.StatusNotFound, gin.H{"message": "product not found"})
}

func main() {
	router := gin.Default()
	router.GET("/products", getProducts)
	router.GET("/products/:id", getProductByID)
	router.POST("/products", postProduct)

	router.Run("localhost:8080")
}
