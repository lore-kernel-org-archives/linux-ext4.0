From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/12] debugfs: clean up feature test macros with predicate
 functions
Date: Mon, 12 Oct 2015 14:57:13 -0700
Message-ID: <20151012215713.29065.49803.stgit@birch.djwong.org>
References: <20151012215629.29065.24418.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40171 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbbJLV5R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:57:17 -0400
In-Reply-To: <20151012215629.29065.24418.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create separate predicate functions to test/set/clear feature flags,
thereby replacing the wordy old macros.  Furthermore, clean out the
places where we open-coded feature tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 contrib/add_ext4_encrypt.c |    5 +-
 debugfs/debugfs.c          |    6 +--
 debugfs/do_journal.c       |   91 ++++++++++++++++----------------------------
 debugfs/filefrag.c         |    3 -
 debugfs/htree.c            |    6 +--
 debugfs/journal.c          |   37 +++++++-----------
 debugfs/logdump.c          |    2 -
 debugfs/quota.c            |    3 -
 8 files changed, 57 insertions(+), 96 deletions(-)


diff --git a/contrib/add_ext4_encrypt.c b/contrib/add_ext4_encrypt.c
index 73008dc..d4e7c8c 100644
--- a/contrib/add_ext4_encrypt.c
+++ b/contrib/add_ext4_encrypt.c
@@ -42,9 +42,8 @@ int main (int argc, char *argv[])
 			argv[1]);
 		exit(1);
 	}
