import 'package:flutter/material.dart';
import 'package:jornada_verde/core/theme/app_colors.dart';

/// Exibe loading, executa a requisição e mostra SnackBar de sucesso ou erro.
abstract final class ApiFeedback {
  static Future<T?> execute<T>({
    required BuildContext context,
    required Future<T> Function() request,
    required String successMessage,
    void Function(T data)? onSuccess,
    bool showSuccessSnackBar = true,
  }) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryGreen),
                  SizedBox(height: 16),
                  Text('Aguarde...'),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    try {
      final result = await request();
      if (!context.mounted) return null;
      Navigator.of(context, rootNavigator: true).pop();

      if (showSuccessSnackBar) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }

      onSuccess?.call(result);
      return result;
    } catch (error) {
      if (!context.mounted) return null;
      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_messageFrom(error)),
          backgroundColor: AppColors.red,
        ),
      );
      return null;
    }
  }

  static String _messageFrom(Object error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Erro inesperado. Tente novamente.';
  }
}
