import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';


const storedState = localStorage.getItem('val');
const startingValue = storedState ? JSON.parse(storedState) : null;


function getCounters() {
    return Object.values(localStorage)
        .map(s => JSON.parse(s));
}


const app = Elm.Main.init({
    node: document.getElementById('root'),
    flags: {
        startingValue: startingValue,
        counters: getCounters(),
        isOnline: navigator.onLine
           }
});


app.ports.saveValue.subscribe (function(counter) {
    const name = "counter-" + counter.id;
    const val = counter.numberOfTimes;
    localStorage.setItem(name, JSON.stringify(counter));
});

window.addEventListener('online', function() {
    app.ports.networkStatus.send('online');
});

window.addEventListener('offline', function() {
    app.ports.networkStatus.send('offline');
});

registerServiceWorker();
