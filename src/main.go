package main

import (
	"errors"

	"net/http"

	"example.com/api-product/controllers"
//	"example.com/api-product/docs"
	"github.com/gin-gonic/gin"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

// @BasePath /api/v1

// PingExample godoc
// @Summary ping example
// @Schemes
// @Description do ping
// @Tags example
// @Accept json
// @Produce json
// @Success 200 {string} Helloworld
// @Router /example/helloworld [get]
func Helloworld(g *gin.Context) {
	g.JSON(http.StatusOK, "helloworld")
}
func Healthcheck(g *gin.Context) {
	g.JSON(http.StatusOK, "Healthcheck hi")
}

func main() {
	r := setupRouter()

	_ = r.Run(":8080")
}

func setupRouter() *gin.Engine {
	r := gin.Default()

	ProductRepo := controllers.New()
	docs.SwaggerInfo.BasePath = "/api/v1"
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
		examples := v1.Group("/example")
		{
			examples.GET("/helloworld", Helloworld)

			examples.GET("hello", func(c *gin.Context) {
				//c.JSON(http.StatusOK, "hi, i am 2.0")
				err1 := errors.New("math: square root of negative number")
				AbortMsg(http.StatusInternalServerError, err1, c)
			})

			examples.GET("error", func(c *gin.Context) {
				err1 := errors.New("math: square root of negative number")
				AbortMsg(http.StatusInternalServerError, err1, c)
			})

		}
	}
	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))
	r.GET("/healthz", Healthcheck)

	return r
}

func AbortMsg(code int, err error, c *gin.Context) {
	c.String(code, "Oops! Please retry.")
	// A custom error page with HTML templates can be shown by c.HTML()
	c.Error(err)
	c.Abort()
}
