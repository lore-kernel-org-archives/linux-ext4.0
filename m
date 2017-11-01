From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v2 1/2] ext4: dirdata feature
Date: Thu,  2 Nov 2017 00:24:54 +0300
Message-ID: <20171101212455.47964-2-artem.blagodarenko@gmail.com>
References: <20171101212455.47964-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca, Andreas Dilger <andreas.dilger@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:43187 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933705AbdKAVZE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Nov 2017 17:25:04 -0400
Received: by mail-lf0-f67.google.com with SMTP id a16so4084093lfk.0
        for <linux-ext4@vger.kernel.org>; Wed, 01 Nov 2017 14:25:03 -0700 (PDT)
In-Reply-To: <20171101212455.47964-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andreas Dilger <andreas.dilger@intel.com>

This patch implements feature which allows ext4 fs users (e.g. Lustre)
to store data in ext4 dirent. Data is stored in ext4 dirent after
file-name, this space is accounted in de->rec_len.
Flag EXT4_DIRENT_LUFID added to d_type if extra data
is present.

Make use of dentry->d_fsdata to pass fid to ext4. so no
changes in ext4_add_entry() interface required.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 fs/ext4/dir.c    |  17 +++++---
 fs/ext4/ext4.h   |  85 ++++++++++++++++++++++++++++++++++---
 fs/ext4/inline.c |  18 ++++----
 fs/ext4/namei.c  | 126 ++++++++++++++++++++++++++++++++++++++++++-------------
 fs/ext4/super.c  |   3 +-
 5 files changed, 200 insertions(+), 49 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index b04e882179c6..46fcb8ec47a6 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -67,11 +67,11 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 	const int rlen = ext4_rec_len_from_disk(de->rec_len,
 						dir->i_sb->s_blocksize);
 
-	if (unlikely(rlen < EXT4_DIR_REC_LEN(1)))
+	if (unlikely(rlen < __EXT4_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
 	else if (unlikely(rlen % 4 != 0))
 		error_msg = "rec_len % 4 != 0";
-	else if (unlikely(rlen < EXT4_DIR_REC_LEN(de->name_len)))
+	else if (unlikely(rlen < EXT4_DIR_REC_LEN(de)))
 		error_msg = "rec_len is too small for name_len";
 	else if (unlikely(((char *) de - buf) + rlen > size))
 		error_msg = "directory entry across range";
@@ -218,7 +218,8 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 				 * failure will be detected in the
 				 * dirent test below. */
 				if (ext4_rec_len_from_disk(de->rec_len,
-					sb->s_blocksize) < EXT4_DIR_REC_LEN(1))
+						sb->s_blocksize) <
+						__EXT4_DIR_REC_LEN(1))
 					break;
 				i += ext4_rec_len_from_disk(de->rec_len,
 							    sb->s_blocksize);
@@ -441,12 +442,18 @@ int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
 	struct fname *fname, *new_fn;
 	struct dir_private_info *info;
 	int len;
+	int extra_data = 0;
 
 	info = dir_file->private_data;
 	p = &info->root.rb_node;
 
 	/* Create and allocate the fname structure */
-	len = sizeof(struct fname) + ent_name->len + 1;
+	if (dirent->file_type & ~EXT4_FT_MASK)
+		extra_data = ext4_get_dirent_data_len(dirent);
+
+	len = sizeof(struct fname) + dirent->name_len + extra_data + 1;
+
+
 	new_fn = kzalloc(len, GFP_KERNEL);
 	if (!new_fn)
 		return -ENOMEM;
@@ -455,7 +462,7 @@ int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
 	new_fn->inode = le32_to_cpu(dirent->inode);
 	new_fn->name_len = ent_name->len;
 	new_fn->file_type = dirent->file_type;
