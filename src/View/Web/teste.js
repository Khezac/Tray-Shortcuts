let ListaAtalhos;

window.chrome.webview.addEventListener('message', e => {
    const msg = e.data;
    if (msg.tipo == 'listaAplicativos') {
        ListaAtalhos = msg.dados;
        PreencherLista();
    }
});

function PreencherLista(pListaAtalhos) {
    let Lista = document.getElementById('popup-list');
    Lista.innerHTML = '';

    ListaAtalhos.forEach((atalho, index) => {
        const ItemDaLista = document.createElement('li');        
        ItemDaLista.className = 'list-item';
        ItemDaLista.dataset.index = index;
        
        const TextoDoItem = document.createElement('p');
        let AtalhoNome = atalho.nome;

        if(AtalhoNome.length >= 25){
            AtalhoNome = AtalhoNome.slice(0, 18) + '...'
        }

        TextoDoItem.innerText = AtalhoNome;

        ItemDaLista.appendChild(TextoDoItem);
        Lista.appendChild(ItemDaLista);
    });
}

document.addEventListener('DOMContentLoaded', () => {
    const Lista = document.getElementById('popup-list');

    Lista.addEventListener('click', e => {
        const item = e.target.closest('.list-item');
        if (!item) return;

        const index = item.dataset.index;
        const atalho = ListaAtalhos[index];

        console.log(atalho);

        window.chrome.webview.postMessage({
            tipo: 'clickAtalho',
            dados: atalho
        });
    });
});