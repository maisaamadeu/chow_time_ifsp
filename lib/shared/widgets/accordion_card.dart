import 'package:flutter/material.dart';

class AccordionCard extends StatefulWidget {
  const AccordionCard({super.key, required this.title, required this.content});

  final String title;
  final Widget content;

  @override
  State<AccordionCard> createState() => _AccordionCardState();
}

class _AccordionCardState extends State<AccordionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Duração da animação
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            title: Text(widget.title),
            trailing: IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_arrow,
                progress: _animationController,
              ),
              onPressed: () {
                if (_animationController.isCompleted) {
                  _animationController.reverse();
                  setState(() {
                    isExpanded = false;
                  });
                } else {
                  _animationController.forward();
                  setState(() {
                    isExpanded = true;
                  });
                }
              },
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              height: isExpanded ? 350 : 0,
              child: widget.content,
            ),
          ),
        ],
      ),
    );
  }
}
