From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 26/54] e2fsck: Check directory leaf block checksums
Date: Tue, 06 Mar 2012 16:00:12 -0800
Message-ID: <20120307000012.11945.82746.stgit@elm3b70.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e32.co.us.ibm.com ([32.97.110.150]:41601 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab2CGABO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 19:01:14 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 17:01:14 -0700
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id DCC8C1FF0047
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 17:00:21 -0700 (MST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2700Knl144528
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 17:00:20 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2700HId021563
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 17:00:20 -0700
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Checks that directory leaf blocks have the necessary fake dir_entry at the end
of the block to hold a checksum and that the checksum is valid.  It will resize
the block and/or rebuild the directory if necessary.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass2.c   |   79 +++++++++++++++++++++++++++++++++++++++++++++++-------
 e2fsck/pass3.c   |    4 +++
 e2fsck/problem.c |   15 ++++++++++
 e2fsck/problem.h |    9 ++++++
 4 files changed, 97 insertions(+), 10 deletions(-)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 5de301f..be950de 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -753,8 +753,9 @@ static int check_dir_block(ext2_filsys fs,
 	struct problem_context	pctx;
 	int	dups_found = 0;
 	int	ret;
-	int	dx_csum_size = 0;
+	int	dx_csum_size = 0, de_csum_size = 0;
 	int	failed_csum = 0;
+	int	is_leaf = 1;
 
 	cd = (struct check_dir_struct *) priv_data;
 	buf = cd->buf;
@@ -767,8 +768,10 @@ static int check_dir_block(ext2_filsys fs,
 		return DIRENT_ABORT;
 
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		dx_csum_size = sizeof(struct ext2_dx_tail);
+		de_csum_size = sizeof(struct ext2_dir_entry_tail);
+	}
 
 	/*
 	 * Make sure the inode is still in use (could have been
@@ -814,11 +817,15 @@ static int check_dir_block(ext2_filsys fs,
 		failed_csum = 1;
 	}
 	if (cd->pctx.errcode) {
+		char *buf2;
 		if (!fix_problem(ctx, PR_2_READ_DIRBLOCK, &cd->pctx)) {
 			ctx->flags |= E2F_FLAG_ABORT;
 			return DIRENT_ABORT;
 		}
-		memset(buf, 0, fs->blocksize);
+		ext2fs_new_dir_block(fs, db->blockcnt == 0 ? ino : 0,
+				     EXT2_ROOT_INO, &buf2);
+		memcpy(buf, buf2, fs->blocksize);
+		ext2fs_free_mem(&buf2);
 	}
 #ifdef ENABLE_HTREE
 	dx_dir = e2fsck_get_dx_dir_info(ctx, ino);
@@ -866,10 +873,43 @@ static int check_dir_block(ext2_filsys fs,
 			    ((fs->blocksize - (8 + dx_csum_size)) /
 			     sizeof(struct ext2_dx_entry))))
 			dx_db->type = DX_DIRBLOCK_NODE;
+		is_leaf = 0;
 	}
 out_htree:
 #endif /* ENABLE_HTREE */
 
+	/* Verify checksum. */
+	if (is_leaf && de_csum_size) {
+		/* No space for csum?  Rebuild dirs in pass 3A. */
+		if (!ext2fs_dirent_has_tail(fs, (struct ext2_dir_entry *)buf)) {
+			de_csum_size = 0;
+			if (e2fsck_dir_will_be_rehashed(ctx, ino))
+				goto skip_checksum;
+			if (!fix_problem(cd->ctx, PR_2_LEAF_NODE_MISSING_CSUM,
+					 &cd->pctx))
+				goto skip_checksum;
+			e2fsck_rehash_dir_later(ctx, ino);
+			goto skip_checksum;
+		}
+		if (failed_csum) {
+			char *buf2;
+			if (!fix_problem(cd->ctx, PR_2_LEAF_NODE_CSUM_INVALID,
+					 &cd->pctx))
+				goto skip_checksum;
+			ext2fs_new_dir_block(fs,
+					     db->blockcnt == 0 ? ino : 0,
+					     EXT2_ROOT_INO, &buf2);
+			memcpy(buf, buf2, fs->blocksize);
+			ext2fs_free_mem(&buf2);
+			dir_modified++;
+			failed_csum = 0;
+		}
+	}
+	/* htree nodes don't use fake dirents to store checksums */
+	if (!is_leaf)
+		de_csum_size = 0;
+
+skip_checksum:
 	dict_init(&de_dict, DICTCOUNT_T_MAX, dict_de_cmp);
 	prev = 0;
 	do {
@@ -1117,10 +1157,7 @@ out_htree:
 			pctx.ino = ino;
 			pctx.dirent = dirent;
 			fix_problem(ctx, PR_2_REPORT_DUP_DIRENT, &pctx);
-			if (!ctx->dirs_to_hash)
-				ext2fs_u32_list_create(&ctx->dirs_to_hash, 50);
-			if (ctx->dirs_to_hash)
-				ext2fs_u32_list_add(ctx->dirs_to_hash, ino);
+			e2fsck_rehash_dir_later(ctx, ino);
 			dups_found++;
 		} else
 			dict_alloc_insert(&de_dict, dirent, dirent);
@@ -1136,7 +1173,7 @@ out_htree:
 			(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
 		offset += rec_len;
 		dot_state++;
-	} while (offset < fs->blocksize);
+	} while (offset < fs->blocksize - de_csum_size);
 #if 0
 	printf("\n");
 #endif
@@ -1153,22 +1190,44 @@ out_htree:
 			parse_int_node(fs, db, cd, dx_dir, buf, failed_csum);
 	}
 #endif /* ENABLE_HTREE */
-	if (offset != fs->blocksize) {
-		cd->pctx.num = rec_len - fs->blocksize + offset;
+
+	if (offset != fs->blocksize - de_csum_size) {
+		cd->pctx.num = rec_len - (fs->blocksize - de_csum_size) +
+			       offset;
 		if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
 			dirent->rec_len = cd->pctx.num;
 			dir_modified++;
 		}
 	}
 	if (dir_modified) {
+		/* leaf block with no tail?  Rehash dirs later. */
+		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+		    is_leaf &&
+		    !ext2fs_dirent_has_tail(fs, (struct ext2_dir_entry *)buf))
+			e2fsck_rehash_dir_later(ctx, ino);
+
+write_and_fix:
+		if (e2fsck_dir_will_be_rehashed(ctx, ino))
+			ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		cd->pctx.errcode = ext2fs_write_dir_block4(fs, block_nr, buf,
 							   0, ino);
+		if (e2fsck_dir_will_be_rehashed(ctx, ino))
+			ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		if (cd->pctx.errcode) {
 			if (!fix_problem(ctx, PR_2_WRITE_DIRBLOCK,
 					 &cd->pctx))
 				goto abort_free_dict;
 		}
 		ext2fs_mark_changed(fs);
+	} else if (is_leaf && failed_csum && !dir_modified) {
+		/*
+		 * If a leaf node that fails csum makes it this far without
+		 * alteration, ask the user if the checksum should be fixed.
+		 */
+		if (fix_problem(ctx, PR_2_LEAF_NODE_ONLY_CSUM_INVALID,
+				&cd->pctx))
+			goto write_and_fix;
 	}
 	dict_free_nodes(&de_dict);
 	return 0;
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 4ae3a33..ad733c2 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -659,8 +659,12 @@ static void fix_dotdot(e2fsck_t ctx, ext2_ino_t ino, ext2_ino_t parent)
 
 	clear_problem_context(&pctx);
 	pctx.ino = ino;
