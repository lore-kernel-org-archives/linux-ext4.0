From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] badblocks: Change unsigned long to blk_t and unsigned int, as appropriate
Date: Mon, 22 Oct 2007 11:19:21 -0400
Message-ID: <1193066362-11222-2-git-send-email-tytso@mit.edu>
References: <20071022141641.GA6619@thunk.org>
 <1193066362-11222-1-git-send-email-tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52186 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbXJVPTe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2007 11:19:34 -0400
In-Reply-To: <1193066362-11222-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This will make it easier for us to support 64-bit block numbers when
the time comes.  Not that running badblocks on a > 4TB machine is
anything I want to contemplate!

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/badblocks.c |   74 +++++++++++++++++++++++++++++------------------------
 1 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/misc/badblocks.c b/misc/badblocks.c
index 155fb77..a768a8a 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -73,7 +73,7 @@ static int exclusive_ok = 0;
 
 #define T_INC 32
 
-int sys_page_size = 4096;
+unsigned int sys_page_size = 4096;
 
 static void usage(void)
 {
@@ -90,8 +90,8 @@ static void exclusive_usage(void)
 	exit(1);
 }
 
-static unsigned long currently_testing = 0;
-static unsigned long num_blocks = 0;
+static blk_t currently_testing = 0;
+static blk_t num_blocks = 0;
 static ext2_badblocks_list bb_list = NULL;
 static FILE *out;
 static blk_t next_bad = 0;
@@ -124,14 +124,14 @@ static void *allocate_buffer(size_t size)
  * This routine reports a new bad block.  If the bad block has already
  * been seen before, then it returns 0; otherwise it returns 1.
  */
