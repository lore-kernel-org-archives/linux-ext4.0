From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] e2fsck: check htree leaf block checksums
Date: Mon, 22 Jun 2015 11:41:12 -0700
Message-ID: <20150622184112.GF7063@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44713 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbbFVSlR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Jun 2015 14:41:17 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We weren't verifying the checksum of an htree leaf block due to a
coding error that marked all htree blocks as not having checksums.
While we're at it, fix the error message that gets displayed so that
it doesn't print a meaningless block offset.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c                   |    2 +-
 e2fsck/problem.c                 |    2 +-
 tests/f_dir_bad_csum/expect.1    |    2 +-
 tests/f_htree_leaf_csum/expect.1 |   12 ++++++++++++
 tests/f_htree_leaf_csum/expect.2 |    7 +++++++
 tests/f_htree_leaf_csum/image.gz |  Bin
 tests/f_htree_leaf_csum/name     |    1 +
 7 files changed, 23 insertions(+), 3 deletions(-)
 create mode 100644 tests/f_htree_leaf_csum/expect.1
 create mode 100644 tests/f_htree_leaf_csum/expect.2
 create mode 100644 tests/f_htree_leaf_csum/image.gz
 create mode 100644 tests/f_htree_leaf_csum/name

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index ecc0aaa..3a91e98 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1085,7 +1085,7 @@ inline_read_fail:
 			    ((fs->blocksize - (8 + dx_csum_size)) /
 			     sizeof(struct ext2_dx_entry))))
 			dx_db->type = DX_DIRBLOCK_NODE;
-		is_leaf = 0;
+		is_leaf = (dx_db->type == DX_DIRBLOCK_LEAF);
 	}
 out_htree:
 #endif /* ENABLE_HTREE */
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 80c6492..5916d01 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1597,7 +1597,7 @@ static struct e2fsck_problem problem_table[] = {
 
 	/* leaf node passes checks but fails checksum */
 	{ PR_2_LEAF_NODE_ONLY_CSUM_INVALID,
-	  N_("@d @i %i, %B, offset %N: @d passes checks but fails checksum.\n"),
+	  N_("@d @i %i, %B: @d passes checks but fails checksum.\n"),
 	  PROMPT_FIX, PR_PREEN_OK },
 
 	/* inline directory inode size must be a multiple of 4 */
diff --git a/tests/f_dir_bad_csum/expect.1 b/tests/f_dir_bad_csum/expect.1
index b2b2fae..94e72da 100644
--- a/tests/f_dir_bad_csum/expect.1
+++ b/tests/f_dir_bad_csum/expect.1
@@ -1,6 +1,6 @@
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
-Directory inode 12, block #0, offset 12: directory passes checks but fails checksum.
+Directory inode 12, block #0: directory passes checks but fails checksum.
 Fix? yes
 
 Directory inode 13, block #0, offset 0: directory has no checksum.
diff --git a/tests/f_htree_leaf_csum/expect.1 b/tests/f_htree_leaf_csum/expect.1
new file mode 100644
index 0000000..d6b179e
--- /dev/null
+++ b/tests/f_htree_leaf_csum/expect.1
@@ -0,0 +1,12 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Directory inode 12, block #1: directory passes checks but fails checksum.
+Fix? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 430/512 files (0.2% non-contiguous), 45/512 blocks
+Exit status is 1
diff --git a/tests/f_htree_leaf_csum/expect.2 b/tests/f_htree_leaf_csum/expect.2
new file mode 100644
index 0000000..1609785
--- /dev/null
+++ b/tests/f_htree_leaf_csum/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 430/512 files (0.2% non-contiguous), 45/512 blocks
+Exit status is 0
diff --git a/tests/f_htree_leaf_csum/image.gz b/tests/f_htree_leaf_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..f2e461990c095b045750eb6fb657e660a1a360e5
GIT binary patch
literal 15906
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
S0MPgvf}CqRR;}8*>VE)5>UBZ@

literal 0
HcmV?d00001

diff --git a/tests/f_htree_leaf_csum/name b/tests/f_htree_leaf_csum/name
new file mode 100644
index 0000000..43c6ada
--- /dev/null
+++ b/tests/f_htree_leaf_csum/name
@@ -0,0 +1 @@
+bad csum in htree leaf block
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
