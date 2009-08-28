From: pravin shelar <Pravin.Shelar@Sun.COM>
Subject: [patch 2/3] FEATURE DIRDATA - add user data field in ext4 dirent
Date: Fri, 28 Aug 2009 11:21:22 +0530
Message-ID: <4A97705A.5010107@sun.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_FbCEOppEcNSQZn6kq1QFWA)"
Cc: Andreas Dilger <adilger@Sun.COM>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:59353 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZH1GDJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2009 02:03:09 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id n7S5o5or002162
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 05:50:05 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KP200700O0HKH00@mail-apac.sun.com> for linux-ext4@vger.kernel.org; Fri,
 28 Aug 2009 13:50:05 +0800 (SGT)
Received: from [192.168.1.2] ([unknown] [59.95.7.244])
 by mail-apac.sun.com (Sun Java(tm) System Messaging Server 7u2-7.04 64bit
 (built Jul  2 2009)) with ESMTPSA id <0KP200FPBO7G0SD0@mail-apac.sun.com> for
 linux-ext4@vger.kernel.org; Fri, 28 Aug 2009 13:50:05 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_FbCEOppEcNSQZn6kq1QFWA)
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT

Hi
   attached patch  adds data field in ext4 dirent. so that user can have data 
ext4 dirent.

Thanks,
Pravin.



--Boundary_(ID_FbCEOppEcNSQZn6kq1QFWA)
Content-type: text/x-diff; name=ext4_data_in_dirent.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=ext4_data_in_dirent.patch

this patch implements feature which allows ext4 fs uses (e.g. Lustre)
store data in ext4 dirent.
data is stored in ext4 dirent after file-name, this space is accounted
in de->rec_len. flag EXT4_DIRENT_LUFID added to d_type if extra data
is present.


Index: b/fs/ext4/dir.c
===================================================================
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -53,11 +53,18 @@ const struct file_operations ext4_dir_op
 
 static unsigned char get_dtype(struct super_block *sb, int filetype)
 {
+	int fl_index = filetype & EXT4_FT_MASK;
+
 	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FILETYPE) ||
-	    (filetype >= EXT4_FT_MAX))
+	    (fl_index >= EXT4_FT_MAX))
 		return DT_UNKNOWN;
 
-	return (ext4_filetype_table[filetype]);
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_DIRDATA))
+		return (ext4_filetype_table[fl_index]);
+
+	return (ext4_filetype_table[fl_index]) |
+		(filetype & EXT4_DIRENT_LUFID);
+
 }
 
 
