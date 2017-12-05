// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

// TODO: add priv channels

// // Now that you are connected, you can join channels with a topic:
// let lobby = socket.channel("game:lobby", {})
// lobby.join()
//   .receive("ok", resp => { console.log("Joined successfully", resp) })
//   .receive("error", resp => { console.log("Unable to join", resp) })
//
// let hitButton = document.querySelector("#hit");
//
//
// // TODO: hardcoded
// let player = 0;
//
// if (hitButton) {
//     hitButton.addEventListener("click", event => {
//
//         let target = $("#target").text().substr(8, 2);
//
//         lobby.push("hit", {pos: parseInt(target), player: player})
//
//         console.log(target);
//
//     })
//
// }
//
// console.log(target)

import {start} from './app'


// let lobby = socket.channel("game:lobby", {})
//
//
// // lobby.on("started", payload => {
// //     console.log("Got message")
// //     let pid = '${payload.pid}';
// //     console.log(pid)
// // })
//
// lobby.on("start", payload => {
//     console.log("Started Game")
//
// })
//
// lobby.join()
//     .receive("ok", resp => { console.log("Joined successfully", resp) })
//     .receive("error", resp => { console.log("Unable to join", resp) })
//
//
//
// lobby.push("start");







export default socket
