From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: check for zero length extent
Date: Sun, 11 Mar 2012 16:25:33 -0400
Message-ID: <1331497533-29917-1-git-send-email-tytso@mit.edu>
Cc: merll@web.de, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44171 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab2CKUZg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Mar 2012 16:25:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If an extent has e_len set to zero, the kernel will oops with a
BUG_ON.  Unfortuntaely, e2fsck wasn't catching this case.  The kernel
needs to be fixed to notice this case and call ext4_error() instead of
failing an assertion check, but e2fsck should catch this case and
repair it (by deleting the errant extent).

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c                |    2 ++
 e2fsck/problem.c              |    5 +++++
 e2fsck/problem.h              |    3 +++
 tests/f_ext_zero_len/expect.1 |   13 +++++++++++++
 tests/f_ext_zero_len/expect.2 |    7 +++++++
 tests/f_ext_zero_len/image.gz |  Bin 0 -> 576 bytes
 tests/f_ext_zero_len/name     |    1 +
 7 files changed, 31 insertions(+), 0 deletions(-)
 create mode 100644 tests/f_ext_zero_len/expect.1
 create mode 100644 tests/f_ext_zero_len/expect.2
 create mode 100644 tests/f_ext_zero_len/image.gz
 create mode 100644 tests/f_ext_zero_len/name

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 5faa093..9f4142b 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1778,6 +1778,8 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			problem = PR_1_EXTENT_BAD_START_BLK;
 		else if (extent.e_lblk < start_block)
 			problem = PR_1_OUT_OF_ORDER_EXTENTS;
+		else if (extent.e_len == 0)
+			problem = PR_1_EXTENT_LENGTH_ZERO;
 		else if (is_leaf &&
 			 (extent.e_pblk + extent.e_len) >
 			 ext2fs_blocks_count(ctx->fs->super))
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 579c838..b951eb7 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -936,6 +936,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("The bad @b @i looks @n.  "),
 	  PROMPT_CLEAR, 0 },
 
+	/* Extent has zero length */
+	{ PR_1_EXTENT_LENGTH_ZERO,
+	  N_("@i %i has zero length extent\n\t(@n logical @b %c, physical @b %b)\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 3fabc90..f2bd414 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -550,6 +550,9 @@ struct problem_context {
 /* Invalid bad inode */
 #define PR_1_INVALID_BAD_INODE		0x010065
 
+/* Extent has zero length */
+#define PR_1_EXTENT_LENGTH_ZERO		0x010066
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_ext_zero_len/expect.1 b/tests/f_ext_zero_len/expect.1
new file mode 100644
index 0000000..40109b3
--- /dev/null
+++ b/tests/f_ext_zero_len/expect.1
@@ -0,0 +1,13 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has zero length extent
+	(invalid logical block 0, physical block 37)
+Clear? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/16 files (0.0% non-contiguous), 21/100 blocks
+Exit status is 1
diff --git a/tests/f_ext_zero_len/expect.2 b/tests/f_ext_zero_len/expect.2
new file mode 100644
index 0000000..4ee5d96
--- /dev/null
+++ b/tests/f_ext_zero_len/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/16 files (0.0% non-contiguous), 21/100 blocks
+Exit status is 0
diff --git a/tests/f_ext_zero_len/image.gz b/tests/f_ext_zero_len/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..a03e5fd890f56538dfe97e02439c9d2132912fc6
GIT binary patch
literal 576
zc-oWi=HNKW9_!D<oSB=Lp33m{?#684KpFNA<<nhMbVD-P1*bGvX&O4Q7p`t?5;z$!
z_m<uzE-#;UwdQD1!NL&s{|to%7tbzo`m6lMScF~ni0Z!6OQW*cE^1w@vHNgVbvpO^
zcXxm9y)((1<G_kr;+tiHyE2c6Bu{!P9r7vVw&|s%$DYp+*md{kchCIYe@gRS7bhFO
zHe8;3Zkb|C|LNWB=j?ZUeRJp8*|UeYKQ{}T_vTLj<m*vy?Q7QrpMCz_f66O=`F*>r
zzHh4g;<|1B<G<h2w#y#R^I}_b`qz)1g~tUnj`$ptd3m+oaLL|_J5Bw%`@ahO*}v=V
zrR(nx_{SzpS+Y0#fy&xrssC(zS6}@jRi`!O^0QY_zkfWv>X&V~KddfTLpA)`H7o69
zem|b~zFqOZzje>QM!~=<tPB1ze&t_L@9>xTm3+YehF|Pg?7>0|3_Oe9wcK|&yuyf?
zi2)fL_%PFVx>WSf*>CsFUU}#AJNs!{cVF<|_U~NE!teD*6yNZA*67rG?Az@dx$Rwf
zUi37Jr!KF}A33j$_*3{t{qM)`ufM&%xA1$Fn)UzYXZuZLUYxg2Jn+X@F8EgKH~FI<
z%MJ9z%g)r_Pg`;DbNsU#{@V;UK7ZS0d{#kRzclKt-_ww_QM1?ig})Mirro{vRMO^{
VYvv3TfyFPlWo9n(W|+Xp001_Q4H*Cc

literal 0
Hc-jL100001

diff --git a/tests/f_ext_zero_len/name b/tests/f_ext_zero_len/name
new file mode 100644
index 0000000..ada4a72
--- /dev/null
+++ b/tests/f_ext_zero_len/name
@@ -0,0 +1 @@
+extent with zero length
-- 
1.7.9.107.g97f9a

