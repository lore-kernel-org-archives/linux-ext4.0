From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH 2/2] cleanup whitespace in problem.c and problem.h
Date: Tue, 28 Apr 2009 12:59:07 -0600
Message-ID: <20090428185907.GS3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52624 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZD1S7U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 14:59:20 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3SIxJJw017197
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 11:59:20 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIT00800RAZFI00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 28 Apr 2009 11:59:19 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cleanup whitespace in the problem.h and problem.c files.  Removes a
bunch of places where tabs follow spaces, whitespace on empty lines, etc.
I didn't reformat the indenting of the entire problem.h error codes,
but there is some room for doing this...

Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: e2fsprogs-1.41.5/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.41.5.orig/e2fsck/problem.c
+++ e2fsprogs-1.41.5/e2fsck/problem.c
@@ -26,16 +26,16 @@
 #define PROMPT_RELOCATE	3
 #define PROMPT_ALLOCATE 4
 #define PROMPT_EXPAND	5
-#define PROMPT_CONNECT 	6
+#define PROMPT_CONNECT	6
 #define PROMPT_CREATE	7
 #define PROMPT_SALVAGE	8
 #define PROMPT_TRUNCATE	9
 #define PROMPT_CLEAR_INODE 10
-#define PROMPT_ABORT 	11
-#define PROMPT_SPLIT 	12
+#define PROMPT_ABORT	11
+#define PROMPT_SPLIT	12
 #define PROMPT_CONTINUE	13
 #define PROMPT_CLONE	14
-#define PROMPT_DELETE 	15
+#define PROMPT_DELETE	15
 #define PROMPT_SUPPRESS 16
 #define PROMPT_UNLINK	17
 #define PROMPT_CLEAR_HTREE 18
