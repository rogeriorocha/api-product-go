package database

import (
	"fmt"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"os"
)

var Db *gorm.DB

func InitDb() *gorm.DB {
	Db = connectDB()
	return Db
}

func connectDB() *gorm.DB {
	USER := os.Getenv("DB_USER")
	PASS := os.Getenv("DB_PASS")
	HOST := os.Getenv("DB_HOST")
	NAME := os.Getenv("DB_NAME")
	PORT := os.Getenv("DB_PORT")

	//URL := fmt.Sprintf("%s:%s@tcp(%s)/%s?charset=utf8&parseTime=True&loc=Local", USER, PASS, HOST, NAME)
	//fmt.Println(URL)

	URL := USER + ":" + PASS + "@tcp" + "(" + HOST + ":" + PORT + ")/" + NAME + "?" + "parseTime=true&loc=Local"
	fmt.Println("URL : ", URL)

	db, err := gorm.Open(mysql.Open(URL))

	if err != nil {
		panic("Failed to connect to database!")

	}
	fmt.Println("Database connection established")

	db.AutoMigrate()
	return db

}

/*
docker run --name=mk-mysql -p3306:3306  -e MYSQL_ROOT_PASSWORD=root -d mysql/mysql-server:8.0.20
*/
