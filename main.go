package main

import (
	"context"
	firebase "firebase.google.com/go"
	"github.com/ajanach/bet-server/api"
	"github.com/ajanach/bet-server/app"
	"github.com/ajanach/bet-server/gol24"
	"github.com/gorilla/handlers"
	"github.com/jasonlvhit/gocron"
	"google.golang.org/api/option"
	"log"
	"net/http"
	"os"
)

const (
	ADDR = "10.20.233.121:8080"
)

func main() {
	ctx := context.Background()
	opt := option.WithCredentialsFile("betmet-523bd-firebase-adminsdk-w8cv0-c7213299f2.json")
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

	log.Printf("Running Gol24 client in background")
	gocron.Every(1).Minute().Do(gol24.DownloadDataAndUploadToFirebase)
	gocron.Start()

	log.Printf("Running server on port %s", ADDR)
	log.Fatal(http.ListenAndServe(ADDR, handlers.LoggingHandler(os.Stdout, handlers.ProxyHeaders(api.CreateRouter()))))
}
