#!/bin/bash

# variables
AUTH_TOKEN=""
PROJECT_ID=""

# functions
print_welcom_message() {
    echo "Welcom to script which is allowing data manipulation in Firestore database!"
    echo "This script is created in purpose of creating Betmet web application - making life easier for frontend developers"
}

print_menu_1() {
    echo -e "---------\nMenu 1:
            1 - get matches
            2 - add matches
            3 - get bets
            4 - add bets
            5 - update data for specific bet
            6 - delete bet\n"
}

print_menu_11() {
    echo -e "---------\nMenu 1.1:
            1 - get all matches
            2 - get specific match\n"
}

print_menu_12() {
    echo -e "---------\nMenu 1.2:
            1 - add match with custom ID
            2 - add 5 matches for testing with random ID"
}

print_menu_13() {
    echo -e "---------\nMenu 1.3:
        1 - get all bets
        2 - get specific bet"
}

print_menu_14() {
    echo -e "---------\nMenu 1.4:
        1 - add bet directly to Firebase?
        2 - add bet using backend server?"
}

print_menu_15() {
    echo -e "---------\nMenu 1.5:
        1 - update bet directly from Firebase?
        2 - update bet using backend server?"
}

print_menu_16() {
    echo -e "---------\nMenu 1.4:
        1 - remove bet directly from Firebase?
        2 - remove bet using backend server?"
}

add_specific_match() {
    read -p "Enter match ID: " MATCH_ID
    read -p "Enter match state: (format: BEFORE, DURING or AFTER): " MATCH_STATE
    read -p "Enter match score: (format: 2:1 or null): " MATCH_SCORE
    read -p "Enter match team1: (format: hr): " MATCH_TEAM1
    read -p "Enter match team2: (format: de): " MATCH_TEAM2
    read -p "Enter match event: ID (format: any meaningful number): " MATCH_EVENT_ID
    read -p "Enter match date: (format: 2023-05-14T18:00:00Z): " MATCH_DATE

    curl -X POST "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/matches/?documentId=$MATCH_ID&key=$AUTH_TOKEN" \
        -H 'Content-Type: application/json' \
        -d "{
            \"fields\": {
                \"state\": {
                    \"stringValue\": \"$MATCH_STATE\"
                },
                \"score\": {
                    \"stringValue\": \"$MATCH_SCORE\"
                },
                \"team1\": {
                    \"stringValue\": \"$MATCH_TEAM1\"
                },
                \"team2\": {
                    \"stringValue\": \"$MATCH_TEAM2\"
                },
                \"event\": {
                    \"integerValue\": \"$MATCH_EVENT_ID\"
                },
                \"date\": {
                    \"timestampValue\": \"$MATCH_DATE\"
                }
            }
        }"
    }

    add_five_testing_matches() {
    # adding first match
    curl -X POST "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/matches/?documentId=$RANDOM&key=$AUTH_TOKEN" \
    -H 'Content-Type: application/json' \
    -d '{
        "fields": {
        "state": {
            "stringValue": "BEFORE"
        },
        "score": {
            "stringValue": "null"
        },
        "team1": {
            "stringValue": "hr"
        },
        "team2": {
            "stringValue": "de"
        },
        "event": {
            "integerValue": "280"
        },
        "date": {
            "timestampValue": "2023-05-14T18:00:00Z"
        }
        }
    }'

    # adding second match
    curl -X POST "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/matches/?documentId=$RANDOM&key=$AUTH_TOKEN" \
    -H 'Content-Type: application/json' \
    -d '{
        "fields": {
        "state": {
            "stringValue": "DURING"
        },
        "score": {
            "stringValue": "2:1"
        },
        "team1": {
            "stringValue": "fr"
        },
        "team2": {
            "stringValue": "de"
        },
        "event": {
            "integerValue": "280"
        },
        "date": {
            "timestampValue": "2023-05-14T18:00:00Z"
        }
        }
    }'

    # adding third match
    curl -X POST "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/matches/?documentId=$RANDOM&key=$AUTH_TOKEN" \
    -H 'Content-Type: application/json' \
    -d '{
        "fields": {
        "state": {
            "stringValue": "AFTER"
        },
        "score": {
            "stringValue": "1:2"
        },
        "team1": {
            "stringValue": "hr"
        },
        "team2": {
            "stringValue": "dk"
        },
        "event": {
            "integerValue": "280"
        },
        "date": {
            "timestampValue": "2023-05-14T18:00:00Z"
        }
        }
    }'

    # adding fourth match
    curl -X POST "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/matches/?documentId=$RANDOM&key=$AUTH_TOKEN" \
    -H 'Content-Type: application/json' \
    -d '{
        "fields": {
        "state": {
            "stringValue": "BEFORE"
        },
        "score": {
            "stringValue": "null"
        },
        "team1": {
            "stringValue": "ru"
        },
        "team2": {
            "stringValue": "hr"
        },
        "event": {
            "integerValue": "280"
        },
        "date": {
            "timestampValue": "2023-05-14T18:00:00Z"
        }
        }
    }'

