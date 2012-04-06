From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] libext2fs: improve testing coverage of tst_bitmaps
Date: Fri,  6 Apr 2012 11:59:06 -0700
Message-ID: <1333738746-5857-3-git-send-email-tytso@mit.edu>
References: <20120406185759.GA5584@thunk.org>
 <1333738746-5857-1-git-send-email-tytso@mit.edu>
Cc: rjones@redhat.com, sami.liedes@iki.fi,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60247 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757889Ab2DFTyN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2012 15:54:13 -0400
In-Reply-To: <1333738746-5857-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Improve the test coverage of tst_bitmaps by:

   (a) adding the ability to test the legacy (32-bit) bitmap code
   (b) adding tests for ext2fs_find_first_zero_inode_bitmap2() and
       ext2fs_find_first_zero_block_bitmap2()

The recent regressions caused by the addition (and use) of
ext2fs_find_first_zero_inode_bitmap2() would have been caught if we
had added these tests first.  (Another object lesson in why unit tests
are critically important!)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/Makefile.in        |    3 ++
 lib/ext2fs/tst_bitmaps.c      |   88 ++++++++++++++++++++++++++++++++++++++---
 lib/ext2fs/tst_bitmaps_cmd.ct |    6 +++
 lib/ext2fs/tst_bitmaps_cmds   |   11 ++++++
 lib/ext2fs/tst_bitmaps_exp    |   22 +++++++++++
 5 files changed, 124 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 8840a32..507a459 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -403,6 +403,9 @@ check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) \
 		./tst_bitmaps -t 3 -f $(srcdir)/tst_bitmaps_cmds > tst_bitmaps_out
 	diff $(srcdir)/tst_bitmaps_exp tst_bitmaps_out
+	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) \
+		./tst_bitmaps -l -f $(srcdir)/tst_bitmaps_cmds > tst_bitmaps_out
+	diff $(srcdir)/tst_bitmaps_exp tst_bitmaps_out
 
 installdirs::
 	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/ext2fs"
