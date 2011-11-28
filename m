From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 05/22] ext4: Calculate and verify superblock checksum
Date: Mon, 28 Nov 2011 15:26:49 -0800
Message-ID: <20111128232649.19194.5974.stgit@elm3c44.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Calculate and verify the superblock checksum.  Since the UUID and block group
number are embedded in each copy of the superblock, we need only checksum the
entire block.  Refactor some of the code to eliminate open-coding of the
checksum update call.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4.h      |   10 +++++++++-
 fs/ext4/ext4_jbd2.c |    9 ++++++++-
 fs/ext4/ext4_jbd2.h |    7 +++++--
 fs/ext4/inode.c     |    3 +--
 fs/ext4/namei.c     |    4 ++--
 fs/ext4/resize.c    |    6 +++++-
 fs/ext4/super.c     |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 77 insertions(+), 9 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index eab64c2..4022320 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1098,7 +1098,8 @@ struct ext4_super_block {
 	__le32	s_usr_quota_inum;	/* inode for tracking user quota */
 	__le32	s_grp_quota_inum;	/* inode for tracking group quota */
 	__le32	s_overhead_clusters;	/* overhead blocks/clusters in fs */
-	__le32  s_reserved[109];        /* Padding to the end of the block */
+	__le32	s_reserved[108];	/* Padding to the end of the block */
+	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
 #define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)
@@ -1957,6 +1958,10 @@ extern int ext4_group_extend(struct super_block *sb,
 				ext4_fsblk_t n_blocks_count);
 
 /* super.c */
+extern int ext4_superblock_csum_verify(struct super_block *sb,
+				       struct ext4_super_block *es);
+extern void ext4_superblock_csum_set(struct super_block *sb,
+				     struct ext4_super_block *es);
 extern void *ext4_kvmalloc(size_t size, gfp_t flags);
 extern void *ext4_kvzalloc(size_t size, gfp_t flags);
 extern void ext4_kvfree(void *ptr);
@@ -2232,6 +2237,9 @@ static inline void ext4_unlock_group(struct super_block *sb,
 
 static inline void ext4_mark_super_dirty(struct super_block *sb)
 {
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+
+	ext4_superblock_csum_set(sb, es);
 	if (EXT4_SB(sb)->s_journal == NULL)
 		sb->s_dirt =1;
 }
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index aca1790..90f7c2e 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -138,16 +138,23 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 }
 
 int __ext4_handle_dirty_super(const char *where, unsigned int line,
-			      handle_t *handle, struct super_block *sb)
+			      handle_t *handle, struct super_block *sb,
+			      int now)
 {
 	struct buffer_head *bh = EXT4_SB(sb)->s_sbh;
 	int err = 0;
 
 	if (ext4_handle_valid(handle)) {
+		ext4_superblock_csum_set(sb,
+				(struct ext4_super_block *)bh->b_data);
 		err = jbd2_journal_dirty_metadata(handle, bh);
 		if (err)
 			ext4_journal_abort_handle(where, line, __func__,
 						  bh, handle, err);
+	} else if (now) {
+		ext4_superblock_csum_set(sb,
+				(struct ext4_super_block *)bh->b_data);
+		mark_buffer_dirty(bh);
 	} else
 		sb->s_dirt = 1;
 	return err;
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 5802fa1..ed9b78d 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -141,7 +141,8 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 				 struct buffer_head *bh);
 
 int __ext4_handle_dirty_super(const char *where, unsigned int line,
-			      handle_t *handle, struct super_block *sb);
+			      handle_t *handle, struct super_block *sb,
+			      int now);
 
 #define ext4_journal_get_write_access(handle, bh) \
 	__ext4_journal_get_write_access(__func__, __LINE__, (handle), (bh))
@@ -153,8 +154,10 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 #define ext4_handle_dirty_metadata(handle, inode, bh) \
 	__ext4_handle_dirty_metadata(__func__, __LINE__, (handle), (inode), \
 				     (bh))
+#define ext4_handle_dirty_super_now(handle, sb) \
+	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb), 1)
 #define ext4_handle_dirty_super(handle, sb) \