@@ -69,11 +76,11 @@ int ext4_check_dir_entry (const char * f
 	const char * error_msg = NULL;
 	const int rlen = ext4_rec_len_from_disk(de->rec_len);
 
-	if (rlen < EXT4_DIR_REC_LEN(1))
+	if (rlen < __EXT4_DIR_REC_LEN(1))
 		error_msg = "rec_len is smaller than minimal";
 	else if (rlen % 4 != 0)
 		error_msg = "rec_len % 4 != 0";
-	else if (rlen < EXT4_DIR_REC_LEN(de->name_len))
+	else if (rlen < EXT4_DIR_REC_LEN(de))
 		error_msg = "rec_len is too small for name_len";
 	else if (((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize)
 		error_msg = "directory entry across blocks";
@@ -175,7 +182,7 @@ revalidate:
 				 * failure will be detected in the
 				 * dirent test below. */
 				if (ext4_rec_len_from_disk(de->rec_len)
-						< EXT4_DIR_REC_LEN(1))
+						< __EXT4_DIR_REC_LEN(1))
 					break;
 				i += ext4_rec_len_from_disk(de->rec_len);
 			}
@@ -209,7 +216,6 @@ revalidate:
 				 * during the copy operation.
 				 */
 				u64 version = filp->f_version;
-
 				error = filldir(dirent, de->name,
 						de->name_len,
 						filp->f_pos,
@@ -335,12 +341,17 @@ int ext4_htree_store_dirent(struct file 
 	struct fname * fname, *new_fn;
 	struct dir_private_info *info;
 	int len;
+	int extra_data = 1;
 
 	info = (struct dir_private_info *) dir_file->private_data;
 	p = &info->root.rb_node;
 
 	/* Create and allocate the fname structure */
-	len = sizeof(struct fname) + dirent->name_len + 1;
+	if (dirent->file_type & EXT4_DIRENT_LUFID)
+		extra_data = ext4_get_dirent_data_len(dirent);
+
+	len = sizeof(struct fname) + dirent->name_len + extra_data;
+
 	new_fn = kzalloc(len, GFP_KERNEL);
 	if (!new_fn)
 		return -ENOMEM;
@@ -349,7 +360,7 @@ int ext4_htree_store_dirent(struct file 
 	new_fn->inode = le32_to_cpu(dirent->inode);
 	new_fn->name_len = dirent->name_len;
 	new_fn->file_type = dirent->file_type;
-	memcpy(new_fn->name, dirent->name, dirent->name_len);
+	memcpy(new_fn->name, dirent->name, dirent->name_len + extra_data);
 	new_fn->name[dirent->name_len] = 0;
 
 	while (*p) {
Index: b/fs/ext4/ext4.h
===================================================================
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -771,6 +771,7 @@ static inline int ext4_valid_inum(struct
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP               0x0100
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
+#define EXT4_FEATURE_INCOMPAT_DIRDATA           0x1000
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -779,7 +780,9 @@ static inline int ext4_valid_inum(struct
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
 					 EXT4_FEATURE_INCOMPAT_64BIT| \
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
-					 EXT4_FEATURE_INCOMPAT_MMP)
+					 EXT4_FEATURE_INCOMPAT_MMP| \
+					 EXT4_FEATURE_INCOMPAT_DIRDATA)
+
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
@@ -847,6 +850,44 @@ struct ext4_dir_entry_2 {
 #define EXT4_FT_SYMLINK		7
 
 #define EXT4_FT_MAX		8
+#define EXT4_FT_MASK	        0xf
+
+
+#if EXT4_FT_MAX > EXT4_FT_MASK
+#error "conflicting EXT4_FT_MAX and EXT4_FT_MASK"
+#endif
+
+/*
+ * d_type has 4 unused bits, so it can hold four types data. these different
+ * type of data (e.g. lustre data, high 32 bits of 64-bit inode number) can be
+ * stored, in flag order, after file-name in ext4 dirent.
+*/
+/*
+ * this flag is added to d_type if ext4 dirent has extra data after
+ * filename. this data length is variable and length is stored in first byte
+ * of data. data start after filename NUL byte.
+ * This is used by Lustre FS.
+  */
+#define EXT4_DIRENT_LUFID               0x10
+
+#define EXT4_LUFID_MAGIC    0xAD200907UL
+struct ext4_dentry_param {
+	__u32  edp_magic;   /* EXT4_LUFID_MAGIC */
+	char   edp_len;     /* size of edp_data in bytes */
+	char   edp_data[0]; /* packed array of data */
+} __attribute__((packed));
+
+static inline unsigned char *ext4_dentry_get_data(struct super_block *sb,
+		struct ext4_dentry_param* p)
+
+{
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_DIRDATA))
+		return NULL;
+	if (p && p->edp_magic == EXT4_LUFID_MAGIC)
+		return &p->edp_len;
+	else
+		return NULL;
+}
 
 /*
  * EXT4_DIR_PAD defines the directory entries boundaries
@@ -855,8 +896,11 @@ struct ext4_dir_entry_2 {
  */
 #define EXT4_DIR_PAD			4
 #define EXT4_DIR_ROUND			(EXT4_DIR_PAD - 1)
-#define EXT4_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXT4_DIR_ROUND) & \
+#define __EXT4_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXT4_DIR_ROUND) & \
 					 ~EXT4_DIR_ROUND)
+#define EXT4_DIR_REC_LEN(de)            (__EXT4_DIR_REC_LEN(de->name_len +\
+					ext4_get_dirent_data_len(de)))
+
 #define EXT4_MAX_REC_LEN		((1<<16)-1)
 
 static inline unsigned ext4_rec_len_from_disk(__le16 dlen)
@@ -1155,7 +1199,7 @@ extern struct buffer_head * ext4_find_en
 					       struct ext4_dir_entry_2
 					       ** res_dir);
 extern int ext4_add_dot_dotdot(handle_t *handle, struct inode *dir,
-				  struct inode *inode);
+			  struct inode *inode, const void *, const void *);
 extern int ext4_orphan_add(handle_t *, struct inode *);
 extern int ext4_orphan_del(handle_t *, struct inode *);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
@@ -1345,7 +1389,28 @@ static inline int ext4_is_group_locked(s
 	return spin_is_locked(ext4_group_lock_ptr(sb, group));
 }
 
