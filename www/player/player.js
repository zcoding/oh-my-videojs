(function () {

function MiniPlayer (videoID, options) {
  const el = document.getElementById(videoID);
  const player = new Player(el);
  return player;
}

function Player (el) {
  this._el = el;
}

Player.prototype.play = function (src) {
  this._el.minijs_setProperty("src", src);
  console.message().text(src, {
    fontSize: 16,
    color: 'red'
  }).print();
};

Player.prototype.pause = function () {
  this._el.minijs_pause();
};

window.MiniPlayer = MiniPlayer;

})();
