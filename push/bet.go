package push

import (
	"fmt"
	"github.com/ajanach/betmet-backend/app"
	"github.com/ajanach/betmet-backend/repository"
	"golang.org/x/net/context"
)

func LoadBets(matchId string) (*map[string]repository.Bet, error) {
	docs, err := app.FirestoreClient.Collection("bets").Where("matchId", "==", matchId).Documents(context.Background()).GetAll()

	if err != nil {
		return nil, fmt.Errorf("unable to load bets for match %v", err)
	}

	var bets = make(map[string]repository.Bet)

	for _, doc := range docs {
		var bet repository.Bet
		err = doc.DataTo(&bet)
		if err != nil {
			return nil, fmt.Errorf("unable to parse bet %v", err)
		}

		bets[doc.Ref.ID] = bet
	}

	return &bets, nil
}
