From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v3 05/11] e4defrag: Add force option for e4defrag
Date: Mon, 14 Nov 2011 15:24:37 +0900
Message-ID: <4EC0B425.2080901@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:51590 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1KNGh5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Nov 2011 01:37:57 -0500
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id pAE6buXO024386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Nov 2011 15:37:56 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, e4defrag calls EXT4_IOC_MOVE_EXT ioctl if the fragmentation score
of a donor file is zero. However, it is difficult sometimes to create the file
that has the average of 4096 blocks per extent. We can use e4defrag -F to defrag
in this case.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.8.in |    5 ++++-
 misc/e4defrag.c    |   14 ++++++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)
diff --git a/misc/e4defrag.8.in b/misc/e4defrag.8.in
index 3997f75..e91ac85 100644
--- a/misc/e4defrag.8.in
+++ b/misc/e4defrag.8.in
@@ -4,7 +4,7 @@ e4defrag \- online defragmenter for ext4 filesystem
 .SH SYNOPSIS
 .B e4defrag
 [
-.B \-v
+.B \-Fv
 ]
 .I target
 \&...
@@ -31,6 +31,9 @@ gets the mount point of it and reduces fragmentation of all files in this mount
 point.
 .SH OPTIONS
 .TP
+.B \-F
+Force defrag if the fragmentation gets better.
+.TP
 .B \-v
 Print error messages and the fragmentation count before and after defrag for
 each file.
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index c1599fd..8b19776 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -81,6 +81,7 @@
 
 /* The mode of defrag */
 #define DETAIL			0x01
+#define FORCE			0x02
 
 #define DEVNAME			0
 #define DIRNAME			1
@@ -108,7 +109,7 @@
 
 /* The following macros are error message */
 #define MSG_USAGE		\
-"Usage	: e4defrag [-v] file...| directory...| device...\n"
+"Usage	: e4defrag [-Fv] file...| directory...| device...\n"
 
 #define NGMSG_EXT4		"Filesystem is not ext4 filesystem"
 #define NGMSG_FILE_EXTENT	"Failed to get file extents"
@@ -1157,7 +1158,8 @@ check_improvement:
 		extents_before_defrag += file_frags_start;
 	}
 
-	if (orig_score == 0 || donor_score > 0) {
+	if (orig_score == 0 || (donor_score > 0 && !(mode_flag & FORCE)) ||
+			(orig_score <= donor_score && (mode_flag & FORCE))) {
 		printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
 			defraged_file_count, total_count, file, 100);
 		if (mode_flag & DETAIL)
@@ -1236,8 +1238,12 @@ int main(int argc, char *argv[])
 	if (argc == 1)
 		goto out;
 
-	while ((opt = getopt(argc, argv, "v")) != EOF) {
+	while ((opt = getopt(argc, argv, "Fv")) != EOF) {
 		switch (opt) {
+		case 'F':
+			/* Force defrag if the fragmentation gets better */
+			mode_flag |= FORCE;
+			break;
 		case 'v':
 			mode_flag |= DETAIL;
 			break;
@@ -1250,7 +1256,7 @@ int main(int argc, char *argv[])
 		goto out;
 
 	current_uid = getuid();
-	threshold = DEFAULT_THRESHOLD;
+	threshold = (mode_flag & FORCE) ? ~0U : DEFAULT_THRESHOLD;
 
 	/* Main process */
 	for (i = optind; i < argc; i++) {
