// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

import React from 'react';
import ReactDOM from 'react-dom';

import Board from './components/Board';


// function renderBoard(squares, player, hit) {
//
//     ReactDOM.render(
//         <Board
//             squares={squares}
//             onClick={i => }
//         />, player)
// }


function runGame() {

    // If user creates a game, pass their id and map it to player 1
    // If user joins a game, same but player 2
    let userID = Math.floor(Math.random() * 100)

    let joinBtn = document.querySelector("#join");
    let startBtn = document.querySelector("#start");

    let serverName = document.querySelector("#game-id");

    let lobby = socket.channel("game:lobby", {})

    lobby.on("start", payload => {

        console.log("Started Game: " + payload.name)

        start(payload.name, userID, true)

    })

    lobby.on("join", payload => {
        console.log("Joined " + payload.name)

        start(payload.name, userID, false)
    })



    startBtn.addEventListener("click", event => {
        if (serverName.value != "") {

            placeShips(serverName, userID, lobby, "start");
            // if (ships.length >= 17) {
            //     lobby.push("start", {name: serverName.value, player: userID, ships: ships})
            // }
        }
    })

    joinBtn.addEventListener("click", event => {
        if (serverName.value != "") {
            placeShips(serverName, userID, lobby, "join");
            //lobby.push("join", {name: serverName.value, player: userID, ships: ships})
        }
    })



    lobby.join()
        .receive("ok", resp => { console.log("Joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })

}

function placeShips(serverName, userID, lobby, message) {


    let ships = [];

    function addShip(i) {
        ships.push(i);
        squares[i] = "ship";
        if (ships.length >= 17) {
            lobby.push(message, {name: serverName.value, player: userID, ships: ships})
            return;
        }
        renderBoard(squares)
        console.log(squares)
        console.log(ships)
    }

    function renderBoard(squares) {
        ReactDOM.render(
            <Board
                squares={squares}
                onClick={i => addShip(i)}
            />, player)
    }

    let squares = Array(100).fill("water");

    // Player board
    let player = document.getElementById("player-board");

    //renderBoard(squares, player);

    renderBoard(squares)
    return ships;

}


export function start(name, playerID, playerOne) {


    let channel = socket.channel("game:" + name, {})
    channel.join()
        .receive("ok", resp => { console.log("Joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })

    channel.push("update", {server: name});


    function hit(pos) {
        channel.push("hit", {pos: pos, server: name, player: playerID});
        channel.push("update", {server: name})
    }


    let update = "update" + playerID;
    console.log(update)

    channel.on(update, payload => {

            console.log(payload)

            console.log("ID: " + playerID)
            let squares = payload.state[0];
            let rivalSquares = payload.state[1];

            console.log(squares)
            console.log(rivalSquares)


            // Player board
            let player = document.getElementById("player-board");

            //renderBoard(squares, player);

            ReactDOM.render(
                <Board
                    squares={squares}
                    onClick={i => hit(i)}
                />, player)

            // Rival board
            let rival = document.getElementById("rival-board")
            //renderBoard(rivalSquares, rival)

            ReactDOM.render(
                <Board
                    squares={rivalSquares}
                    onClick={i => hit(i)}
                />, rival)

    })

    channel.on("gameOver", payload => {
        alert("Winner: Player " + payload.winner)
    })

}

$(runGame());