-	memcpy(new_fn->name, ent_name->name, ent_name->len);
+	memcpy(new_fn->name, ent_name->name, ent_name->len + extra_data);
 	new_fn->name[ent_name->len] = 0;
 
 	while (*p) {
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e2abe01c8c6b..9a9b01b0956a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1111,6 +1111,7 @@ struct ext4_inode_info {
  * Mount flags set via mount options or defaults
  */
 #define EXT4_MOUNT_NO_MBCACHE		0x00001 /* Do not use mbcache */
+#define EXT4_MOUNT_DIRDATA		0x00002 /* Data in directory entries*/
 #define EXT4_MOUNT_GRPID		0x00004	/* Create files with directory's group */
 #define EXT4_MOUNT_DEBUG		0x00008	/* Some debugging messages */
 #define EXT4_MOUNT_ERRORS_CONT		0x00010	/* Continue on errors */
@@ -1804,7 +1805,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
 					 EXT4_FEATURE_INCOMPAT_CSUM_SEED | \
-					 EXT4_FEATURE_INCOMPAT_LARGEDIR)
+					 EXT4_FEATURE_INCOMPAT_LARGEDIR | \
+					 EXT4_FEATURE_INCOMPAT_DIRDATA)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
@@ -1965,6 +1967,45 @@ struct ext4_dir_entry_tail {
 
 #define EXT4_FT_DIR_CSUM	0xDE
 
+#define EXT4_FT_MASK		0xf
+
+#if EXT4_FT_MAX > EXT4_FT_MASK
+#error "conflicting EXT4_FT_MAX and EXT4_FT_MASK"
+#endif
+
+/*
+ * d_type has 4 unused bits, so it can hold four types data. these different
+ * type of data (e.g. lustre data, high 32 bits of 64-bit inode number) can be
+ * stored, in flag order, after file-name in ext4 dirent.
+ */
+/*
+ * this flag is added to d_type if ext4 dirent has extra data after
+ * filename. this data length is variable and length is stored in first byte
+ * of data. data start after filename NUL byte.
+ * This is used by Lustre FS.
+ */
+#define EXT4_DIRENT_LUFID		0x10
+#define EXT4_DIRENT_INODE		0x20
+#define DIRENT_INODE_LEN		2
+
+#define EXT4_LUFID_MAGIC    0xAD200907UL
+struct ext4_dentry_param {
+	__u32  edp_magic;	/* EXT4_LUFID_MAGIC */
+	char   edp_len;		/* size of edp_data in bytes */
+	char   edp_data[0];	/* packed array of data */
+} __packed;
+
+static inline unsigned char *ext4_dentry_get_data(struct super_block *sb,
+		struct ext4_dentry_param *p)
+{
+	if (!ext4_has_feature_dirdata(sb))
+		return NULL;
+	if (p && p->edp_magic == EXT4_LUFID_MAGIC)
+		return &p->edp_len;
+	else
+		return NULL;
+}
+
 /*
  * EXT4_DIR_PAD defines the directory entries boundaries
  *
@@ -1972,8 +2013,11 @@ struct ext4_dir_entry_tail {
  */
 #define EXT4_DIR_PAD			4
 #define EXT4_DIR_ROUND			(EXT4_DIR_PAD - 1)
-#define EXT4_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXT4_DIR_ROUND) & \
+#define __EXT4_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXT4_DIR_ROUND) & \
 					 ~EXT4_DIR_ROUND)
+#define EXT4_DIR_REC_LEN(de)		(__EXT4_DIR_REC_LEN(de->name_len +\
+					ext4_get_dirent_data_len(de)))
+
 #define EXT4_MAX_REC_LEN		((1<<16)-1)
 
 /*
@@ -2376,7 +2420,10 @@ extern int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 			     struct buffer_head *bh,
 			     void *buf, int buf_size,
 			     struct ext4_filename *fname,
-			     struct ext4_dir_entry_2 **dest_de);
+			     struct ext4_dir_entry_2 **dest_de,
+			     bool is_dotdot,
+			     bool *write_short_dotdot,
+			     unsigned short dotdot_reclen);
 void ext4_insert_dentry(struct inode *inode,
 			struct ext4_dir_entry_2 *de,
 			int buf_size,
@@ -2392,10 +2439,16 @@ static const unsigned char ext4_filetype_table[] = {
 
 static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
 {
-	if (!ext4_has_feature_filetype(sb) || filetype >= EXT4_FT_MAX)
+	int fl_index = filetype & EXT4_FT_MASK;
+
+	if (!ext4_has_feature_filetype(sb) || fl_index >= EXT4_FT_MAX)
 		return DT_UNKNOWN;
 
-	return ext4_filetype_table[filetype];
+	if (!test_opt(sb, DIRDATA))
+		return (ext4_filetype_table[fl_index]);
+
+	return (ext4_filetype_table[fl_index]) |
+		(filetype & ~EXT4_FT_MASK);
 }
 extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size);
@@ -3271,6 +3324,28 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 
 extern const struct iomap_ops ext4_iomap_ops;
 
+/*
+ * Compute the total directory entry data length.
+ * This includes the filename and an implicit NUL terminator (always present),
+ * and optional extensions.  Each extension has a bit set in the high 4 bits of
+ * de->file_type, and the extension length is the first byte in each entry.
+ */
+static inline int ext4_get_dirent_data_len(struct ext4_dir_entry_2 *de)
+{
+	char *len = de->name + de->name_len + 1 /* NUL terminator */;
+	int dlen = 0;
+	__u8 extra_data_flags = (de->file_type & ~EXT4_FT_MASK) >> 4;
+
+	while (extra_data_flags) {
+		if (extra_data_flags & 1) {
+			dlen += *len + (dlen == 0);
+			len += *len;
+		}
+		extra_data_flags >>= 1;
+	}
+	return dlen;
+}
+
 #endif	/* __KERNEL__ */
 
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 28c5c3abddb3..ea46735e18c6 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1026,7 +1026,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 	struct ext4_dir_entry_2 *de;
 
 	err = ext4_find_dest_de(dir, inode, iloc->bh, inline_start,
-				inline_size, fname, &de);
+				inline_size, fname, &de, 0, NULL, 0);
 	if (err)
 		return err;
 
