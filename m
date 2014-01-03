From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/5] e2image: eliminate division by zero
Date: Fri,  3 Jan 2014 00:29:55 -0500
Message-ID: <1388726998-14349-2-git-send-email-tytso@mit.edu>
References: <1388726998-14349-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45547 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaACFaN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 00:30:13 -0500
In-Reply-To: <1388726998-14349-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dividing a floating point number by zero is undefined in C.  It
happens to work with gcc/glibc, but it's not something that's
guaranteed.

Addresses-Coverity-ID: #1147781

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2image.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index 253fad1..ac62ffe 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -704,14 +704,15 @@ more_blocks:
 	if (show_progress) {
 		time_t duration = time(NULL) - start_time;
 		char buff[30];
-		while (bscount--)
-			fputc('\b', stderr);
+		fputc('\r', stderr);
 		strftime(buff, 30, "%T", gmtime(&duration));
-		fprintf(stderr, _("\b\b\b\b\b\b\b\bCopied %llu / %llu "
-			 "blocks (%d%%) in %s at %.2f MB/s       \n"),
-		       total_written, meta_blocks_count,
-		       calc_percent(total_written, meta_blocks_count), buff,
-		       calc_rate(total_written, fs->blocksize, duration));
+		fprintf(stderr, _("Copied %llu / %llu blocks (%d%%) in %s "),
+			total_written, meta_blocks_count,
+			calc_percent(total_written, meta_blocks_count), buff);
+		if (duration)
+			fprintf(stderr, _("at %.2f MB/s"),
+				calc_rate(total_written, fs->blocksize, duration));
+		fputs("       \n", stderr);
 	}
 #ifdef HAVE_FTRUNCATE64
 	if (sparse) {
-- 
1.8.5.rc3.362.gdf10213