+	if (e2fsck_dir_will_be_rehashed(ctx, ino))
+		ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	retval = ext2fs_dir_iterate(fs, ino, DIRENT_FLAG_INCLUDE_EMPTY,
 				    0, fix_dotdot_proc, &fp);
+	if (e2fsck_dir_will_be_rehashed(ctx, ino))
+		ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	if (retval || !fp.done) {
 		pctx.errcode = retval;
 		fix_problem(ctx, retval ? PR_3_FIX_PARENT_ERR :
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 25db675..d910629 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1393,6 +1393,21 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@p @h %d: internal node fails checksum\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
+	/* leaf node fails checksum */
+	{ PR_2_LEAF_NODE_CSUM_INVALID,
+	  N_("@d @i %i, %B, offset %N: @d fails checksum\n"),
+	  PROMPT_SALVAGE, PR_PREEN_OK },
+
+	/* leaf node has no checksum */
+	{ PR_2_LEAF_NODE_MISSING_CSUM,
+	  N_("@d @i %i, %B, offset %N: @d has no checksum\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	/* leaf node passes checks but fails checksum */
+	{ PR_2_LEAF_NODE_ONLY_CSUM_INVALID,
+	  N_("@d @i %i, %B, offset %N: @d passes checks but fails checksum\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 5cf80fb..eb70d61 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -833,6 +833,15 @@ struct problem_context {
 /* htree node fails checksum */
 #define PR_2_HTREE_NODE_CSUM_INVALID	0x02004A
 
+/* dir leaf node fails checksum */
+#define PR_2_LEAF_NODE_CSUM_INVALID	0x02004B
+
+/* no space in leaf for checksum */
+#define PR_2_LEAF_NODE_MISSING_CSUM	0x02004C
+
+/* dir leaf node passes checks, but fails checksum */
+#define PR_2_LEAF_NODE_ONLY_CSUM_INVALID	0x02004D
+
 /*
  * Pass 3 errors
  */

