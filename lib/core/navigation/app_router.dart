import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/setup_page.dart';
import '../../features/auth/presentation/pages/pin_setup_page.dart';
import '../../features/auth/presentation/pages/pin_login_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/contacts/presentation/pages/add_contact_page.dart';
import '../../features/contacts/presentation/pages/contacts_page.dart';
import '../../features/groups/presentation/pages/groups_page.dart';
import '../../features/groups/presentation/pages/create_group_page.dart';
import '../../features/groups/presentation/pages/group_chat_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/security_settings_page.dart';
import '../session/session_manager.dart';

// Arquivo obsoleto: GoRouter removido. Toda navegação agora é feita pelo Navigator padrão do Flutter.