-	if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_INCOMPAT_ENCRYPT)) {
-		fs->super->s_feature_incompat |= EXT4_FEATURE_INCOMPAT_ENCRYPT;
+	if (!ext2fs_has_feature_encrypt(fs->super)) {
+		ext2fs_set_feature_encrypt(fs->super);
 		fs->super->s_encrypt_algos[0] =
 			EXT4_ENCRYPTION_MODE_AES_256_XTS;
 		fs->super->s_encrypt_algos[1] =
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 583cf8b..175fb90 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -436,8 +436,7 @@ void do_show_super_stats(int argc, char *argv[])
 		return;
 	out = open_pager();
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(current_fs->super,
-				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+	if (ext2fs_has_feature_bigalloc(current_fs->super))
 		units = "cluster";
 
 	list_super2(current_fs->super, out);
@@ -893,8 +892,7 @@ void internal_dump_inode(FILE *out, const char *prefix,
 					  (struct ext2_inode_large *) inode);
 	dump_inode_attributes(out, inode_num);
 	if (current_fs->super->s_creator_os == EXT2_OS_LINUX &&
-	    current_fs->super->s_feature_ro_compat &
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
+	    ext2fs_has_feature_metadata_csum(current_fs->super)) {
 		__u32 crc = inode->i_checksum_lo;
 		if (is_large_inode &&
 		    large_inode->i_extra_isize >=
diff --git a/debugfs/do_journal.c b/debugfs/do_journal.c
index 5c2c2a2..b8c1e59 100644
--- a/debugfs/do_journal.c
+++ b/debugfs/do_journal.c
@@ -88,8 +88,7 @@ static errcode_t journal_commit_trans(journal_transaction_t *trans)
 	commit->h_magic = ext2fs_cpu_to_be32(JFS_MAGIC_NUMBER);
 	commit->h_blocktype = ext2fs_cpu_to_be32(JFS_COMMIT_BLOCK);
 	commit->h_sequence = ext2fs_cpu_to_be32(trans->tid);
-	if (JFS_HAS_COMPAT_FEATURE(trans->journal,
-				   JFS_FEATURE_COMPAT_CHECKSUM)) {
+	if (jfs_has_feature_checksum(trans->journal)) {
 		__u32 csum_v1 = ~0;
 		blk64_t cblk;
 
@@ -149,7 +148,7 @@ static errcode_t journal_commit_trans(journal_transaction_t *trans)
 	trans->flags &= ~J_TRANS_OPEN;
 	trans->block++;
 
-	trans->fs->super->s_feature_incompat |= EXT3_FEATURE_INCOMPAT_RECOVER;
+	ext2fs_set_feature_journal_needs_recovery(trans->fs->super);
 	ext2fs_mark_super_dirty(trans->fs);
 error:
 	if (cbh)
@@ -195,8 +194,7 @@ static errcode_t journal_add_revoke_to_trans(journal_transaction_t *trans,
 	jrb->r_header.h_sequence = ext2fs_cpu_to_be32(trans->tid);
 	offset = sizeof(*jrb);
 
-	if (JFS_HAS_INCOMPAT_FEATURE(trans->journal,
-				     JFS_FEATURE_INCOMPAT_64BIT))
+	if (jfs_has_feature_64bit(trans->journal))
 		sz = 8;
 	else
 		sz = 4;
@@ -229,8 +227,7 @@ static errcode_t journal_add_revoke_to_trans(journal_transaction_t *trans,
 			goto error;
 		}
 
-		if (JFS_HAS_INCOMPAT_FEATURE(trans->journal,
-					     JFS_FEATURE_INCOMPAT_64BIT))
+		if (jfs_has_feature_64bit(trans->journal))
 			*((__u64 *)(&((char *)buf)[offset])) =
 				ext2fs_cpu_to_be64(revoke_list[i]);
 		else
@@ -364,8 +361,7 @@ static errcode_t journal_add_blocks_to_trans(journal_transaction_t *trans,
 			*((__u32 *)buf) = 0;
 			jdbt->t_flags |= ext2fs_cpu_to_be16(JFS_FLAG_ESCAPE);
 		}
-		if (JFS_HAS_INCOMPAT_FEATURE(trans->journal,
-					     JFS_FEATURE_INCOMPAT_64BIT))
+		if (jfs_has_feature_64bit(trans->journal))
 			jdbt->t_blocknr_high = ext2fs_cpu_to_be32(block_list[i] >> 32);
 		jbd2_block_tag_csum_set(trans->journal, jdbt, data_bh,
 					trans->tid);
@@ -421,8 +417,7 @@ static blk64_t journal_guess_blocks(journal_t *journal, blk64_t data_blocks,
 	bs = journal->j_blocksize;
 	if (journal_has_csum_v2or3(journal))
 		bs -= sizeof(struct journal_revoke_tail);
-	sz = JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT) ?
-				sizeof(__u64) : sizeof(__u32);
+	sz = jfs_has_feature_64bit(journal) ? sizeof(__u64) : sizeof(__u32);
 	ret += revoke_blocks * sz / bs;
 
 	/* Estimate # of data blocks */
@@ -489,10 +484,8 @@ static errcode_t journal_close_trans(journal_transaction_t *trans)
 	trans->magic = 0;
 
 	/* Mark ourselves as needing recovery */
-	if (!(EXT2_HAS_INCOMPAT_FEATURE(trans->fs->super,
-					EXT3_FEATURE_INCOMPAT_RECOVER))) {
-		trans->fs->super->s_feature_incompat |=
-					EXT3_FEATURE_INCOMPAT_RECOVER;
+	if (!ext2fs_has_feature_journal_needs_recovery(trans->fs->super)) {
+		ext2fs_set_feature_journal_needs_recovery(trans->fs->super);
 		ext2fs_mark_super_dirty(trans->fs);
 	}
 
@@ -510,8 +503,7 @@ static errcode_t journal_write(journal_t *journal,
 	errcode_t err;
 
 	if (revoke_len > 0) {
-		journal->j_superblock->s_feature_incompat |=
-				ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_REVOKE);
+		jfs_set_feature_revoke(journal);
 		mark_buffer_dirty(journal->j_sb_buffer);
 	}
 
@@ -774,33 +766,26 @@ static void update_journal_csum(journal_t *journal, int ver)
 		return;
 
 	if (journal->j_tail != 0 ||
-	    EXT2_HAS_INCOMPAT_FEATURE(journal->j_fs_dev->k_fs->super,
-				      EXT3_FEATURE_INCOMPAT_RECOVER)) {
+	    ext2fs_has_feature_journal_needs_recovery(
+					journal->j_fs_dev->k_fs->super)) {
 		printf("Journal needs recovery, will not add csums.\n");
 		return;
 	}
 
 	/* metadata_csum implies journal csum v3 */
 	jsb = journal->j_superblock;
-	if (EXT2_HAS_RO_COMPAT_FEATURE(journal->j_fs_dev->k_fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+	if (ext2fs_has_feature_metadata_csum(journal->j_fs_dev->k_fs->super)) {
 		printf("Setting csum v%d\n", ver);
 		switch (ver) {
 		case 2:
-			journal->j_superblock->s_feature_incompat &=
-				ext2fs_cpu_to_be32(~JFS_FEATURE_INCOMPAT_CSUM_V3);
-			journal->j_superblock->s_feature_incompat |=
-				ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2);
-			journal->j_superblock->s_feature_compat &=
-				ext2fs_cpu_to_be32(~JFS_FEATURE_COMPAT_CHECKSUM);
+			jfs_clear_feature_csum3(journal);
+			jfs_set_feature_csum2(journal);
+			jfs_clear_feature_checksum(journal);
 			break;
 		case 3:
-			journal->j_superblock->s_feature_incompat &=
-				ext2fs_cpu_to_be32(~JFS_FEATURE_INCOMPAT_CSUM_V2);
-			journal->j_superblock->s_feature_incompat |=
-				ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V3);
-			journal->j_superblock->s_feature_compat &=
-				ext2fs_cpu_to_be32(~JFS_FEATURE_COMPAT_CHECKSUM);
+			jfs_set_feature_csum3(journal);
+			jfs_clear_feature_csum2(journal);
+			jfs_clear_feature_checksum(journal);
 			break;
 		default:
 			printf("Unknown checksum v%d\n", ver);
@@ -810,11 +795,9 @@ static void update_journal_csum(journal_t *journal, int ver)
 		journal->j_csum_seed = jbd2_chksum(journal, ~0, jsb->s_uuid,
 						   sizeof(jsb->s_uuid));
 	} else {
-		journal->j_superblock->s_feature_compat |=
-			ext2fs_cpu_to_be32(JFS_FEATURE_COMPAT_CHECKSUM);
-		journal->j_superblock->s_feature_incompat &=
-			ext2fs_cpu_to_be32(~(JFS_FEATURE_INCOMPAT_CSUM_V2 |
-					     JFS_FEATURE_INCOMPAT_CSUM_V3));
+		jfs_clear_feature_csum3(journal);
+		jfs_clear_feature_csum2(journal);
+		jfs_set_feature_checksum(journal);
 	}
 }
 
@@ -833,18 +816,15 @@ static void update_uuid(journal_t *journal)
 		return;
 
 	fs = journal->j_fs_dev->k_fs;
-	if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_INCOMPAT_64BIT))
+	if (!ext2fs_has_feature_64bit(fs->super))
 		return;
 
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT) &&
-	    EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT4_FEATURE_INCOMPAT_64BIT))
+	if (jfs_has_feature_64bit(journal) &&
+	    ext2fs_has_feature_64bit(fs->super))
 		return;
 
 	if (journal->j_tail != 0 ||
-	    EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT3_FEATURE_INCOMPAT_RECOVER)) {
+	    ext2fs_has_feature_journal_needs_recovery(fs->super)) {
 		printf("Journal needs recovery, will not set 64bit.\n");
 		return;
 	}
@@ -858,24 +838,21 @@ static void update_64bit_flag(journal_t *journal)
 	if (journal->j_format_version < 2)
 		return;
 
-	if (!EXT2_HAS_INCOMPAT_FEATURE(journal->j_fs_dev->k_fs->super,
-				       EXT4_FEATURE_INCOMPAT_64BIT))
+	if (!ext2fs_has_feature_64bit(journal->j_fs_dev->k_fs->super))
 		return;
 
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT) &&
-	    EXT2_HAS_INCOMPAT_FEATURE(journal->j_fs_dev->k_fs->super,
-				      EXT4_FEATURE_INCOMPAT_64BIT))
+	if (jfs_has_feature_64bit(journal) &&
+	    ext2fs_has_feature_64bit(journal->j_fs_dev->k_fs->super))
 		return;
 
 	if (journal->j_tail != 0 ||
-	    EXT2_HAS_INCOMPAT_FEATURE(journal->j_fs_dev->k_fs->super,
-				      EXT3_FEATURE_INCOMPAT_RECOVER)) {
+	    ext2fs_has_feature_journal_needs_recovery(
+				journal->j_fs_dev->k_fs->super)) {
 		printf("Journal needs recovery, will not set 64bit.\n");
 		return;
 	}
 
-	journal->j_superblock->s_feature_incompat |=
-				ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_64BIT);
+	jfs_set_feature_64bit(journal);
 }
 
 void do_journal_open(int argc, char *argv[])