diff --git a/lib/ext2fs/tst_bitmaps.c b/lib/ext2fs/tst_bitmaps.c
index 27722e5..22346a2 100644
--- a/lib/ext2fs/tst_bitmaps.c
+++ b/lib/ext2fs/tst_bitmaps.c
@@ -151,7 +151,7 @@ int check_fs_open(char *name)
 
 static void setup_filesystem(const char *name,
 			     unsigned int blocks, unsigned int inodes,
-			     unsigned int type)
+			     unsigned int type, int flags)
 {
 	struct ext2_super_block param;
 	errcode_t retval;
@@ -160,7 +160,7 @@ static void setup_filesystem(const char *name,
 	ext2fs_blocks_count_set(&param, blocks);
 	param.s_inodes_count = inodes;
 
-	retval = ext2fs_initialize("test fs", EXT2_FLAG_64BITS, &param,
+	retval = ext2fs_initialize("test fs", flags, &param,
 				   test_io_manager, &test_fs);
 
 	if (retval) {
@@ -198,6 +198,7 @@ void setup_cmd(int argc, char **argv)
 	unsigned int	blocks = 128;
 	unsigned int	inodes = 0;
 	unsigned int	type = EXT2FS_BMAP64_BITARRAY;
+	int		flags = EXT2_FLAG_64BITS;
 
 	if (test_fs) {
 		ext2fs_close(test_fs);
@@ -205,7 +206,7 @@ void setup_cmd(int argc, char **argv)
 	}
 
 	reset_getopt();
-	while ((c = getopt(argc, argv, "b:i:t:")) != EOF) {
+	while ((c = getopt(argc, argv, "b:i:lt:")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocks = parse_ulong(optarg, argv[0],
@@ -219,6 +220,9 @@ void setup_cmd(int argc, char **argv)
 			if (err)
 				return;
 			break;
+		case 'l':	/* Legacy bitmaps */
+			flags = 0;
+			break;
 		case 't':
 			type = parse_ulong(optarg, argv[0],
 					   "bitmap backend type", &err);
@@ -231,7 +235,7 @@ void setup_cmd(int argc, char **argv)
 			return;
 		}
 	}
-	setup_filesystem(argv[0], blocks, inodes, type);
+	setup_filesystem(argv[0], blocks, inodes, type, flags);
 }
 
 void close_cmd(int argc, char **argv)
@@ -399,6 +403,40 @@ void do_testb(int argc, char *argv[])
 	printf("Block %u is %s\n", block, test_result ? "set" : "clear");
 }
 
+void do_ffzb(int argc, char *argv[])
+{
+	unsigned int start, end;
+	int err;
+	errcode_t retval;
+	blk64_t out;
+
+	if (check_fs_open(argv[0]))
+		return;
+
+	if (argc != 3 && argc != 3) {
+		com_err(argv[0], 0, "Usage: ffzb <start> <end>");
+		return;
+	}
+
+	start = parse_ulong(argv[1], argv[0], "start", &err);
+	if (err)
+		return;
+
+	end = parse_ulong(argv[2], argv[0], "end", &err);
+	if (err)
+		return;
+
+	retval = ext2fs_find_first_zero_block_bitmap2(test_fs->block_map,
+						      start, end, &out);
+	if (retval) {
+		printf("ext2fs_find_first_zero_block_bitmap2() returned %s\n",
+		       error_message(retval));
+		return;
+	}
+	printf("First unmarked block is %llu\n", out);
+}
+
+
 void do_zerob(int argc, char *argv[])
 {
 	if (check_fs_open(argv[0]))
@@ -488,6 +526,40 @@ void do_testi(int argc, char *argv[])
 	printf("Inode %u is %s\n", inode, test_result ? "set" : "clear");
 }
 
+void do_ffzi(int argc, char *argv[])
+{
+	unsigned int start, end;
+	int err;
+	errcode_t retval;
+	ext2_ino_t out;
+
+	if (check_fs_open(argv[0]))
+		return;
+
+	if (argc != 3 && argc != 3) {
+		com_err(argv[0], 0, "Usage: ffzi <start> <end>");
+		return;
+	}
+
+	start = parse_ulong(argv[1], argv[0], "start", &err);
+	if (err)
+		return;
+
+	end = parse_ulong(argv[2], argv[0], "end", &err);
+	if (err)
+		return;
+
+	retval = ext2fs_find_first_zero_inode_bitmap2(test_fs->inode_map,
+						      start, end, &out);
+	if (retval) {
+		printf("ext2fs_find_first_zero_inode_bitmap2() returned %s\n",
+		       error_message(retval));
+		return;
+	}
+	printf("First unmarked inode is %u\n", out);
+}
+
+
 void do_zeroi(int argc, char *argv[])
 {
 	if (check_fs_open(argv[0]))
@@ -506,10 +578,11 @@ int main(int argc, char **argv)
 	char		*request = (char *)NULL;
 	char		*cmd_file = 0;
 	int		sci_idx;
+	int		flags = EXT2_FLAG_64BITS;
 
 	add_error_table(&et_ss_error_table);
 	add_error_table(&et_ext2_error_table);
-	while ((c = getopt (argc, argv, "b:i:t:R:f:")) != EOF) {
+	while ((c = getopt (argc, argv, "b:i:lt:R:f:")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocks = parse_ulong(optarg, argv[0],
@@ -523,6 +596,9 @@ int main(int argc, char **argv)
 			if (err)
 				return;
 			break;
+		case 'l':	/* Legacy bitmaps */
+			flags = 0;
+			break;
 		case 't':
 			type = parse_ulong(optarg, argv[0],
 					   "bitmap backend type", &err);
@@ -558,7 +634,7 @@ int main(int argc, char **argv)
 	printf("%s %s.  Type '?' for a list of commands.\n\n",
 	       subsystem_name, version);
 
-	setup_filesystem(argv[0], blocks, inodes, type);
+	setup_filesystem(argv[0], blocks, inodes, type, flags);
 
 	if (request) {
 		code = ss_execute_line(sci_idx, request);
diff --git a/lib/ext2fs/tst_bitmaps_cmd.ct b/lib/ext2fs/tst_bitmaps_cmd.ct
index 5a51d23..1e1e5d3 100644
--- a/lib/ext2fs/tst_bitmaps_cmd.ct
+++ b/lib/ext2fs/tst_bitmaps_cmd.ct
@@ -21,6 +21,9 @@ request do_clearb, "Clear block",
 request do_testb, "Test block",
 	test_block, testb;
 
+request do_ffzb, "Find first zero block",
+	find_first_zero_block, ffzb;
+
 request do_zerob, "Clear block bitmap",
 	clear_block_bitmap, zerob;
 
@@ -33,6 +36,9 @@ request do_cleari, "Clear inode",
 request do_testi, "Test inode",
 	test_inode, testi;
 
+request do_ffzi, "Find first zero inode",
+	find_first_zero_inode, ffzi;
+
 request do_zeroi, "Clear inode bitmap",
 	clear_inode_bitmap, zeroi;
 
diff --git a/lib/ext2fs/tst_bitmaps_cmds b/lib/ext2fs/tst_bitmaps_cmds
index 13f4ea8..9a4f3d0 100644
--- a/lib/ext2fs/tst_bitmaps_cmds
+++ b/lib/ext2fs/tst_bitmaps_cmds
@@ -16,6 +16,12 @@ testb 11
 testb 15
 testb 16
 dump_bb
+ffzb 11 16
+ffzb 12 16
+ffzb 12 20
+clearb 13
+ffzb 12 20
+setb 13
 clearb 12 7
 testb 12 7
 setb 15
@@ -33,6 +39,11 @@ seti 5
 testi 6
 testi 1
 dump_ib
+ffzi 1 6
+ffzi 2 5
+ffzi 2 6
+cleari 4
+ffzi 2 6
 zeroi
 testi 5
 seti 5
diff --git a/lib/ext2fs/tst_bitmaps_exp b/lib/ext2fs/tst_bitmaps_exp
index aa64ae7..2d406ce 100644
--- a/lib/ext2fs/tst_bitmaps_exp
+++ b/lib/ext2fs/tst_bitmaps_exp
@@ -36,6 +36,18 @@ tst_bitmaps: testb 16
 Block 16 is set
 tst_bitmaps: dump_bb
 block bitmap: 00f80000000000000000000000000000
+tst_bitmaps: ffzb 11 16
+First unmarked block is 11
+tst_bitmaps: ffzb 12 16
+ext2fs_find_first_zero_block_bitmap2() returned No such file or directory
+tst_bitmaps: ffzb 12 20
+First unmarked block is 17
+tst_bitmaps: clearb 13
+Clearing block 13, was set before
+tst_bitmaps: ffzb 12 20
+First unmarked block is 13
+tst_bitmaps: setb 13
+Setting block 13, was clear before
 tst_bitmaps: clearb 12 7
 Clearing blocks 12 to 18
 tst_bitmaps: testb 12 7
@@ -70,6 +82,16 @@ tst_bitmaps: testi 1
 Inode 1 is clear
 tst_bitmaps: dump_ib
 inode bitmap: 1e000000
+tst_bitmaps: ffzi 1 6
+First unmarked inode is 1
+tst_bitmaps: ffzi 2 5
+ext2fs_find_first_zero_inode_bitmap2() returned No such file or directory
+tst_bitmaps: ffzi 2 6
+First unmarked inode is 6
+tst_bitmaps: cleari 4
+Clearing inode 4, was set before
+tst_bitmaps: ffzi 2 6
+First unmarked inode is 4
 tst_bitmaps: zeroi
 Clearing inode bitmap.
 tst_bitmaps: testi 5
-- 
1.7.10.rc3

