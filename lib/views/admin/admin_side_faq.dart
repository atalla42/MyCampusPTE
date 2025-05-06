import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:mycampuspte/views/admin/add_faq.dart';
import 'package:mycampuspte/widgets/faq_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:mycampuspte/providers/faq_provider.dart';

class AdminSideFAQ extends StatelessWidget {
  final ScrollController scrollController;
  const AdminSideFAQ({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FaqProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: size.width,
            height: size.height / 4,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.03,
                    ),
                    child: Text(
                      "Resources",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: (size.width < 550) ? 20 : 24,
                        color: white,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: TextField(
                      onChanged: provider.updateSearchQuery,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search ...',
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<FaqProvider>(
              builder: (context, provider, _) {
                final faqs = provider.faqs;

                if (faqs.isEmpty) {
                  return const Center(child: Text('No FAQs available'));
                }

                return ListView.builder(
                controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: faqs.length,
                  itemBuilder: (context, index) {
                    final faq = faqs[index];
                    final faqId = faq.id;
                    final data = faq.data() as Map<String, dynamic>;

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                        vertical: size.height * 0.002,
                      ),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            CustomSlidableAction(
                              backgroundColor: Colors.transparent,
                              onPressed: (context) =>
                                  provider.deleteFaq(faqId, context),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        child: Card(
                          color: tileColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.question_answer,
                                color: Colors.white),
                            title: Text(
                              data['question'] ?? '',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: (size.width < 550) ? 14 : 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              data['answer'] ?? '',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: (size.width < 550) ? 12 : 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing:
                                Icon(Icons.arrow_forward_ios, color: white),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FaqPage(
                                    question: data['question'],
                                    answer: data['answer'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddFaq()),
          );
        },
        child: Icon(Icons.add, color: white),
      ),
    );
  }
}
