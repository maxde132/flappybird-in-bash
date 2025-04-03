#!/usr/bin/env bash
# -*- coding: utf-8 -*-

grid0=("." "." "." "." "." "." "." "." "." ".")
grid1=("." "." "." "." "." "." "." "." "." ".")
grid2=("." "." "." "." "." "." "." "." "." ".")
grid3=("." "." "." "." "." "." "." "." "." ".")
grid4=("." "." "." "." "." "." "." "." "." ".")
grid5=("." "." "." "." "." "." "." "." "." ".")
grid6=("." "." "." "." "." "." "." "." "." ".")
grid7=("." "." "." "." "." "." "." "." "." ".")
grid8=("." "." "." "." "." "." "." "." "." ".")
grid9=("." "." "." "." "." "." "." "." "." ".")

flappy_y=5
flappy_x=0
score=0

function displayGrid {
    echo "${grid0[*]}"
    echo "${grid1[*]}"
    echo "${grid2[*]}"
    echo "${grid3[*]}"
    echo "${grid4[*]}"
    echo "${grid5[*]}"
    echo "${grid6[*]}"
    echo "${grid7[*]}"
    echo "${grid8[*]}"
    echo "${grid9[*]}"
    echo "Score: $score"
}

changeGrid() {
    if [ "$1" == 0 ]; then
        grid0[$2]="$3"
    elif [ "$1" == 1 ]; then
        grid1[$2]="$3"
    elif [ "$1" == 2 ]; then
        grid2[$2]="$3"
    elif [ "$1" == 3 ]; then
        grid3[$2]="$3"
    elif [ "$1" == 4 ]; then
        grid4[$2]="$3"
    elif [ "$1" == 5 ]; then
        grid5[$2]="$3"
    elif [ "$1" == 6 ]; then
        grid6[$2]="$3"
    elif [ "$1" == 7 ]; then
        grid7[$2]="$3"
    elif [ "$1" == 8 ]; then
        grid8[$2]="$3"
    elif [ "$1" == 9 ]; then
        grid9[$2]="$3"
    else
        echo "Invalid grid number: $1"
    fi
}

update_column() {
    changeGrid 0 "$1" "$2"
    changeGrid 1 "$1" "$2"
    changeGrid 2 "$1" "$2"
    changeGrid 3 "$1" "$2"
    changeGrid 4 "$1" "$2"
    changeGrid 5 "$1" "$2"
    changeGrid 6 "$1" "$2"
    changeGrid 7 "$1" "$2"
    changeGrid 8 "$1" "$2"
    changeGrid 9 "$1" "$2"

}

createGap() {
    random_int=$(( RANDOM % 8 + 1 ))
    changeGrid $random_int "$1" "$2"
    random_int=$((random_int + 1))
    changeGrid $random_int "$1" "$2"

    random_int=$((random_int - 2))
    changeGrid $random_int "$1" "$2"

}
generatePipe() {
    update_column "$1" "|"
    createGap "$1" "."
}
movePipe() {
    grid0[$1]=${grid0[(($1 + 1))]}
    grid1[$1]=${grid1[(($1 + 1))]}
    grid2[$1]=${grid2[(($1 + 1))]}
    grid3[$1]=${grid3[(($1 + 1))]}
    grid4[$1]=${grid4[(($1 + 1))]}
    grid5[$1]=${grid5[(($1 + 1))]}
    grid6[$1]=${grid6[(($1 + 1))]}
    grid7[$1]=${grid7[(($1 + 1))]}
    grid8[$1]=${grid8[(($1 + 1))]}
    grid9[$1]=${grid9[(($1 + 1))]}
}
MoveAllPipes() {
    movePipe 0
    movePipe 1
    #update_column 2 "."
    movePipe 2
    #update_column 3 "."
    movePipe 3
    #update_column 4 "."
    movePipe 4
    #update_column 5 "."
    movePipe 5
    #update_column 6 "."
    movePipe 6
    #update_column 7 "."
    movePipe 7
    #update_column 8 "."
    movePipe 8
    #update_column 9 "."
    movePipe 9
    

}

function raiseFlappy() {
    if [ $flappy_y -gt 0 ]; then
            ((flappy_y--))
            clear
            displayGrid
    fi
}
function lowerFlappy() {
    if [ $flappy_y -lt 9 ]; then
            ((flappy_y++))
            clear
            displayGrid
    fi
}

getKeyPress() {
    stty -echo -icanon time 0 min 0
    key=$(dd bs=1 count=1 2>/dev/null)
    stty echo icanon
    echo "$key"
}