# adding fifth match
    curl -X POST "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/matches/?documentId=$RANDOM&key=$AUTH_TOKEN" \
    -H 'Content-Type: application/json' \
    -d '{
        "fields": {
        "state": {
            "stringValue": "AFTER"
        },
        "score": {
            "stringValue": "2:0"
        },
        "team1": {
            "stringValue": "ng"
        },
        "team2": {
            "stringValue": "hr"
        },
        "event": {
            "integerValue": "280"
        },
        "date": {
            "timestampValue": "2023-05-14T18:00:00Z"
        }
        }
    }'
}

add_bet_firestore() {
    read -p "Enter bet user ID (numbers and letters): " BET_USER_ID
    read -p "Enter bet match ID: " BET_MATCH_ID
    read -p "Enter bet match state (BEFORE, DURING or AFTER): " BET_MATCH_STATE
    read -p "Enter bet bid (in €): " BET_EUROS
    read -p "Enter bet date (format: 2023-05-14T18:31:58.405942Z): " BET_DATE
    read -p "Enter bet score (format 2:1): " BET_SCORE

    curl -X POST "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/bets/?documentId=$RANDOM&key=$AUTH_TOKEN" \
    -H 'Content-Type: application/json' \
    -d '{
        "fields": {
            "users": {
                "mapValue": {
                    "fields": {
                        "'"$BET_USER_ID"'": {
                            "booleanValue": true
                        }
                    }
                }
            },
            "matchId": {
                "stringValue": "'"$BET_MATCH_ID"'"
            },
            "state": {
                "stringValue": "'"$BET_MATCH_STATE"'"
            },
            "bets": {
                "mapValue": {
                    "fields": {
                        "'"$BET_USER_ID"'": {
                            "mapValue": {
                                "fields": {
                                    "bid": {
                                        "integerValue": "'"$BET_EUROS"'"
                                    },
                                    "date": {
                                        "timestampValue": "'"$BET_DATE"'"
                                    },
                                    "score": {
                                        "stringValue": "'"$BET_SCORE"'"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }'
}

add_bet_backend_server() {
    read -p "Enter bet user ID (numbers and letters): " BET_USER_ID
    read -p "Enter bet match ID: " BET_MATCH_ID
    read -p "Enter bet match state (BEFORE, DURING or AFTER): " BET_MATCH_STATE
    read -p "Enter bet bid (in €): " BET_EUROS
    read -p "Enter bet date (format: 2023-05-14T18:31:58.405942Z): " BET_DATE
    read -p "Enter bet score (format 2:1): " BET_SCORE
    read -p "IP address and port of the backend server (format 192.168.1.2:8080): " IP_ADDRESS

    curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $AUTH_TOKEN" -d "{
        \"users\": {
            \"mapValue\": {
                \"fields\": {
                    \"$BET_USER_ID\": {
                        \"booleanValue\": true
                    }
                }
            }
        },
        \"matchId\": {
            \"stringValue\": \"$BET_MATCH_ID\"
        },
        \"state\": {
            \"stringValue\": \"$BET_MATCH_STATE\"
        },
        \"bets\": {
            \"mapValue\": {
                \"fields\": {
                    \"$BET_USER_ID\": {
                        \"mapValue\": {
                            \"fields\": {
                                \"bid\": {
                                    \"integerValue\": \"$BET_EUROS\"
                                },
                                \"date\": {
                                    \"timestampValue\": \"$BET_DATE\"
                                },
                                \"score\": {
                                    \"stringValue\": \"$BET_SCORE\"
                                }
                            }
                        }
                    }
                }
            }
        }
    }" "http://$IP_ADDRESS/bet/$BET_MATCH_ID"
}


