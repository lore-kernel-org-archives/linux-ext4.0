From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] badblocks: Use unsigned int instead of unsigned long for test patterns
Date: Mon, 22 Oct 2007 11:19:20 -0400
Message-ID: <1193066362-11222-1-git-send-email-tytso@mit.edu>
References: <20071022141641.GA6619@thunk.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52185 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbXJVPTe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2007 11:19:34 -0400
In-Reply-To: <20071022141641.GA6619@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/badblocks.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/misc/badblocks.c b/misc/badblocks.c
index 29c5a5c..155fb77 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -67,7 +67,7 @@ static int s_flag = 0;			/* show progress of test */
 static int force = 0;			/* force check of mounted device */
 static int t_flag = 0;			/* number of test patterns */
 static int t_max = 0;			/* allocated test patterns */
-static unsigned long *t_patts = NULL;	/* test patterns */
+static unsigned int *t_patts = NULL;	/* test patterns */
 static int current_O_DIRECT = 0;	/* Current status of O_DIRECT flag */
 static int exclusive_ok = 0;
 
@@ -221,13 +221,13 @@ static void set_o_direct(int dev, unsigned char *buffer, size_t size,
 }
 
 
-static void pattern_fill(unsigned char *buffer, unsigned long pattern,
+static void pattern_fill(unsigned char *buffer, unsigned int pattern,
 			 size_t n)
 {
 	unsigned int	i, nb;
 	unsigned char	bpattern[sizeof(pattern)], *ptr;
 	
-	if (pattern == (unsigned long) ~0) {
+	if (pattern == (unsigned int) ~0) {
 		for (ptr = buffer; ptr < buffer + n; ptr++) {
 			(*ptr) = random() % (1 << (8 * sizeof(char)));
 		}
@@ -435,8 +435,8 @@ static unsigned int test_rw (int dev, unsigned long last_block,
 			     unsigned long blocks_at_once)
 {
 	unsigned char *buffer, *read_buffer;
-	const unsigned long patterns[] = {0xaa, 0x55, 0xff, 0x00};
-	const unsigned long *pattern;
+	const unsigned int patterns[] = {0xaa, 0x55, 0xff, 0x00};
+	const unsigned int *pattern;
 	int i, try, got, nr_pattern, pat_idx;
 	unsigned int bb_count = 0;
 
@@ -562,8 +562,8 @@ static unsigned int test_nd (int dev, unsigned long last_block,
 	unsigned char *blkbuf, *save_ptr, *test_ptr, *read_ptr;
 	unsigned char *test_base, *save_base, *read_base;
 	int try, i;
-	const unsigned long patterns[] = { ~0 };
-	const unsigned long *pattern;
+	const unsigned int patterns[] = { ~0 };
+	const unsigned int *pattern;
 	int nr_pattern, pat_idx;
 	long got, used2, written, save_currently_testing;
 	struct saved_blk_record *test_record;
@@ -830,7 +830,7 @@ int main (int argc, char ** argv)
 	int passes_clean = 0;
 	int dev;
 	errcode_t errcode;
-	unsigned long pattern;
+	unsigned int pattern;
 	unsigned int (*test_func)(int, unsigned long,
 				  int, unsigned long,
 				  unsigned long);
@@ -920,7 +920,7 @@ int main (int argc, char ** argv)
 			break;
 		case 't':
 			if (t_flag + 1 > t_max) {
-				unsigned long *t_patts_new;
+				unsigned int *t_patts_new;
 
 				t_patts_new = realloc(t_patts, t_max + T_INC);
 				if (!t_patts_new) {
@@ -943,7 +943,7 @@ int main (int argc, char ** argv)
 						optarg);
 					exit(1);
 				}
-				if (pattern == (unsigned long) ~0)
+				if (pattern == (unsigned int) ~0)
 					pattern = 0xffff;
 				t_patts[t_flag++] = pattern;
 			}
@@ -962,7 +962,7 @@ int main (int argc, char ** argv)
 			  "in read-only mode"));
 			exit(1);
 		}
-		if (t_patts && (t_patts[0] == (unsigned long) ~0)) {
+		if (t_patts && (t_patts[0] == (unsigned int) ~0)) {
 			com_err(program_name, 0,
 			_("Random test_pattern is not allowed "
 			  "in read-only mode"));
-- 
1.5.3.4.1232.g9991d-dirty