-
+/*
+ * Compute the total directory entry data length.
+ * This includes the filename and an implicit NUL terminator (always present),
+ * and optional extensions.  Each extension has a bit set in the high 4 bits of
+ * de->file_type, and the extension length is the first byte in each entry.
+ */
+
+static inline int ext4_get_dirent_data_len(struct ext4_dir_entry_2 *de)
+{
+        char *len = de->name + de->name_len + 1 /* NUL terminator */;
+        int dlen = 0;
+        __u8 extra_data_flags = (de->file_type & ~EXT4_FT_MASK) >> 4;
+
+        while (extra_data_flags) {
+                if (extra_data_flags & 1) {
+                        dlen += *len + (dlen == 0);
+                        len += *len;
+                }
+                extra_data_flags >>= 1;
+        }
+        return dlen;
+}
 
 #endif	/* __KERNEL__ */
 
Index: b/fs/ext4/namei.c
===================================================================
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -171,7 +171,8 @@ static unsigned dx_get_count (struct dx_
 static unsigned dx_get_limit (struct dx_entry *entries);
 static void dx_set_count (struct dx_entry *entries, unsigned value);
 static void dx_set_limit (struct dx_entry *entries, unsigned value);
-static unsigned dx_root_limit (struct inode *dir, unsigned infosize);
+static inline unsigned dx_root_limit(__u32 blocksize,
+                struct ext4_dir_entry_2 *dot_de, unsigned infosize);
 static unsigned dx_node_limit (struct inode *dir);
 static struct dx_frame *dx_probe(struct dentry *dentry,
 				 struct inode *dir,
@@ -212,11 +213,12 @@ ext4_next_entry(struct ext4_dir_entry_2 
  */
 struct dx_root_info * dx_get_dx_info(struct ext4_dir_entry_2 *de)
 {
-       /* get dotdot first */
-       de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_REC_LEN(1));
+	BUG_ON(de->name_len != 1);
+	/* get dotdot first */
+	de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_REC_LEN(de));
 
-       /* dx root info is after dotdot entry */
-       de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_REC_LEN(2));
+	/* dx root info is after dotdot entry */
+	de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_REC_LEN(de));
 
        return (struct dx_root_info *) de;
 }
@@ -261,16 +263,23 @@ static inline void dx_set_limit (struct 
 	((struct dx_countlimit *) entries)->limit = cpu_to_le16(value);
 }
 
-static inline unsigned dx_root_limit (struct inode *dir, unsigned infosize)
+static inline unsigned dx_root_limit(__u32 blocksize,
+		struct ext4_dir_entry_2 *dot_de, unsigned infosize)
 {
-	unsigned entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(1) -
-		EXT4_DIR_REC_LEN(2) - infosize;
+	struct ext4_dir_entry_2 *dotdot_de;
+	unsigned entry_space;
+
+	BUG_ON(dot_de->name_len != 1);
+	dotdot_de = ext4_next_entry(dot_de);
+	entry_space = blocksize - EXT4_DIR_REC_LEN(dot_de) -
+			 EXT4_DIR_REC_LEN(dotdot_de) - infosize;
+
 	return entry_space / sizeof(struct dx_entry);
 }
 
 static inline unsigned dx_node_limit (struct inode *dir)
 {
-	unsigned entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(0);
+	unsigned entry_space = dir->i_sb->s_blocksize - __EXT4_DIR_REC_LEN(0);
 	return entry_space / sizeof(struct dx_entry);
 }
 
@@ -317,7 +326,7 @@ static struct stats dx_show_leaf(struct 
 				printk(":%x.%u ", h.hash,
 				       ((char *) de - base));
 			}
-			space += EXT4_DIR_REC_LEN(de->name_len);
+			space += EXT4_DIR_REC_LEN(de);
 			names++;
 		}
 		de = ext4_next_entry(de);
