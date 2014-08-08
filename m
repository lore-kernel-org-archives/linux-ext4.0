From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 09/21] e2fsck: check ea-in-inode regions for overlap
Date: Fri, 8 Aug 2014 15:43:58 -0700
Message-ID: <20140808224358.GF11191@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010555.2611.52850.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32251 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaHHWoE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 18:44:04 -0400
Content-Disposition: inline
In-Reply-To: <20140805010555.2611.52850.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ensure that the various blobs in the in-inode EA region do not overlap.

v2: Actually clear the magic number when we're clearing a bad inode EA
region, not whatever comes after it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c                      |   43 ++++++++++++++++++++++++++++++++---
 e2fsck/problem.c                    |    5 ++++
 e2fsck/problem.h                    |    3 ++
 tests/f_inode_ea_collision/expect.1 |   15 ++++++++++++
 tests/f_inode_ea_collision/expect.2 |    7 ++++++
 tests/f_inode_ea_collision/image.gz |  Bin
 tests/f_inode_ea_collision/name     |    1 +
 7 files changed, 70 insertions(+), 4 deletions(-)
 create mode 100644 tests/f_inode_ea_collision/expect.1
 create mode 100644 tests/f_inode_ea_collision/expect.2
 create mode 100644 tests/f_inode_ea_collision/image.gz
 create mode 100644 tests/f_inode_ea_collision/name

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 6c79eed..3fbf00a 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -286,15 +286,17 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 	struct ext2_super_block *sb = ctx->fs->super;
 	struct ext2_inode_large *inode;
 	struct ext2_ext_attr_entry *entry;
-	char *start;
+	char *start, *header;
 	unsigned int storage_size, remain;
 	problem_t problem = 0;
+	region_t region = 0;
 
 	inode = (struct ext2_inode_large *) pctx->inode;
 	storage_size = EXT2_INODE_SIZE(ctx->fs->super) - EXT2_GOOD_OLD_INODE_SIZE -
 		inode->i_extra_isize;
-	start = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
-		inode->i_extra_isize + sizeof(__u32);
+	header = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
+		 inode->i_extra_isize;
+	start = header + sizeof(__u32);
 	entry = (struct ext2_ext_attr_entry *) start;
 
 	/* scan all entry's headers first */
@@ -302,10 +304,28 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 	/* take finish entry 0UL into account */
 	remain = storage_size - sizeof(__u32);
 
+	region = region_create(0, storage_size);
+	if (!region) {
+		fix_problem(ctx, PR_1_EA_ALLOC_REGION_ABORT, pctx);
+		problem = 0;
+		ctx->flags |= E2F_FLAG_ABORT;
+		return;
+	}
+	if (region_allocate(region, 0, sizeof(__u32))) {
+		problem = PR_1_INODE_EA_ALLOC_COLLISION;
+		goto fix;
+	}
+
 	while (remain >= sizeof(struct ext2_ext_attr_entry) &&
 	       !EXT2_EXT_IS_LAST_ENTRY(entry)) {
 		__u32 hash;
 
+		if (region_allocate(region, (char *)entry - (char *)header,
+				    EXT2_EXT_ATTR_LEN(entry->e_name_len))) {
+			problem = PR_1_INODE_EA_ALLOC_COLLISION;
+			goto fix;
+		}
+
 		/* header eats this space */
 		remain -= sizeof(struct ext2_ext_attr_entry);
 
@@ -333,6 +353,13 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 			goto fix;
 		}
 
+		if (entry->e_value_size &&
+		    region_allocate(region, sizeof(__u32) + entry->e_value_offs,
+				    EXT2_EXT_ATTR_SIZE(entry->e_value_size))) {
+			problem = PR_1_INODE_EA_ALLOC_COLLISION;
+			goto fix;
+		}
+
 		hash = ext2fs_ext_attr_hash_entry(entry,
 						  start + entry->e_value_offs);
 
@@ -347,7 +374,15 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
+
+	if (region_allocate(region, (char *)entry - (char *)header,
+			    sizeof(__u32))) {
+		problem = PR_1_INODE_EA_ALLOC_COLLISION;
+		goto fix;
+	}
 fix:
+	if (region)
+		region_free(region);
 	/*
 	 * it seems like a corruption. it's very unlikely we could repair
 	 * EA(s) in automatic fashion -bzzz
@@ -356,7 +391,7 @@ fix:
 		return;
 
 	/* simply remove all possible EA(s) */
