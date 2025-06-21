<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Modal d'ajout de station -->
<div class="modal fade" id="addStationModal" tabindex="-1" aria-labelledby="addStationModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white border-0">
                <h5 class="modal-title fw-bold" id="addStationModalLabel">
                    <i class="bi bi-plus-lg me-2"></i>Ajouter une station météo
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Fermer"></button>
            </div>
            <form action="add-station" method="post" id="addStationForm">
                <div class="modal-body p-4">
                    <div class="alert alert-info border-0 bg-light">
                        <i class="bi bi-info-circle-fill me-2 text-info"></i>
                        <strong>Information :</strong> Entrez les coordonnées géographiques de la nouvelle station.
                    </div>

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label for="latitude" class="form-label fw-bold">
                                <i class="bi bi-geo-alt-fill me-2 text-primary"></i>Latitude
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-primary text-white border-0">
                                    <i class="bi bi-compass"></i>
                                </span>
                                <input type="number" step="any" class="form-control border-0 shadow-sm"
                                       id="latitude" name="latitude" placeholder="48.8566" required>
                            </div>
                            <div class="form-text text-muted">
                                <i class="bi bi-arrow-up-down me-1"></i>Coordonnée Nord-Sud (-90 à 90)
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="longitude" class="form-label fw-bold">
                                <i class="bi bi-geo-alt-fill me-2 text-primary"></i>Longitude
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-primary text-white border-0">
                                    <i class="bi bi-compass"></i>
                                </span>
                                <input type="number" step="any" class="form-control border-0 shadow-sm"
                                       id="longitude" name="longitude" placeholder="2.3522" required>
                            </div>
                            <div class="form-text text-muted">
                                <i class="bi bi-arrow-left-right me-1"></i>Coordonnée Est-Ouest (-180 à 180)
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 d-flex justify-content-center gap-3">
                    <button type="button" class="btn btn-outline-secondary btn-lg" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle me-2"></i>Annuler
                    </button>
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="bi bi-plus-lg me-2"></i>Ajouter la station
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>