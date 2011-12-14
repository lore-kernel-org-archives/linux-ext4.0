From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 23/51] e2fsck: Verify htree root/node checksums
Date: Tue, 13 Dec 2011 17:15:51 -0800
Message-ID: <20111214011551.20947.72443.stgit@elm3c44.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:33470 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab1LNBP5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Dec 2011 20:15:57 -0500
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 18:15:57 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1Fs87132816
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:15:54 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1Fq7u011687
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:15:54 -0700
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check htree internal node checksums.  If broken, ask user to clear the htree
index and recreate it later.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass2.c   |   31 ++++++++++++++++++++++++++-----
 e2fsck/problem.c |   10 ++++++++++
 e2fsck/problem.h |    6 ++++++
 e2fsck/rehash.c  |   16 ++++++++++++++--
 4 files changed, 56 insertions(+), 7 deletions(-)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 103b155..e11ddbf 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -522,7 +522,7 @@ static void parse_int_node(ext2_filsys fs,
 			   struct ext2_db_entry2 *db,
 			   struct check_dir_struct *cd,
 			   struct dx_dir_info	*dx_dir,
-			   char *block_buf)
+			   char *block_buf, int failed_csum)
 {
 	struct 		ext2_dx_root_info  *root;
 	struct 		ext2_dx_entry *ent;
@@ -533,6 +533,7 @@ static void parse_int_node(ext2_filsys fs,
 	ext2_dirhash_t	min_hash = 0xffffffff;
 	ext2_dirhash_t	max_hash = 0;
 	ext2_dirhash_t	hash = 0, prev_hash;
+	int		csum_size = 0;
 
 	if (db->blockcnt == 0) {
 		root = (struct ext2_dx_root_info *) (block_buf + 24);
@@ -547,9 +548,20 @@ static void parse_int_node(ext2_filsys fs,
 #endif
 
 		ent = (struct ext2_dx_entry *) (block_buf + 24 + root->info_length);
+
+		if (failed_csum &&
+		    fix_problem(cd->ctx, PR_2_HTREE_ROOT_CSUM_INVALID,
+				&cd->pctx))
+			goto clear_and_exit;
 	} else {
 		ent = (struct ext2_dx_entry *) (block_buf+8);
+
+		if (failed_csum &&
+		    fix_problem(cd->ctx, PR_2_HTREE_NODE_CSUM_INVALID,
+				&cd->pctx))
+			goto clear_and_exit;
 	}
+
 	limit = (struct ext2_dx_countlimit *) ent;
 
 #ifdef DX_DEBUG
@@ -560,8 +572,12 @@ static void parse_int_node(ext2_filsys fs,
 #endif
 
 	count = ext2fs_le16_to_cpu(limit->count);
-	expect_limit = (fs->blocksize - ((char *) ent - block_buf)) /
-		sizeof(struct ext2_dx_entry);
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dx_tail);
+	expect_limit = (fs->blocksize -
+			(csum_size + ((char *) ent - block_buf))) /
+		       sizeof(struct ext2_dx_entry);
 	if (ext2fs_le16_to_cpu(limit->limit) != expect_limit) {
 		cd->pctx.num = ext2fs_le16_to_cpu(limit->limit);
 		if (fix_problem(cd->ctx, PR_2_HTREE_BAD_LIMIT, &cd->pctx))
@@ -729,6 +745,7 @@ static int check_dir_block(ext2_filsys fs,
 	struct problem_context	pctx;
 	int	dups_found = 0;
 	int	ret;
+	int	csum_size = 0;
 
 	cd = (struct check_dir_struct *) priv_data;
 	buf = cd->buf;
@@ -740,6 +757,10 @@ static int check_dir_block(ext2_filsys fs,
 	if (ctx->progress && (ctx->progress)(ctx, 2, cd->count++, cd->max))
 		return DIRENT_ABORT;
 
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dx_tail);
+
 	/*
 	 * Make sure the inode is still in use (could have been
 	 * deleted in the duplicate/bad blocks pass.
@@ -829,7 +850,7 @@ static int check_dir_block(ext2_filsys fs,
 			   (rec_len == fs->blocksize) &&
 			   (dirent->name_len == 0) &&
 			   (ext2fs_le16_to_cpu(limit->limit) ==
-			    ((fs->blocksize-8) /
+			    ((fs->blocksize - (8 + csum_size)) /
 			     sizeof(struct ext2_dx_entry))))
 			dx_db->type = DX_DIRBLOCK_NODE;
 	}
@@ -1116,7 +1137,7 @@ out_htree:
 		cd->pctx.dir = cd->pctx.ino;
 		if ((dx_db->type == DX_DIRBLOCK_ROOT) ||
 		    (dx_db->type == DX_DIRBLOCK_NODE))
-			parse_int_node(fs, db, cd, dx_dir, buf);
+			parse_int_node(fs, db, cd, dx_dir, buf, 0);
 	}
 #endif /* ENABLE_HTREE */
 	if (offset != fs->blocksize) {
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 96b0de5..2e9ab7f 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1374,6 +1374,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("i_file_acl_hi @F %N, @s zero.\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
+	/* htree root node fails checksum */
+	{ PR_2_HTREE_ROOT_CSUM_INVALID,
+	  N_("@p @h %d: root node fails checksum\n"),
+	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
+
+	/* htree internal node fails checksum */
+	{ PR_2_HTREE_NODE_CSUM_INVALID,
+	  N_("@p @h %d: node fails checksum\n"),
+	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index a1e7ffb..08c06e1 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -821,6 +821,12 @@ struct problem_context {
 /* i_file_acl_hi should be zero */
 #define PR_2_I_FILE_ACL_HI_ZERO		0x020048
 
+/* htree root node fails checksum */
+#define PR_2_HTREE_ROOT_CSUM_INVALID	0x020049
+
+/* htree node fails checksum */
+#define PR_2_HTREE_NODE_CSUM_INVALID	0x02004A
+
 /*
  * Pass 3 errors
  */
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 15993b3..a472aad 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -495,6 +495,7 @@ static struct ext2_dx_root_info *set_root_node(ext2_filsys fs, char *buf,
 	struct ext2_dx_root_info  	*root;
 	struct ext2_dx_countlimit	*limits;
 	int				filetype = 0;
+	int				csum_size = 0;
 
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_FILETYPE)
 		filetype = EXT2_FT_DIR << 8;
@@ -519,8 +520,13 @@ static struct ext2_dx_root_info *set_root_node(ext2_filsys fs, char *buf,
 	root->indirect_levels = 0;
 	root->unused_flags = 0;
 
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dx_tail);
+
 	limits = (struct ext2_dx_countlimit *) (buf+32);
-	limits->limit = (fs->blocksize - 32) / sizeof(struct ext2_dx_entry);
+	limits->limit = (fs->blocksize - (32 + csum_size)) /
+			sizeof(struct ext2_dx_entry);
 	limits->count = 0;
 
 	return root;
@@ -531,14 +537,20 @@ static struct ext2_dx_entry *set_int_node(ext2_filsys fs, char *buf)
 {
 	struct ext2_dir_entry 		*dir;
 	struct ext2_dx_countlimit	*limits;
+	int				csum_size = 0;
 
 	memset(buf, 0, fs->blocksize);
 	dir = (struct ext2_dir_entry *) buf;
 	dir->inode = 0;
 	(void) ext2fs_set_rec_len(fs, fs->blocksize, dir);
 
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dx_tail);
+
 	limits = (struct ext2_dx_countlimit *) (buf+8);
-	limits->limit = (fs->blocksize - 8) / sizeof(struct ext2_dx_entry);
+	limits->limit = (fs->blocksize - (8 + csum_size)) /
+			sizeof(struct ext2_dx_entry);
 	limits->count = 0;
 
 	return (struct ext2_dx_entry *) limits;

