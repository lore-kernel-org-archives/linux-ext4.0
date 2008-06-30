From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH, v4] ext3: validate directory entry data before use
Date: Mon, 30 Jun 2008 15:18:42 +0100
Message-ID: <1214835522-5414-1-git-send-email-duaneg@dghda.com>
References: <200806291857.m5TIv1k5001781@imap1.linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	sct@redhat.com, adilger@clusterfs.com,
	Sami Liedes <sliedes@cc.hut.fi>, jochen.voss@googlemail.com,
	Jan Kara <jack@suse.cz>, Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:1959 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbYF3OSr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jun 2008 10:18:47 -0400
In-Reply-To: <200806291857.m5TIv1k5001781@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Various places in fs/ext3/namei.c use ext3_next_entry to loop over
directory entries, but not all of them verify that entries are valid before
attempting to move to the next one. In the case where rec_len == 0 this
causes an infinite loop.

Introduce a new version of ext3_next_entry that checks the validity of the
entry before using its data to find the next one. Rename the original
function to __ext3_next_entry and use it in places where we already know
the data is valid.

Note that the changes to empty_dir follow the original code in reporting
the directory as empty in the presence of errors.

This patch fixes the first case (image hdb.25.softlockup.gz) reported in
http://bugzilla.kernel.org/show_bug.cgi?id=10882.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
--

This is version 4. It fixes the problems reported by checkpatch by giving a
variable a shorter name instead of omitting whitespace.

Please note that I've only properly tested the originally reported failure
case (i.e. the changes to ext3_dx_find_entry).

Reviewers may want to pay particular attention to the changes to do_split,
make_indexed_dir and empty_dir. I've tried to follow the original code's
error handling conventions, as noted above for empty_dir, but I'm not sure
this is the best way to do things.

