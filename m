From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v4 4/4] ext4: Add 64-bit inode number support
Date: Fri,  2 Feb 2018 12:41:36 +0300
Message-ID: <20180202094136.13032-5-artem.blagodarenko@gmail.com>
References: <20180202094136.13032-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:41375 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751461AbeBBJnW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Feb 2018 04:43:22 -0500
Received: by mail-lf0-f68.google.com with SMTP id f136so30513523lff.8
        for <linux-ext4@vger.kernel.org>; Fri, 02 Feb 2018 01:43:21 -0800 (PST)
In-Reply-To: <20180202094136.13032-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use dirdata to store high bits of 64bit inode
number.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 fs/ext4/ext4.h    |  38 +++++++++++---
 fs/ext4/ialloc.c  |   7 ++-
 fs/ext4/inline.c  |  31 ++++++-----
 fs/ext4/inode.c   |   5 ++
 fs/ext4/migrate.c |   2 +-
 fs/ext4/namei.c   | 150 +++++++++++++++++++++++++++++++++++++-----------------
 fs/ext4/super.c   |   6 +++
 7 files changed, 172 insertions(+), 67 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 51aadb2c294b..0cfb95c4e723 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1291,7 +1291,7 @@ struct ext4_super_block {
 	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
 	__le32	s_free_blocks_count_hi;	/* Free blocks count */
 	__le16	s_min_extra_isize;	/* All inodes have at least # bytes */
-	__le16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
+	__le16	s_want_extra_isize;	/* New inodes should reserve # bytes */
 	__le32	s_flags;		/* Miscellaneous flags */
 	__le16  s_raid_stride;		/* RAID stride */
 	__le16  s_mmp_update_interval;  /* # seconds to wait in MMP checking */
@@ -1303,6 +1303,7 @@ struct ext4_super_block {
 	__u8	s_reserved_pad;		/* Padding to next 32bits */
 	__le64	s_kbytes_written;	/* nr of lifetime kilobytes written */
 	__le32	s_snapshot_inum;	/* Inode number of active snapshot */
+	/* there is no high part of s_snapshot_inum yet */
 	__le32	s_snapshot_id;		/* sequential ID of active snapshot */
 	__le64	s_snapshot_r_blocks_count; /* reserved blocks for active
 					      snapshot's future use */
@@ -1331,7 +1332,13 @@ struct ext4_super_block {
 	__le32	s_lpf_ino;		/* Location of the lost+found inode */
 	__le32	s_prj_quota_inum;	/* inode for tracking project quota */
 	__le32	s_checksum_seed;	/* crc32c(uuid) if csum_seed set */
-	__le32	s_reserved[98];		/* Padding to the end of the block */
+	__le32	s_inodes_count_hi;	/* higth part of inode count */
+	__le32	s_free_inodes_count_hi;	/* Free inodes count */
+	__le32	s_prj_quota_inum_hi;	/* high part of project quota inode */
+	__le32	s_last_orphan_hi;	/* high part of last orphan */
+	__le32	s_first_error_ino_hi;	/* high part of first error ino */
+	__le32	s_last_error_ino_hi;	/* high part of last error ino */
+	__le32	s_reserved[92];		/* Padding to the end of the block */
 	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -1392,7 +1399,7 @@ struct ext4_sb_info {
 	int s_inode_size;
 	int s_first_ino;
 	unsigned int s_inode_readahead_blks;
-	unsigned int s_inode_goal;
+	unsigned long s_inode_goal;
 	spinlock_t s_next_gen_lock;
 	u32 s_next_generation;
 	u32 s_hash_seed[4];
@@ -1677,6 +1684,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
+#define EXT4_FEATURE_INCOMPAT_INODE64		0x20000
 
 #define EXT4_FEATURE_COMPAT_FUNCS(name, flagname) \
 static inline bool ext4_has_feature_##name(struct super_block *sb) \
@@ -1765,6 +1773,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(csum_seed,		CSUM_SEED)
 EXT4_FEATURE_INCOMPAT_FUNCS(largedir,		LARGEDIR)
 EXT4_FEATURE_INCOMPAT_FUNCS(inline_data,	INLINE_DATA)
 EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
+EXT4_FEATURE_INCOMPAT_FUNCS(inode64,		INODE64)
+
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -1793,6 +1803,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
 					 EXT4_FEATURE_INCOMPAT_CSUM_SEED | \
+					 EXT4_FEATURE_INCOMPAT_INODE64 | \
 					 EXT4_FEATURE_INCOMPAT_LARGEDIR | \
 					 EXT4_FEATURE_INCOMPAT_DIRDATA)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
@@ -1974,7 +1985,7 @@ struct ext4_dir_entry_tail {
  */
 #define EXT4_DIRENT_LUFID		0x10
 #define EXT4_DIRENT_INODE		0x20
-
+#define DIRENT_INODE_LEN                4
 #define EXT4_LUFID_MAGIC    0xAD200907UL
 
 struct ext4_dirent_data_header {
@@ -1987,6 +1998,11 @@ struct ext4_dirent_lufid {
 	__u8				dl_data[0];
 } __packed;
 
+struct ext4_dirent_inode64 {
+	struct ext4_dirent_data_header	di_header; /* 1 + 4 */
+	__le32				di_inohi;
+} __packed;
+
 struct ext4_dentry_param {
 	__u32				edp_magic; /* EXT4_LUFID_MAGIC */
 	struct ext4_dirent_lufid	edp_lufid;
@@ -2428,7 +2444,9 @@ extern int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 void ext4_insert_dentry(struct inode *inode,
 			struct ext4_dir_entry_2 *de,
 			int buf_size,
-			struct ext4_filename *fname);
+			struct ext4_filename *fname,
+			bool write_short_dotdot,
+			struct dentry *dentry);
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
 	if (!ext4_has_feature_dir_index(inode->i_sb))
@@ -2463,7 +2481,7 @@ extern int ext4fs_dirhash(const char *name, int len, struct
 
 /* ialloc.c */
 extern struct inode *__ext4_new_inode(handle_t *, struct inode *, umode_t,
-				      const struct qstr *qstr, __u32 goal,
+				      const struct qstr *qstr, __u64 goal,
 				      uid_t *owner, __u32 i_flags,
 				      int handle_type, unsigned int line_no,
 				      int nblocks);
@@ -3106,7 +3124,8 @@ extern int ext4_da_write_inline_data_end(struct inode *inode, loff_t pos,
 					 struct page *page);
 extern int ext4_try_add_inline_entry(handle_t *handle,
 				     struct ext4_filename *fname,
-				     struct inode *dir, struct inode *inode);
+				     struct inode *dir, struct inode *inode,
+				     struct dentry *dentry);
 extern int ext4_try_create_inline_dir(handle_t *handle,
 				      struct inode *parent,
 				      struct inode *inode);
@@ -3383,6 +3402,11 @@ static inline int ext4_get_dirent_data_len(struct ext4_dir_entry_2 *de)
 	return dlen;
 }
 
+extern int get_ino(struct inode *dir,
+			     struct ext4_dir_entry_2 *de, unsigned long *ino);
+extern void set_ino(struct inode *dir,
+		    struct ext4_dir_entry_2 *de, unsigned long i_ino,
+		    bool write_short_dotdot, struct dentry *dentry);
 #endif	/* __KERNEL__ */
 
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 25dbc15e2ee1..e23dc4133e84 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -770,7 +770,7 @@ static int find_inode_bit(struct super_block *sb, ext4_group_t group,
  */
 struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 			       umode_t mode, const struct qstr *qstr,
-			       __u32 goal, uid_t *owner, __u32 i_flags,
+			       __u64 goal, uid_t *owner, __u32 i_flags,
 			       int handle_type, unsigned int line_no,
 			       int nblocks)
 {
@@ -1149,6 +1149,11 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		__le32 gen = cpu_to_le32(inode->i_generation);
 		csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&inum,
 				   sizeof(inum));
+		if (inode->i_ino >> 32) {
+			inum = cpu_to_le32(inode->i_ino >> 32);
+			csum = ext4_chksum(sbi, sbi->s_csum_seed,
+					(__u8 *)&inum, sizeof(inum));
+		}
 		ei->i_csum_seed = ext4_chksum(sbi, csum, (__u8 *)&gen,
 					      sizeof(gen));
 	}
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 666891dc03cd..f3d0d7f9d331 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1020,13 +1020,16 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 				     struct inode *dir,
 				     struct inode *inode,
 				     struct ext4_iloc *iloc,
-				     void *inline_start, int inline_size)
+				     void *inline_start, int inline_size,
+				     struct dentry *dentry)
 {
 	int		err;
 	struct ext4_dir_entry_2 *de;
+	bool write_short_dotdot = 0;
 
 	err = ext4_find_dest_de(dir, inode, iloc->bh, inline_start,
-				inline_size, fname, &de, 0, NULL, 0);
+				inline_size, fname, &de, 0,
+				&write_short_dotdot, 0);
 	if (err)
 		return err;
 
@@ -1034,7 +1037,8 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 	err = ext4_journal_get_write_access(handle, iloc->bh);
 	if (err)
 		return err;
-	ext4_insert_dentry(inode, de, inline_size, fname);
+	ext4_insert_dentry(inode, de, inline_size, fname,
+			   write_short_dotdot, dentry);
 
 	ext4_show_inline_dir(dir, iloc->bh, inline_start, inline_size);
 
@@ -1264,7 +1268,8 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
  * the new created block.
  */
 int ext4_try_add_inline_entry(handle_t *handle, struct ext4_filename *fname,
-			      struct inode *dir, struct inode *inode)
+			      struct inode *dir, struct inode *inode,
+			      struct dentry *dentry)
 {
 	int ret, inline_size, no_expand;
 	void *inline_start;
@@ -1283,7 +1288,7 @@ int ext4_try_add_inline_entry(handle_t *handle, struct ext4_filename *fname,
 	inline_size = EXT4_MIN_INLINE_DATA_SIZE - EXT4_INLINE_DOTDOT_SIZE;
 
 	ret = ext4_add_dirent_to_inline(handle, fname, dir, inode, &iloc,
-					inline_start, inline_size);
+					inline_start, inline_size, dentry);
 	if (ret != -ENOSPC)
 		goto out;
 
@@ -1305,7 +1310,7 @@ int ext4_try_add_inline_entry(handle_t *handle, struct ext4_filename *fname,
 
 		ret = ext4_add_dirent_to_inline(handle, fname, dir,
 						inode, &iloc, inline_start,
-						inline_size);
+						inline_size, dentry);
 
 		if (ret != -ENOSPC)
 			goto out;
@@ -1337,7 +1342,7 @@ int htree_inlinedir_to_tree(struct file *dir_file,
 			    int *has_inline_data)
 {
 	int err = 0, count = 0;
-	unsigned int parent_ino;
+	unsigned long parent_ino;
 	int pos;
 	struct ext4_dir_entry_2 *de;
 	struct inode *inode = file_inode(dir_file);
@@ -1372,7 +1377,9 @@ int htree_inlinedir_to_tree(struct file *dir_file,
 		goto out;
 
 	pos = 0;
-	parent_ino = le32_to_cpu(((struct ext4_dir_entry_2 *)dir_buf)->inode);
+	ret = get_ino(inode, (struct ext4_dir_entry_2 *)dir_buf, &parent_ino);
+	if (ret)
+		goto out;
 	while (pos < inline_size) {
 		/*
 		 * As inlined dir doesn't store any information about '.' and
@@ -1380,9 +1387,9 @@ int htree_inlinedir_to_tree(struct file *dir_file,
 		 * them differently.
 		 */
 		if (pos == 0) {
-			fake.inode = cpu_to_le32(inode->i_ino);
 			fake.name_len = 1;
 			strcpy(fake.name, ".");
+			set_ino(inode, &fake, inode->i_ino, 0, NULL);
 			fake.rec_len = ext4_rec_len_to_disk(
 					EXT4_DIR_NAME_LEN(fake.name_len),
 					inline_size);
@@ -1390,9 +1397,9 @@ int htree_inlinedir_to_tree(struct file *dir_file,
 			de = &fake;
 			pos = EXT4_INLINE_DOTDOT_OFFSET;
 		} else if (pos == EXT4_INLINE_DOTDOT_OFFSET) {
-			fake.inode = cpu_to_le32(parent_ino);
 			fake.name_len = 2;
 			strcpy(fake.name, "..");
+			set_ino(inode, &fake, parent_ino, 0, NULL);
 			fake.rec_len = ext4_rec_len_to_disk(
 					EXT4_DIR_NAME_LEN(fake.name_len),
 					inline_size);
@@ -1612,9 +1619,9 @@ int ext4_try_create_inline_dir(handle_t *handle, struct inode *parent,
 	 * and create a fake dentry to cover the left space.
 	 */
 	de = (struct ext4_dir_entry_2 *)ext4_raw_inode(&iloc)->i_block;
-	de->inode = cpu_to_le32(parent->i_ino);
+	set_ino(parent, de, parent->i_ino, 0, NULL);
 	de = (struct ext4_dir_entry_2 *)((void *)de + EXT4_INLINE_DOTDOT_SIZE);
-	de->inode = 0;
+	set_ino(parent, de, 0, 0, NULL);
 	de->rec_len = ext4_rec_len_to_disk(
 				inline_size - EXT4_INLINE_DOTDOT_SIZE,
 				inline_size);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 31db875bc7a1..9caefee1bce9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4691,6 +4691,11 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		__le32 gen = raw_inode->i_generation;
 		csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&inum,
 				   sizeof(inum));
+		if (inode->i_ino >> 32) {
+			inum = cpu_to_le32(inode->i_ino >> 32);
+			csum = ext4_chksum(sbi, sbi->s_csum_seed,
+					(__u8 *)&inum, sizeof(inum));
+		}
 		ei->i_csum_seed = ext4_chksum(sbi, csum, (__u8 *)&gen,
 					      sizeof(gen));
 	}
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index cf5181b62df1..89266764908b 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -441,7 +441,7 @@ int ext4_ext_migrate(struct inode *inode)
 	struct inode *tmp_inode = NULL;
 	struct migrate_struct lb;
 	unsigned long max_entries;
-	__u32 goal;
+	__u64 goal;
 	uid_t owner[2];
 
 	/*
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 21f86c48708b..154f4ab0e0c6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1543,21 +1543,91 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 	return bh;
 }
 
-static int get_ino(struct inode *dir,
-			     struct ext4_dir_entry_2 *de, __u32 *ino)
+int get_ino(struct inode *dir,
+			     struct ext4_dir_entry_2 *de, unsigned long *ino)
 {
 	struct super_block *sb = dir->i_sb;
 
 	*ino = le32_to_cpu(de->inode);
+
+	if (ext4_has_feature_inode64(sb) &&
+	    (de->file_type & EXT4_DIRENT_INODE)) {
+		struct ext4_dirent_data_header *ddh =
+			(struct ext4_dirent_data_header *)
+			&de->name[de->name_len] + 1;
+
+		if ((char *)ddh > &de->name[de->rec_len]) {
+			EXT4_ERROR_INODE(dir, "corrupted dirdata entry\n");
+			return -EFSCORRUPTED;
+		}
+
+		if (de->file_type & EXT4_DIRENT_LUFID) {
+			/* skip LUFID record if present */
+			ddh = (struct ext4_dirent_data_header *)
+			((char *)ddh + ddh->ddh_length);
+		}
+
+		if ((char *)ddh > &de->name[de->rec_len]) {
+			EXT4_ERROR_INODE(dir, "corrupted dirdata entry\n");
+			return -EFSCORRUPTED;
+		}
+
+		if (ddh->ddh_length == (sizeof(__u32) + 1)) {
+			__le32 ino_hi;
+			struct ext4_dirent_inode64 *di =
+				(struct ext4_dirent_inode64 *)ddh;
+
+			memcpy(&ino_hi, &di->di_inohi, sizeof(__u32));
+			*ino |= (__u64)le32_to_cpu(ino_hi) << 32;
+		} else {
+			EXT4_ERROR_INODE(dir,
+				"corrupted dirdata inode number\n");
+			return -EFSCORRUPTED;
+		}
+	}
+
 	return 0;
 }
 
-static void set_ino(struct inode *dir,
-		    struct ext4_dir_entry_2 *de, unsigned long i_ino)
+void set_ino(struct inode *dir,
+		    struct ext4_dir_entry_2 *de, unsigned long i_ino,
+		    bool write_short_dotdot, struct dentry *dentry)
 {
-	struct super_block *sb = dir->i_sb;
+	__u32 i_ino_hi;
+	struct ext4_dirent_inode64 *di;
+	struct ext4_dirent_data_header *ddh = NULL;
+	int data_offset = 0;
+	int namelen;
+
+	de->inode = cpu_to_le32(i_ino & 0xFFFFFFFF);
+
+	if (dentry) {
+		ddh = ext4_dentry_get_data(dir->i_sb,
+					   (struct ext4_dentry_param *)
+					   dentry->d_fsdata);
+		namelen = dentry->d_name.len;
+	} else {
+		namelen = de->name_len;
+	}
+
+	/* If we're writing short form of "dotdot", don't add data section */
+	if (write_short_dotdot)
+		return;
 
-	de->inode = cpu_to_le32(i_ino);
+	if (ddh) {
+		de->name[namelen] = 0;
+		memcpy(&de->name[namelen + 1], ddh, ddh->ddh_length);
+		de->file_type |= EXT4_DIRENT_LUFID;
+		data_offset = ddh->ddh_length;
+	}
+
+	if (ext4_has_feature_inode64(dir->i_sb)) {
+		i_ino_hi = cpu_to_le32((__u32)(i_ino >> 32));
+		di = (void *)&de->name[namelen + 1 + data_offset];
+		di->di_header.ddh_length = sizeof(*di);
+		memcpy(&di->di_inohi, &i_ino_hi, sizeof(i_ino_hi));
+		de->file_type |= EXT4_DIRENT_INODE;
+	}
 }
 
 static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
@@ -1589,12 +1659,12 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 		return (struct dentry *) bh;
 	inode = NULL;
 	if (bh) {
-		__u32 ino;
+		unsigned long ino;
 		int ret = get_ino(dir, de, &ino);
 
 		brelse(bh);
 		if (ret || !ext4_valid_inum(dir->i_sb, ino)) {
-			EXT4_ERROR_INODE(dir, "bad inode number: %u", ino);
+			EXT4_ERROR_INODE(dir, "bad inode number: %lu", ino);
 			return ERR_PTR(-EFSCORRUPTED);
 		}
 		if (unlikely(ino == dir->i_ino)) {
@@ -1605,7 +1675,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 		inode = ext4_iget_normal(dir->i_sb, ino);
 		if (inode == ERR_PTR(-ESTALE)) {
 			EXT4_ERROR_INODE(dir,
-					 "deleted inode referenced: %u",
+					 "deleted inode referenced: %lu",
 					 ino);
 			return ERR_PTR(-EFSCORRUPTED);
 		}
@@ -1625,7 +1695,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 
 struct dentry *ext4_get_parent(struct dentry *child)
 {
-	__u32 ino;
+	unsigned long ino;
 	static const struct qstr dotdot = QSTR_INIT("..", 2);
 	struct ext4_dir_entry_2 * de;
 	struct buffer_head *bh;
@@ -1641,7 +1711,7 @@ struct dentry *ext4_get_parent(struct dentry *child)
 
 	if (ret || !ext4_valid_inum(child->d_sb, ino)) {
 		EXT4_ERROR_INODE(d_inode(child),
-				 "bad parent inode number: %u", ino);
+				 "bad parent inode number: %lu", ino);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
@@ -1870,7 +1940,9 @@ int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 void ext4_insert_dentry(struct inode *inode,
 			struct ext4_dir_entry_2 *de,
 			int buf_size,
-			struct ext4_filename *fname)
+			struct ext4_filename *fname,
+			bool write_short_dotdot,
+			struct dentry *dentry)
 {
 
 	int nlen, rlen;
@@ -1886,7 +1958,7 @@ void ext4_insert_dentry(struct inode *inode,
 		de = de1;
 	}
 	de->file_type = EXT4_FT_UNKNOWN;
-	set_ino(inode, de, inode->i_ino);
+	set_ino(inode, de, inode->i_ino, write_short_dotdot,  dentry);
 	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
 	de->name_len = fname_len(fname);
 	memcpy(de->name, fname_name(fname), fname_len(fname));
@@ -1909,20 +1981,14 @@ static int add_dirent_to_buf(handle_t *handle,
 {
 	unsigned int	blocksize = dir->i_sb->s_blocksize;
 	int		csum_size = 0;
-	unsigned short	reclen, dotdot_reclen = 0;
-	int		 err, dlen = 0, data_offset = 0;
+	unsigned short  dotdot_reclen = 0;
+	int		err;
 	bool		is_dotdot = false, write_short_dotdot = false;
-	struct ext4_dirent_data_header *ddh;
 	int namelen = dentry->d_name.len;
 
 	if (ext4_has_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
-	ddh = ext4_dentry_get_data(inode->i_sb, (struct ext4_dentry_param *)
-						dentry->d_fsdata);
-	if (ddh)
-		dlen = ddh->ddh_length + 1 /* NUL separator */;
-
 	is_dotdot = (namelen == 2 &&
 		     memcmp(dentry->d_name.name, "..", 2) == 0);
 
@@ -1933,8 +1999,6 @@ static int add_dirent_to_buf(handle_t *handle,
 	if (is_dotdot)
 		dotdot_reclen = EXT4_DIR_NAME_LEN(namelen);
 
-	reclen = EXT4_DIR_NAME_LEN(namelen + dlen + 3);
-
 	if (!de) {
 		err = ext4_find_dest_de(dir, inode, bh, bh->b_data,
 					blocksize - csum_size, fname, &de,
@@ -1951,15 +2015,8 @@ static int add_dirent_to_buf(handle_t *handle,
 	}
 
 	/* By now the buffer is marked for journaling */
-	ext4_insert_dentry(inode, de, blocksize, fname);
-
-	/* If we're writing short form of "dotdot", don't add data section */
-	if (ddh && !write_short_dotdot) {
-		de->name[namelen] = 0;
-		memcpy(&de->name[namelen + 1], ddh, ddh->ddh_length);
-		de->file_type |= EXT4_DIRENT_LUFID;
-		data_offset = ddh->ddh_length;
-	}
+	ext4_insert_dentry(inode, de, blocksize, fname, write_short_dotdot,
+			   dentry);
 
 	/*
 	 * XXX shouldn't update any times until successful
@@ -2150,7 +2207,8 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 		return retval;
 
 	if (ext4_has_inline_data(dir)) {
-		retval = ext4_try_add_inline_entry(handle, &fname, dir, inode);
+		retval = ext4_try_add_inline_entry(handle, &fname, dir,
+						   inode, dentry);
 		if (retval < 0)
 			goto out;
 		if (retval == 1) {
@@ -2636,7 +2694,7 @@ struct ext4_dir_entry_2 *ext4_init_dot_dotdot(struct inode *inode,
 			  int blocksize, int csum_size,
 			  unsigned int parent_ino, int dotdot_real_len)
 {
-	set_ino(inode, de, inode->i_ino);
+	set_ino(inode, de, inode->i_ino, 0, NULL);
 	de->name_len = 1;
 	de->rec_len = ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de),
 					   blocksize);
@@ -2644,7 +2702,7 @@ struct ext4_dir_entry_2 *ext4_init_dot_dotdot(struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
 
 	de = ext4_next_entry(de, blocksize);
-	set_ino(inode, de, parent_ino);
+	set_ino(inode, de, parent_ino, 0, NULL);
 	de->name_len = 2;
 	if (!dotdot_real_len)
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
@@ -2770,7 +2828,7 @@ bool ext4_empty_dir(struct inode *inode)
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de, *de1;
 	struct super_block *sb;
-	__u32 ino, ino2;
+	unsigned long ino, ino2;
 
 	if (ext4_has_inline_data(inode)) {
 		int has_inline_data = 1;
@@ -2928,7 +2986,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	struct list_head *prev;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	__u32 ino_next;
+	__u64 ino_next;
 	struct ext4_iloc iloc;
 	int err = 0;
 
@@ -2978,7 +3036,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 		struct inode *i_prev =
 			&list_entry(prev, struct ext4_inode_info, i_orphan)->vfs_inode;
 
-		jbd_debug(4, "orphan inode %lu will point to %u\n",
+		jbd_debug(4, "orphan inode %lu will point to %lu\n",
 			  i_prev->i_ino, ino_next);
 		err = ext4_reserve_inode_write(handle, i_prev, &iloc2);
 		if (err) {
@@ -3009,7 +3067,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
 	handle_t *handle = NULL;
-	__u32 ino;
+	unsigned long ino;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
 		return -EIO;
@@ -3086,7 +3144,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
 	handle_t *handle = NULL;
-	__u32 ino;
+	unsigned long ino;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
 		return -EIO;
@@ -3414,7 +3472,7 @@ struct ext4_renament {
 static int ext4_rename_dir_prepare(handle_t *handle, struct ext4_renament *ent)
 {
 	int retval;
-	__u32 ino;
+	unsigned long ino;
 
 	ent->dir_bh = ext4_get_first_dir_block(handle, ent->inode,
 					      &retval, &ent->parent_de,
@@ -3433,7 +3491,7 @@ static int ext4_rename_dir_finish(handle_t *handle, struct ext4_renament *ent,
 {
 	int retval;
 
-	set_ino(ent->dir, ent->parent_de, dir_ino);
+	set_ino(ent->dir, ent->parent_de, dir_ino, 0, NULL);
 	BUFFER_TRACE(ent->dir_bh, "call ext4_handle_dirty_metadata");
 	if (!ent->dir_inlined) {
 		if (is_dx(ent->inode)) {
@@ -3464,7 +3522,7 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 	retval = ext4_journal_get_write_access(handle, ent->bh);
 	if (retval)
 		return retval;
-	set_ino(ent->dir, ent->de, ino);
+	set_ino(ent->dir, ent->de, ino, 0, NULL);
 	if (ext4_has_feature_filetype(ent->dir->i_sb))
 		ent->de->file_type = file_type;
 	ent->dir->i_version++;
@@ -3507,7 +3565,7 @@ static void ext4_rename_delete(handle_t *handle, struct ext4_renament *ent,
 			       int force_reread)
 {
 	int retval;
-	__u32 ino;
+	unsigned long ino;
 	/*
 	 * ent->de could have moved from under us during htree split, so make
 	 * sure that we are deleting the right entry.  We might also be pointing
@@ -3593,7 +3651,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		       unsigned int flags)
 {
 	handle_t *handle = NULL;
-	__u32 ino;
+	unsigned long ino;
 	struct ext4_renament old = {
 		.dir = old_dir,
 		.dentry = old_dentry,
@@ -3821,7 +3879,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	u8 new_file_type;
 	int retval;
 	struct timespec ctime;
-	__u32 ino;
+	unsigned long ino;
 
 	if ((ext4_encrypted_inode(old_dir) &&
 	     !fscrypt_has_encryption_key(old_dir)) ||
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 455cad8c29e1..8f81adda722f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3490,6 +3490,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto cantfind_ext4;
 	}
 
+	if (ext4_has_feature_inode64(sb) &&
+	    (sizeof(u64) != sizeof(unsigned long))) {
+		ext4_msg(sb, KERN_ERR, "64-bit inodes need 64 bit kernel.");
+		goto failed_mount;
+	}
+
 	/* Load the checksum driver */
 	if (ext4_has_feature_metadata_csum(sb) ||
 	    ext4_has_feature_ea_inode(sb)) {
-- 
2.14.3 (Apple Git-98)
