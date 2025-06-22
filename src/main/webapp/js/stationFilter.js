document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("searchInput");
    const cards = document.querySelectorAll(".station-card");
    const modalEl = document.getElementById('addStationModal');
    const shouldOpenModal = document.body.dataset.openModal === "true";
    const filterButtons = document.querySelectorAll('.filter-btn');

    let currentFilter = 'all';

    // --- 1. Recherche améliorée
    if (searchInput) {
        searchInput.addEventListener("input", () => {
            const searchTerm = searchInput.value.toLowerCase().trim();
            filterStations(searchTerm, currentFilter);
        });
    }

    // --- 2. Filtres rapides
    filterButtons.forEach(button => {
        button.addEventListener('click', function() {
            filterButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');

            currentFilter = this.getAttribute('data-filter');
            const searchTerm = searchInput ? searchInput.value.toLowerCase().trim() : '';
            filterStations(searchTerm, currentFilter);
        });
    });

    // --- 3. Fonction de filtrage
    function filterStations(searchTerm, filter) {
        let visibleCount = 0;

        cards.forEach(card => {
            const name = (card.getAttribute("data-name") || '').toLowerCase();
            const country = (card.getAttribute("data-country") || '').toLowerCase();
            const id = card.getAttribute("data-id") || '';
            const tempStr = card.getAttribute("data-temp") || '0';
            const temp = parseFloat(tempStr) || 0;
            const hasData = card.getAttribute("data-has-data") === "true";

            // Recherche textuelle
            const matchesSearch = !searchTerm ||
                name.includes(searchTerm) ||
                country.includes(searchTerm) ||
                id.toString().includes(searchTerm) ||
                tempStr.includes(searchTerm);

            // Filtre par catégorie
            let matchesFilter = true;
            switch(filter) {
                case 'hot':
                    matchesFilter = hasData && temp > 25;
                    break;
                case 'cold':
                    matchesFilter = hasData && temp < 10;
                    break;
                case 'all':
                default:
                    matchesFilter = true;
                    break;
            }

            const shouldShow = matchesSearch && matchesFilter;
            card.style.display = shouldShow ? "block" : "none";

            if (shouldShow) {
                visibleCount++;
            }
        });

        updateNoResultsMessage(visibleCount);
    }

    // --- 4. Message "aucun résultat" simplifié
    function updateNoResultsMessage(count) {
        const noResultsDiv = document.getElementById('noResults');

        if (noResultsDiv) {
            noResultsDiv.style.display = count === 0 ? 'block' : 'none';
        }
    }

    // --- 5. Initialiser le premier bouton comme actif
    if (filterButtons.length > 0) {
        filterButtons[0].classList.add('active');
    }

    // --- 6. Code existant pour les modales (CONSERVÉ)
    if (shouldOpenModal && modalEl) {
        const modal = new bootstrap.Modal(modalEl);
        modal.show();

        modalEl.addEventListener('shown.bs.modal', () => {
            setTimeout(() => {
                modalEl.querySelectorAll('.alert').forEach(alert => {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 7000);
        });
    }

    // --- 7. Fermer les alertes globales (CONSERVÉ)
    setTimeout(() => {
        document.querySelectorAll('body > .alert').forEach(alert => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);
});