@@ -1103,7 +1103,7 @@ static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
 	int old_size = EXT4_I(dir)->i_inline_size - EXT4_MIN_INLINE_DATA_SIZE;
 	int new_size = get_max_inline_xattr_value_size(dir, iloc);
 
-	if (new_size - old_size <= EXT4_DIR_REC_LEN(1))
+	if (new_size - old_size <= __EXT4_DIR_REC_LEN(1))
 		return -ENOSPC;
 
 	ret = ext4_update_inline_data(handle, dir,
@@ -1384,8 +1384,8 @@ int htree_inlinedir_to_tree(struct file *dir_file,
 			fake.name_len = 1;
 			strcpy(fake.name, ".");
 			fake.rec_len = ext4_rec_len_to_disk(
-						EXT4_DIR_REC_LEN(fake.name_len),
-						inline_size);
+					__EXT4_DIR_REC_LEN(fake.name_len),
+					inline_size);
 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
 			de = &fake;
 			pos = EXT4_INLINE_DOTDOT_OFFSET;
@@ -1394,8 +1394,8 @@ int htree_inlinedir_to_tree(struct file *dir_file,
 			fake.name_len = 2;
 			strcpy(fake.name, "..");
 			fake.rec_len = ext4_rec_len_to_disk(
-						EXT4_DIR_REC_LEN(fake.name_len),
-						inline_size);
+					__EXT4_DIR_REC_LEN(fake.name_len),
+					inline_size);
 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
 			de = &fake;
 			pos = EXT4_INLINE_DOTDOT_SIZE;
@@ -1492,8 +1492,8 @@ int ext4_read_inline_dir(struct file *file,
 	 * So we will use extra_offset and extra_size to indicate them
 	 * during the inline dir iteration.
 	 */
-	dotdot_offset = EXT4_DIR_REC_LEN(1);
-	dotdot_size = dotdot_offset + EXT4_DIR_REC_LEN(2);
+	dotdot_offset = __EXT4_DIR_REC_LEN(1);
+	dotdot_size = dotdot_offset + __EXT4_DIR_REC_LEN(2);
 	extra_offset = dotdot_size - EXT4_INLINE_DOTDOT_SIZE;
 	extra_size = extra_offset + inline_size;
 
@@ -1528,7 +1528,7 @@ int ext4_read_inline_dir(struct file *file,
 			 * failure will be detected in the
 			 * dirent test below. */
 			if (ext4_rec_len_from_disk(de->rec_len, extra_size)
-				< EXT4_DIR_REC_LEN(1))
+				< __EXT4_DIR_REC_LEN(1))
 				break;
 			i += ext4_rec_len_from_disk(de->rec_len,
 						    extra_size);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c1cf020d1889..b09e73100e14 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -249,7 +249,8 @@ static unsigned dx_get_count(struct dx_entry *entries);
 static unsigned dx_get_limit(struct dx_entry *entries);
 static void dx_set_count(struct dx_entry *entries, unsigned value);
 static void dx_set_limit(struct dx_entry *entries, unsigned value);
-static unsigned dx_root_limit(struct inode *dir, unsigned infosize);
+static inline unsigned int dx_root_limit(struct inode *dir,
+		struct ext4_dir_entry_2 *dot_de, unsigned int infosize);
 static unsigned dx_node_limit(struct inode *dir);
 static struct dx_frame *dx_probe(struct ext4_filename *fname,
 				 struct inode *dir,
@@ -551,10 +552,16 @@ static inline void dx_set_limit(struct dx_entry *entries, unsigned value)
 	((struct dx_countlimit *) entries)->limit = cpu_to_le16(value);
 }
 
-static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
+static inline unsigned int dx_root_limit(struct inode *dir,
+		struct ext4_dir_entry_2 *dot_de, unsigned int infosize)
 {
-	unsigned entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(1) -
-		EXT4_DIR_REC_LEN(2) - infosize;
+	struct ext4_dir_entry_2 *dotdot_de;
+	unsigned int entry_space;
+
+	BUG_ON(dot_de->name_len != 1);
+	dotdot_de = ext4_next_entry(dot_de, dir->i_sb->s_blocksize);
+	entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(dot_de) -
+			 EXT4_DIR_REC_LEN(dotdot_de) - infosize;
 
 	if (ext4_has_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -563,7 +570,8 @@ static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
 
 static inline unsigned dx_node_limit(struct inode *dir)
 {
-	unsigned entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(0);
+	unsigned int entry_space = dir->i_sb->s_blocksize -
+					__EXT4_DIR_REC_LEN(0);
 
 	if (ext4_has_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -675,7 +683,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 				       (unsigned) ((char *) de - base));
 #endif
 			}
-			space += EXT4_DIR_REC_LEN(de->name_len);
+			space += EXT4_DIR_REC_LEN(de);
 			names++;
 		}
 		de = ext4_next_entry(de, size);
@@ -785,10 +793,14 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 				      root->info.info_length);
 
 	if (dx_get_limit(entries) != dx_root_limit(dir,
-						   root->info.info_length)) {
+				(struct ext4_dir_entry_2 *) frame->bh->b_data,
+				root->info.info_length)) {
 		ext4_warning_inode(dir, "dx entry: limit %u != root limit %u",
 				   dx_get_limit(entries),
-				   dx_root_limit(dir, root->info.info_length));
+				   dx_root_limit(dir,
+						 (struct ext4_dir_entry_2 *)
+						 frame->bh->b_data,
+						 root->info.info_length));
 		goto fail;
 	}
 
