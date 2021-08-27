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

	ProductRepo := controllers.New()

	v1 := r.Group("/api/v1")
	{
		products := v1.Group("/products")
		{
			products.POST("", ProductRepo.CreateProduct)
			products.GET("", ProductRepo.GetProducts)
			products.GET(":id", ProductRepo.GetProduct)
			products.PUT(":id", ProductRepo.UpdateProduct)
			products.DELETE(":id", ProductRepo.DeleteProduct)
		}
		examples := v1.Group("/examples")
		{
			examples.GET("ping", func(c *gin.Context) {
				c.JSON(http.StatusOK, "pong")
			})
		}
	}

	return r
}