getCharacter() {
    if [ "$1" == 0 ]; then
        echo "${grid0[$2]}"
    elif [ "$1" == 1 ]; then
        echo "${grid1[$2]}"
    elif [ "$1" == 2 ]; then
        echo "${grid2[$2]}"
    elif [ "$1" == 3 ]; then
        echo "${grid3[$2]}"
    elif [ "$1" == 4 ]; then
        echo "${grid4[$2]}"
    elif [ "$1" == 5 ]; then
        echo "${grid5[$2]}"
    elif [ "$1" == 6 ]; then
        echo "${grid6[$2]}"
    elif [ "$1" == 7 ]; then
        echo "${grid7[$2]}"
    elif [ "$1" == 8 ]; then
        echo "${grid8[$2]}"
    elif [ "$1" == 9 ]; then
        echo "${grid9[$2]}"
    else
        echo "Invalid grid number: $1"
        return 1
    fi
}
checkCollision() {
    # Get the character at the bird's current position
    local character
    character=$(getCharacter $flappy_y $flappy_x)

    # Check if the character is a pipe (|) or any obstacle
    if [ "$character" == "|" ]; then
        
        return 1  # Exit code for collision
    fi
    local character
    local highflap=$((flappy_y + 1))
    local lowflap=$((flappy_y - 1))
    character=$(getCharacter $lowflap $flappy_x)
    if [ "$character" == "|" ]; then
        character=$(getCharacter $highflap $flappy_x)
        if [ "$character" == "|" ]; then
            
            return 1  # Exit code for collision
        fi
        
    fi
    local character
    local oneup=$((flappy_y + 1))
    
    character=$(getCharacter $oneup $flappy_x)
    if [ "$flappy_y" == "9" ]; then
        character=$(getCharacter $lowflap $flappy_x)
        if [ "$character" == "|" ]; then
            return 1
        fi
    fi
    if [ "$flappy_y" == "0" ]; then
        character=$(getCharacter $highflap $flappy_x)
        if [ "$character" == "|" ]; then
            return 1
        fi
    fi
    local character
    local onelow=$((flappy_y - 1))
    local twolow=$((flappy_y - 2))
    local threelow=$((flappy_y - 3))
    local fourlow=$((flappy_y - 4))
    character=$(getCharacter $onelow $flappy_x)
    if [ "$character" == "." ]; then
        character=$(getCharacter $twolow $flappy_x)
        if [ "$character" == "." ]; then
            character=$(getCharacter $threelow $flappy_x)
            if [ "$character" == "." ]; then
                character=$(getCharacter $fourlow $flappy_x)
                if [ "$character" == "|" ]; then

                return 1
                fi
            fi
        fi
    fi
    local character
    local onelow=$((flappy_y + 1))
    local twolow=$((flappy_y + 2))
    local threelow=$((flappy_y + 3))
    local fourlow=$((flappy_y + 4))
    character=$(getCharacter $onelow $flappy_x)
    if [ "$character" == "." ]; then
        character=$(getCharacter $twolow $flappy_x)
        if [ "$character" == "." ]; then
            character=$(getCharacter $threelow $flappy_x)
            if [ "$character" == "." ]; then
                character=$(getCharacter $fourlow $flappy_x)
                if [ "$character" == "|" ]; then

                return 1
                fi
            fi
        fi
    fi
    

    return 0  # No collision
}


#sleepamount=0.5
performActions() {
    
    checkCollision
    if [ $? -eq 1 ]; then
        echo "Game Over!"
        exit 1  # End the game
    fi
    key=$(getKeyPress)

    if [ "$key" == " " ]; then
        raiseFlappy
    fi
    if [ "$key" == "b" ]; then
        lowerFlappy
        
    elif [ "$key" == "q" ]; then
        echo "Quit game."
        return
    fi
    

    clear
    checkCollision
    if [ $? -eq 1 ]; then
        echo "Game Over!"
        exit 1  # End the game
    fi
    MoveAllPipes

    changeGrid $flappy_y $flappy_x "@"
    update_column 9 "."
    displayGrid
    
    sleep 0.5

}

while true; do 
    key=$(getKeyPress)

    if [ "$key" == " " ]; then
        raiseFlappy
    fi
    if [ "$key" == "b" ]; then
        lowerFlappy
        
    elif [ "$key" == "q" ]; then
        echo "Quit game."
        break
    fi
    performActions
    
    generatePipe 9
    key=$(getKeyPress)

    if [ "$key" == " " ]; then
        raiseFlappy
    fi
    if [ "$key" == "b" ]; then
        lowerFlappy
    elif [ "$key" == "q" ]; then
        echo "Quit game."
        break
    fi
    performActions
    
    if [ "$key" == " " ]; then
        raiseFlappy
    fi
    if [ "$key" == "b" ]; then
        lowerFlappy
    elif [ "$key" == "q" ]; then
        echo "Quit game."
        break
    fi
    performActions
    ((score = score + 1))
    lowerFlappy
    if [ "$key" == " " ]; then
        raiseFlappy
    fi
    if [ "$key" == "b" ]; then
        lowerFlappy
    elif [ "$key" == "q" ]; then
        echo "Quit game."
        break
    fi
    performActions
    
done
