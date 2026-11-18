import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:seguros_app/core/theme/app_theme.dart';
import 'package:seguros_app/core/utils/validators.dart';
import 'package:seguros_app/core/widgets/pill_input.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.initialCpf});

  /// CPF (só dígitos) lembrado de um login anterior.
  final String? initialCpf;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final MaskTextInputFormatter _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
    initialText: widget.initialCpf ?? '',
  );
  late final TextEditingController _cpfCtrl =
      TextEditingController(text: _cpfMask.getMaskedText());
  final _nameCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _isLogin = true;
  bool _remember = true;
  bool _obscure = true;

  @override
  void dispose() {
    _cpfCtrl.dispose();
    _nameCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final bloc = context.read<AuthBloc>();
    final cpf = _cpfMask.getUnmaskedText();
    if (_isLogin) {
      bloc.add(AuthLoginRequested(cpf, _passCtrl.text, remember: _remember));
    } else {
      bloc.add(
        AuthRegisterRequested(
          name: _nameCtrl.text.trim(),
          cpf: cpf,
          password: _passCtrl.text,
        ),
      );
    }
  }

  void _forgotPassword() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Esqueceu a senha?'),
        content: const Text(
          'Fluxo ilustrativo neste desafio: o login usa o CPF como '
          'identificador e a conta não possui um e-mail real associado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final loading = state is AuthLoading;
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration:
                          const BoxDecoration(gradient: AppColors.gradient),
                    ),
                  ),
                  const Expanded(
                    flex: 4,
                    child: ColoredBox(color: AppColors.background),
                  ),
                ],
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        children: [
                          const _Header(),
                          const SizedBox(height: 24),
                          _buildCard(),
                          Transform.translate(
                            offset: const Offset(0, -28),
                            child: _SubmitButton(
                              loading: loading,
                              onPressed: _submit,
                            ),
                          ),
                          const _SocialFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 44),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 16)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _TabButton(
                key: const Key('tab_login'),
                label: 'Entrar',
                selected: _isLogin,
                onTap: () => setState(() => _isLogin = true),
              ),
              const SizedBox(width: 8),
              _TabButton(
                key: const Key('tab_register'),
                label: 'Cadastrar',
                selected: !_isLogin,
                onTap: () => setState(() => _isLogin = false),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            // A key troca o estado dos campos (limpa erros) ao alternar a aba.
            child: Column(
              key: ValueKey(_isLogin),
              children: [
                if (!_isLogin) ...[
                  TextFormField(
                    key: const Key('name_field'),
                    controller: _nameCtrl,
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.words,
                    decoration: pillInput('Nome completo'),
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 12),
                ],
                TextFormField(
                  key: const Key('cpf_field'),
                  controller: _cpfCtrl,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_cpfMask],
                  decoration: pillInput('CPF'),
                  validator: Validators.cpf,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('password_field'),
                  controller: _passCtrl,
                  textAlign: TextAlign.center,
                  obscureText: _obscure,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
                  decoration: pillInput(
                    'Senha',
                    suffix: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: Validators.password,
                ),
                if (!_isLogin) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('confirm_field'),
                    controller: _confirmCtrl,
                    textAlign: TextAlign.center,
                    obscureText: _obscure,
                    decoration: pillInput('Confirmar senha'),
                    validator: (v) =>
                        v == _passCtrl.text ? null : 'As senhas não conferem',
                  ),
                ],
              ],
            ),
          ),
          if (_isLogin)
            Row(
              children: [
                Checkbox(
                  key: const Key('remember_checkbox'),
                  value: _remember,
                  activeColor: AppColors.primary,
                  shape: const CircleBorder(),
                  onChanged: (v) => setState(() => _remember = v ?? false),
                ),
                const Flexible(
                  child: Text('Lembrar sempre', style: TextStyle(fontSize: 13)),
                ),
                const Spacer(),
                TextButton(
                  key: const Key('forgot_password'),
                  onPressed: _forgotPassword,
                  child: const Text(
                    'Esqueceu a senha?',
                    style: TextStyle(color: AppColors.primary, fontSize: 13),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.shield_outlined, size: 40, color: Colors.white),
        SizedBox(height: 4),
        Text('SEGUROS',
            style: TextStyle(
                letterSpacing: 4,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        SizedBox(height: 24),
        Text('Bem vindo!',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        SizedBox(height: 6),
        Text(
          'Aqui você gerencia seus seguros e de seus familiares em poucos cliques!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: selected ? AppColors.primary : Colors.white,
          decoration: selected ? TextDecoration.underline : null,
          decorationColor: AppColors.primary,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.loading, required this.onPressed});
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.gradient,
        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10)],
      ),
      child: IconButton(
        key: const Key('submit_button'),
        tooltip: 'Entrar',
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}

/// Redes sociais apenas ilustrativas (sem ação), conforme o enunciado.
class _SocialFooter extends StatelessWidget {
  const _SocialFooter();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Acesse através das redes sociais',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialGlyph('G'),
            SizedBox(width: 28),
            _SocialGlyph('f'),
            SizedBox(width: 28),
            _SocialGlyph('X'),
          ],
        ),
      ],
    );
  }
}

class _SocialGlyph extends StatelessWidget {
  const _SocialGlyph(this.letter);
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white54),
      ),
      child: Text(
        letter,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
    );
  }
}
