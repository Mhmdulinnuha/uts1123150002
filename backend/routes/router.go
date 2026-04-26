package routes
import (
"github.com/gin-gonic/gin"
"github.com/Mhmdulinnuha/uts1123150002/handlers"
"github.com/Mhmdulinnuha/uts1123150002/middleware"
)
func SetupRouter() *gin.Engine {
r := gin.Default()
 r.Static("/assets", "../assets")
r.Use(func(c *gin.Context) {
c.Header("Access-Control-Allow-Origin", "*")
c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")
if c.Request.Method == "OPTIONS" {
c.AbortWithStatus(204)
return
}
c.Next()
})

authHandler := handlers.NewAuthHandler()
productHandler := handlers.NewProductHandler()

v1 := r.Group("/v1")
{

v1.GET("/health", func(c *gin.Context) {
c.JSON(200, gin.H{"status": "ok", "service":
"appstorerept"})
})

auth := v1.Group("/auth")
{

auth.POST("/verify-token", authHandler.VerifyToken)
}

protected := v1.Group("")
protected.Use(middleware.AuthMiddleware())
{

products := protected.Group("/products")
{
products.GET("", productHandler.GetAll) // GET /v1/products
products.GET("/:id", productHandler.GetByID) // GET/v1/products/:id

adminProducts := products.Group("")
adminProducts.Use(middleware.AdminOnly())
{
adminProducts.POST("", productHandler.Create) // POST/v1/products
adminProducts.PUT("/:id", productHandler.Update) // PUT/v1/products/:id
adminProducts.DELETE("/:id", productHandler.Delete)//DELETE /v1/products/:id
}
}
}
}
return r
}