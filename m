From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v4 3/4] ext4: Add helper functions to access inode numbers
Date: Fri,  2 Feb 2018 12:41:35 +0300
Message-ID: <20180202094136.13032-4-artem.blagodarenko@gmail.com>
References: <20180202094136.13032-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36826 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbeBBJmc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Feb 2018 04:42:32 -0500
Received: by mail-lf0-f65.google.com with SMTP id t79so30543781lfe.3
        for <linux-ext4@vger.kernel.org>; Fri, 02 Feb 2018 01:42:31 -0800 (PST)
In-Reply-To: <20180202094136.13032-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

64-bit inodes counter uses extra fields to store hight part.
Let's incapsulate inode number reading and writing to extend
counter in next commits.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 fs/ext4/dir.c    |  4 +--
 fs/ext4/ext4.h   | 44 +++++++++++++++++++++++---------
 fs/ext4/ialloc.c | 12 ++++-----
 fs/ext4/namei.c  | 78 +++++++++++++++++++++++++++++++++++++++-----------------
 fs/ext4/resize.c |  8 +++---
 fs/ext4/super.c  | 45 ++++++++++++++++----------------
 6 files changed, 121 insertions(+), 70 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 02d6fd0d643e..49ddbbf1ed90 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -76,7 +76,7 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 	else if (unlikely(((char *) de - buf) + rlen > size))
 		error_msg = "directory entry across range";
 	else if (unlikely(le32_to_cpu(de->inode) >
-			le32_to_cpu(EXT4_SB(dir->i_sb)->s_es->s_inodes_count)))
+		 ext4_get_inodes_count(dir->i_sb)))
 		error_msg = "inode out of bounds";
 	else
 		return 0;
@@ -382,7 +382,7 @@ struct fname {
 	__u32		minor_hash;
 	struct rb_node	rb_hash;
 	struct fname	*next;
-	__u32		inode;
+	__u64		inode;
 	__u8		name_len;
 	__u8		file_type;
 	char		name[0];
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index aa02bd8cba0f..51aadb2c294b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1539,18 +1539,6 @@ static inline struct ext4_inode_info *EXT4_I(struct inode *inode)
 	return container_of(inode, struct ext4_inode_info, vfs_inode);
 }
 
-static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
-{
-	return ino == EXT4_ROOT_INO ||
-		ino == EXT4_USR_QUOTA_INO ||
-		ino == EXT4_GRP_QUOTA_INO ||
-		ino == EXT4_BOOT_LOADER_INO ||
-		ino == EXT4_JOURNAL_INO ||
-		ino == EXT4_RESIZE_INO ||
-		(ino >= EXT4_FIRST_INO(sb) &&
-		 ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
-}
-
 /*
  * Inode dynamic state flags
  */
@@ -2902,6 +2890,38 @@ static inline unsigned int ext4_flex_bg_size(struct ext4_sb_info *sbi)
 	return 1 << sbi->s_log_groups_per_flex;
 }
 