@@ -421,7 +430,8 @@ dx_probe(struct dentry *dentry, struct i
 
 	entries = (struct dx_entry *) (((char *)info) + info->info_length);
 
-	if (dx_get_limit(entries) != dx_root_limit(dir,
+	if (dx_get_limit(entries) != dx_root_limit(dir->i_sb->s_blocksize,
+						   (struct ext4_dir_entry_2*)bh->b_data,
 						   info->info_length)) {
 		ext4_warning(dir->i_sb, __func__,
 			     "dx entry: limit != root limit");
@@ -611,7 +621,7 @@ static int htree_dirblock_to_tree(struct
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
 	top = (struct ext4_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
-					   EXT4_DIR_REC_LEN(0));
+					   __EXT4_DIR_REC_LEN(0));
 	for (; de < top; de = ext4_next_entry(de)) {
 		if (!ext4_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
 					(block<<EXT4_BLOCK_SIZE_BITS(dir->i_sb))
@@ -1020,7 +1030,7 @@ static struct buffer_head * ext4_dx_find
 			goto errout;
 		de = (struct ext4_dir_entry_2 *) bh->b_data;
 		top = (struct ext4_dir_entry_2 *) ((char *) de + sb->s_blocksize -
-				       EXT4_DIR_REC_LEN(0));
+				       __EXT4_DIR_REC_LEN(0));
 		for (; de < top; de = ext4_next_entry(de)) {
 			int off = (block << EXT4_BLOCK_SIZE_BITS(sb))
 				  + ((char *) de - bh->b_data);
@@ -1187,7 +1197,7 @@ dx_move_dirents(char *from, char *to, st
 
 	while (count--) {
 		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *) (from + map->offs);
-		rec_len = EXT4_DIR_REC_LEN(de->name_len);
+		rec_len = EXT4_DIR_REC_LEN(de);
 		memcpy (to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
 				ext4_rec_len_to_disk(rec_len);
@@ -1211,7 +1221,7 @@ static struct ext4_dir_entry_2* dx_pack_
 	while ((char*)de < base + size) {
 		next = ext4_next_entry(de);
 		if (de->inode && de->name_len) {
-			rec_len = EXT4_DIR_REC_LEN(de->name_len);
+			rec_len = EXT4_DIR_REC_LEN(de);
 			if (de > to)
 				memmove(to, de, rec_len);
 			to->rec_len = ext4_rec_len_to_disk(rec_len);
@@ -1341,10 +1351,17 @@ static int add_dirent_to_buf(handle_t *h
 	int		namelen = dentry->d_name.len;
 	unsigned long	offset = 0;
 	unsigned short	reclen;
-	int		nlen, rlen, err;
+	int		nlen, rlen, err, dlen = 0;
+	unsigned char	*data;
 	char		*top;
 
-	reclen = EXT4_DIR_REC_LEN(namelen);
+	data = ext4_dentry_get_data(inode->i_sb,
+			(struct ext4_dentry_param *)
+			dentry->d_fsdata);
+	if (data)
+		dlen = (*data) + 1;
+
+	reclen = __EXT4_DIR_REC_LEN(namelen + dlen);
 	if (!de) {
 		de = (struct ext4_dir_entry_2 *)bh->b_data;
 		top = bh->b_data + dir->i_sb->s_blocksize - reclen;
@@ -1358,7 +1375,7 @@ static int add_dirent_to_buf(handle_t *h
 				brelse (bh);
 				return -EEXIST;
 			}
-			nlen = EXT4_DIR_REC_LEN(de->name_len);
+			nlen = EXT4_DIR_REC_LEN(de);
 			rlen = ext4_rec_len_from_disk(de->rec_len);
 			if ((de->inode? rlen - nlen: rlen) >= reclen)
 				break;
@@ -1377,7 +1394,7 @@ static int add_dirent_to_buf(handle_t *h
 	}
 
 	/* By now the buffer is marked for journaling */
-	nlen = EXT4_DIR_REC_LEN(de->name_len);
+	nlen = EXT4_DIR_REC_LEN(de);
 	rlen = ext4_rec_len_from_disk(de->rec_len);
 	if (de->inode) {
 		struct ext4_dir_entry_2 *de1 = (struct ext4_dir_entry_2 *)((char *)de + nlen);
@@ -1393,6 +1410,12 @@ static int add_dirent_to_buf(handle_t *h
 		de->inode = 0;
 	de->name_len = namelen;
 	memcpy (de->name, name, namelen);
+	if (data) {
+		de->name[namelen] = 0;
+		memcpy(&de->name[namelen + 1], data, *(char *) data);
+		de->file_type |= EXT4_DIRENT_LUFID;
+	}
+
 	/*
 	 * XXX shouldn't update any times until successful
 	 * completion of syscall, but too many callers depend
@@ -1482,7 +1505,8 @@ static int make_indexed_dir(handle_t *ha
 
 	dx_set_block(entries, 1);
 	dx_set_count(entries, 1);
-	dx_set_limit(entries, dx_root_limit(dir, sizeof(*dx_info)));
+	dx_set_limit(entries, dx_root_limit(dir->i_sb->s_blocksize,
+					 dot_de, sizeof(*dx_info)));
 
 	/* Initialize as for dx_probe */
 	hinfo.hash_version = dx_info->hash_version;
@@ -2067,7 +2125,7 @@ static int empty_dir (struct inode * ino
 	int err = 0;
 
 	sb = inode->i_sb;
-	if (inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2) ||
+	if (inode->i_size < __EXT4_DIR_REC_LEN(1) + __EXT4_DIR_REC_LEN(2) ||
 	    !(bh = ext4_bread (NULL, inode, 0, 0, &err))) {
 		if (err)
 			ext4_error(inode->i_sb, __func__,

--Boundary_(ID_FbCEOppEcNSQZn6kq1QFWA)--
