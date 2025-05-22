<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Prank Game</title>
<style>
  body {
    background-color: black;
    color: lime;
    font-family: monospace;
    text-align: center;
    user-select: none;
    margin: 0; padding: 20px;
  }
  #header {
    font-size: 24px;
    margin-bottom: 5px;
  }
  #timer {
    font-size: 20px;
    margin-bottom: 20px;
  }
  #game {
    position: relative;
    margin: 0 auto;
    width: 300px;
    height: 300px;
    border: 2px solid lime;
    background: #111;
  }
  #target {
    width: 50px;
    height: 50px;
    background: lime;
    position: absolute;
    border-radius: 8px;
    cursor: pointer;
  }
  #score {
    margin-top: 10px;
    font-size: 18px;
  }
  #prompt, #finalStage, #multiButtons {
    display: none;
  }
  button {
    background: black;
    color: lime;
    border: 2px solid lime;
    font-size: 18px;
    padding: 10px 30px;
    margin: 10px;
    cursor: pointer;
    user-select: none;
    transition: 0.3s;
  }
  button:hover {
    background: lime;
    color: black;
  }
  #yesSmall {
    width: 70px !important;
    font-size: 14px !important;
    position: fixed !important;
    bottom: 10px !important;
    right: 10px !important;
    padding: 5px !important;
    margin: 5px !important;
  }
  #multiButtons button {
    position: absolute;
    width: 60px;
    height: 30px;
    font-size: 14px;
    padding: 5px;
    margin: 0;
  }
  #finalNo {
    font-size: 22px;
    padding: 15px 50px;
    position: relative;
  }
</style>
</head>
<body>

<h1 id="header">Click the green square for 10 seconds!</h1>
<div id="timer">Time Left: 10</div>

<div id="game">
  <div id="target"></div>
</div>
<div id="score">Score: 0</div>

<div id="prompt">
  <p id="promptText">Do you want to erase all your data?</p>
  <button id="yesBtn">Yes</button>
  <button id="noBtn">No</button>
</div>

<div id="multiButtons"></div>

<div id="finalStage">
  <p id="finalText">Erase all data</p>
  <button id="finalNo">No</button>
</div>