+#define EXT4_SB_VALUES(name) \
+static inline unsigned long ext4_get_##name(struct super_block *sb) \
+{ \
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es; \
+	unsigned long value = le32_to_cpu(es->s_##name); \
+	return value; \
+} \
+static inline void ext4_set_##name(struct super_block *sb,\
+					   unsigned long val)\
+{ \
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es; \
+	es->s_##name = cpu_to_le32(val); \
+}
+
+EXT4_SB_VALUES(inodes_count)
+EXT4_SB_VALUES(free_inodes_count)
+EXT4_SB_VALUES(last_orphan)
+EXT4_SB_VALUES(first_error_ino)
+EXT4_SB_VALUES(last_error_ino)
+
+static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
+{
+	return ino == EXT4_ROOT_INO ||
+		ino == EXT4_USR_QUOTA_INO ||
+		ino == EXT4_GRP_QUOTA_INO ||
+		ino == EXT4_BOOT_LOADER_INO ||
+		ino == EXT4_JOURNAL_INO ||
+		ino == EXT4_RESIZE_INO ||
+		(ino >= EXT4_FIRST_INO(sb) &&
+		 ino <= ext4_get_inodes_count(sb));
+}
+
 #define ext4_std_error(sb, errno)				\
 do {								\
 	if ((errno))						\
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index ee823022aa34..25dbc15e2ee1 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -303,7 +303,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	ext4_clear_inode(inode);
 
 	es = EXT4_SB(sb)->s_es;
-	if (ino < EXT4_FIRST_INO(sb) || ino > le32_to_cpu(es->s_inodes_count)) {
+	if (ino < EXT4_FIRST_INO(sb) || ino > ext4_get_inodes_count(sb)) {
 		ext4_error(sb, "reserved or nonexistent inode %lu", ino);
 		goto error_return;
 	}
@@ -887,7 +887,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	if (!goal)
 		goal = sbi->s_inode_goal;
 
-	if (goal && goal <= le32_to_cpu(sbi->s_es->s_inodes_count)) {
+	if (goal && goal <= ext4_get_inodes_count(sb)) {
 		group = (goal - 1) / EXT4_INODES_PER_GROUP(sb);
 		ino = (goal - 1) % EXT4_INODES_PER_GROUP(sb);
 		ret2 = 0;
@@ -1226,7 +1226,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 /* Verify that we are loading a valid orphan from disk */
 struct inode *ext4_orphan_get(struct super_block *sb, unsigned long ino)
 {
-	unsigned long max_ino = le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count);
+	unsigned long max_ino = ext4_get_inodes_count(sb);
 	ext4_group_t block_group;
 	int bit;
 	struct buffer_head *bitmap_bh = NULL;
@@ -1330,9 +1330,9 @@ unsigned long ext4_count_free_inodes(struct super_block *sb)
 		bitmap_count += x;
 	}
 	brelse(bitmap_bh);
-	printk(KERN_DEBUG "ext4_count_free_inodes: "
-	       "stored = %u, computed = %lu, %lu\n",
-	       le32_to_cpu(es->s_free_inodes_count), desc_count, bitmap_count);
+	printk(KERN_DEBUG "ext4_count_free_inodes:\n"
+	       "stored = %lu, computed = %lu, %lu\n",
+	       ext4_get_inodes_count(sb), desc_count, bitmap_count);
 	return desc_count;
 #else
 	desc_count = 0;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b6681aebe5cf..21f86c48708b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1543,6 +1543,23 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 	return bh;
 }
 
+static int get_ino(struct inode *dir,
+			     struct ext4_dir_entry_2 *de, __u32 *ino)
+{
+	struct super_block *sb = dir->i_sb;
+
+	*ino = le32_to_cpu(de->inode);
+	return 0;
+}
+
+static void set_ino(struct inode *dir,
+		    struct ext4_dir_entry_2 *de, unsigned long i_ino)
+{
+	struct super_block *sb = dir->i_sb;
+
+	de->inode = cpu_to_le32(i_ino);
+}
+
 static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 {
 	struct inode *inode;
@@ -1572,10 +1589,11 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 		return (struct dentry *) bh;
 	inode = NULL;
 	if (bh) {
-		__u32 ino = le32_to_cpu(de->inode);
+		__u32 ino;
+		int ret = get_ino(dir, de, &ino);
 
 		brelse(bh);
-		if (!ext4_valid_inum(dir->i_sb, ino)) {
+		if (ret || !ext4_valid_inum(dir->i_sb, ino)) {
 			EXT4_ERROR_INODE(dir, "bad inode number: %u", ino);
 			return ERR_PTR(-EFSCORRUPTED);
 		}
@@ -1611,16 +1629,17 @@ struct dentry *ext4_get_parent(struct dentry *child)
 	static const struct qstr dotdot = QSTR_INIT("..", 2);
 	struct ext4_dir_entry_2 * de;
 	struct buffer_head *bh;
+	int ret;
 
 	bh = ext4_find_entry(d_inode(child), &dotdot, &de, NULL);
 	if (IS_ERR(bh))
 		return (struct dentry *) bh;
 	if (!bh)
 		return ERR_PTR(-ENOENT);
-	ino = le32_to_cpu(de->inode);
+	ret = get_ino(d_inode(child), de, &ino);
 	brelse(bh);
 
-	if (!ext4_valid_inum(child->d_sb, ino)) {
+	if (ret || !ext4_valid_inum(child->d_sb, ino)) {
 		EXT4_ERROR_INODE(d_inode(child),
 				 "bad parent inode number: %u", ino);
 		return ERR_PTR(-EFSCORRUPTED);
@@ -1867,7 +1886,7 @@ void ext4_insert_dentry(struct inode *inode,
 		de = de1;
 	}
 	de->file_type = EXT4_FT_UNKNOWN;
-	de->inode = cpu_to_le32(inode->i_ino);
+	set_ino(inode, de, inode->i_ino);
 	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
 	de->name_len = fname_len(fname);
 	memcpy(de->name, fname_name(fname), fname_len(fname));
@@ -2617,7 +2636,7 @@ struct ext4_dir_entry_2 *ext4_init_dot_dotdot(struct inode *inode,
 			  int blocksize, int csum_size,
 			  unsigned int parent_ino, int dotdot_real_len)
 {
-	de->inode = cpu_to_le32(inode->i_ino);
+	set_ino(inode, de, inode->i_ino);
 	de->name_len = 1;
 	de->rec_len = ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de),
 					   blocksize);
@@ -2625,7 +2644,7 @@ struct ext4_dir_entry_2 *ext4_init_dot_dotdot(struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
 
 	de = ext4_next_entry(de, blocksize);
-	de->inode = cpu_to_le32(parent_ino);
+	set_ino(inode, de, parent_ino);
 	de->name_len = 2;
 	if (!dotdot_real_len)
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
@@ -2751,6 +2770,7 @@ bool ext4_empty_dir(struct inode *inode)
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de, *de1;
 	struct super_block *sb;
+	__u32 ino, ino2;
 
 	if (ext4_has_inline_data(inode)) {
 		int has_inline_data = 1;
@@ -2772,8 +2792,8 @@ bool ext4_empty_dir(struct inode *inode)
 
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
 	de1 = ext4_next_entry(de, sb->s_blocksize);
-	if (le32_to_cpu(de->inode) != inode->i_ino ||
-			le32_to_cpu(de1->inode) == 0 ||
+	if (get_ino(inode, de, &ino) || ino != inode->i_ino ||
+			get_ino(inode, de1, &ino2) || ino2 == 0 ||
 			strcmp(".", de->name) || strcmp("..", de1->name)) {
 		ext4_warning_inode(inode, "directory missing '.' and/or '..'");
 		brelse(bh);
@@ -2799,7 +2819,7 @@ bool ext4_empty_dir(struct inode *inode)
 			offset = (offset | (sb->s_blocksize - 1)) + 1;
 			continue;
 		}
-		if (le32_to_cpu(de->inode)) {
+		if (!get_ino(inode, de, &ino) && ino) {
 			brelse(bh);
 			return false;
 		}
@@ -2866,10 +2886,10 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	 * orphan list. If so skip on-disk list modification.
 	 */
 	if (!NEXT_ORPHAN(inode) || NEXT_ORPHAN(inode) >
-	    (le32_to_cpu(sbi->s_es->s_inodes_count))) {
+	    (ext4_get_inodes_count(sb))) {
 		/* Insert this inode at the head of the on-disk orphan list */
-		NEXT_ORPHAN(inode) = le32_to_cpu(sbi->s_es->s_last_orphan);
-		sbi->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
+		NEXT_ORPHAN(inode) = le64_to_cpu(ext4_get_last_orphan(sb));
+		ext4_set_last_orphan(sb, cpu_to_le64(inode->i_ino));
 		dirty = true;
 	}
 	list_add(&EXT4_I(inode)->i_orphan, &sbi->s_orphan);
@@ -2943,14 +2963,14 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 
 	ino_next = NEXT_ORPHAN(inode);
 	if (prev == &sbi->s_orphan) {
-		jbd_debug(4, "superblock will point to %u\n", ino_next);
+		jbd_debug(4, "superblock will point to %lu\n", ino_next);
 		BUFFER_TRACE(sbi->s_sbh, "get_write_access");
 		err = ext4_journal_get_write_access(handle, sbi->s_sbh);
 		if (err) {
 			mutex_unlock(&sbi->s_orphan_lock);
 			goto out_brelse;
 		}
-		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
+		ext4_set_last_orphan(inode->i_sb, cpu_to_le64(ino_next));
 		mutex_unlock(&sbi->s_orphan_lock);
 		err = ext4_handle_dirty_super(handle, inode->i_sb);
 	} else {
@@ -2989,6 +3009,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
 	handle_t *handle = NULL;
+	__u32 ino;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
 		return -EIO;
@@ -3012,7 +3033,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	inode = d_inode(dentry);
 
 	retval = -EFSCORRUPTED;
-	if (le32_to_cpu(de->inode) != inode->i_ino)
+	if (get_ino(dir, de, &ino) || ino != inode->i_ino)
 		goto end_rmdir;
 
 	retval = -ENOTEMPTY;
@@ -3065,6 +3086,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
 	handle_t *handle = NULL;
+	__u32 ino;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
 		return -EIO;
@@ -3089,7 +3111,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	inode = d_inode(dentry);
 
 	retval = -EFSCORRUPTED;
-	if (le32_to_cpu(de->inode) != inode->i_ino)
+	if (get_ino(dir, de, &ino) || ino != inode->i_ino)
 		goto end_unlink;
 
 	handle = ext4_journal_start(dir, EXT4_HT_DIR,
@@ -3392,13 +3414,15 @@ struct ext4_renament {
 static int ext4_rename_dir_prepare(handle_t *handle, struct ext4_renament *ent)
 {
 	int retval;
+	__u32 ino;
 
 	ent->dir_bh = ext4_get_first_dir_block(handle, ent->inode,
 					      &retval, &ent->parent_de,
 					      &ent->dir_inlined);
 	if (!ent->dir_bh)
 		return retval;
-	if (le32_to_cpu(ent->parent_de->inode) != ent->dir->i_ino)
+	if (get_ino(ent->dir, ent->parent_de, &ino) ||
+							ino != ent->dir->i_ino)
 		return -EFSCORRUPTED;
 	BUFFER_TRACE(ent->dir_bh, "get_write_access");
 	return ext4_journal_get_write_access(handle, ent->dir_bh);
@@ -3409,7 +3433,7 @@ static int ext4_rename_dir_finish(handle_t *handle, struct ext4_renament *ent,
 {
 	int retval;
 
-	ent->parent_de->inode = cpu_to_le32(dir_ino);
+	set_ino(ent->dir, ent->parent_de, dir_ino);
 	BUFFER_TRACE(ent->dir_bh, "call ext4_handle_dirty_metadata");
 	if (!ent->dir_inlined) {
 		if (is_dx(ent->inode)) {
@@ -3440,7 +3464,7 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 	retval = ext4_journal_get_write_access(handle, ent->bh);
 	if (retval)
 		return retval;
-	ent->de->inode = cpu_to_le32(ino);
+	set_ino(ent->dir, ent->de, ino);
 	if (ext4_has_feature_filetype(ent->dir->i_sb))
 		ent->de->file_type = file_type;
 	ent->dir->i_version++;
@@ -3483,13 +3507,14 @@ static void ext4_rename_delete(handle_t *handle, struct ext4_renament *ent,
 			       int force_reread)
 {
 	int retval;
+	__u32 ino;
 	/*
 	 * ent->de could have moved from under us during htree split, so make
 	 * sure that we are deleting the right entry.  We might also be pointing
 	 * to a stale entry in the unused part of ent->bh so just checking inum
 	 * and the name isn't enough.
 	 */
-	if (le32_to_cpu(ent->de->inode) != ent->inode->i_ino ||
+	if (get_ino(ent->dir, ent->de, &ino) || ino != ent->inode->i_ino ||
 	    ent->de->name_len != ent->dentry->d_name.len ||
 	    strncmp(ent->de->name, ent->dentry->d_name.name,
 		    ent->de->name_len) ||
@@ -3568,6 +3593,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		       unsigned int flags)
 {
 	handle_t *handle = NULL;
+	__u32 ino;
 	struct ext4_renament old = {
 		.dir = old_dir,
 		.dentry = old_dentry,
@@ -3620,7 +3646,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 *  same name. Goodbye sticky bit ;-<
 	 */
 	retval = -ENOENT;
-	if (!old.bh || le32_to_cpu(old.de->inode) != old.inode->i_ino)
+	if (!old.bh || get_ino(old.dir, old.de, &ino) ||
+						ino != old.inode->i_ino)
 		goto end_rename;
 
 	if ((old.dir != new.dir) &&
@@ -3794,6 +3821,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	u8 new_file_type;
 	int retval;
 	struct timespec ctime;
+	__u32 ino;
 
 	if ((ext4_encrypted_inode(old_dir) &&
 	     !fscrypt_has_encryption_key(old_dir)) ||
@@ -3834,7 +3862,8 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 *  same name. Goodbye sticky bit ;-<
 	 */
 	retval = -ENOENT;
-	if (!old.bh || le32_to_cpu(old.de->inode) != old.inode->i_ino)
+	if (!old.bh || get_ino(old.dir, old.de, &ino) ||
+						ino != old.inode->i_ino)
 		goto end_rename;
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
@@ -3846,7 +3875,8 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 
 	/* RENAME_EXCHANGE case: old *and* new must both exist */
-	if (!new.bh || le32_to_cpu(new.de->inode) != new.inode->i_ino)
+	if (!new.bh || get_ino(new.dir, new.de, &ino) ||
+						ino != new.inode->i_ino)
 		goto end_rename;
 
 	handle = ext4_journal_start(old.dir, EXT4_HT_DIR,
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 035cd3f4785e..d0d5acd1a70d 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1337,10 +1337,10 @@ static void ext4_update_super(struct super_block *sb,
 
 	ext4_blocks_count_set(es, ext4_blocks_count(es) + blocks_count);
 	ext4_free_blocks_count_set(es, ext4_free_blocks_count(es) + free_blocks);
-	le32_add_cpu(&es->s_inodes_count, EXT4_INODES_PER_GROUP(sb) *
-		     flex_gd->count);
-	le32_add_cpu(&es->s_free_inodes_count, EXT4_INODES_PER_GROUP(sb) *
-		     flex_gd->count);
+	ext4_set_inodes_count(sb, ext4_get_inodes_count(sb) +
+			      EXT4_INODES_PER_GROUP(sb) * flex_gd->count);
+	ext4_set_free_inodes_count(sb, ext4_get_free_inodes_count(sb) +
+			EXT4_INODES_PER_GROUP(sb) * flex_gd->count);
 
 	ext4_debug("free blocks count %llu", ext4_free_blocks_count(es));
 	/*
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ead9406d9cff..455cad8c29e1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -330,7 +330,7 @@ static void __save_error_info(struct super_block *sb, const char *func,
 		strncpy(es->s_first_error_func, func,
 			sizeof(es->s_first_error_func));
 		es->s_first_error_line = cpu_to_le32(line);
-		es->s_first_error_ino = es->s_last_error_ino;
+		ext4_set_first_error_ino(sb, ext4_get_last_error_ino(sb));
 		es->s_first_error_block = es->s_last_error_block;
 	}
 	/*
@@ -470,7 +470,7 @@ void __ext4_error_inode(struct inode *inode, const char *function,
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
 		return;
 
-	es->s_last_error_ino = cpu_to_le32(inode->i_ino);
+	ext4_set_last_error_ino(inode->i_sb, cpu_to_le64(inode->i_ino));
 	es->s_last_error_block = cpu_to_le64(block);
 	if (ext4_error_ratelimit(inode->i_sb)) {
 		va_start(args, fmt);
@@ -506,7 +506,7 @@ void __ext4_error_file(struct file *file, const char *function,
 		return;
 
 	es = EXT4_SB(inode->i_sb)->s_es;
-	es->s_last_error_ino = cpu_to_le32(inode->i_ino);
+	ext4_set_last_error_ino(inode->i_sb, cpu_to_le64(inode->i_ino));
 	if (ext4_error_ratelimit(inode->i_sb)) {
 		path = file_path(file, pathname, sizeof(pathname));
 		if (IS_ERR(path))
@@ -717,7 +717,7 @@ __acquires(bitlock)
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(sb))))
 		return;
 
-	es->s_last_error_ino = cpu_to_le32(ino);
+	ext4_set_last_error_ino(sb, cpu_to_le64(ino));
 	es->s_last_error_block = cpu_to_le64(block);
 	__save_error_info(sb, function, line);
 
@@ -829,8 +829,8 @@ static void dump_orphan_list(struct super_block *sb, struct ext4_sb_info *sbi)
 {
 	struct list_head *l;
 
-	ext4_msg(sb, KERN_ERR, "sb orphan head is %d",
-		 le32_to_cpu(sbi->s_es->s_last_orphan));
+	ext4_msg(sb, KERN_ERR, "sb orphan head is %llu",
+		 le64_to_cpu(ext4_get_last_orphan(sb)));
 
 	printk(KERN_ERR "sb_info orphan list:\n");
 	list_for_each(l, &sbi->s_orphan) {
@@ -2408,7 +2408,7 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 	int quota_update = 0;
 	int i;
 #endif
-	if (!es->s_last_orphan) {
+	if (!ext4_get_last_orphan(sb)) {
 		jbd_debug(4, "no orphan inodes to clean up\n");
 		return;
 	}
@@ -2428,10 +2428,10 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 
 	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
 		/* don't clear list on RO mount w/ errors */
-		if (es->s_last_orphan && !(s_flags & MS_RDONLY)) {
+		if (ext4_get_last_orphan(sb) && !(s_flags & MS_RDONLY)) {
 			ext4_msg(sb, KERN_INFO, "Errors on filesystem, "
 				  "clearing orphan list.\n");
-			es->s_last_orphan = 0;
+			ext4_set_last_orphan(sb, 0);
 		}
 		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
 		return;
@@ -2474,7 +2474,7 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 	}
 #endif
 
-	while (es->s_last_orphan) {
+	while (ext4_get_last_orphan(sb)) {
 		struct inode *inode;
 
 		/*
@@ -2483,11 +2483,12 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 		 */
 		if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
 			jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
-			es->s_last_orphan = 0;
+			ext4_set_last_orphan(sb, 0);
 			break;
 		}
 
-		inode = ext4_orphan_get(sb, le32_to_cpu(es->s_last_orphan));
+		inode = ext4_orphan_get(sb,
+					le64_to_cpu(ext4_get_last_orphan(sb)));
 		if (IS_ERR(inode)) {
 			es->s_last_orphan = 0;
 			break;
@@ -2811,9 +2812,9 @@ static void print_daily_error_info(unsigned long arg)
 		       (int) sizeof(es->s_first_error_func),
 		       es->s_first_error_func,
 		       le32_to_cpu(es->s_first_error_line));
-		if (es->s_first_error_ino)
-			printk(KERN_CONT ": inode %u",
-			       le32_to_cpu(es->s_first_error_ino));
+		if (ext4_get_first_error_ino(sb))
+			printk(KERN_CONT ": inode %llu",
+			       le64_to_cpu(ext4_get_first_error_ino(sb)));
 		if (es->s_first_error_block)
 			printk(KERN_CONT ": block %llu", (unsigned long long)
 			       le64_to_cpu(es->s_first_error_block));
@@ -2825,9 +2826,9 @@ static void print_daily_error_info(unsigned long arg)
 		       (int) sizeof(es->s_last_error_func),
 		       es->s_last_error_func,
 		       le32_to_cpu(es->s_last_error_line));
-		if (es->s_last_error_ino)
-			printk(KERN_CONT ": inode %u",
-			       le32_to_cpu(es->s_last_error_ino));
+		if (ext4_get_last_error_ino(sb))
+			printk(KERN_CONT ": inode %llu",
+			       le64_to_cpu(ext4_get_last_error_ino(sb)));
 		if (es->s_last_error_block)
 			printk(KERN_CONT ": block %llu", (unsigned long long)
 			       le64_to_cpu(es->s_last_error_block));
@@ -4248,7 +4249,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				  GFP_KERNEL);
 	if (!err) {
 		unsigned long freei = ext4_count_free_inodes(sb);
-		sbi->s_es->s_free_inodes_count = cpu_to_le32(freei);
+		ext4_set_free_inodes_count(sb, freei);
 		err = percpu_counter_init(&sbi->s_freeinodes_counter, freei,
 					  GFP_KERNEL);
 	}
@@ -4705,9 +4706,9 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 			EXT4_C2B(EXT4_SB(sb), percpu_counter_sum_positive(
 				&EXT4_SB(sb)->s_freeclusters_counter)));
 	if (percpu_counter_initialized(&EXT4_SB(sb)->s_freeinodes_counter))
-		es->s_free_inodes_count =
-			cpu_to_le32(percpu_counter_sum_positive(
-				&EXT4_SB(sb)->s_freeinodes_counter));
+		ext4_set_free_inodes_count(sb,
+				cpu_to_le32(percpu_counter_sum_positive(
+				&EXT4_SB(sb)->s_freeinodes_counter)));
 	BUFFER_TRACE(sbh, "marking dirty");
 	ext4_superblock_csum_set(sb);
 	if (sync)
-- 
2.14.3 (Apple Git-98)
