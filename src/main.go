package main

import (
	"errors"

	"example.com/api-product/controllers"
	"github.com/gin-gonic/gin"

	"net/http"
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

			examples.GET("hello", func(c *gin.Context) {

				c.JSON(http.StatusOK, "k8s")
			})

			examples.GET("error", func(c *gin.Context) {
				err1 := errors.New("math: square root of negative number")
				AbortMsg(http.StatusInternalServerError, err1, c)
			})

		}
	}

	return r
}

func AbortMsg(code int, err error, c *gin.Context) {
	c.String(code, "Oops! Please retry.")
	// A custom error page with HTML templates can be shown by c.HTML()
	c.Error(err)
	c.Abort()
}
