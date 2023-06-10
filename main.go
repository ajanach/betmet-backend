package main

import (
	"context"
	firebase "firebase.google.com/go"
	"github.com/ajanach/betmet-backend/api"
	"github.com/ajanach/betmet-backend/app"
	"github.com/ajanach/betmet-backend/gol24"
	"github.com/gorilla/handlers"
	"github.com/jasonlvhit/gocron"
	"google.golang.org/api/option"
	"log"
	"net/http"
	"os"
)

const (
	ADDR = "192.168.0.14:8080"
)

func main() {
	ctx := context.Background()
	opt := option.WithCredentialsFile("betmet-523bd-firebase-adminsdk-w8cv0-93ada3fabe.json")
	firebaseApp, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		panic(err)
	}

	app.FirestoreClient, err = firebaseApp.Firestore(ctx)
	if err != nil {
		panic(err)
	}
	defer app.FirestoreClient.Close()
	log.Printf("Connected to Firebase")

	app.FcmClient, err = firebaseApp.Messaging(ctx)
	if err != nil {
		panic(err)
	}
	log.Printf("Connected to FCM")

	log.Printf("Running Betmet client in background")
	gocron.Every(1).Minute().Do(gol24.DownloadDataAndUploadToFirebase)
	gocron.Start()

	log.Printf("Running server on port %s", ADDR)
	log.Fatal(http.ListenAndServe(ADDR, handlers.LoggingHandler(os.Stdout, handlers.ProxyHeaders(api.CreateRouter()))))
}
