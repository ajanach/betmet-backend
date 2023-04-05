package render

import (
	"bytes"
	"fmt"
	"github.com/ajanach/go-web/pkg/config"
	"html/template"
	"net/http"
	"path/filepath"
)

var functions = template.FuncMap{} // I am using this when I am creating templateSet .Funcs(functions)

var app *config.AppConfig

// NewTemplates sets config fot the template package
func NewTemplates(a *config.AppConfig) {
	app = a
}

// RenderTemplate is executing parsed data to writer
func RenderTemplate(w http.ResponseWriter, tmpl string) {
	// retrieving cache map from CreateTemplateCache() function
	cacheMap, err := CreateTemplateCache()
	if err != nil {
		fmt.Println("Error:", err)
	}

	// parsedData is holding parsedData of specific key
	parsedData, ok := cacheMap[tmpl]
	if !ok {
		panic("template doesn't exists")
	}

	// creating new bytes buffer type - used to store the result of executed data
	buff := new(bytes.Buffer)

	// executing parsed data - write result to buffer
	_ = parsedData.Execute(buff, nil)

	// context of the buffer are written to the HTTP response writer using writeTo()
	_, err = buff.WriteTo(w)
	if err != nil {
		fmt.Println("Error:", err)
	}
}

// CreateTemplateCache is creating template cache of parsed data - returning cacheMap and error
func CreateTemplateCache() (map[string]*template.Template, error) {
	// cacheMap is map who's holding key (template name) and parsed template (value)
	cacheMap := make(map[string]*template.Template)

	// pages is holding all paths of *.page.tmpl - eq regex in Linux
	pages, err := filepath.Glob("./templates/*.page.tmpl")
	if err != nil {
		return cacheMap, err
	}

	// iterating through all pages and do stuff
	for _, page := range pages {
		pageName := filepath.Base(page)

		// declaring new object of template struct with name
		// new we need to parse data to it than we can execute it
		templateSet := template.New(pageName)

		// layouts are holding all paths of *layout.tmpl
		layouts, err := filepath.Glob("./templates/*.layout.tmpl")
		if err != nil {
			return cacheMap, err
		}

		// parsing all layouts
		if len(layouts) > 0 {
			templateSet, err = templateSet.ParseGlob("./templates/*.layout.tmpl")
			if err != nil {
				return cacheMap, err
			}
		}

		// parsing specific template
		// templateSet is holding parsed data of layout.tmpl files and page.tmpl file
		templateSet, err = templateSet.ParseFiles(page)
		if err != nil {
			return cacheMap, err
		}
		cacheMap[pageName] = templateSet
	}
	return cacheMap, nil
}