<script>
  const target = document.getElementById('target');
  const scoreDisplay = document.getElementById('score');
  const header = document.getElementById('header');
  const timerDisplay = document.getElementById('timer');
  const game = document.getElementById('game');
  
  const promptDiv = document.getElementById('prompt');
  const promptText = document.getElementById('promptText');
  const yesBtn = document.getElementById('yesBtn');
  const noBtn = document.getElementById('noBtn');
  
  const multiButtonsDiv = document.getElementById('multiButtons');
  
  const finalStage = document.getElementById('finalStage');
  const finalText = document.getElementById('finalText');
  const finalNoBtn = document.getElementById('finalNo');

  let score = 0;
  let gameTime = 10; // seconds
  let timer;
  let countdownInterval;
  let gameActive = true;
  let promptStage = 0; // track prompt progress
  let timeLeft = gameTime;

  function randomPosition() {
    const maxX = game.clientWidth - target.offsetWidth;
    const maxY = game.clientHeight - target.offsetHeight;
    const x = Math.floor(Math.random() * maxX);
    const y = Math.floor(Math.random() * maxY);
    target.style.left = x + 'px';
    target.style.top = y + 'px';
  }

  function startGame() {
    score = 0;
    timeLeft = gameTime;
    scoreDisplay.textContent = 'Score: 0';
    timerDisplay.textContent = `Time Left: ${timeLeft}`;
    header.textContent = 'Click the green square for 10 seconds!';
    promptDiv.style.display = 'none';
    multiButtonsDiv.style.display = 'none';
    finalStage.style.display = 'none';
    game.style.display = 'block';
    gameActive = true;
    randomPosition();

    target.onclick = () => {
      if (!gameActive) return;
      score++;
      scoreDisplay.textContent = 'Score: ' + score;
      randomPosition();
    };

    countdownInterval = setInterval(() => {
      timeLeft--;
      timerDisplay.textContent = `Time Left: ${timeLeft}`;
      if(timeLeft <= 0){
        clearInterval(countdownInterval);
      }
    }, 1000);

    timer = setTimeout(() => {
      gameActive = false;
      endGame();
    }, gameTime * 1000);
  }

  function endGame() {
    game.style.display = 'none';
    timerDisplay.textContent = '';
    header.textContent = 'Warning!';
    showPrompt();
  }

  function showPrompt() {
    promptStage = 0;
    promptText.textContent = 'Do you want to Delete System 32?';
    yesBtn.textContent = 'Yes';
    noBtn.textContent = 'No';
    yesBtn.classList.remove('small');
    yesBtn.style.position = 'relative';
    promptDiv.style.display = 'block';
  }

  noBtn.onclick = () => {
    if(promptStage === 0) {
      promptText.textContent = 'Are you sure?';
      promptStage = 1;
    } else if(promptStage === 1) {
      noBtn.style.position = 'fixed';
      noBtn.style.bottom = '10px';
      noBtn.style.right = '10px';
      noBtn.style.width = '60px';
      noBtn.style.fontSize = '14px';
      noBtn.style.padding = '5px';
      promptText.textContent = 'Really sure?';
      promptStage = 2;
    } else if(promptStage === 2) {
      promptDiv.style.display = 'none';
      finalStage.style.display = 'block';
      header.textContent = '';
      promptStage = 3;
    }
  };

  yesBtn.onclick = () => {
    if(promptStage === 0) {
      promptText.textContent = 'Are you sure?';
      promptStage = 1;
    } else if(promptStage === 1) {
      yesBtn.classList.add('small');
      yesBtn.style.position = 'fixed';
      yesBtn.style.bottom = '10px';
      yesBtn.style.right = '10px';
      promptText.textContent = 'Are you REALLY sure?';
      promptStage = 2;
    } else if(promptStage === 2) {
      promptDiv.style.display = 'none';
      multiButtonsDiv.innerHTML = '';
      multiButtonsDiv.style.display = 'block';
      header.textContent = 'Catch the YES button!';
      spawnButtons();
      promptStage = 3;
    }
  };

  function spawnButtons() {
    const total = 26;
    const yesIndex = Math.floor(Math.random() * total);
    multiButtonsDiv.style.position = 'relative';
    multiButtonsDiv.style.width = '320px';
    multiButtonsDiv.style.height = '250px';
    multiButtonsDiv.style.margin = '20px auto';

    for(let i=0; i<total; i++) {
      const btn = document.createElement('button');
      btn.className = 'multiBtn';
      btn.style.position = 'absolute';
      btn.style.width = '60px';
      btn.style.height = '30px';
      btn.style.border = '2px solid lime';
      btn.style.background = 'black';
      btn.style.color = 'lime';
      btn.style.borderRadius = '5px';

      const x = Math.floor(Math.random() * (multiButtonsDiv.clientWidth - 60));
      const y = Math.floor(Math.random() * (multiButtonsDiv.clientHeight - 30));
      btn.style.left = x + 'px';
      btn.style.top = y + 'px';

      if(i === yesIndex) {
        btn.textContent = 'Yes';
        btn.onclick = () => {
          multiButtonsDiv.style.display = 'none';
          header.textContent = '';
          showFinalStage();
          promptStage = 4;
        };
      } else {
        btn.textContent = 'No';
        btn.onclick = () => {
          btn.style.transform = `translate(${Math.random()*10-5}px,${Math.random()*10-5}px)`;
          setTimeout(() => btn.style.transform = 'none', 300);
        };
      }
      multiButtonsDiv.appendChild(btn);
    }
  }

  function showFinalStage() {
    finalStage.style.display = 'block';
    promptText.textContent = '';
    finalNoBtn.textContent = 'No';
    finalNoBtn.style.position = 'relative';
    finalNoBtn.style.fontSize = '22px';
    finalNoBtn.style.padding = '15px 50px';
    finalNoBtn.style.width = 'auto';
    finalText.textContent = 'Delete 3ystem 32';

    finalNoBtn.onmouseenter = () => {
      finalNoBtn.textContent = 'Yes';
    };
    finalNoBtn.onmouseleave = () => {
      finalNoBtn.textContent = 'No';
    };
    finalNoBtn.onclick = () => {
      alert('BOOM! You\'ve been hacked! 😂');
      window.open('https://i.pinimg.com/736x/05/e4/8d/05e48dd33a8f1b1c3092afe74b480970.jpg', '_blank');
    };
  }

  // Start the game automatically
  startGame();
</script>

</body>
</html>

