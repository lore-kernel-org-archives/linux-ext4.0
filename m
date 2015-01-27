From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 17/54] e2fsck: inspect inline dir data as two directory
 blocks
Date: Mon, 26 Jan 2015 23:37:24 -0800
Message-ID: <20150127073724.13308.48792.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33748 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbbA0Hhb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:37:31 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The design of inline directories (apparently) calls for the i_block[]
region and the EA regions to be treated as if they were two separate
blocks of dirents.  Effectively this means that it is impossible for a
directory entry to straddle both areas.  e2fsck doesn't enforce this,
so teach it to do so.  e2fslib already knows to do this....

Cc: Zheng Liu <gnehzuil.liu@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c                        |   34 ++++++++++-
 e2fsck/pass2.c                        |  104 ++++++++++++++++++++++-----------
 tests/f_inlinedata_dirblocks/expect.1 |   25 ++++++++
 tests/f_inlinedata_dirblocks/expect.2 |    7 ++
 tests/f_inlinedata_dirblocks/image.gz |  Bin
 tests/f_inlinedata_dirblocks/name     |    1 
 6 files changed, 131 insertions(+), 40 deletions(-)
 create mode 100644 tests/f_inlinedata_dirblocks/expect.1
 create mode 100644 tests/f_inlinedata_dirblocks/expect.2
 create mode 100644 tests/f_inlinedata_dirblocks/image.gz
 create mode 100644 tests/f_inlinedata_dirblocks/name


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 2089943..69a9ac1 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2742,18 +2742,44 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 static void check_blocks_inline_data(e2fsck_t ctx, struct problem_context *pctx,
 				     struct process_block_struct *pb)
 {
+	int	flags;
+	size_t	inline_data_size = 0;
+
 	if (!pb->is_dir) {
 		pctx->errcode = 0;
 		return;
 	}
 
+	/* Process the dirents in i_block[] as the "first" block. */
 	pctx->errcode = ext2fs_add_dir_block2(ctx->fs->dblist, pb->ino, 0, 0);
+	if (pctx->errcode)
+		goto err;
+
+	/* Process the dirents in the EA as a "second" block. */
+	flags = ctx->fs->flags;
+	ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	pctx->errcode = ext2fs_inline_data_size(ctx->fs, pb->ino,
+						&inline_data_size);
+	ctx->fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+			 (ctx->fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 	if (pctx->errcode) {
-		pctx->blk = 0;
-		pctx->num = 0;
-		fix_problem(ctx, PR_1_ADD_DBLOCK, pctx);
-		ctx->flags |= E2F_FLAG_ABORT;
+		pctx->errcode = 0;
+		return;
 	}
+
+	if (inline_data_size <= EXT4_MIN_INLINE_DATA_SIZE)
+		return;
+
+	pctx->errcode = ext2fs_add_dir_block2(ctx->fs->dblist, pb->ino, 0, 1);
+	if (pctx->errcode)
+		goto err;
+
+	return;
+err:
+	pctx->blk = 0;
+	pctx->num = 0;
+	fix_problem(ctx, PR_1_ADD_DBLOCK, pctx);
+	ctx->flags |= E2F_FLAG_ABORT;
 }
 
 /*
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 7aaebce..26db2e6 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -732,15 +732,6 @@ static void salvage_directory(ext2_filsys fs,
 	}
 }
 
-static int is_last_entry(ext2_filsys fs, int inline_data_size,
-			 unsigned int offset, int csum_size)
-{
-	if (inline_data_size)
-		return (offset < inline_data_size);
-	else
-		return (offset < fs->blocksize - csum_size);
-}
-
 #define NEXT_DIRENT(d)	((void *)((char *)(d) + (d)->rec_len))
 static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
 {
@@ -783,10 +774,22 @@ static errcode_t fix_inline_dir_size(e2fsck_t ctx, ext2_ino_t ino,
 	errcode_t retval;
 
 	old_size = *inline_data_size;
-	new_size = old_size + (4 - (old_size & 3));
+	/*
+	 * If there's not enough bytes to start the "second" dir block
+	 * (in the EA space) then truncate everything to the first block.
+	 */
+	if (old_size > EXT4_MIN_INLINE_DATA_SIZE &&
+	    old_size < EXT4_MIN_INLINE_DATA_SIZE +
+		       EXT2_DIR_REC_LEN(1)) {
+		old_size = EXT4_MIN_INLINE_DATA_SIZE;
+		new_size = old_size;
+	} else
+		/* Increase to the next four-byte boundary for salvaging */
+		new_size = old_size + (4 - (old_size & 3));
 	memset(buf + old_size, 0, new_size - old_size);
 	retval = ext2fs_inline_data_set(fs, ino, 0, buf, new_size);
 	if (retval == EXT2_ET_INLINE_DATA_NO_SPACE) {
+		/* Or we can't, so truncate. */
 		new_size -= 4;
 		retval = ext2fs_inline_data_set(fs, ino, 0, buf, new_size);
 		if (retval) {
@@ -844,7 +847,7 @@ static int check_dir_block(ext2_filsys fs,
 	ext2_ino_t 		subdir_parent;
 	__u16			links;
 	struct check_dir_struct	*cd;
-	char 			*buf;
+	char			*buf, *ibuf;
 	e2fsck_t		ctx;
 	problem_t		problem;
 	struct ext2_dx_root_info *root;
@@ -858,9 +861,10 @@ static int check_dir_block(ext2_filsys fs,
 	int	is_leaf = 1;
 	size_t	inline_data_size = 0;
 	int	filetype = 0;
+	size_t	max_block_size;
 
 	cd = (struct check_dir_struct *) priv_data;
-	buf = cd->buf;
+	ibuf = buf = cd->buf;
 	ctx = cd->ctx;
 
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & E2F_FLAG_RESTART)
@@ -928,10 +932,22 @@ static int check_dir_block(ext2_filsys fs,
 		if (cd->pctx.errcode)
 			goto inline_read_fail;
 #ifdef WORDS_BIGENDIAN
+		if (db->blockcnt)
+			goto skip_first_read_swab;
 		*((__u32 *)buf) = ext2fs_le32_to_cpu(*((__u32 *)buf));
 		cd->pctx.errcode = ext2fs_dirent_swab_in2(fs,
 				buf + EXT4_INLINE_DATA_DOTDOT_SIZE,
-				inline_data_size - EXT4_INLINE_DATA_DOTDOT_SIZE,
+				EXT4_MIN_INLINE_DATA_SIZE - EXT4_INLINE_DATA_DOTDOT_SIZE,
+				0);
+		if (cd->pctx.errcode)
+			goto inline_read_fail;
+skip_first_read_swab:
+		if (inline_data_size <= EXT4_MIN_INLINE_DATA_SIZE ||
+		    !db->blockcnt)
+			goto inline_read_fail;
+		cd->pctx.errcode = ext2fs_dirent_swab_in2(fs,
+				buf + EXT4_MIN_INLINE_DATA_SIZE,
+				inline_data_size - EXT4_MIN_INLINE_DATA_SIZE,
 				0);
 #endif
 	} else
@@ -940,7 +956,10 @@ static int check_dir_block(ext2_filsys fs,
 inline_read_fail:
 	pctx.ino = ino;
 	pctx.num = inline_data_size;
-	if ((inline_data_size & 3) &&
+	if (((inline_data_size & 3) ||
+	     (inline_data_size > EXT4_MIN_INLINE_DATA_SIZE &&
+	      inline_data_size < EXT4_MIN_INLINE_DATA_SIZE +
+				 EXT2_DIR_REC_LEN(1))) &&
 	    fix_problem(ctx, PR_2_BAD_INLINE_DIR_SIZE, &pctx)) {
 		errcode_t err = fix_inline_dir_size(ctx, ino,
 						    &inline_data_size, &pctx,
@@ -1039,6 +1058,19 @@ out_htree:
 		de_csum_size = 0;
 
 skip_checksum:
+	if (inline_data_size) {
+		if (db->blockcnt) {
+			buf += EXT4_MIN_INLINE_DATA_SIZE;
+			max_block_size = inline_data_size - EXT4_MIN_INLINE_DATA_SIZE;
+			/* Zero-length second block, just exit */
+			if (max_block_size == 0)
+				return 0;
+		} else {
+			max_block_size = EXT4_MIN_INLINE_DATA_SIZE;
+		}
+	} else
+		max_block_size = fs->blocksize - de_csum_size;
+
 	dict_init(&de_dict, DICTCOUNT_T_MAX, dict_de_cmp);
 	prev = 0;
 	do {
@@ -1048,10 +1080,6 @@ skip_checksum:
 
 		problem = 0;
 		if (!inline_data_size || dot_state > 1) {
-			size_t max_block_size = fs->blocksize - de_csum_size;
-
-			if (inline_data_size)
-				max_block_size = inline_data_size;
 			dirent = (struct ext2_dir_entry *) (buf + offset);
 			(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
 			cd->pctx.dirent = dirent;
@@ -1388,7 +1416,7 @@ skip_checksum:
 			}
 		}
 		dot_state++;
-	} while (is_last_entry(fs, inline_data_size, offset, de_csum_size));
+	} while (offset < max_block_size);
 #if 0
 	printf("\n");
 #endif
@@ -1406,22 +1434,11 @@ skip_checksum:
 	}
 #endif /* ENABLE_HTREE */
 
-	if (inline_data_size) {
-		if (offset != inline_data_size) {
-			cd->pctx.num = rec_len + offset - inline_data_size;
-			if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
-				dirent->rec_len = cd->pctx.num;
-				dir_modified++;
-			}
-		}
-	} else {
-		if (offset != fs->blocksize - de_csum_size) {
-			cd->pctx.num = rec_len - (fs->blocksize - de_csum_size) +
-				       offset;
-			if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
-				dirent->rec_len = cd->pctx.num;
-				dir_modified++;
-			}
+	if (offset != max_block_size) {
+		cd->pctx.num = rec_len + offset - max_block_size;
+		if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
+			dirent->rec_len = cd->pctx.num;
+			dir_modified++;
 		}
 	}
 	if (dir_modified) {
@@ -1444,13 +1461,28 @@ write_and_fix:
 			ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		}
 		if (inline_data_size) {
+			buf = ibuf;
 #ifdef WORDS_BIGENDIAN
+			if (db->blockcnt)
+				goto skip_first_write_swab;
 			*((__u32 *)buf) = ext2fs_le32_to_cpu(*((__u32 *)buf));
 			cd->pctx.errcode = ext2fs_dirent_swab_out2(fs,
 					buf + EXT4_INLINE_DATA_DOTDOT_SIZE,
-					inline_data_size -
+					EXT4_MIN_INLINE_DATA_SIZE -
 					EXT4_INLINE_DATA_DOTDOT_SIZE,
 					0);
+			if (cd->pctx.errcode)
+				goto skip_second_write_swab;
+skip_first_write_swab:
+			if (inline_data_size <= EXT4_MIN_INLINE_DATA_SIZE ||
+			    !db->blockcnt)
+				goto skip_second_write_swab;
+			cd->pctx.errcode = ext2fs_dirent_swab_out2(fs,
+					buf + EXT4_MIN_INLINE_DATA_SIZE,
+					inline_data_size -
+					EXT4_MIN_INLINE_DATA_SIZE,
+					0);
+skip_second_write_swab:
 			if (cd->pctx.errcode &&
 			    !fix_problem(ctx, PR_2_WRITE_DIRBLOCK, &cd->pctx))
 				goto abort_free_dict;
diff --git a/tests/f_inlinedata_dirblocks/expect.1 b/tests/f_inlinedata_dirblocks/expect.1
new file mode 100644
index 0000000..e3d0ee2
--- /dev/null
+++ b/tests/f_inlinedata_dirblocks/expect.1
@@ -0,0 +1,25 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Entry '..' in ??? (12) has invalid inode #: 1752440867.
+Clear? yes
+
+Directory inode 12, block #0, offset 4: directory corrupted
+Salvage? yes
+
+Directory inode 12, block #1, offset 0: directory corrupted
+Salvage? yes
+
+Pass 3: Checking directory connectivity
+'..' in /aoo (12) is ??? (1752440867), should be / (2).
+Fix? yes
+
+Error while adjusting inode count on inode 0
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Directories count wrong for group #0 (2, counted=3).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
+Exit status is 1
diff --git a/tests/f_inlinedata_dirblocks/expect.2 b/tests/f_inlinedata_dirblocks/expect.2
new file mode 100644
index 0000000..3b6073e
--- /dev/null
+++ b/tests/f_inlinedata_dirblocks/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
+Exit status is 0
diff --git a/tests/f_inlinedata_dirblocks/image.gz b/tests/f_inlinedata_dirblocks/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..4cd64e01348c4370f856ac847287a14d0e3463ba
GIT binary patch
literal 2597
zcmb2|=3qGOxIcu6`R%QP*&^XG3=hmFi>3;DepoW$u(Ito>8%<SnkgR@L_}BKOEuXo
z6|q~<`k)iP?-dyv5uGnjmQLpix+PZ~TBY^Fyh4*hX^LFc+9T$>r6+C>+v1k|XW!Gk
z_p6Qb%YL3c!<S#C&ho%{Yfxw<2Yb*DYwm?Idgt4h+9#x1=v7|WQ?A$Y_3P%$0x7v`
zzy3DnNE~mUo2>b#PPb)!@SeJF*Ke<Ox4&PX{Pm0e(Yfya_gvSp%ipW5Do%QLTV77?
z?$^Kb_y3*Jy3=4H|Fyj{j?Xrl8+Wtg>DG`k%dZR!73`~CzTX#;_UrS1qp#WLuTOpW
zfU%l`fq~&({rxv9TkDU<)&DL9auaT^{`Y@AN2HxJ+j%CR7MuBVWo-^iJKMf5seXF=
z?YmFYKVRLoswY)^*WJ3`{U<l>@yG>fs+O)l`M3V*$0dK6fn4ijQ(}P>!@K{CAc}a9
zkiFJF?-kgHzIX@X^<k*25Y0YY{oL$S`;_nTXG45@Pu1(Zd3oG1_P;v!R`G48e<}al
z|5EVy!J8a=c(qrr++}b6=+|`K^)>7BYl7{I|2F47tuy^^X_EDCa{J%^hW}SSv)igW
z|Nj&JZC3x~ga37F-t(HjJJ9Tt{H#^0`jaXv7mDBJo*VXN>#4Xo`CGf6`ekj|?Y%K#
zkBIoK<_q28-G0kW<=5*?nZEmUYD~@4Kl!<*_HX+=x$d=xR<*T#y?OkUqo?n!j?h}S
z<<zyH^>O+0EDQhneC`gOf7ZnB=;h=7$J_+@kGkobtviyu@nfjXpUj*o#$R{kWB7Sg
jU^E0qLtr!nMnhmU1V%%EN+Gb}vJG?isTY$O7!())I%6w0

literal 0
HcmV?d00001

diff --git a/tests/f_inlinedata_dirblocks/name b/tests/f_inlinedata_dirblocks/name
new file mode 100644
index 0000000..a226758
--- /dev/null
+++ b/tests/f_inlinedata_dirblocks/name
@@ -0,0 +1 @@
+check inline dir as two dirent blocks