---

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index 8ca3bfd..5c85ffa 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -187,8 +187,8 @@ revalidate:
 		while (!error && filp->f_pos < inode->i_size
 		       && offset < sb->s_blocksize) {
 			de = (struct ext3_dir_entry_2 *) (bh->b_data + offset);
-			if (!ext3_check_dir_entry ("ext3_readdir", inode, de,
-						   bh, offset)) {
+			if (!ext3_check_dir_entry(__func__, inode, de,
+						  bh, offset)) {
 				/* On error, skip the f_pos to the
                                    next block. */
 				filp->f_pos = (filp->f_pos |
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 0b8cf80..37f7e9d 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -185,13 +185,27 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
  * p is at least 6 bytes before the end of page
  */
 static inline struct ext3_dir_entry_2 *
-ext3_next_entry(struct ext3_dir_entry_2 *p)
+__ext3_next_entry(struct ext3_dir_entry_2 *p)
 {
 	return (struct ext3_dir_entry_2 *)((char *)p +
 		ext3_rec_len_from_disk(p->rec_len));
 }
 
 /*
+ * Checks the directory entry looks sane before using it to find the next one.
+ * Returns NULL and reports an error if an invalid entry is passed.
+ */
+static inline struct ext3_dir_entry_2 *
+ext3_next_entry(const char *func, struct inode *dir,
+		struct ext3_dir_entry_2 *de, struct buffer_head *bh, int offset)
+{
+	if (ext3_check_dir_entry(func, dir, de, bh, offset))
+		return __ext3_next_entry(de);
+	else
+		return NULL;
+}
+
+/*
  * Future: use high four bits of block for coalesce-on-delete flags
  * Mask them off for now.
  */
@@ -271,15 +285,17 @@ struct stats
 	unsigned bcount;
 };
 
-static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext3_dir_entry_2 *de,
-				 int size, int show_names)
+static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct inode *dir,
+				 struct buffer_head *bh, int size,
+				 int show_names)
 {
+	struct ext3_dir_entry_2 *de = (struct ext3_dir_entry_2 *) bh->b_data;
 	unsigned names = 0, space = 0;
 	char *base = (char *) de;
 	struct dx_hash_info h = *hinfo;
 
 	printk("names: ");
-	while ((char *) de < base + size)
+	while (de && (char *) de < base + size)
 	{
 		if (de->inode)
 		{
@@ -295,7 +311,7 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext3_dir_ent
 			space += EXT3_DIR_REC_LEN(de->name_len);
 			names++;
 		}
-		de = ext3_next_entry(de);
+		de = ext3_next_entry(__func__, dir, de, bh, 0);
 	}
 	printk("(%i)\n", names);
 	return (struct stats) { names, space, 1 };
@@ -319,7 +335,7 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
 		if (!(bh = ext3_bread (NULL,dir, block, 0,&err))) continue;
 		stats = levels?
 		   dx_show_entries(hinfo, dir, ((struct dx_node *) bh->b_data)->entries, levels - 1):
-		   dx_show_leaf(hinfo, (struct ext3_dir_entry_2 *) bh->b_data, blocksize, 0);
+		   dx_show_leaf(hinfo, dir, bh, blocksize, 0);
 		names += stats.names;
 		space += stats.space;
 		bcount += stats.bcount;
@@ -583,8 +599,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	top = (struct ext3_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
 					   EXT3_DIR_REC_LEN(0));
-	for (; de < top; de = ext3_next_entry(de)) {
-		if (!ext3_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
+	for (; de < top; de = __ext3_next_entry(de)) {
+		if (!ext3_check_dir_entry(__func__, dir, de, bh,
 					(block<<EXT3_BLOCK_SIZE_BITS(dir->i_sb))
 						+((char *)de - bh->b_data))) {
 			/* On error, skip the f_pos to the next block. */
@@ -658,7 +674,11 @@ int ext3_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 	}
 	if (start_hash < 2 || (start_hash ==2 && start_minor_hash==0)) {
 		de = (struct ext3_dir_entry_2 *) frames[0].bh->b_data;
-		de = ext3_next_entry(de);
+		de = ext3_next_entry(__func__, dir, de, frames[0].bh, 0);
+		if (de == NULL) {
+			err = -EIO;
+			goto errout;
+		}
 		if ((err = ext3_htree_store_dirent(dir_file, 2, 0, de)) != 0)
 			goto errout;
 		count++;
@@ -726,8 +746,7 @@ static int dx_make_map (struct ext3_dir_entry_2 *de, int size,
 			count++;
 			cond_resched();
 		}
-		/* XXX: do we need to check rec_len == 0 case? -Chris */
-		de = ext3_next_entry(de);
+		de = __ext3_next_entry(de);
 	}
 	return count;
 }
@@ -804,7 +823,7 @@ static inline int ext3_match (int len, const char * const name,
 static inline int search_dirblock(struct buffer_head * bh,
 				  struct inode *dir,
 				  struct dentry *dentry,
-				  unsigned long offset,
+				  unsigned long off,
 				  struct ext3_dir_entry_2 ** res_dir)
 {
 	struct ext3_dir_entry_2 * de;
@@ -822,8 +841,7 @@ static inline int search_dirblock(struct buffer_head * bh,
 		if ((char *) de + namelen <= dlimit &&
 		    ext3_match (namelen, name, de)) {
 			/* found a match - just to be sure, do a full check */
-			if (!ext3_check_dir_entry("ext3_find_entry",
-						  dir, de, bh, offset))
+			if (!ext3_check_dir_entry(__func__, dir, de, bh, off))
 				return -1;
 			*res_dir = de;
 			return 1;
@@ -832,7 +850,7 @@ static inline int search_dirblock(struct buffer_head * bh,
 		de_len = ext3_rec_len_from_disk(de->rec_len);
 		if (de_len <= 0)
 			return -1;
-		offset += de_len;
+		off += de_len;
 		de = (struct ext3_dir_entry_2 *) ((char *) de + de_len);
 	}
 	return 0;
@@ -991,24 +1009,27 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
 		de = (struct ext3_dir_entry_2 *) bh->b_data;
 		top = (struct ext3_dir_entry_2 *) ((char *) de + sb->s_blocksize -
 				       EXT3_DIR_REC_LEN(0));
-		for (; de < top; de = ext3_next_entry(de))
-		if (ext3_match (namelen, name, de)) {
-			if (!ext3_check_dir_entry("ext3_find_entry",
-						  dir, de, bh,
-				  (block<<EXT3_BLOCK_SIZE_BITS(sb))
-					  +((char *)de - bh->b_data))) {
-				brelse (bh);
+		for (; de < top; de = __ext3_next_entry(de)) {
+			int off = (block << EXT3_BLOCK_SIZE_BITS(sb))
+				  + ((char *) de - bh->b_data);
+
+			if (!ext3_check_dir_entry(__func__, dir, de, bh, off)) {
+				brelse(bh);
 				*err = ERR_BAD_DX_DIR;
 				goto errout;
 			}
-			*res_dir = de;
-			dx_release (frames);
-			return bh;
+
+			if (ext3_match(namelen, name, de)) {
+				*res_dir = de;
+				dx_release(frames);
+				return bh;
+			}
 		}
 		brelse (bh);
+
 		/* Check to see if we should continue to search */
-		retval = ext3_htree_next_block(dir, hash, frame,
-					       frames, NULL);
+		retval = ext3_htree_next_block(dir, hash, frame, frames, NULL);
+
 		if (retval < 0) {
 			ext3_warning(sb, __func__,
 			     "error reading index page in directory #%lu",
@@ -1141,7 +1162,7 @@ static struct ext3_dir_entry_2* dx_pack_dirents(char *base, int size)
 
 	prev = to = de;
 	while ((char*)de < base + size) {
-		next = ext3_next_entry(de);
+		next = __ext3_next_entry(de);
 		if (de->inode && de->name_len) {
 			rec_len = EXT3_DIR_REC_LEN(de->name_len);
 			if (de > to)
@@ -1172,9 +1193,22 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	struct dx_map_entry *map;
 	char *data1 = (*bh)->b_data, *data2;
 	unsigned split, move, size, i;
-	struct ext3_dir_entry_2 *de = NULL, *de2;
+	struct ext3_dir_entry_2 *de, *de2;
 	int	err = 0;
 
+	/* Verify directory entries are sane before trying anything else. */
+	de = (struct ext3_dir_entry_2 *) data1;
+	de2 = (struct ext3_dir_entry_2 *) data1 +
+		dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(0);
+	while (de < de2) {
+		de = ext3_next_entry(__func__, dir, de, *bh, 0);
+		if (de == NULL) {
+			brelse(*bh);
+			*bh = NULL;
+			goto errout;
+		}
+	}
+
 	bh2 = ext3_append (handle, dir, &newblock, &err);
 	if (!(bh2)) {
 		brelse(*bh);
@@ -1271,7 +1305,7 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 	struct inode	*dir = dentry->d_parent->d_inode;
 	const char	*name = dentry->d_name.name;
 	int		namelen = dentry->d_name.len;
-	unsigned long	offset = 0;
+	unsigned long	off = 0;
 	unsigned short	reclen;
 	int		nlen, rlen, err;
 	char		*top;
@@ -1281,8 +1315,7 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 		de = (struct ext3_dir_entry_2 *)bh->b_data;
 		top = bh->b_data + dir->i_sb->s_blocksize - reclen;
 		while ((char *) de <= top) {
-			if (!ext3_check_dir_entry("ext3_add_entry", dir, de,
-						  bh, offset)) {
+			if (!ext3_check_dir_entry(__func__, dir, de, bh, off)) {
 				brelse (bh);
 				return -EIO;
 			}
@@ -1295,7 +1328,7 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 			if ((de->inode? rlen - nlen: rlen) >= reclen)
 				break;
 			de = (struct ext3_dir_entry_2 *)((char *)de + rlen);
-			offset += rlen;
+			off += rlen;
 		}
 		if ((char *) de > top)
 			return -ENOSPC;
@@ -1397,8 +1430,13 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	memcpy (data1, de, len);
 	de = (struct ext3_dir_entry_2 *) data1;
 	top = data1 + len;
-	while ((char *)(de2 = ext3_next_entry(de)) < top)
+
+	de2 = de;
+	while (de2 != NULL && de2 < top) {
 		de = de2;
+		de2 = ext3_next_entry(__func__, dir, de, bh, 0);
+	}
+
 	de->rec_len = ext3_rec_len_to_disk(data1 + blocksize - (char *) de);
 	/* Initialize the root; the dot dirents already exist */
 	de = (struct ext3_dir_entry_2 *) (&root->dotdot);
@@ -1637,7 +1675,7 @@ static int ext3_delete_entry (handle_t *handle,
 	pde = NULL;
 	de = (struct ext3_dir_entry_2 *) bh->b_data;
 	while (i < bh->b_size) {
-		if (!ext3_check_dir_entry("ext3_delete_entry", dir, de, bh, i))
+		if (!ext3_check_dir_entry(__func__, dir, de, bh, i))
 			return -EIO;
 		if (de == de_del)  {
 			BUFFER_TRACE(bh, "get_write_access");
@@ -1655,7 +1693,7 @@ static int ext3_delete_entry (handle_t *handle,
 		}
 		i += ext3_rec_len_from_disk(de->rec_len);
 		pde = de;
-		de = ext3_next_entry(de);
+		de = __ext3_next_entry(de);
 	}
 	return -ENOENT;
 }
@@ -1792,7 +1830,7 @@ retry:
 	de->rec_len = ext3_rec_len_to_disk(EXT3_DIR_REC_LEN(de->name_len));
 	strcpy (de->name, ".");
 	ext3_set_de_type(dir->i_sb, de, S_IFDIR);
-	de = ext3_next_entry(de);
+	de = __ext3_next_entry(de);
 	de->inode = cpu_to_le32(dir->i_ino);
 	de->rec_len = ext3_rec_len_to_disk(inode->i_sb->s_blocksize -
 					EXT3_DIR_REC_LEN(1));
@@ -1825,7 +1863,7 @@ out_stop:
 /*
  * routine to check that the specified directory is empty (for rmdir)
  */
-static int empty_dir (struct inode * inode)
+static int empty_dir(struct inode *dir, struct inode *inode)
 {
 	unsigned long offset;
 	struct buffer_head * bh;
@@ -1846,8 +1884,14 @@ static int empty_dir (struct inode * inode)
 				     inode->i_ino);
 		return 1;
 	}
+
 	de = (struct ext3_dir_entry_2 *) bh->b_data;
-	de1 = ext3_next_entry(de);
+	de1 = ext3_next_entry(__func__, dir, de, bh, 0);
+	if (de1 == NULL) {
+		brelse(bh);
+		return 1;
+	}
+
 	if (le32_to_cpu(de->inode) != inode->i_ino ||
 			!le32_to_cpu(de1->inode) ||
 			strcmp (".", de->name) ||
@@ -1860,8 +1904,8 @@ static int empty_dir (struct inode * inode)
 	}
 	offset = ext3_rec_len_from_disk(de->rec_len) +
 			ext3_rec_len_from_disk(de1->rec_len);
-	de = ext3_next_entry(de1);
-	while (offset < inode->i_size ) {
+	de = ext3_next_entry(__func__, dir, de1, bh, offset);
+	while (de && offset < inode->i_size) {
 		if (!bh ||
 			(void *) de >= (void *) (bh->b_data+sb->s_blocksize)) {
 			err = 0;
@@ -1879,7 +1923,7 @@ static int empty_dir (struct inode * inode)
 			}
 			de = (struct ext3_dir_entry_2 *) bh->b_data;
 		}
-		if (!ext3_check_dir_entry("empty_dir", inode, de, bh, offset)) {
+		if (!ext3_check_dir_entry(__func__, inode, de, bh, offset)) {
 			de = (struct ext3_dir_entry_2 *)(bh->b_data +
 							 sb->s_blocksize);
 			offset = (offset | (sb->s_blocksize - 1)) + 1;
@@ -1890,7 +1934,7 @@ static int empty_dir (struct inode * inode)
 			return 0;
 		}
 		offset += ext3_rec_len_from_disk(de->rec_len);
-		de = ext3_next_entry(de);
+		de = __ext3_next_entry(de);
 	}
 	brelse (bh);
 	return 1;
@@ -2068,7 +2112,7 @@ static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
 		goto end_rmdir;
 
 	retval = -ENOTEMPTY;
-	if (!empty_dir (inode))
+	if (!empty_dir(dir, inode))
 		goto end_rmdir;
 
 	retval = ext3_delete_entry(handle, dir, de, bh);
@@ -2244,7 +2288,7 @@ retry:
 }
 
 #define PARENT_INO(buffer) \
-	(ext3_next_entry((struct ext3_dir_entry_2 *)(buffer))->inode)
+	(__ext3_next_entry((struct ext3_dir_entry_2 *)(buffer))->inode)
 
 /*
  * Anybody can rename anything with this: the permission checks are left to the
@@ -2297,7 +2341,7 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	if (S_ISDIR(old_inode->i_mode)) {
 		if (new_inode) {
 			retval = -ENOTEMPTY;
-			if (!empty_dir (new_inode))
+			if (!empty_dir(new_dir, new_inode))
 				goto end_rename;
 		}
 		retval = -EIO;