@@ -980,7 +992,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
 	top = (struct ext4_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
-					   EXT4_DIR_REC_LEN(0));
+					   __EXT4_DIR_REC_LEN(0));
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 	/* Check if the directory is encrypted */
 	if (ext4_encrypted_inode(dir)) {
@@ -1563,6 +1575,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 	inode = NULL;
 	if (bh) {
 		__u32 ino = le32_to_cpu(de->inode);
+
 		brelse(bh);
 		if (!ext4_valid_inum(dir->i_sb, ino)) {
 			EXT4_ERROR_INODE(dir, "bad inode number: %u", ino);
@@ -1631,7 +1644,7 @@ dx_move_dirents(char *from, char *to, struct dx_map_entry *map, int count,
 	while (count--) {
 		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)
 						(from + (map->offs<<2));
-		rec_len = EXT4_DIR_REC_LEN(de->name_len);
+		rec_len = EXT4_DIR_REC_LEN(de);
 		memcpy (to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
 				ext4_rec_len_to_disk(rec_len, blocksize);
@@ -1655,7 +1668,7 @@ static struct ext4_dir_entry_2* dx_pack_dirents(char *base, unsigned blocksize)
 	while ((char*)de < base + blocksize) {
 		next = ext4_next_entry(de, blocksize);
 		if (de->inode && de->name_len) {
-			rec_len = EXT4_DIR_REC_LEN(de->name_len);
+			rec_len = EXT4_DIR_REC_LEN(de);
 			if (de > to)
 				memmove(to, de, rec_len);
 			to->rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
@@ -1786,10 +1799,13 @@ int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 		      struct buffer_head *bh,
 		      void *buf, int buf_size,
 		      struct ext4_filename *fname,
-		      struct ext4_dir_entry_2 **dest_de)
+		      struct ext4_dir_entry_2 **dest_de,
+		      bool is_dotdot,
+		      bool *write_short_dotdot,
+		      unsigned short dotdot_reclen)
 {
 	struct ext4_dir_entry_2 *de;
-	unsigned short reclen = EXT4_DIR_REC_LEN(fname_len(fname));
+	unsigned short reclen = __EXT4_DIR_REC_LEN(fname_len(fname));
 	int nlen, rlen;
 	unsigned int offset = 0;
 	char *top;
@@ -1802,10 +1818,28 @@ int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 			return -EFSCORRUPTED;
 		if (ext4_match(fname, de))
 			return -EEXIST;
-		nlen = EXT4_DIR_REC_LEN(de->name_len);
+		nlen = EXT4_DIR_REC_LEN(de);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
+		/* Check first for enough space for the full entry */
 		if ((de->inode ? rlen - nlen : rlen) >= reclen)
 			break;
+		/* Then for dotdot entries, check for the smaller space
+		 * required for just the entry, no FID
+		 */
+		if (is_dotdot) {
+			if ((de->inode ? rlen - nlen : rlen) >=
+			    dotdot_reclen) {
+				*write_short_dotdot = true;
+				break;
+			}
+			/* The new ".." entry mut be written over the
+			 * previous ".." entry, which is the first
+			 * entry traversed by this scan.  If it doesn't
+			 * fit, something is badly wrong, so -EIO.
+			 */
+			return -EIO;
+		}
+
 		de = (struct ext4_dir_entry_2 *)((char *)de + rlen);
 		offset += rlen;
 	}
@@ -1824,7 +1858,8 @@ void ext4_insert_dentry(struct inode *inode,
 
 	int nlen, rlen;
 
-	nlen = EXT4_DIR_REC_LEN(de->name_len);
+	nlen = EXT4_DIR_REC_LEN(de);
+
 	rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 	if (de->inode) {
 		struct ext4_dir_entry_2 *de1 =
@@ -1848,21 +1883,46 @@ void ext4_insert_dentry(struct inode *inode,
  * space.  It will return -ENOSPC if no space is available, and -EIO
  * and -EEXIST if directory entry already exists.
  */
-static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
+static int add_dirent_to_buf(handle_t *handle,
+			     struct dentry *dentry,
+			     struct ext4_filename *fname,
 			     struct inode *dir,
 			     struct inode *inode, struct ext4_dir_entry_2 *de,
 			     struct buffer_head *bh)
 {
 	unsigned int	blocksize = dir->i_sb->s_blocksize;
 	int		csum_size = 0;
-	int		err;
+	unsigned short	reclen, dotdot_reclen = 0;
+	int		 err, dlen = 0;
+	bool		is_dotdot = false, write_short_dotdot = false;
+	unsigned char	*data;
+	int namelen = dentry->d_name.len;
 
 	if (ext4_has_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
+	data = ext4_dentry_get_data(inode->i_sb, (struct ext4_dentry_param *)
+						dentry->d_fsdata);
+	if (data)
+		dlen = (*data) + 1;
+
+	is_dotdot = (namelen == 2 &&
+		     memcmp(dentry->d_name.name, "..", 2) == 0);
+
+	/* dotdot entries must be in the second place in a directory block,
+	 * so calculate an alternate length without the dirdata so they can
+	 * always be made to fit in the existing slot
+	 */
+	if (is_dotdot)
+		dotdot_reclen = __EXT4_DIR_REC_LEN(namelen);
+
+	reclen = __EXT4_DIR_REC_LEN(namelen + dlen + 3);
+
 	if (!de) {
 		err = ext4_find_dest_de(dir, inode, bh, bh->b_data,
-					blocksize - csum_size, fname, &de);
+					blocksize - csum_size, fname, &de,
+					is_dotdot,
+					&write_short_dotdot, dotdot_reclen);
 		if (err)
 			return err;
 	}
@@ -1876,6 +1936,13 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	/* By now the buffer is marked for journaling */
 	ext4_insert_dentry(inode, de, blocksize, fname);
 
+	/* If we're writing short form of "dotdot", don't add data section */
+	if (data && !write_short_dotdot) {
+		de->name[namelen] = 0;
+		memcpy(&de->name[namelen + 1], data, *(char *)data);
+		de->file_type |= EXT4_DIRENT_LUFID;
+	}
+
 	/*
 	 * XXX shouldn't update any times until successful
 	 * completion of syscall, but too many callers depend
@@ -1970,7 +2037,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 
 	/* Initialize the root; the dot dirents already exist */
 	de = (struct ext4_dir_entry_2 *) (&root->dotdot);
-	de->rec_len = ext4_rec_len_to_disk(blocksize - EXT4_DIR_REC_LEN(2),
+	de->rec_len = ext4_rec_len_to_disk(blocksize - __EXT4_DIR_REC_LEN(2),
 					   blocksize);
 	memset (&root->info, 0, sizeof(root->info));
 	root->info.info_length = sizeof(root->info);
@@ -1978,7 +2045,8 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 	entries = root->entries;
 	dx_set_block(entries, 1);
 	dx_set_count(entries, 1);
-	dx_set_limit(entries, dx_root_limit(dir, sizeof(root->info)));
+	dx_set_limit(entries, dx_root_limit(dir,
+					 fde, sizeof(root->info)));
 
 	/* Initialize as for dx_probe */
 	fname->hinfo.hash_version = root->info.hash_version;
@@ -2006,7 +2074,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 		goto out_frames;
 	}
 
-	retval = add_dirent_to_buf(handle, fname, dir, inode, de, bh2);
+	retval = add_dirent_to_buf(handle, NULL, fname, dir, inode, de, bh2);
 out_frames:
 	/*
 	 * Even if the block split failed, we have to properly write
@@ -2083,7 +2151,7 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 			bh = NULL;
 			goto out;
 		}
-		retval = add_dirent_to_buf(handle, &fname, dir, inode,
+		retval = add_dirent_to_buf(handle, dentry, &fname, dir, inode,
 					   NULL, bh);
 		if (retval != -ENOSPC)
 			goto out;
@@ -2112,7 +2180,7 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 		initialize_dirent_tail(t, blocksize);
 	}
 
-	retval = add_dirent_to_buf(handle, &fname, dir, inode, de, bh);
+	retval = add_dirent_to_buf(handle, dentry, &fname, dir, inode, de, bh);
 out:
 	ext4_fname_free_filename(&fname);
 	brelse(bh);
@@ -2154,7 +2222,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 	if (err)
 		goto journal_error;
 
-	err = add_dirent_to_buf(handle, fname, dir, inode, NULL, bh);
+	err = add_dirent_to_buf(handle, NULL, fname, dir, inode, NULL, bh);
 	if (err != -ENOSPC)
 		goto cleanup;
 
@@ -2279,7 +2347,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 		err = PTR_ERR(de);
 		goto cleanup;
 	}
-	err = add_dirent_to_buf(handle, fname, dir, inode, de, bh);
+	err = add_dirent_to_buf(handle, NULL, fname, dir, inode, de, bh);
 	goto cleanup;
 
 journal_error:
@@ -2545,7 +2613,7 @@ struct ext4_dir_entry_2 *ext4_init_dot_dotdot(struct inode *inode,
 {
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
-	de->rec_len = ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de->name_len),
+	de->rec_len = ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de),
 					   blocksize);
 	strcpy(de->name, ".");
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
@@ -2555,11 +2623,11 @@ struct ext4_dir_entry_2 *ext4_init_dot_dotdot(struct inode *inode,
 	de->name_len = 2;
 	if (!dotdot_real_len)
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
-					(csum_size + EXT4_DIR_REC_LEN(1)),
+					(csum_size + __EXT4_DIR_REC_LEN(1)),
 					blocksize);
 	else
 		de->rec_len = ext4_rec_len_to_disk(
-				EXT4_DIR_REC_LEN(de->name_len), blocksize);
+				EXT4_DIR_REC_LEN(de), blocksize);
 	strcpy(de->name, "..");
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
 
@@ -2688,7 +2756,7 @@ bool ext4_empty_dir(struct inode *inode)
 	}
 
 	sb = inode->i_sb;
-	if (inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2)) {
+	if (inode->i_size < __EXT4_DIR_REC_LEN(1) + __EXT4_DIR_REC_LEN(2)) {
 		EXT4_ERROR_INODE(inode, "invalid size");
 		return true;
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b0915b734a38..ead9406d9cff 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1339,7 +1339,7 @@ enum {
 	Opt_data_err_abort, Opt_data_err_ignore, Opt_test_dummy_encryption,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
-	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
+	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err, Opt_dirdata,
 	Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version, Opt_dax,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
 	Opt_lazytime, Opt_nolazytime, Opt_debug_want_extra_isize,
@@ -1400,6 +1400,7 @@ static const match_table_t tokens = {
 	{Opt_noquota, "noquota"},
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
+	{Opt_dirdata, "dirdata"},
 	{Opt_prjquota, "prjquota"},
 	{Opt_barrier, "barrier=%u"},
 	{Opt_barrier, "barrier"},
-- 
2.13.5 (Apple Git-94)
