import Foundation

public enum APIError: LocalizedError, Equatable, Sendable {
    case invalidURL
    case invalidResponse
    case invalidDate
    case emptyResponse

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            "La URL de la API no es válida."
        case .invalidResponse:
            "La API no respondió correctamente."
        case .invalidDate:
            "La API devolvió una fecha inválida."
        case .emptyResponse:
            "La API no devolvió las cotizaciones esperadas."
        }
    }
}
