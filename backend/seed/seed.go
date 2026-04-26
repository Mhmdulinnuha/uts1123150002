package main
import (
"log"
"github.com/joho/godotenv"
"github.com/Mhmdulinnuha/uts1123150002/config"
"github.com/Mhmdulinnuha/uts1123150002/models"
)
func main() {
godotenv.Load()
config.InitDatabase()
products := []models.Product{
{Name:"Ball python", Price:250000, Category:"ular", Stock:1,
Description:"No minus",
ImageURL:"http://10.0.2.2:8080/assets/images/ball_python.webp"},
{Name:"chameleon", Price:500000, Category:"kadal",
Stock:1,
Description:"no minus no sakit",
ImageURL:"http://10.0.2.2:8080/assets/images/image2.png"},
{Name:"Iguana", Price:800000, Category:"kadal",
Stock:2,
Description:"mumer",
ImageURL:"http://10.0.2.2:8080/assets/images/image.png"},
}
for _, p := range products {
config.DB.Create(&p)
}
log.Printf("Seed berhasil: %d produk ditambahkan", len(products))
}