import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mycampuspte/providers/mails_provider.dart';
import 'package:mycampuspte/utils/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycampuspte/views/admin/detailed_mail.dart';

class Mails extends StatefulWidget {
  final ScrollController scrollController;
  const Mails({super.key, required this.scrollController});

  @override
  State<Mails> createState() => _MailsState();
}

class _MailsState extends State<Mails> {
  String _searchQuery = '';

  String _formatDate(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: Column(
        children: [
          // Header & Search
          Container(
            width: width,
            height: height / 4,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.03),
                    child: Text(
                      "Mails",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: white,
                        fontSize: (width < 550) ? 20 : 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                        Provider.of<MailProvider>(context, listen: false)
                            .filterMails(_searchQuery);
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search mails...',
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

          // Mail List with Consumer
          Expanded(
            child: Consumer<MailProvider>(
              builder: (context, mailProvider, child) {
                final mails = mailProvider.mails;

                if (mails.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  controller: widget.scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: mails.length,
                  itemBuilder: (context, index) {
                    final mail = mails[index];
                    final mailId = mail.id;
                    final data = mail.data() as Map<String, dynamic>;

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: height * 0.005,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          tileColor: tileColor,
                          leading: const Icon(Icons.mail_outline,
                              color: Colors.white),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  data['name'] ?? '',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: (width < 550) ? 14 : 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _formatDate(data['timestamp']),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            data['message'],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: (width < 550) ? 12 : 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: data['isRead'] == false
                              ? const Icon(Icons.brightness_1,
                                  color: Colors.red, size: 10)
                              : null,
                          onTap: () async {
                            if (data['isRead'] == false) {
                              await mailProvider.markAsRead(mailId);
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MailDetailPage(
                                  name: data['name'],
                                  email: data['email'],
                                  message: data['message'],
                                  mailId: mailId,
                                  timestamp: data['timestamp'],
                                ),
                              ),
                            );
                          },
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
    );
  }
}
