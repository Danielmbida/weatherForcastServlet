document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("searchInput");
    const cards = document.querySelectorAll(".station-card");
    const modalEl = document.getElementById('addStationModal');
    const shouldOpenModal = document.body.dataset.openModal === "true";

    // --- 1. Filtrage des stations par nom
    if (searchInput) {
        searchInput.addEventListener("input", () => {
            const filter = searchInput.value.toLowerCase();
            cards.forEach(card => {
                const name = card.getAttribute("data-name").toLowerCase();
                card.style.display = name.includes(filter) ? "block" : "none";
            });
        });
    }

    // --- 2. Ouvrir la modale si nécessaire
    if (shouldOpenModal && modalEl) {
        const modal = new bootstrap.Modal(modalEl);
        modal.show();

        // 3. Fermer les alertes dans la modale après ouverture (7s)
        modalEl.addEventListener('shown.bs.modal', () => {
            setTimeout(() => {
                modalEl.querySelectorAll('.alert').forEach(alert => {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 7000);
        });
    }

    // --- 4. Fermer les alertes globales (hors modale) après 7s
    setTimeout(() => {
        document.querySelectorAll('body > .alert').forEach(alert => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);
});
