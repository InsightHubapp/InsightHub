import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlight/highlight.dart' show highlight, Node;
import 'package:flutter_highlight/themes/atom-one-dark.dart';

class QuizCodeBlock extends StatefulWidget {
  final String code;
  final String? language;

  const QuizCodeBlock({super.key, required this.code, this.language});

  @override
  State<QuizCodeBlock> createState() => _QuizCodeBlockState();
}

class _QuizCodeBlockState extends State<QuizCodeBlock> {
  bool _isExpanded = false;
  bool _canExpand = false;
  final ScrollController _scrollController = ScrollController();

  List<_CodeLine> _lines = [];

  @override
  void initState() {
    super.initState();
    _parseCode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScrollable();
    });
  }

  @override
  void didUpdateWidget(covariant QuizCodeBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code || oldWidget.language != widget.language) {
      _parseCode();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkScrollable();
      });
    }
  }

  void _parseCode() {
    final codeText = widget.code.trimRight();
    final lang = widget.language?.trim().toLowerCase() ?? 'dart';
    
    final result = highlight.parse(codeText, language: lang);
    final nodes = result.nodes ?? [];

    List<_CodeLine> lines = [];
    List<TextSpan> currentLineSpans = [];

    void traverse(Node node, TextStyle? currentStyle) {
      final style = atomOneDarkTheme[node.className] ?? currentStyle;

      if (node.value != null) {
        final text = node.value!;
        final parts = text.split('\n');
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].isNotEmpty) {
            currentLineSpans.add(TextSpan(text: parts[i], style: style));
          }
          if (i < parts.length - 1) {
            lines.add(_CodeLine(List.from(currentLineSpans)));
            currentLineSpans.clear();
          }
        }
      } else if (node.children != null) {
        for (var child in node.children!) {
          traverse(child, style);
        }
      }
    }

    final rootStyle = atomOneDarkTheme['root'] ?? const TextStyle(color: Color(0xFFABB2BF));

    for (var node in nodes) {
      traverse(node, rootStyle);
    }

    if (currentLineSpans.isNotEmpty) {
      lines.add(_CodeLine(currentLineSpans));
    }

    if (lines.isEmpty && codeText.isEmpty) {
      lines.add(_CodeLine([]));
    }

    setState(() {
      _lines = lines;
    });
  }

  void _checkScrollable() {
    if (!mounted) return;
    if (!_isExpanded && _scrollController.hasClients) {
      if (_scrollController.position.maxScrollExtent > 0) {
        if (!_canExpand) setState(() => _canExpand = true);
      } else {
        if (_canExpand) setState(() => _canExpand = false);
      }
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Code copied to clipboard', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayLanguage = widget.language?.trim();
    final defaultStyle = GoogleFonts.jetBrainsMono(
      fontSize: 13,
      height: 1.5,
      color: const Color(0xFFABB2BF),
    );

    Widget codeTable = Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
      },
      children: List.generate(_lines.length, (index) {
        final lineNumber = index + 1;
        return TableRow(
          children: [
            SelectionContainer.disabled(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 4.0),
                child: Text(
                  lineNumber.toString(),
                  textAlign: TextAlign.right,
                  style: defaultStyle.copyWith(
                    color: const Color(0xFF4B5263),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Text.rich(
              TextSpan(children: _lines[index].spans),
              style: defaultStyle,
            ),
          ],
        );
      }),
    );

    Widget scrollableCode = SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: SelectionArea(child: codeTable),
    );

    Widget content;
    if (_isExpanded) {
      content = scrollableCode;
    } else {
      content = ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: scrollableCode,
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF282C34), 
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3E4451)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF21252B),
              border: Border(bottom: BorderSide(color: Color(0xFF181A1F))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (displayLanguage != null && displayLanguage.isNotEmpty)
                  Text(
                    displayLanguage,
                    style: const TextStyle(
                      color: Color(0xFF61AFEF),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                InkWell(
                  onTap: _copyToClipboard,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.copy, size: 14, color: Color(0xFFABB2BF)),
                        SizedBox(width: 4),
                        Text(
                          'Copy',
                          style: TextStyle(
                            color: Color(0xFFABB2BF),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              content,
              
              if (_canExpand && !_isExpanded)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF282C34).withOpacity(0),
                          const Color(0xFF282C34),
                        ],
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isExpanded = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3E4451),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Expand Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
              if (_isExpanded)
                Positioned(
                  bottom: 8,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isExpanded = false;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollController.jumpTo(0);
                          _checkScrollable();
                        });
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E4451).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Collapse',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CodeLine {
  final List<TextSpan> spans;
  _CodeLine(this.spans);
}
