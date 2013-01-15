From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] libe2p: teach parse_num_blocks2() to return bytes if log_block_size < 0
Date: Mon, 14 Jan 2013 19:37:10 -0500
Message-ID: <1358210232-30578-3-git-send-email-tytso@mit.edu>
References: <20130114211014.GA22642@thunk.org>
 <1358210232-30578-1-git-send-email-tytso@mit.edu>
Cc: gnehzuil.liu@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43392 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760Ab3AOAhY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 19:37:24 -0500
In-Reply-To: <1358210232-30578-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Previously the behavior of parse_num_block2 was undefined if
log_block_size was less than zero.  It will now return a number in
units of bytes.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/e2p/parse_num.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/lib/e2p/parse_num.c b/lib/e2p/parse_num.c
index d9ad3e7..cb0dc5b 100644
--- a/lib/e2p/parse_num.c
+++ b/lib/e2p/parse_num.c
@@ -35,10 +35,16 @@ unsigned long long parse_num_blocks2(const char *arg, int log_block_size)
 		num <<= 10;
 		/* fallthrough */
 	case 'K': case 'k':
-		num >>= log_block_size;
+		if (log_block_size < 0)
+			num <<= 10;
+		else
+			num >>= log_block_size;
 		break;
 	case 's':
-		num >>= (1+log_block_size);
+		if (log_block_size < 0)
+			num << 1;
+		else
+			num >>= (1+log_block_size);
 		break;
 	case '\0':
 		break;
@@ -62,11 +68,21 @@ main(int argc, char **argv)
 	unsigned long num;
 	int log_block_size = 0;
 
-	if (argc != 2) {
-		fprintf(stderr, "Usage: %s arg\n", argv[0]);
+	if (argc != 2 && argc != 3) {
+		fprintf(stderr, "Usage: %s arg [log_block_size]\n", argv[0]);
 		exit(1);
 	}
 
+	if (argc == 3) {
+		char *p;
+
+		log_block_size = strtol(argv[2], &p, 0);
+		if (*p) {
+			fprintf(stderr, "Bad log_block_size: %s\n", argv[2]);
+			exit(1);
+		}
+	}
+
 	num = parse_num_blocks(argv[1], log_block_size);
 
 	printf("Parsed number: %lu\n", num);
-- 
1.7.12.rc0.22.gcdd159b

