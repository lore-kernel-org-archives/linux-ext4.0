From: Jan Kara <jack@suse.cz>
Subject: [PATCH] badblocks: Limit maximum number of bad blocks
Date: Thu, 11 Sep 2014 12:03:24 +0200
Message-ID: <1410429804-26459-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbaIKKDc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 06:03:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently maximum number of bad blocks is not limited in any way.
However our code can really handle at most INT_MAX/2 bad blocks (for
larger numbers binary search indexes start overflowing). So report
number of bad blocks is just too big instead of plaing segfault.

It won't be too hard to raise the limit but I don't think there's any
real use for disks with over 1 billion of bad blocks...

Signed-off-by: Jan Kara <jack@suse.cz>
---
 misc/badblocks.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/misc/badblocks.c b/misc/badblocks.c
index e5024f6c67d1..2c28ee00ec15 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -65,6 +65,9 @@ extern int optind;
 #define O_LARGEFILE 0
 #endif
 
+/* Maximum number of bad blocks we support */
+#define MAX_BAD_BLOCKS (INT_MAX/2)
+
 static const char * program_name = "badblocks";
 static const char * done_string = N_("done                                                 \n");
 
@@ -78,7 +81,9 @@ static int t_max;			/* allocated test patterns */
 static unsigned int *t_patts;		/* test patterns */
 static int use_buffered_io;
 static int exclusive_ok;
-static unsigned int max_bb;		/* Abort test if more than this number of bad blocks has been encountered */
+static unsigned int max_bb = MAX_BAD_BLOCKS;	/* Abort test if more than this
+						 * number of bad blocks has been
+						 * encountered */
 static unsigned int d_flag;		/* delay factor between reads */
 static struct timeval time_start;
 
@@ -526,7 +531,7 @@ static unsigned int test_ro (int dev, blk_t last_block,
 		alarm_intr(SIGALRM);
 	while (currently_testing < last_block)
 	{
-		if (max_bb && bb_count >= max_bb) {
+		if (bb_count >= max_bb) {
 			if (s_flag || v_flag) {
 				fputs(_("Too many bad blocks, aborting test\n"), stderr);
 			}
@@ -633,7 +638,7 @@ static unsigned int test_rw (int dev, blk_t last_block,
 
 		try = blocks_at_once;
 		while (currently_testing < last_block) {
-			if (max_bb && bb_count >= max_bb) {
+			if (bb_count >= max_bb) {
 				if (s_flag || v_flag) {
 					fputs(_("Too many bad blocks, aborting test\n"), stderr);
 				}
@@ -675,7 +680,7 @@ static unsigned int test_rw (int dev, blk_t last_block,
 
 		try = blocks_at_once;
 		while (currently_testing < last_block) {
-			if (max_bb && bb_count >= max_bb) {
+			if (bb_count >= max_bb) {
 				if (s_flag || v_flag) {
 					fputs(_("Too many bad blocks, aborting test\n"), stderr);
 				}
@@ -822,7 +827,7 @@ static unsigned int test_nd (int dev, blk_t last_block,
 			alarm_intr(SIGALRM);
 
 		while (currently_testing < last_block) {
-			if (max_bb && bb_count >= max_bb) {
+			if (bb_count >= max_bb) {
 				if (s_flag || v_flag) {
 					fputs(_("Too many bad blocks, aborting test\n"), stderr);
 				}
@@ -1117,6 +1122,16 @@ int main (int argc, char ** argv)
 			break;
 		case 'e':
 			max_bb = parse_uint(optarg, "max bad block count");
+			if (max_bb > MAX_BAD_BLOCKS) {
+				com_err (program_name, 0,
+					 _("Too big max bad blocks count %u - "
+					   "maximum is %u"), max_bb,
+					   MAX_BAD_BLOCKS);
+				exit (1);
+			}
+			/* 0 really means unlimited but we cannot do that much... */
+			if (max_bb == 0)
+				max_bb = MAX_BAD_BLOCKS;
 			break;
 		case 'd':
 			d_flag = parse_uint(optarg, "read delay factor");
-- 
1.8.1.4

