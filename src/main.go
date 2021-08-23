package main

import (
	"net/http"

	"example.com/api-product/controllers"
	"github.com/gin-gonic/gin"
)

func main() {
	r := setupRouter()
	_ = r.Run(":8080")
}

func setupRouter() *gin.Engine {
	r := gin.Default()

	r.GET("ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, "pong")
	})

	ProductRepo := controllers.New()
	r.POST("/products", ProductRepo.CreateProduct)
	r.GET("/products", ProductRepo.GetProducts)
	r.GET("/products/:id", ProductRepo.GetProduct)
	r.PUT("/products/:id", ProductRepo.UpdateProduct)
	r.DELETE("/products/:id", ProductRepo.DeleteProduct)

	return r
}
