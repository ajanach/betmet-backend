package main

import (
	"fmt"
	"github.com/ajanach/go-web/pkg/config"
	"github.com/ajanach/go-web/pkg/handlers"
	"github.com/ajanach/go-web/pkg/render"
	"net/http"
)

const portNumber string = ":8080"

func main() {
	var app config.AppConfig

	tc, err := render.CreateTemplateCache()
	if err != nil {
		panic("cannot create template cache")
	}
	app.TemplateCache = tc
	app.UseCache = false // want to use cache true/false (for production -> true )

	repo := handlers.NewRepo(&app)
	handlers.NewHandlers(repo)

	render.NewTemplates(&app)

	http.HandleFunc("/", handlers.Repo.Home)
	http.HandleFunc("/about", handlers.Repo.About)

	fmt.Printf("Staring application on port %v\n", portNumber)
	err = http.ListenAndServe(portNumber, nil)
	if err != nil {
		panic("Cannot run web application on same port twice!")
	}
}
