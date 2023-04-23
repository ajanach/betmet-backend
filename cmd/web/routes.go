package main

import (
	"github.com/ajanach/go-web/pkg/config"
	"github.com/ajanach/go-web/pkg/handlers"
	"github.com/go-chi/chi/v5"
	"net/http"
)

// Routes function creates a new instance of the Chi router
func Routes(app *config.AppConfig) http.Handler {
	mux := chi.NewMux()
	mux.Get("/", handlers.Repo.Home)
	mux.Get("/about", handlers.Repo.About)
	return mux
}