-	*((__u32 *)start) = 0UL;
+	*((__u32 *)header) = 0UL;
 	e2fsck_write_inode_full(ctx, pctx->ino, pctx->inode,
 				EXT2_INODE_SIZE(sb), "pass1");
 }
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 2d29c35..b982a27 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -977,6 +977,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i passes checks, but checksum does not match @i.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
+	/* Inode extended attribute is corrupt (allocation collision) */
+	{ PR_1_INODE_EA_ALLOC_COLLISION,
+	  N_("@i %i @a is corrupt (allocation collision).  "),
+	  PROMPT_CLEAR, 0},
+
 	/*
 	 * Inode extent block passes checks, but checksum does not match
 	 * extent
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 89146ec..f051c11 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -577,6 +577,9 @@ struct problem_context {
 /* inode passes checks, but checksum does not match inode */
 #define PR_1_INODE_ONLY_CSUM_INVALID   0x010068
 
+/* Inode EA allocation collision */
+#define PR_1_INODE_EA_ALLOC_COLLISION	0x010069
+
 /* extent block passes checks, but checksum does not match extent block */
 #define PR_1_EXTENT_ONLY_CSUM_INVALID  0x01006A
 
diff --git a/tests/f_inode_ea_collision/expect.1 b/tests/f_inode_ea_collision/expect.1
new file mode 100644
index 0000000..a67a5f1
--- /dev/null
+++ b/tests/f_inode_ea_collision/expect.1
@@ -0,0 +1,15 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 extended attribute is corrupt (allocation collision).  Clear? yes
+
+Inode 13 extended attribute is corrupt (allocation collision).  Clear? yes
+
+Inode 14 extended attribute is corrupt (allocation collision).  Clear? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 14/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_inode_ea_collision/expect.2 b/tests/f_inode_ea_collision/expect.2
new file mode 100644
index 0000000..5a7ca86
--- /dev/null
+++ b/tests/f_inode_ea_collision/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 14/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 0
diff --git a/tests/f_inode_ea_collision/image.gz b/tests/f_inode_ea_collision/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..5217f6503404864944a88bfc36b7d75a305aafb8
GIT binary patch
literal 2602
zcmb2|=3rRTdo!4c`Ry(1jNn8Oh6n%E1ihnk1;sZu?eJW<NUv+f#j`7&rz`1+%6Chx
z=yzP$zj61~h22d*Bw~&@hIDCYH8poTn;&#Na(uyTr@!x&7j4w~mb&)7_&M9}GoL+C
zGk@+c%=BTul$ZKafv}@r^f(vpkBHY&x}B)u->fWbo2immwCQ=R(4%*W3VPSyYikyH
zZ``1|?Dt2%b4UJs`SxP5`rf<qk6jPBKPPtAKflM1ZxnpF(YbTo*E?sW`@hG%t1C!M
z`g-u=^W<936>Zmo_PxDrmFDffM>TlO`Xe_UFJ)&q5I<qte(j_+r+@wbw<G4~uC?|#
zcOOVHF)%dL-%klvt<gLGpn`#cA>p9+|Nr-;CIy9`sOP>Q<+XI(x<BT7w4IAzdc6J7
zdCqz3<l}rxZf~lc+-s<>{mlI69-Cu#x2fEG^I8O`IbuST)Up5aw?BQf2l6(Y*iy{}
zq!0X%2a*Q=*nuRGpkb%!&drIEK-Cc?HOxRqk_!&ZmynqGV&(DwA>VJu7G9cn-9Ex)
z-%^=bo9>7_cgpxTq2-kMan+l0#@7WOyMF(gCH3|5gR2~8+7~{w*cm?e(XaU;*Z057
z&W!M@EBc%LN2Vw&q3(|N@A<Dn{>E#r(fu{w!1aHyW|G;j`TKwV+ix=G`9b+#`+r?s
zr8ztMpTXa%^)Y*{{yhEf{nO2F^^e8ndMp3^ovC;3;OnAI>tDDPw`Xk)@T=PVQ}yVs
zzqQN%|1gw&XD!<Qdj9lZ>;J9$x8;BAuL5_e$iIgFSN+p<{rgaU<^NmnU)kI5+HJ>n
z;+6g}CVTt;_t($%{7Y`ojOrT=fzc2c4S~@R7!85Z5Fii&8zgEO|2Qt4#K54y004(2
BL%09{

literal 0
HcmV?d00001

diff --git a/tests/f_inode_ea_collision/name b/tests/f_inode_ea_collision/name
new file mode 100644
index 0000000..b64119e
--- /dev/null
+++ b/tests/f_inode_ea_collision/name
@@ -0,0 +1 @@
+collisions in the inode ea area
