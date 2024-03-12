import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientInstance {
  static final SupabaseClient _instance = SupabaseClient(
    'https://gcsoenjtznqmxcmakolu.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdjc29lbmp0em5xbXhjbWFrb2x1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAxMjkyNjUsImV4cCI6MjAyNTcwNTI2NX0.uu2sjs07cps91Aeuhh3TDsukZH-Hn-oG94saoxXmXEM',
  );

  static SupabaseClient get instance => _instance;
}