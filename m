From: pravin shelar <Pravin.Shelar@Sun.COM>
Subject: [patch 2/2] add user data field in ext4 dirent
Date: Fri, 17 Jul 2009 22:59:52 +0530
Message-ID: <4A60B510.2010507@sun.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_2zRX6SpmBVcYCYew0oTiPw)"
Cc: Andreas Dilger <adilger@Sun.COM>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:40823 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964917AbZGQRnv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jul 2009 13:43:51 -0400
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id n6HHS4Lg028925
	for <linux-ext4@vger.kernel.org>; Fri, 17 Jul 2009 17:28:19 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KMX00K00SFVG600@mail-apac.sun.com> for linux-ext4@vger.kernel.org; Sat,
 18 Jul 2009 01:28:04 +0800 (SGT)
Received: from [129.150.33.148] ([unknown] [129.150.33.148])
 by mail-apac.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPSA id <0KMX00JXQSIMT5H0@mail-apac.sun.com> for
 linux-ext4@vger.kernel.org; Sat, 18 Jul 2009 01:28:03 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_2zRX6SpmBVcYCYew0oTiPw)
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT

Hi
   attached patch  adds data field in ext4 dirent. so that user can have data 
ext4 dirent.

Thanks,
Pravin.

--Boundary_(ID_2zRX6SpmBVcYCYew0oTiPw)
Content-type: text/x-patch; name=ext4_data_in_dirent.patch
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
@@ -53,6 +53,8 @@ const struct file_operations ext4_dir_op
 
 static unsigned char get_dtype(struct super_block *sb, int filetype)
 {
+	filetype &= EXT4_FT_MASK;
+
 	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FILETYPE) ||
 	    (filetype >= EXT4_FT_MAX))
 		return DT_UNKNOWN;
@@ -70,11 +72,11 @@ int ext4_check_dir_entry(const char *fun
 	const int rlen = ext4_rec_len_from_disk(de->rec_len,
 						dir->i_sb->s_blocksize);
 
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
@@ -179,7 +181,7 @@ revalidate:
 				 * failure will be detected in the
 				 * dirent test below. */
 				if (ext4_rec_len_from_disk(de->rec_len,
-					sb->s_blocksize) < EXT4_DIR_REC_LEN(1))
+					sb->s_blocksize) < __EXT4_DIR_REC_LEN(1))
 					break;
 				i += ext4_rec_len_from_disk(de->rec_len,
 							    sb->s_blocksize);
@@ -215,12 +217,13 @@ revalidate:
 				 * during the copy operation.
 				 */
 				u64 version = filp->f_version;
-
 				error = filldir(dirent, de->name,
 						de->name_len,
 						filp->f_pos,
 						le32_to_cpu(de->inode),
-						get_dtype(sb, de->file_type));
+						get_dtype(sb, de->file_type)|
+						(de->file_type &
+                                                 EXT4_DIRENT_LUFID));
 				if (error)
 					break;
 				if (version != filp->f_version)
