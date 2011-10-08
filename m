From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 23/47] e2fsck: Verify htree root/node checksums
Date: Sat, 08 Oct 2011 00:35:42 -0700
Message-ID: <20111008073542.17888.85744.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56210 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab1JHHhp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:37:45 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987KUv0002893
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:20:30 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987ZjQx231942
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:35:45 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987Zhov022104
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 04:35:45 -0300
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check htree internal node checksums.  If broken, ask user to clear the htree
index and recreate it later.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass2.c   |   32 ++++++++++++++++++++++++++++----
 e2fsck/problem.c |   10 ++++++++++
 e2fsck/problem.h |    6 ++++++
 e2fsck/rehash.c  |   31 ++++++++++++++++++++++++++++---
 4 files changed, 72 insertions(+), 7 deletions(-)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 0ba2957..11c469b 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -533,6 +533,7 @@ static void parse_int_node(ext2_filsys fs,
 	ext2_dirhash_t	min_hash = 0xffffffff;
 	ext2_dirhash_t	max_hash = 0;
 	ext2_dirhash_t	hash = 0, prev_hash;
+	int		csum_size = 0;
 
 	if (db->blockcnt == 0) {
 		root = (struct ext2_dx_root_info *) (block_buf + 24);
@@ -546,10 +547,24 @@ static void parse_int_node(ext2_filsys fs,
 		printf("\t Flags: %d\n", root->unused_flags);
 #endif
 
-		ent = (struct ext2_dx_entry *) (block_buf + 24 + root->info_length);
+		ent = (struct ext2_dx_entry *)
+				(block_buf + 24 + root->info_length);
+
+		if (!ext2fs_dx_csum_verify(fs, cd->pctx.ino,
+				(struct ext2_dir_entry *)block_buf) &&
+		    fix_problem(cd->ctx, PR_2_HTREE_ROOT_CSUM_INVALID,
+				&cd->pctx))
+			goto clear_and_exit;
 	} else {
 		ent = (struct ext2_dx_entry *) (block_buf+8);
+
+		if (!ext2fs_dx_csum_verify(fs, cd->pctx.ino,
+				(struct ext2_dir_entry *)block_buf) &&
+		    fix_problem(cd->ctx, PR_2_HTREE_NODE_CSUM_INVALID,
+				&cd->pctx))
+			goto clear_and_exit;
 	}
+
 	limit = (struct ext2_dx_countlimit *) ent;
 
 #ifdef DX_DEBUG
@@ -560,8 +575,12 @@ static void parse_int_node(ext2_filsys fs,
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
@@ -729,6 +748,7 @@ static int check_dir_block(ext2_filsys fs,
 	struct problem_context	pctx;
 	int	dups_found = 0;
 	int	ret;
+	int	csum_size = 0;
 
 	cd = (struct check_dir_struct *) priv_data;
 	buf = cd->buf;
@@ -740,6 +760,10 @@ static int check_dir_block(ext2_filsys fs,
 	if (ctx->progress && (ctx->progress)(ctx, 2, cd->count++, cd->max))
 		return DIRENT_ABORT;
 
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dx_tail);
+
 	/*
 	 * Make sure the inode is still in use (could have been
 	 * deleted in the duplicate/bad blocks pass.
@@ -829,7 +853,7 @@ static int check_dir_block(ext2_filsys fs,
 			   (rec_len == fs->blocksize) &&
 			   (dirent->name_len == 0) &&
 			   (ext2fs_le16_to_cpu(limit->limit) ==
-			    ((fs->blocksize-8) /
+			    ((fs->blocksize - (8 + csum_size)) /
 			     sizeof(struct ext2_dx_entry))))
 			dx_db->type = DX_DIRBLOCK_NODE;
 	}
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 62dcae3..d5c8796 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1378,6 +1378,16 @@ static struct e2fsck_problem problem_table[] = {
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
index a584369..22c6b9b 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -824,6 +824,12 @@ struct problem_context {
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
index 15993b3..5fbe862 100644
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
@@ -588,9 +600,14 @@ static errcode_t calculate_tree(ext2_filsys fs,
 			if (c1 == 0)
 				return ENOSPC;
 			if (c2 == 0) {
-				if (limit)
+				if (limit) {
 					limit->limit = limit->count =
 		ext2fs_cpu_to_le16(limit->limit);
+					retval = ext2fs_dx_csum_set(fs, ino,
+		(struct ext2_dir_entry *)(((void *)limit) - 8));
+					if (retval)
+						return retval;
+				}
 				root = (struct ext2_dx_entry *)
 					(outdir->buf + root_offset);
 				root->block = ext2fs_cpu_to_le32(outdir->num);
@@ -615,10 +632,18 @@ static errcode_t calculate_tree(ext2_filsys fs,
 		}
 		limit->count = ext2fs_cpu_to_le16(limit->limit - c2);
 		limit->limit = ext2fs_cpu_to_le16(limit->limit);
+		retval = ext2fs_dx_csum_set(fs, ino,
+				(struct ext2_dir_entry *)(((void *)limit) - 8));
+		if (retval)
+			return retval;
 	}
 	root_limit = (struct ext2_dx_countlimit *) (outdir->buf + limit_offset);
 	root_limit->count = ext2fs_cpu_to_le16(root_limit->limit - c1);
 	root_limit->limit = ext2fs_cpu_to_le16(root_limit->limit);
+	retval = ext2fs_dx_csum_set(fs, ino,
+				    (struct ext2_dir_entry *)outdir->buf);
+	if (retval)
+		return retval;
 
 	return 0;
 }

