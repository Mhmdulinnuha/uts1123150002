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
ImageURL:"assets/images/ball python.webp"},
{Name:"chameleon", Price:500000, Category:"kadal",
Stock:1,
Description:"no minus no sakit",
ImageURL:"assets/images/image2.png"},
{Name:"Iguana", Price:800000, Category:"kadal",
Stock:2,
Description:"mumer",
ImageURL:"assets/images/image.png"},
}
for _, p := range products {
config.DB.Create(&p)
}
log.Printf("Seed berhasil: %d produk ditambahkan", len(products))
}