-	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))
+	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb), 0)
 
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fffec40..47eeabc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4078,8 +4078,7 @@ static int ext4_do_update_inode(handle_t *handle,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
 			sb->s_dirt = 1;
 			ext4_handle_sync(handle);
-			err = ext4_handle_dirty_metadata(handle, NULL,
-					EXT4_SB(sb)->s_sbh);
+			err = ext4_handle_dirty_super_now(handle, sb);
 		}
 	}
 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index aa4c782..363b9c0 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2013,7 +2013,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	/* Insert this inode at the head of the on-disk orphan list... */
 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
 	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
-	err = ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
+	err = ext4_handle_dirty_super_now(handle, sb);
 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (!err)
 		err = rc;
@@ -2086,7 +2086,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 		if (err)
 			goto out_brelse;
 		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
-		err = ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
+		err = ext4_handle_dirty_super_now(handle, inode->i_sb);
 	} else {
 		struct ext4_iloc iloc2;
 		struct inode *i_prev =
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 996780a..c33b72a 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -511,7 +511,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	ext4_kvfree(o_group_desc);
 
 	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
-	err = ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
+	err = ext4_handle_dirty_super_now(handle, sb);
 	if (err)
 		ext4_std_error(sb, err);
 
@@ -682,6 +682,8 @@ static void update_backups(struct super_block *sb,
 		goto exit_err;
 	}
 
+	ext4_superblock_csum_set(sb, (struct ext4_super_block *)data);
+
 	while ((group = ext4_list_backups(sb, &three, &five, &seven)) < last) {
 		struct buffer_head *bh;
 
@@ -925,6 +927,8 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	/* Update the global fs size fields */
 	sbi->s_groups_count++;
 
+	ext4_superblock_csum_set(sb,
+				 (struct ext4_super_block *)primary->b_data);
 	err = ext4_handle_dirty_metadata(handle, NULL, primary);
 	if (unlikely(err)) {
 		ext4_std_error(sb, err);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a555811..4fb8d9a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -121,6 +121,38 @@ static int ext4_verify_csum_type(struct super_block *sb,
 	return es->s_checksum_type == EXT4_CRC32C_CHKSUM;
 }
 
+static __le32 ext4_superblock_csum(struct super_block *sb,
+				   struct ext4_super_block *es)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int offset = offsetof(struct ext4_super_block, s_checksum);
+	__u32 csum;
+
+	csum = ext4_chksum(sbi, ~0, (char *)es, offset);
+
+	return cpu_to_le32(csum);
+}
+
+int ext4_superblock_csum_verify(struct super_block *sb,
+				struct ext4_super_block *es)
+{
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	return es->s_checksum == ext4_superblock_csum(sb, es);
+}
+
+void ext4_superblock_csum_set(struct super_block *sb,
+			      struct ext4_super_block *es)
+{
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	es->s_checksum = ext4_superblock_csum(sb, es);
+}
+
 void *ext4_kvmalloc(size_t size, gfp_t flags)
 {
 	void *ret;
@@ -3213,6 +3245,20 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	}
 
+	/* Check superblock checksum */
+	if (!ext4_superblock_csum_verify(sb, es)) {
+		ext4_msg(sb, KERN_ERR, "VFS: Found ext4 filesystem with "
+			 "invalid superblock checksum.  Run e2fsck?");
+		silent = 1;
+		goto cantfind_ext4;
+	}
+
+	/* Precompute first piece of csum */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		sbi->s_uuid_csum = ext4_chksum(sbi, ~0, es->s_uuid,
+					       sizeof(es->s_uuid));
+
 	/* Set defaults before we parse the mount options */
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 	set_opt(sb, INIT_INODE_TABLE);
@@ -4218,6 +4264,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 				&EXT4_SB(sb)->s_freeinodes_counter));
 	sb->s_dirt = 0;
 	BUFFER_TRACE(sbh, "marking dirty");
+	ext4_superblock_csum_set(sb, es);
 	mark_buffer_dirty(sbh);
 	if (sync) {
 		error = sync_dirty_buffer(sbh);
