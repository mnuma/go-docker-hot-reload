package main

import (
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
	"net/http"

	"context"

	"fmt"
	"log"

	"cloud.google.com/go/spanner"
	"google.golang.org/api/iterator"
)

func main() {
	e := echo.New()
	e.Use(middleware.Logger())
	e.GET("/", func(c echo.Context) error {

		ctx := context.Background()
		databaseName := "projects/gcpug-public-spanner/instances/merpay-sponsored-instance/databases/mnuma"

		client, err := spanner.NewClient(ctx, databaseName)

		if err != nil {
			log.Fatalf("Failed to create client %v", err)
		}
		defer client.Close()

		stmt := spanner.Statement{SQL: "SELECT Id FROM User"}
		iter := client.Single().Query(ctx, stmt)
		defer iter.Stop()

		userIDs := []string{}
		for {
			row, err := iter.Next()
			if err == iterator.Done {
				return c.JSON(http.StatusOK, userIDs)
			}
			if err != nil {
				log.Fatalf("Query failed with %v", err)
			}

			var i string
			if row.Columns(&i) != nil {
				log.Fatalf("Failed to parse row %v", err)
			}
			fmt.Printf("Got value %v\n", i)
			userIDs = append(userIDs, i)
		}
	})
	e.Start(":1323")
}
