import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';


const storedState = localStorage.getItem('val');
const startingValue = storedState ? JSON.parse(storedState) : null;

const app = Elm.Main.init({
    node: document.getElementById('root'),
    flags: startingValue
});


app.ports.saveValue.subscribe(function(val) {
    localStorage.setItem('val', val);
});

window.addEventListener('online', function() {
    app.ports.networkStatus.send('online');
});

window.addEventListener('offline', function() {
    app.ports.networkStatus.send('offline');
});

registerServiceWorker();