-static int bb_output (unsigned long bad)
+static int bb_output (blk_t bad)
 {
 	errcode_t errcode;
 
 	if (ext2fs_badblocks_list_test(bb_list, bad))
 		return 0;
 
-	fprintf(out, "%lu\n", bad);
+	fprintf(out, "%lu\n", (unsigned long) bad);
 	fflush(out);
 
 	errcode = ext2fs_badblocks_list_add (bb_list, bad);
@@ -151,7 +151,8 @@ static int bb_output (unsigned long bad)
 
 static void print_status(void)
 {
-	fprintf(stderr, "%15ld/%15ld", currently_testing, num_blocks);
+	fprintf(stderr, "%15lu/%15lu", (unsigned long) currently_testing, 
+		(unsigned long) num_blocks);
 	fputs("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b", stderr);
 	fflush (stderr);
 }
@@ -197,7 +198,7 @@ static void uncapture_terminate(void)
 }
 
 static void set_o_direct(int dev, unsigned char *buffer, size_t size,
-			 unsigned long current_block)
+			 blk_t current_block)
 {
 #ifdef O_DIRECT
 	int new_flag = O_DIRECT;
@@ -262,8 +263,8 @@ static void pattern_fill(unsigned char *buffer, unsigned int pattern,
  * Perform a read of a sequence of blocks; return the number of blocks
  *    successfully sequentially read.
  */
-static long do_read (int dev, unsigned char * buffer, int try, int block_size,
-		     unsigned long current_block)
+static int do_read (int dev, unsigned char * buffer, int try, int block_size,
+		    blk_t current_block)
 {
 	long got;
 
@@ -291,8 +292,8 @@ static long do_read (int dev, unsigned char * buffer, int try, int block_size,
  * Perform a write of a sequence of blocks; return the number of blocks
  *    successfully sequentially written.
  */
-static long do_write (int dev, unsigned char * buffer, int try, int block_size,
-		     unsigned long current_block)
+static int do_write(int dev, unsigned char * buffer, int try, int block_size,
+		    unsigned long current_block)
 {
 	long got;
 
@@ -327,13 +328,13 @@ static void flush_bufs(void)
 		com_err(program_name, retval, _("during ext2fs_sync_device"));
 }
 
-static unsigned int test_ro (int dev, unsigned long last_block,
-			     int block_size, unsigned long from_count,
-			     unsigned long blocks_at_once)
+static unsigned int test_ro (int dev, blk_t last_block,
+			     int block_size, blk_t from_count,
+			     unsigned int blocks_at_once)
 {
 	unsigned char * blkbuf;
 	int try;
-	long got;
+	int got;
 	unsigned int bb_count = 0;
 	errcode_t errcode;
 
@@ -358,8 +359,9 @@ static unsigned int test_ro (int dev, unsigned long last_block,
 		exit (1);
 	}
 	if (v_flag) {
-	    fprintf (stderr, _("Checking blocks %lu to %lu\n"), from_count,
-		     last_block - 1);
+		fprintf (stderr, _("Checking blocks %lu to %lu\n"), 
+			 (unsigned long) from_count, 
+			 (unsigned long) last_block - 1);
 	}
 	if (t_flag) {
 		fputs(_("Checking for bad blocks in read-only mode\n"), stderr);
@@ -404,7 +406,7 @@ static unsigned int test_ro (int dev, unsigned long last_block,
 		if (got == try) {
 			try = blocks_at_once;
 			/* recover page-aligned offset for O_DIRECT */
-			if ( blocks_at_once >= (unsigned long) (sys_page_size >> 9)
+			if ( (blocks_at_once >= sys_page_size >> 9)
 			     && (currently_testing % (sys_page_size >> 9)!= 0))
 				try -= (sys_page_size >> 9)
 					- (currently_testing 
@@ -430,9 +432,9 @@ static unsigned int test_ro (int dev, unsigned long last_block,
 	return bb_count;
 }
 
-static unsigned int test_rw (int dev, unsigned long last_block,
-			     int block_size, unsigned long from_count,
-			     unsigned long blocks_at_once)
+static unsigned int test_rw (int dev, blk_t last_block,
+			     int block_size, blk_t from_count,
+			     unsigned int blocks_at_once)
 {
 	unsigned char *buffer, *read_buffer;
 	const unsigned int patterns[] = {0xaa, 0x55, 0xff, 0x00};
@@ -454,7 +456,8 @@ static unsigned int test_rw (int dev, unsigned long last_block,
 		fputs(_("Checking for bad blocks in read-write mode\n"), 
 		      stderr);
 		fprintf(stderr, _("From block %lu to %lu\n"),
-			 from_count, last_block);
+			(unsigned long) from_count, 
+			(unsigned long) last_block);
 	}
 	if (t_flag) {
 		pattern = t_patts;
@@ -484,7 +487,7 @@ static unsigned int test_rw (int dev, unsigned long last_block,
 			if (got == try) {
 				try = blocks_at_once;
 				/* recover page-aligned offset for O_DIRECT */
-				if ( blocks_at_once >= (unsigned long) (sys_page_size >> 9)
+				if ( (blocks_at_once >= sys_page_size >> 9)
 				     && (currently_testing % 
 					 (sys_page_size >> 9)!= 0))
 					try -= (sys_page_size >> 9)
@@ -528,7 +531,7 @@ static unsigned int test_rw (int dev, unsigned long last_block,
 			}
 			currently_testing += got;
 			/* recover page-aligned offset for O_DIRECT */
-			if ( blocks_at_once >= (unsigned long) (sys_page_size >> 9)
+			if ( (blocks_at_once >= sys_page_size >> 9)
 			     && (currently_testing % (sys_page_size >> 9)!= 0))
 				try = blocks_at_once - (sys_page_size >> 9)
 					- (currently_testing 
@@ -555,9 +558,9 @@ struct saved_blk_record {
 	int	num;
 };
 
-static unsigned int test_nd (int dev, unsigned long last_block,
-			     int block_size, unsigned long from_count,
-			     unsigned long blocks_at_once)
+static unsigned int test_nd (int dev, blk_t last_block,
+			     int block_size, blk_t from_count,
+			     unsigned int blocks_at_once)
 {
 	unsigned char *blkbuf, *save_ptr, *test_ptr, *read_ptr;
 	unsigned char *test_base, *save_base, *read_base;
@@ -565,7 +568,8 @@ static unsigned int test_nd (int dev, unsigned long last_block,
 	const unsigned int patterns[] = { ~0 };
 	const unsigned int *pattern;
 	int nr_pattern, pat_idx;
-	long got, used2, written, save_currently_testing;
+	int got, used2, written;
+	blk_t save_currently_testing;
 	struct saved_blk_record *test_record;
 	/* This is static to prevent being clobbered by the longjmp */
 	static int num_saved;
@@ -601,7 +605,8 @@ static unsigned int test_nd (int dev, unsigned long last_block,
 	flush_bufs();
 	if (v_flag) {
 	    fputs(_("Checking for bad blocks in non-destructive read-write mode\n"), stderr);
-	    fprintf (stderr, _("From block %lu to %lu\n"), from_count, last_block);
+	    fprintf (stderr, _("From block %lu to %lu\n"), 
+		     (unsigned long) from_count, (unsigned long) last_block);
 	}
 	if (s_flag || v_flag > 1) {
 		fputs(_("Checking for bad blocks (non-destructive read-write test)\n"), stderr);
@@ -682,7 +687,8 @@ static unsigned int test_nd (int dev, unsigned long last_block,
 			if (written != got)
 				com_err (program_name, errno,
 					 _("during test data write, block %lu"),
-					 currently_testing + written);
+					 (unsigned long) currently_testing + 
+					 written);
 
 			buf_used += got;
 			save_ptr += got * block_size;
@@ -824,16 +830,16 @@ int main (int argc, char ** argv)
 	char * output_file = NULL;
 	FILE * in = NULL;
 	int block_size = 1024;
-	unsigned long blocks_at_once = 64;
+	unsigned int blocks_at_once = 64;
 	blk_t last_block, from_count;
 	int num_passes = 0;
 	int passes_clean = 0;
 	int dev;
 	errcode_t errcode;
 	unsigned int pattern;
-	unsigned int (*test_func)(int, unsigned long,
-				  int, unsigned long,
-				  unsigned long);
+	unsigned int (*test_func)(int, blk_t,
+				  int, blk_t,
+				  unsigned int);
 	int open_flag = 0;
 	long sysval;
 
-- 
1.5.3.4.1232.g9991d-dirty
