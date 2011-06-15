From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 02/11 RESEND] filefrag: Output fragmentation score
Date: Wed, 15 Jun 2011 15:33:35 +0900
Message-ID: <4DF8523F.6020108@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:64662 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab1FOGmS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jun 2011 02:42:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds the fragmentation score to the output of filefrag.
The threshold that shows whether a fragment is good or not comes from
"blocksize * 8 - 2048". "blocksize * 8 - 2048" is the maximum number of
contiguous blocks which we can get from empty blockgroup containing some
metadata blocks.

For example, filefrag shows fragmentation score as follows:

# filefrag /mnt/mp1/testfile
/mnt/mp1/testfile: 4 extents found
Fragmentation score: 33 (found a little bit fragmentation)

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/Makefile.in |    4 ++--
 misc/filefrag.c  |   28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 2 deletions(-)
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 86ee53f..19eaa43 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -306,9 +306,9 @@ e2freefrag: $(E2FREEFRAG_OBJS)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o e2freefrag $(E2FREEFRAG_OBJS) $(LIBS)
 
-filefrag: $(FILEFRAG_OBJS)
+filefrag: $(FILEFRAG_OBJS) $(DEPLIBS_E2P)
 	$(E) "	LD $@"
-	$(Q) $(CC) $(ALL_LDFLAGS) -o filefrag $(FILEFRAG_OBJS) 
+	$(Q) $(CC) $(ALL_LDFLAGS) -o filefrag $(FILEFRAG_OBJS) $(DEPLIBS_E2P)
 
 filefrag.profiled: $(PROFILED_FILEFRAG_OBJS)
 	$(E) "	LD $@"
diff --git a/misc/filefrag.c b/misc/filefrag.c
index 2795e15..ca9833a 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -41,6 +41,7 @@ extern int optind;
 #include <linux/fd.h>
 #include <ext2fs/ext2_types.h>
 #include <ext2fs/fiemap.h>
+#include "e2p/e2p.h"
 
 int verbose = 0;
 int no_bs = 0;		/* Don't use the files blocksize, use 1K blocksize */
@@ -279,6 +280,7 @@ static void frag_report(const char *filename)
 	int		is_ext2 = 0;
 	static int	once = 1;
 	unsigned int	flags;
+	int score;
 	int rc;
 
 #ifdef HAVE_OPEN64
@@ -379,6 +381,32 @@ static void frag_report(const char *filename)
 			(expected>1) ? "s" : "");
 	else
 		fputc('\n', stdout);
+
+	if (!xattr_map) {
+		/*
+		 * Get the fragmentation score.
+		 * NOTE: 2048 means the maximum block region of mballoc.
+		 */
+		score = get_fragment_score(fd,
+			(fsinfo.f_bsize * 8 - 2048) * fsinfo.f_bsize);
+
+		/*
+		 * Print fragmentation score with some comments
+		 * 0-30 no problem, 31-55 a little bit fragmented,
+		 * 56- needs defrag
+		 */
+		if (score < 0)
+			;
+		else if (score <= 30)
+			printf("Fragmentation score: %d (no problem)\n", score);
+		else if (score <= 55)
+			printf("Fragmentation score: %d "
+				"(found a little bit fragmentation)\n", score);
+		else
+			printf("Fragmentation score: %d "
+				"(need to do e4defrag command)\n", score);
+	}
+
 	close(fd);
 	once = 0;
 }