@@ -1033,22 +1033,22 @@ static struct e2fsck_problem problem_tab
 	  N_("i_faddr @F %IF, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },
 
-  	/* i_file_acl should be zero */
+	/* i_file_acl should be zero */
 	{ PR_2_FILE_ACL_ZERO,
 	  N_("i_file_acl @F %If, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },
 
-  	/* i_dir_acl should be zero */
+	/* i_dir_acl should be zero */
 	{ PR_2_DIR_ACL_ZERO,
 	  N_("i_dir_acl @F %Id, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },
 
-  	/* i_frag should be zero */
+	/* i_frag should be zero */
 	{ PR_2_FRAG_ZERO,
 	  N_("i_frag @F %N, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },
 
-  	/* i_fsize should be zero */
+	/* i_fsize should be zero */
 	{ PR_2_FSIZE_ZERO,
 	  N_("i_fsize @F %N, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },
@@ -1183,7 +1183,7 @@ static struct e2fsck_problem problem_tab
 	  N_("Symlink %Q (@i #%i) is @n.\n"),
 	  PROMPT_CLEAR, 0 },
 
-  	/* i_file_acl (extended attribute block) is bad */
+	/* i_file_acl (extended attribute block) is bad */
 	{ PR_2_FILE_ACL_BAD,
 	  N_("@a @b @F @n (%If).\n"),
 	  PROMPT_CLEAR, 0 },
@@ -1267,7 +1267,7 @@ static struct e2fsck_problem problem_tab
 	  N_("Duplicate @e '%Dn' found.\n\tMarking %p (%i) to be rebuilt.\n\n"),
 	  PROMPT_NONE, 0 },
 
-  	/* i_blocks_hi should be zero */
+	/* i_blocks_hi should be zero */
 	{ PR_2_BLOCKS_HI_ZERO,
 	  N_("i_blocks_hi @F %N, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },
@@ -1286,7 +1286,7 @@ static struct e2fsck_problem problem_tab
 	  N_("@E references @i %Di found in @g %g's unused inodes area.\n"),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-  	/* i_blocks_hi should be zero */
+	/* i_blocks_hi should be zero */
 	{ PR_2_I_FILE_ACL_HI_ZERO,
 	  N_("i_file_acl_hi @F %N, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },
@@ -1636,7 +1636,7 @@ static struct latch_descr pr_latch_info[
 
 static struct e2fsck_problem *find_problem(problem_t code)
 {
-	int 	i;
+	int	i;
 
 	for (i=0; problem_table[i].e2p_code; i++) {
 		if (problem_table[i].e2p_code == code)
@@ -1721,7 +1744,7 @@ int fix_problem(e2fsck_t ctx, problem_t 
 	struct e2fsck_problem *ptr;
 	struct latch_descr *ldesc = 0;
 	const char *message;
-	int 		def_yn, answer, ans;
+	int		def_yn, answer, ans;
 	int		print_answer = 0;
 	int		suppress = 0;
 
Index: e2fsprogs-1.41.5/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.41.5.orig/e2fsck/problem.h
+++ e2fsprogs-1.41.5/e2fsck/problem.h
@@ -146,7 +146,7 @@ struct problem_context {
 #define PR_0_ORPHAN_ILLEGAL_HEAD_INODE		0x000023
 
 /* Illegal inode in orphaned inode list */
-#define PR_0_ORPHAN_ILLEGAL_INODE 		0x000024
+#define PR_0_ORPHAN_ILLEGAL_INODE		0x000024
 
 /* Journal has unsupported read-only feature - abort */
 #define PR_0_JOURNAL_UNSUPP_ROCOMPAT		0x000025
@@ -273,10 +273,10 @@ struct problem_context {
 #define PR_1_INODE_BLOCK_LATCH		0x010010
 
 /* Too many bad blocks in inode */
-#define	PR_1_TOO_MANY_BAD_BLOCKS 	0x010011
+#define	PR_1_TOO_MANY_BAD_BLOCKS	0x010011
 
 /* Illegal block number in bad block inode */
-#define PR_1_BB_ILLEGAL_BLOCK_NUM 	0x010012
+#define PR_1_BB_ILLEGAL_BLOCK_NUM	0x010012
 
 /* Bad block inode has illegal blocks (latch question) */
 #define PR_1_INODE_BBLOCK_LATCH		0x010013
@@ -860,7 +860,7 @@ struct problem_context {
 #define PR_3A_OPTIMIZE_DIR_ERR		0x031002
 
 /* Rehashing dir header */
-#define PR_3A_OPTIMIZE_DIR_HEADER		0x031003
+#define PR_3A_OPTIMIZE_DIR_HEADER	0x031003
 
 /* Rehashing directory %d */
 #define PR_3A_OPTIMIZE_DIR		0x031004
@@ -873,19 +873,19 @@ struct problem_context {
  */
 
 /* Pass 4: Checking reference counts */
-#define PR_4_PASS_HEADER	0x040000
+#define PR_4_PASS_HEADER		0x040000
 
 /* Unattached zero-length inode */
-#define PR_4_ZERO_LEN_INODE	0x040001
+#define PR_4_ZERO_LEN_INODE		0x040001
 
 /* Unattached inode */
-#define PR_4_UNATTACHED_INODE	0x040002
+#define PR_4_UNATTACHED_INODE		0x040002
 
 /* Inode ref count wrong */
-#define PR_4_BAD_REF_COUNT	0x040003
+#define PR_4_BAD_REF_COUNT		0x040003
 
 /* Inconsistent inode count information cached */
-#define PR_4_INCONSISTENT_COUNT	0x040004
+#define PR_4_INCONSISTENT_COUNT		0x040004
 
 /*
  * Pass 5 errors
@@ -901,7 +901,7 @@ struct problem_context {
 #define PR_5_BLOCK_BMAP_PADDING		0x050002
 
 /* Block bitmap differences header */
-#define PR_5_BLOCK_BITMAP_HEADER 	0x050003
+#define PR_5_BLOCK_BITMAP_HEADER	0x050003
 
 /* Block not used, but marked in bitmap */
 #define PR_5_BLOCK_UNUSED		0x050004
@@ -931,7 +931,7 @@ struct problem_context {
 #define PR_5_FREE_DIR_COUNT_GROUP	0x05000C
 
 /* Free inodes count wrong */
-#define PR_5_FREE_INODE_COUNT	0x05000D
+#define PR_5_FREE_INODE_COUNT		0x05000D
 
 /* Free blocks count for group wrong */
 #define PR_5_FREE_BLOCK_COUNT_GROUP	0x05000E
@@ -982,7 +982,7 @@ struct problem_context {
 int end_problem_latch(e2fsck_t ctx, int mask);
 int set_latch_flags(int mask, int setflags, int clearflags);
 int get_latch_flags(int mask, int *value);
-void clear_problem_context(struct problem_context *ctx);
+void clear_problem_context(struct problem_context *pctx);
 
 /* message.c */
 void print_e2fsck_message(e2fsck_t ctx, const char *msg,

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

