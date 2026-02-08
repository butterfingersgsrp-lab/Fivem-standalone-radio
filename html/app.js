const overlay = document.getElementById('overlay');
const closeButton = document.getElementById('close');
const stopButton = document.getElementById('stop');
const form = document.getElementById('radio-form');
const stationInput = document.getElementById('station');
const urlInput = document.getElementById('url');
const stationName = document.getElementById('station-name');
const audio = document.getElementById('audio');

const postNui = (event, payload = {}) => {
  if (typeof GetParentResourceName !== 'function') {
    return;
  }

  fetch(`https://${GetParentResourceName()}/${event}`, {
    method: 'POST',
    body: JSON.stringify(payload)
  });
};

const openUI = () => {
  overlay.classList.add('active');
  stationInput.focus();
};

const closeUI = () => {
  overlay.classList.remove('active');
  postNui('close');
};

const playStream = (name, url) => {
  stationName.textContent = name || 'Unnamed Station';
  if (url) {
    audio.src = url;
    audio.volume = 0.6;
    audio.play().catch(() => {});
  }
};

const stopStream = () => {
  audio.pause();
  audio.src = '';
  stationName.textContent = 'No station selected';
};

window.addEventListener('message', (event) => {
  const data = event.data;
  if (data.type === 'open') {
    openUI();
  }
  if (data.type === 'play') {
    playStream(data.name, data.url);
  }
  if (data.type === 'stop') {
    stopStream();
  }
  if (data.type === 'close') {
    closeUI();
  }
});

closeButton.addEventListener('click', closeUI);
stopButton.addEventListener('click', () => {
  postNui('stopStation');
});

form.addEventListener('submit', (event) => {
  event.preventDefault();
  postNui('setStation', {
    name: stationInput.value,
    url: urlInput.value
  });
});

window.addEventListener('keydown', (event) => {
  if (event.key === 'Escape') {
    closeUI();
  }
});