update_bet_firestore() {
    read -p "Enter bet ID: " BET_ID
    read -p "Enter bet user ID (numbers and letters): " BET_USER_ID
    read -p "Enter bet match ID: " BET_MATCH_ID
    read -p "Enter bet match state (BEFORE, DURING, or AFTER): " BET_MATCH_STATE
    read -p "Enter bet bid (in €): " BET_EUROS
    read -p "Enter bet date (format: 2023-05-14T18:31:58.405942Z): " BET_DATE
    read -p "Enter bet score (format 2:1): " BET_SCORE

    curl -X PATCH "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/bets/$BET_ID?key=$AUTH_TOKEN" \
    -H 'Content-Type: application/json' \
    -d '{
        "fields": {
            "users": {
                "mapValue": {
                    "fields": {
                        "'"$BET_USER_ID"'": {
                            "booleanValue": true
                        }
                    }
                }
            },
            "matchId": {
                "stringValue": "'"$BET_MATCH_ID"'"
            },
            "state": {
                "stringValue": "'"$BET_MATCH_STATE"'"
            },
            "bets": {
                "mapValue": {
                    "fields": {
                        "'"$BET_USER_ID"'": {
                            "mapValue": {
                                "fields": {
                                    "bid": {
                                        "integerValue": "'"$BET_EUROS"'"
                                    },
                                    "date": {
                                        "timestampValue": "'"$BET_DATE"'"
                                    },
                                    "score": {
                                        "stringValue": "'"$BET_SCORE"'"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }'
}


update_bet_backend_server() {
    read -p "Enter bet ID: " BET_ID
    read -p "Enter new bid value: " BET_BID
    read -p "Enter new score value: " BET_SCORE
    read -p "IP address and port of the backend server (format 192.168.1.2:8080): " IP_ADDRESS

    curl -X PUT -H "Authorization: Bearer AIzaSyA7-SIU3q10I-3md_xG6xgjM2W2UHhgJr0" -H "Content-Type: application/json" -d "{
        \"bid\": $BET_BID,
        \"score\": \"$BET_SCORE\"
    }" "http://$IP_ADDRESS/bet/{$BET_ID}"
}


delete_bet_firestore() {
    read -p "Enter bet ID: " BET_ID
    curl -X DELETE "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/bets/$BET_ID?key=$AUTH_TOKEN"
}

delete_bet_backend_server() {
    read -p "Enter bet ID: " BET_ID
    read -p "IP addres and port of backend server (format 192.168.1.2:8080): " IP_ADDRESS
    curl -X DELETE -H "Authorization: Bearer $AUTH_TOKEN" http://$IP_ADDRESS/bet/\{$BET_ID\}
}

# test arguments for AUTH_TOKEN and PROJECT_ID
if test -z "$1" || test -z "$2"
then
    echo -e "You have to run command adding two arguments: AUTH_TOKEN and PROJECT_ID.\nExample: $0 AUTH_TOKEN PROJECT_ID"
    exit 1
else
    AUTH_TOKEN=$1
    PROJECT_ID=$2
    echo -e "AUTH_TOKEN: $AUTH_TOKEN\nPROJECT_ID: $PROJECT_ID"
fi


CHOICE_MENU_1_MENU_1=""
until test "$CHOICE_MENU_1" = "exit"
do
    print_menu_1
    read -p "Enter the number of functionality that you want to perform: " CHOICE_MENU_1

    # Get matches
    if test "$CHOICE_MENU_1" = "1"
    then
        echo -e "Your choice is $CHOICE_MENU_1"
        print_menu_11
        read -p "Enter the number of functionality that you want to perform: " CHOICE_MENU_11

        # Get all matches
        if test "$CHOICE_MENU_11" = "1"
        then
            echo -e "You chose to get all matches from collection matches."
            echo -e "Output: "
            curl -X GET "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/matches?key=$AUTH_TOKEN"

        # Get specific match
        elif test "$CHOICE_MENU_11" = "2"
        then 
            echo -e "You chose to get specific match from collection matches."
            read -p "Enter match ID: " MATCH_ID
            echo -e "Output: "
            curl -X GET "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/matches/$MATCH_ID/?key=$AUTH_TOKEN"
        else
            echo -e "Wrong input type. Please try again."
        fi

    # Adding matches
    elif test "$CHOICE_MENU_1" = "2"
    then
        echo -e "Your choice is $CHOICE_MENU_1"
        print_menu_12
            read -p "Enter the number of functionality that you want to perform: " CHOICE_MENU_12

        # Add specific match in collection called matches
        if test "$CHOICE_MENU_12" = "1"
        then
            echo -e "You chose to add match in collection matches."
            add_specific_match

        # Add 5 matches for testing purpose
        elif test "$CHOICE_MENU_12" = "2"
        then
            echo -e "You chose to add 5 matches for testing." 
            add_five_testing_matches
        else
            echo -e "Wrong input type. Please try again."
        fi

    # Get bets
    elif test "$CHOICE_MENU_1" = "3"
    then
        echo -e "Your choice is $CHOICE_MENU_1"
        print_menu_13
        read -p "Enter the number of functionality that you want to perform: " CHOICE_MENU_13

        # Get all bets
        if test "$CHOICE_MENU_13" = "1"
        then
            echo -e "You chose to get all bets in collection bets."
            echo -e "Output: "
            curl -X GET "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/bets?key=$AUTH_TOKEN"

        # Get specific bet
        elif test "$CHOICE_MENU_13" = "2"
        then
            echo -e "You chose to get specific bet." 
            read -p "Bet ID: " BET_ID
            echo -e "Output: "
            curl -X GET "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/bets/$BET_ID/?key=$AUTH_TOKEN"
        else
            echo -e "Wrong input type. Please try again."
        fi

    # Add bets
    elif test "$CHOICE_MENU_1" = "4"
    then
        echo -e "Your choice is $CHOICE_MENU_1"
        print_menu_14
        read -p "Enter the number of functionality that you want to perform: " CHOICE_MENU_14

        # Add bet directly to Firebase
        if test "$CHOICE_MENU_14" = "1"
        then
            echo -e "You chose to add bet directly - Firebase."
            add_bet_firestore

        # Add bet using backend server
        elif test "$CHOICE_MENU_14" = "2"
        then
            echo -e "You chose to add bet using backend server." 
            add_bet_backend_server
        else
            echo -e "Wrong input type. Please try again."
        fi

    # Update data about bet
    elif test "$CHOICE_MENU_1" = "5"
    then
        echo -e "Your choice is $CHOICE_MENU_1"
        print_menu_15
        read -p "Enter the number of functionality that you want to perform: " CHOICE_MENU_15

        # Add bet directly to Firebase
        if test "$CHOICE_MENU_15" = "1"
        then
            echo -e "You chose to update bet directly - Firebase."
            update_bet_firestore

        # Add bet using backend server
        elif test "$CHOICE_MENU_15" = "2"
        then
            echo -e "You chose to update bet using backend server." 
            update_bet_backend_server
        else
            echo -e "Wrong input type. Please try again."
        fi

    # Delete data about bet
    elif test "$CHOICE_MENU_1" = "6"
    then
        echo -e "Your choice is $CHOICE_MENU_1"
        print_menu_16
        read -p "Enter the number of functionality that you want to perform: " CHOICE_MENU_16

        # Add bet directly to Firebase
        if test "$CHOICE_MENU_16" = "1"
        then
            echo -e "You chose to delete bet directly - Firebase."
            delete_bet_firestore

        # Add bet using backend server
        elif test "$CHOICE_MENU_16" = "2"
        then
            echo -e "You chose to delete bet using backend server." 
            delete_bet_backend_server
        else
            echo -e "Wrong input type. Please try again."
        fi

    elif test "$CHOICE_MENU_1" = "exit" || test "$CHOICE_MENU_1" = "EXIT" || test "$CHOICE_MENU_1" = "quit" || test "$CHOICE_MENU_1" = "QUIT"
    then
        break
    else
        echo -e "Wrong input type. Please try again.\n"
    fi
done

echo "Exiting.."