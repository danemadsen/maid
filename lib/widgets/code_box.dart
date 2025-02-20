part of 'package:maid/main.dart';

class CodeBox extends StatelessWidget {
  final String code;

  const CodeBox({super.key, required this.code});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: buildBox(context),
  );
  
  
  Widget buildBox(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTopBar(context),
        buildCode(context),
      ],
    )
  );

  Widget buildTopBar(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceBright,
    ),
    height: 25,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildCodeTitle(context),
        buildCopyCodeButtom(context),
      ],
    ),
  );

  Widget buildCodeTitle(BuildContext context) => Text(
    'Code',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 12,
    ),
  );

  Widget buildCopyCodeButtom(BuildContext context) => TextButton.icon(
    icon: Icon(Icons.content_paste_rounded, color: Theme.of(context).colorScheme.onSurface, size: 15),
    label: Text(
      'Copy Code',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 12,
      ),
    ),
    onPressed: () {
      Clipboard.setData(ClipboardData(text: code));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Code copied to clipboard!")),
      );
    },
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: const Size(10, 10),
    ),
  );

  Widget buildCode(BuildContext context) => Container(
    width: double.infinity,
    color: Colors.black,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      scrollDirection: Axis.horizontal,
      child: buildCodeText()
    ),
  );

  Widget buildCodeText() => SelectableText(
    code,
    style: const TextStyle(
      color: Colors.white,
      fontFamily: 'monospace',
    ),
  );
}