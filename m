From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 4/4] e2image: handle SIGINT safely
Date: Tue,  8 Oct 2013 11:56:32 -0400
Message-ID: <1381247792-22508-5-git-send-email-psusi@ubuntu.com>
References: <1381247792-22508-1-git-send-email-psusi@ubuntu.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rrcs-67-78-168-186.se.biz.rr.com ([67.78.168.186]:47920 "EHLO
	iriserv.iradimed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3JHP4e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Oct 2013 11:56:34 -0400
In-Reply-To: <1381247792-22508-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When doing an in place move, interrupting it past the
point of no return will destroy the filesystem since
parts of it have been overwritten.  Catch SIGINT the
first time and issue a warning if this is the case.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 misc/e2image.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/misc/e2image.c b/misc/e2image.c
index 27be2b1..2340f15 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -35,6 +35,7 @@ extern int optind;
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <assert.h>
+#include <signal.h>
 
 #include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fs.h"
@@ -484,6 +485,14 @@ static void scramble_dir_block(ext2_filsys fs, blk64_t blk, char *buf)
 	}
 }
 
+static char got_sigint;
+
+static void sigint_handler(int unsused)
+{
+	got_sigint = 1;
+	signal (SIGINT, SIG_DFL);
+}
+
 static void output_meta_data_blocks(ext2_filsys fs, int fd)
 {
 	errcode_t	retval;
@@ -527,10 +536,39 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 		if (distance < ext2fs_blocks_count(fs->super))
 			start = ext2fs_blocks_count(fs->super) - distance;
 	}
+	if (move_mode)
+		signal (SIGINT, sigint_handler);
 more_blocks:
 	if (distance)
 		ext2fs_llseek (fd, (start * fs->blocksize) + dest_offset, SEEK_SET);
 	for (blk = start; blk < end; blk++) {
+		if (got_sigint) {
+			if (distance) {
+				/* moving to the right */
+				if (distance >= ext2fs_blocks_count(fs->super) ||
+				    start == ext2fs_blocks_count(fs->super) - distance)
+					kill (getpid(), SIGINT);
+			} else {
+				/* moving to the left */
+				if (blk < (source_offset - dest_offset) / fs->blocksize)
+					kill (getpid(), SIGINT);
+			}
+			if (show_progress)
+				printf ("\r");
+			printf ("Stopping now will destroy the filesystem, "
+				"interrupt again if you are sure\n");
+			if (show_progress) {
+				printf("Copying ");
+				bscount = printf("%llu / %llu blocks (%llu%%)",
+						 total_written,
+						 meta_blocks_count,
+						 (total_written + 50) / ((meta_blocks_count + 50)
+									 / 100));
+				fflush(stdout);
+			}
+
+			got_sigint = 0;
+		}
 		if (show_progress && last_update != time(NULL)) {
 			last_update = time(NULL);
 			while (bscount--)
@@ -600,6 +638,7 @@ more_blocks:
 		sparse = 0;
 		goto more_blocks;
 	}
+	signal (SIGINT, SIG_DFL);
 	if (show_progress) {
 		while (bscount--)
 			printf("\b");
-- 
1.8.1.2