@@ -342,12 +345,17 @@ int ext4_htree_store_dirent(struct file 
 	struct fname *fname, *new_fn;
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
@@ -356,7 +364,7 @@ int ext4_htree_store_dirent(struct file 
 	new_fn->inode = le32_to_cpu(dirent->inode);
 	new_fn->name_len = dirent->name_len;
 	new_fn->file_type = dirent->file_type;
-	memcpy(new_fn->name, dirent->name, dirent->name_len);
+	memcpy(new_fn->name, dirent->name, dirent->name_len + extra_data);
 	new_fn->name[dirent->name_len] = 0;
 
 	while (*p) {
@@ -417,7 +425,9 @@ static int call_filldir(struct file *fil
 		error = filldir(dirent, fname->name,
 				fname->name_len, curr_pos,
 				fname->inode,
-				get_dtype(sb, fname->file_type));
+				get_dtype(sb, fname->file_type)|
+				(fname->file_type &
+				 EXT4_DIRENT_LUFID));
 		if (error) {
 			filp->f_pos = curr_pos;
 			info->extra_fname = fname;
Index: b/fs/ext4/ext4.h
===================================================================
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1061,6 +1061,7 @@ static inline int ext4_valid_inum(struct
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP               0x0100
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
+#define EXT4_FEATURE_INCOMPAT_DIRDATA           0x1000
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -1068,7 +1069,8 @@ static inline int ext4_valid_inum(struct
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
 					 EXT4_FEATURE_INCOMPAT_64BIT| \
-					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
+					 EXT4_FEATURE_INCOMPAT_DIRDATA)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
@@ -1150,6 +1152,25 @@ struct ext4_dir_entry_2 {
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
 
 /*
  * EXT4_DIR_PAD defines the directory entries boundaries
@@ -1158,8 +1179,11 @@ struct ext4_dir_entry_2 {
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
 
 /*
@@ -1678,6 +1702,17 @@ static inline void set_bitmap_uptodate(s
 	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }
 
+static inline int ext4_get_dirent_data_len(struct ext4_dir_entry_2 *de)
+{
+	int dlen = 0;
+	char *data;
+	if (de->file_type & EXT4_DIRENT_LUFID) {
+		data = de->name + de->name_len + 1;
+		dlen = *data + 1;
+	}
+	return dlen;
+}
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
Index: b/fs/ext4/namei.c
===================================================================
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -143,7 +143,8 @@ static unsigned dx_get_count(struct dx_e
 static unsigned dx_get_limit(struct dx_entry *entries);
 static void dx_set_count(struct dx_entry *entries, unsigned value);
 static void dx_set_limit(struct dx_entry *entries, unsigned value);
-static unsigned dx_root_limit(struct inode *dir, unsigned infosize);
+static inline unsigned dx_root_limit(struct inode *dir,
+                struct ext4_dir_entry_2 *de, unsigned infosize);
 static unsigned dx_node_limit(struct inode *dir);
 static struct dx_frame *dx_probe(const struct qstr *d_name,
 				 struct inode *dir,
@@ -210,13 +211,15 @@ ext4_next_entry(struct ext4_dir_entry_2 
  */
 struct dx_root_info * dx_get_dx_info(struct ext4_dir_entry_2 *de)
 {
-       /* get dotdot first */
-       de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_REC_LEN(1));
+	BUG_ON(de->name_len != 1);
+	/* get dotdot first */
+	de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_REC_LEN(de));
+
+	/* dx root info is after dotdot entry */
+	de = (struct ext4_dir_entry_2 *)((char *)de +
+			__EXT4_DIR_REC_LEN(2 + ext4_get_dirent_data_len(de)));
 
-       /* dx root info is after dotdot entry */
-       de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_REC_LEN(2));
-
-       return (struct dx_root_info *) de;
+	return (struct dx_root_info *) de;
 }
 
 static inline ext4_lblk_t dx_get_block(struct dx_entry *entry)
@@ -259,16 +262,20 @@ static inline void dx_set_limit(struct d
 	((struct dx_countlimit *) entries)->limit = cpu_to_le16(value);
 }
 
-static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
+static inline unsigned dx_root_limit(struct inode *dir,
+		struct ext4_dir_entry_2 *dot_de, unsigned infosize)
 {
-	unsigned entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(1) -
-		EXT4_DIR_REC_LEN(2) - infosize;
+	struct ext4_dir_entry_2 *dotdot_de = ext4_next_entry(dot_de,
+						 dir->i_sb->s_blocksize);
+	unsigned entry_space = dir->i_sb->s_blocksize -
+		EXT4_DIR_REC_LEN(dot_de) - EXT4_DIR_REC_LEN(dotdot_de) - infosize;
+	BUG_ON(dot_de->name_len != 1);
 	return entry_space / sizeof(struct dx_entry);
 }
 
 static inline unsigned dx_node_limit(struct inode *dir)
 {
-	unsigned entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(0);
+	unsigned entry_space = dir->i_sb->s_blocksize - __EXT4_DIR_REC_LEN(0);
 	return entry_space / sizeof(struct dx_entry);
 }
 
@@ -315,7 +322,7 @@ static struct stats dx_show_leaf(struct 
 				printk(":%x.%u ", h.hash,
 				       ((char *) de - base));
 			}
-			space += EXT4_DIR_REC_LEN(de->name_len);
+			space += EXT4_DIR_REC_LEN(de);
 			names++;
 		}
 		de = ext4_next_entry(de, size);
@@ -420,6 +427,7 @@ dx_probe(const struct qstr *d_name, stru
 	entries = (struct dx_entry *) (((char *)info) + info->info_length);
 
 	if (dx_get_limit(entries) != dx_root_limit(dir,
+						   (struct ext4_dir_entry_2*)bh->b_data,
 						   info->info_length)) {
 		ext4_warning(dir->i_sb, __func__,
 			     "dx entry: limit != root limit");
@@ -609,7 +617,7 @@ static int htree_dirblock_to_tree(struct
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
 	top = (struct ext4_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
-					   EXT4_DIR_REC_LEN(0));
+					   __EXT4_DIR_REC_LEN(0));
 	for (; de < top; de = ext4_next_entry(de, dir->i_sb->s_blocksize)) {
 		if (!ext4_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
 					(block<<EXT4_BLOCK_SIZE_BITS(dir->i_sb))
@@ -1021,7 +1029,7 @@ static struct buffer_head * ext4_dx_find
 			goto errout;
 		de = (struct ext4_dir_entry_2 *) bh->b_data;
 		top = (struct ext4_dir_entry_2 *) ((char *) de + sb->s_blocksize -
-				       EXT4_DIR_REC_LEN(0));
+				       __EXT4_DIR_REC_LEN(0));
 		for (; de < top; de = ext4_next_entry(de, sb->s_blocksize)) {
 			int off = (block << EXT4_BLOCK_SIZE_BITS(sb))
 				  + ((char *) de - bh->b_data);
@@ -1151,7 +1159,7 @@ dx_move_dirents(char *from, char *to, st
 	while (count--) {
 		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *) 
 						(from + (map->offs<<2));
-		rec_len = EXT4_DIR_REC_LEN(de->name_len);
+		rec_len = EXT4_DIR_REC_LEN(de);
 		memcpy (to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
 				ext4_rec_len_to_disk(rec_len, blocksize);
@@ -1175,7 +1183,7 @@ static struct ext4_dir_entry_2* dx_pack_
 	while ((char*)de < base + blocksize) {
 		next = ext4_next_entry(de, blocksize);
 		if (de->inode && de->name_len) {
-			rec_len = EXT4_DIR_REC_LEN(de->name_len);
+			rec_len = EXT4_DIR_REC_LEN(de);
 			if (de > to)
 				memmove(to, de, rec_len);
 			to->rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
@@ -1308,10 +1316,13 @@ static int add_dirent_to_buf(handle_t *h
 	unsigned int	offset = 0;
 	unsigned int	blocksize = dir->i_sb->s_blocksize;
 	unsigned short	reclen;
-	int		nlen, rlen, err;
+	int		nlen, rlen, err, dlen = 0;
+	unsigned char	*data = dentry->d_fsdata;
 	char		*top;
 
-	reclen = EXT4_DIR_REC_LEN(namelen);
+	if (data)
+		dlen = (*data) + 1;
+	reclen = __EXT4_DIR_REC_LEN(namelen + dlen);
 	if (!de) {
 		de = (struct ext4_dir_entry_2 *)bh->b_data;
 		top = bh->b_data + blocksize - reclen;
@@ -1325,7 +1336,7 @@ static int add_dirent_to_buf(handle_t *h
 				brelse(bh);
 				return -EEXIST;
 			}
-			nlen = EXT4_DIR_REC_LEN(de->name_len);
+			nlen = EXT4_DIR_REC_LEN(de);
 			rlen = ext4_rec_len_from_disk(de->rec_len, blocksize);
 			if ((de->inode? rlen - nlen: rlen) >= reclen)
 				break;
@@ -1344,7 +1355,7 @@ static int add_dirent_to_buf(handle_t *h
 	}
 
 	/* By now the buffer is marked for journaling */
-	nlen = EXT4_DIR_REC_LEN(de->name_len);
+	nlen = EXT4_DIR_REC_LEN(de);
 	rlen = ext4_rec_len_from_disk(de->rec_len, blocksize);
 	if (de->inode) {
 		struct ext4_dir_entry_2 *de1 = (struct ext4_dir_entry_2 *)((char *)de + nlen);
@@ -1360,6 +1371,11 @@ static int add_dirent_to_buf(handle_t *h
 		de->inode = 0;
 	de->name_len = namelen;
 	memcpy(de->name, name, namelen);
+	if (data) {
+		de->name[namelen] = 0;
+		memcpy(&de->name[namelen + 1], data, *(char*) data);
+		de->file_type |= EXT4_DIRENT_LUFID;
+	}
 	/*
 	 * XXX shouldn't update any times until successful
 	 * completion of syscall, but too many callers depend
@@ -1458,7 +1474,7 @@ static int make_indexed_dir(handle_t *ha
 
 	dx_set_block(entries, 1);
 	dx_set_count(entries, 1);
-	dx_set_limit(entries, dx_root_limit(dir, sizeof(*dx_info)));
+	dx_set_limit(entries, dx_root_limit(dir, dot_de, sizeof(*dx_info)));
 
 	/* Initialize as for dx_probe */
 	hinfo.hash_version = dx_info->hash_version;
@@ -1846,6 +1862,7 @@ static int ext4_mkdir(struct inode *dir,
 	struct inode *inode;
 	struct buffer_head *dir_block;
 	struct ext4_dir_entry_2 *de;
+	struct ext4_dir_entry_2 *dot_de;
 	unsigned int blocksize = dir->i_sb->s_blocksize;
 	int err, retries = 0;
 
@@ -1879,13 +1896,14 @@ retry:
 	de = (struct ext4_dir_entry_2 *) dir_block->b_data;
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
-	de->rec_len = ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de->name_len),
+	de->rec_len = ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de),
 					   blocksize);
 	strcpy(de->name, ".");
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
+	dot_de = de;
 	de = ext4_next_entry(de, blocksize);
 	de->inode = cpu_to_le32(dir->i_ino);
-	de->rec_len = ext4_rec_len_to_disk(blocksize - EXT4_DIR_REC_LEN(1),
+	de->rec_len = ext4_rec_len_to_disk(blocksize - EXT4_DIR_REC_LEN(dot_de),
 					   blocksize);
 	de->name_len = 2;
 	strcpy(de->name, "..");
@@ -1928,7 +1946,7 @@ static int empty_dir(struct inode *inode
 	int err = 0;
 
 	sb = inode->i_sb;
-	if (inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2) ||
+	if (inode->i_size < __EXT4_DIR_REC_LEN(1) + __EXT4_DIR_REC_LEN(2) ||
 	    !(bh = ext4_bread(NULL, inode, 0, 0, &err))) {
 		if (err)
 			ext4_error(inode->i_sb, __func__,

--Boundary_(ID_2zRX6SpmBVcYCYew0oTiPw)--
