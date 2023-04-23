package main

import (
	"fmt"
	"github.com/ajanach/go-web/pkg/config"
	"github.com/ajanach/go-web/pkg/handlers"
	"github.com/ajanach/go-web/pkg/render"
	"net/http"
)

// portNumber is assigning port number for web appconst portNumber string = ":8080"
const portNumber = "localhost:8080"

func main() {
	// declaring new object for AppConfig struct
	var app config.AppConfig

	// storing cache map to tc, and handling errors
	tc, err := render.CreateTemplateCache()
	if err != nil {
		fmt.Println(err)
		panic("cannot create template cache")
	}

	// storing data from variable tc to app.TemplateCache
	app.TemplateCache = tc
	app.UseCache = false // want to use cache true/false (for production -> true )

	render.NewTemplates(&app)

	repo := handlers.NewRepo(&app)
	handlers.NewHandlers(repo)

	// Create a new instance of http.Server struct with the given port number and the router from the Routes function
	srv := &http.Server{
		Addr:    portNumber,
		Handler: Routes(&app),
	}

	// Print a message indicating that the application is starting on the given port number
	fmt.Printf("Starting application on port %v\n", portNumber)

	// Start the server and listen for incoming requests on the specified port
	err = srv.ListenAndServe()
	if err != nil {
		panic("Cannot run web application on same port twice!")
	}
}
