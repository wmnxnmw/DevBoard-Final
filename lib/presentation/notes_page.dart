import 'package:flutter/material.dart';

import '../data/note_repository.dart';
import '../domain/note.dart';
import '../domain/ports/env_info.dart';
import 'widgets/section_card.dart';
import 'ports_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({
    required this.repository,
    required this.env,
    required this.ports,
    super.key,
  });

  final NoteRepository repository;
  final EnvInfo env;
  final PortsBundle ports;

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final notes = await widget.repository.getAll();
      if (!mounted) return;
      setState(() {
        _notes = notes;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  Future<void> _addNote() async {
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Нова нотатка'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Введіть текст нотатки',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Скасувати')),
          FilledButton(onPressed: () => Navigator.of(context).pop(controller.text), child: const Text('Зберегти')),
        ],
      ),
    );
    controller.dispose();
    if (text == null) return;
    try {
      await widget.repository.add(text);
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Нотатку збережено')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _removeNote(Note note) async {
    await widget.repository.remove(note.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DevBoard'),
        actions: [
          IconButton(
            tooltip: 'Платформні порти',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PortsPage(repository: widget.repository, ports: widget.ports),
              ),
            ),
            icon: const Icon(Icons.developer_board_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        icon: const Icon(Icons.add),
        label: const Text('Додати нотатку'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            children: [
              Text('Локальний журнал нотаток', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Одна спільна логіка, два способи платформного зберігання.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              SectionCard(
                title: 'Середовище виконання',
                subtitle: 'Інформація надходить через EnvInfo, без платформних перевірок у UI.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(icon: Icons.devices_outlined, label: 'Платформа', value: widget.env.platformName),
                    const SizedBox(height: 10),
                    _InfoRow(icon: Icons.storage_outlined, label: 'Сховище', value: widget.env.storageLocation),
                  ],
                ),
              ),
              if (_error != null)
                SectionCard(
                  title: 'Помилка',
                  subtitle: 'Під час завантаження даних',
                  child: SelectableText(_error!),
                ),
              SectionCard(
                title: 'Нотатки',
                subtitle: 'Дані зберігаються між перезапусками застосунку.',
                child: _loading
                    ? const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
                    : _notes.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: Text('Поки що немає нотаток.')),
                          )
                        : Column(
                            children: _notes
                                .map(
                                  (note) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(note.text),
                                    subtitle: Text(_formatDate(note.createdAt)),
                                    trailing: IconButton(
                                      tooltip: 'Видалити',
                                      onPressed: () => _removeNote(note),
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
              ),
              const SizedBox(height: 4),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PortsPage(repository: widget.repository, ports: widget.ports),
                  ),
                ),
                icon: const Icon(Icons.tune),
                label: const Text('Перевірити 12 індивідуальних портів'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(date.day)}.${two(date.month)}.${date.year} ${two(date.hour)}:${two(date.minute)}:${two(date.second)}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 10),
        SizedBox(width: 92, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text(value)),
      ],
    );
  }
}