@@ -894,8 +871,7 @@ void do_journal_open(int argc, char *argv[])
 		printf("Journal is already open.\n");
 		return;
 	}
-	if (!EXT2_HAS_COMPAT_FEATURE(current_fs->super,
-				     EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
+	if (!ext2fs_has_feature_journal(current_fs->super)) {
 		printf("Journalling is not enabled on this filesystem.\n");
 		return;
 	}
@@ -978,8 +954,7 @@ void do_journal_run(int argc EXT2FS_ATTR((unused)), char *argv[])
 	if (err)
 		com_err("journal_run", err, "while recovering journal");
 	else {
-		current_fs->super->s_feature_incompat &=
-				~EXT3_FEATURE_INCOMPAT_RECOVER;
+		ext2fs_clear_feature_journal_needs_recovery(current_fs->super);
 		ext2fs_mark_super_dirty(current_fs);
 	}
 }
diff --git a/debugfs/filefrag.c b/debugfs/filefrag.c
index 49345ad..128598b 100644
--- a/debugfs/filefrag.c
+++ b/debugfs/filefrag.c
@@ -145,8 +145,7 @@ static void filefrag(ext2_ino_t ino, struct ext2_inode *inode,
 	if (fs->options & VERBOSE_OPT) {
 		blk64_t num_blocks = ext2fs_inode_i_blocks(current_fs, inode);
 
-		if (!(current_fs->super->s_feature_ro_compat &
-		     EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+		if (!ext2fs_has_feature_huge_file(current_fs->super) ||
 		    !(inode->i_flags & EXT4_HUGE_FILE_FL))
 			num_blocks /= current_fs->blocksize / 512;
 
diff --git a/debugfs/htree.c b/debugfs/htree.c
index 83f558c..54e55e2 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -46,8 +46,7 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 	int		hash_alg;
 	int		csum_size = 0;
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext2fs_has_feature_metadata_csum(fs->super))
 		csum_size = sizeof(struct ext2_dir_entry_tail);
 
 	errcode = ext2fs_bmap2(fs, ino, inode, buf, 0, blk, 0, &pblk);
@@ -156,8 +155,7 @@ static void htree_dump_int_node(ext2_filsys fs, ext2_ino_t ino,
 		remainder -= sizeof(struct ext2_dx_root_info) + 24;
 	else
 		remainder -= 8;
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	if (ext2fs_has_feature_metadata_csum(fs->super) &&
 	    remainder == sizeof(struct ext2_dx_tail)) {
 		tail = (struct ext2_dx_tail *)(ent + limit);
 		fprintf(pager, "Checksum: 0x%08x\n",
diff --git a/debugfs/journal.c b/debugfs/journal.c
index 9f0d7fc..aa6325d 100644
--- a/debugfs/journal.c
+++ b/debugfs/journal.c
@@ -245,7 +245,7 @@ void wait_on_buffer(struct buffer_head *bh)
 
 static void ext2fs_clear_recover(ext2_filsys fs, int error)
 {
-	fs->super->s_feature_incompat &= ~EXT3_FEATURE_INCOMPAT_RECOVER;
+	ext2fs_clear_feature_journal_needs_recovery(fs->super);
 
 	/* if we had an error doing journal recovery, we need a full fsck */
 	if (error)
@@ -451,8 +451,7 @@ try_backup_journal:
 			ext2fs_swap_super(&jsuper);
 #endif
 		if (jsuper.s_magic != EXT2_SUPER_MAGIC ||
-		    !(jsuper.s_feature_incompat &
-		      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
+		    !ext2fs_has_feature_journal_dev(&jsuper)) {
 			retval = EXT2_ET_LOAD_EXT_JOURNAL;
 			brelse(bh);
 			goto errout;
@@ -466,8 +465,7 @@ try_backup_journal:
 		}
 
 		/* Check the superblock checksum */
-		if (jsuper.s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
+		if (ext2fs_has_feature_metadata_csum(&jsuper)) {
 			struct struct_ext2_filsys fsx;
 			struct ext2_super_block	superx;
 			void *p;
@@ -476,8 +474,7 @@ try_backup_journal:
 			memcpy(&fsx, fs, sizeof(fsx));
 			memcpy(&superx, fs->super, sizeof(superx));
 			fsx.super = &superx;
-			fsx.super->s_feature_ro_compat |=
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM;
+			ext2fs_set_feature_metadata_csum(fsx.super);
 			if (!ext2fs_superblock_csum_verify(&fsx, p)) {
 				retval = EXT2_ET_LOAD_EXT_JOURNAL;
 				brelse(bh);
@@ -522,10 +519,8 @@ errout:
 static errcode_t ext2fs_journal_fix_bad_inode(ext2_filsys fs)
 {
 	struct ext2_super_block *sb = fs->super;
-	int recover = fs->super->s_feature_incompat &
-		EXT3_FEATURE_INCOMPAT_RECOVER;
-	int has_journal = fs->super->s_feature_compat &
-		EXT3_FEATURE_COMPAT_HAS_JOURNAL;
+	int recover = ext2fs_has_feature_journal_needs_recovery(fs->super);
+	int has_journal = ext2fs_has_feature_journal(fs->super);
 
 	if (has_journal || sb->s_journal_inum) {
 		/* The journal inode is bogus, remove and force full fsck */
@@ -604,12 +599,11 @@ static errcode_t ext2fs_journal_load(journal_t *journal)
 		return EXT2_ET_RO_UNSUPP_FEATURE;
 
 	/* Checksum v1-3 are mutually exclusive features. */
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2) &&
-	    JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V3))
+	if (jfs_has_feature_csum2(journal) && jfs_has_feature_csum3(journal))
 		return EXT2_ET_CORRUPT_SUPERBLOCK;
 
 	if (journal_has_csum_v2or3(journal) &&
-	    JFS_HAS_COMPAT_FEATURE(journal, JFS_FEATURE_COMPAT_CHECKSUM))
+	    jfs_has_feature_checksum(journal))
 		return EXT2_ET_CORRUPT_SUPERBLOCK;
 
 	if (!ext2fs_journal_verify_csum_type(journal, jsb) ||
@@ -680,12 +674,11 @@ static errcode_t ext2fs_check_ext3_journal(ext2_filsys fs)
 {
 	struct ext2_super_block *sb = fs->super;
 	journal_t *journal;
-	int recover = fs->super->s_feature_incompat &
-		EXT3_FEATURE_INCOMPAT_RECOVER;
+	int recover = ext2fs_has_feature_journal_needs_recovery(fs->super);
 	errcode_t retval;
 
 	/* If we don't have any journal features, don't do anything more */
-	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
+	if (!ext2fs_has_feature_journal(sb) &&
 	    !recover && sb->s_journal_inum == 0 && sb->s_journal_dev == 0 &&
 	    uuid_is_null(sb->s_journal_uuid))
 		return 0;
@@ -703,13 +696,13 @@ static errcode_t ext2fs_check_ext3_journal(ext2_filsys fs)
 	 * needs_recovery set but has_journal clear.  We can't get in a loop
 	 * with -y, -n, or -p, only if a user isn't making up their mind.
 	 */
-	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
+	if (!ext2fs_has_feature_journal(sb)) {
 		retval = EXT2_ET_JOURNAL_FLAGS_WRONG;
 		goto err;
 	}
 
-	if (sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL &&
-	    !(sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER) &&
+	if (ext2fs_has_feature_journal(sb) &&
+	    !ext2fs_has_feature_journal_needs_recovery(sb) &&
 	    journal->j_superblock->s_start != 0) {
 		retval = EXT2_ET_JOURNAL_FLAGS_WRONG;
 		goto err;
@@ -720,7 +713,7 @@ static errcode_t ext2fs_check_ext3_journal(ext2_filsys fs)
 	 * the journal's errno is set; if so, we need to mark the file
 	 * system as being corrupt and clear the journal's s_errno.
 	 */
-	if (!(sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER) &&
+	if (!ext2fs_has_feature_journal_needs_recovery(sb) &&
 	    journal->j_superblock->s_errno) {
 		fs->super->s_state |= EXT2_ERROR_FS;
 		ext2fs_mark_super_dirty(fs);
@@ -929,7 +922,7 @@ void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
 	csum32 = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&seq, sizeof(seq));
 	csum32 = jbd2_chksum(j, csum32, bh->b_data, bh->b_size);
 
-	if (JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V3))
+	if (jfs_has_feature_csum3(j))
 		tag3->t_checksum = ext2fs_cpu_to_be32(csum32);
 	else
 		tag->t_checksum = ext2fs_cpu_to_be16(csum32);
diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 885e590..bab0ce9 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -364,7 +364,7 @@ static void dump_journal(char *cmdname, FILE *out_file,
 
 	if ((be32_to_cpu(jsb->s_header.h_magic) != JFS_MAGIC_NUMBER) &&
 	    (sb->s_magic == EXT2_SUPER_MAGIC) &&
-	    (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
+	    ext2fs_has_feature_journal_dev(sb)) {
 		blocksize = EXT2_BLOCK_SIZE(sb);
 		blocknr = (blocksize == 1024) ? 2 : 1;
 		uuid_unparse(sb->s_uuid, jsb_buffer);
diff --git a/debugfs/quota.c b/debugfs/quota.c
index 7aa0f3b..8c94486 100644
--- a/debugfs/quota.c
+++ b/debugfs/quota.c
@@ -34,8 +34,7 @@ static int load_quota_ctx(char *progname)
 	if (check_fs_open(progname))
 		return 1;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(current_fs->super,
-					EXT4_FEATURE_RO_COMPAT_QUOTA)) {
+	if (!ext2fs_has_feature_quota(current_fs->super)) {
 		com_err(progname, 0, "quota feature not enabled");
 		return 1;
 	}

