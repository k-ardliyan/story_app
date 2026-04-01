import '../../l10n/app_localizations.dart';
import 'app_error_codes.dart';
import 'app_error_mapper.dart';

class AppErrorMessageResolver {
  static String fromCode(AppLocalizations l10n, String? code) {
    switch (code) {
      case AppErrorCodes.noInternet:
        return l10n.offlineError;
      case AppErrorCodes.requestTimeout:
        return l10n.requestTimeoutError;
      case AppErrorCodes.sessionExpired:
        return l10n.sessionExpiredError;
      case AppErrorCodes.unauthorized:
        return l10n.unauthorizedError;
      case AppErrorCodes.forbidden:
        return l10n.forbiddenError;
      case AppErrorCodes.notFound:
        return l10n.notFoundError;
      case AppErrorCodes.tooManyRequests:
        return l10n.tooManyRequestsError;
      case AppErrorCodes.server:
        return l10n.serverError;
      case AppErrorCodes.badRequest:
        return l10n.badRequestError;
      case AppErrorCodes.serviceUnavailable:
        return l10n.serviceUnavailableError;
      default:
        return l10n.genericError;
    }
  }

  static String fromError(AppLocalizations l10n, Object? error) {
    if (error == null) {
      return l10n.genericError;
    }

    return fromCode(l10n, AppErrorMapper.toCode(error));
  }
}
