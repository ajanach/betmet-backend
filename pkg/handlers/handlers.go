package handlers

import (
	"github.com/ajanach/go-web/pkg/config"
	"github.com/ajanach/go-web/pkg/models"
	"github.com/ajanach/go-web/pkg/render"
	"net/http"
)

// Repository is the repository type
type Repository struct {
	App *config.AppConfig
}

// Repo the repository used by the handlers
var Repo *Repository

// NewRepo creates a new repository
func NewRepo(a *config.AppConfig) *Repository {
	repo := Repository{App: a}
	return &repo
}

// NewHandlers sets the repository for the handlers
func NewHandlers(r *Repository) {
	Repo = r
}

func (m *Repository) Home(w http.ResponseWriter, r *http.Request) {
	logic := make(map[string]string)
	logic["test"] = "Test sending data from GO to frontend :)"
	render.RenderTemplate(w, "home.page.tmpl", &models.TemplateData{StringMap: logic})
}

func (m *Repository) About(w http.ResponseWriter, r *http.Request) {
	logic := make(map[string]string)
	logic["test"] = "Test sending data from GO to frontend :)"
	render.RenderTemplate(w, "about.page.tmpl", &models.TemplateData{StringMap: logic})
}
