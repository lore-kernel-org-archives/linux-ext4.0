From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/37] dumpe2fs: add switch to disable checksum verification
Date: Thu, 01 May 2014 16:13:54 -0700
Message-ID: <20140501231354.31890.36717.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39097 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaEAXN6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:13:58 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a -n switch to turn off checksum verification.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/dumpe2fs.8.in |    3 +++
 misc/dumpe2fs.c    |   10 +++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)


diff --git a/misc/dumpe2fs.8.in b/misc/dumpe2fs.8.in
index befaf94..51614db 100644
--- a/misc/dumpe2fs.8.in
+++ b/misc/dumpe2fs.8.in
@@ -61,6 +61,9 @@ using
 .I device
 as the pathname to the image file.
 .TP
+.B \-n
+Don't verify checksums when dumping the filesystem.
+.TP
 .B \-x
 print the detailed group information block numbers in hexadecimal format
 .TP
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index ae54f8a..3a3684b 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -52,7 +52,7 @@ static int blocks64 = 0;
 
 static void usage(void)
 {
-	fprintf (stderr, _("Usage: %s [-bfhixV] [-o superblock=<num>] "
+	fprintf(stderr, _("Usage: %s [-bfhinxV] [-o superblock=<num>] "
 		 "[-o blocksize=<num>] device\n"), program_name);
 	exit (1);
 }
@@ -582,7 +582,9 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 
-	while ((c = getopt (argc, argv, "bfhixVo:")) != EOF) {
+	flags = EXT2_FLAG_JOURNAL_DEV_OK | EXT2_FLAG_SOFTSUPP_FEATURES |
+		EXT2_FLAG_64BITS;
+	while ((c = getopt(argc, argv, "bfhixVo:n")) != EOF) {
 		switch (c) {
 		case 'b':
 			print_badblocks++;
@@ -608,6 +610,9 @@ int main (int argc, char ** argv)
 		case 'x':
 			hex_format++;
 			break;
+		case 'n':
+			flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			break;
 		default:
 			usage();
 		}
@@ -615,7 +620,6 @@ int main (int argc, char ** argv)
 	if (optind > argc - 1)
 		usage();
 	device_name = argv[optind++];
-	flags = EXT2_FLAG_JOURNAL_DEV_OK | EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS;
 	if (force)
 		flags |= EXT2_FLAG_FORCE;
 	if (image_dump)

