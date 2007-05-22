From: Kalpak Shah <kalpak@linsyssoft.com>
Subject: [RFC][PATCH] Large EAs in ext4
Date: Tue, 22 May 2007 17:41:48 +0530
Message-ID: <1179835908.25978.14.camel@garfield>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-tdkxcPWs4VyVUBoebkik"
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Komal <komal@linsyssoft.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from svr68.ehostpros.com ([67.15.48.48]:59686 "EHLO
	svr68.ehostpros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbXEVMIO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 May 2007 08:08:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-tdkxcPWs4VyVUBoebkik
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

There was discussion at the LFS07 workshop regarding the need of large
extended attributes in ext4. Samba, some security mechanisms would
benefit from larger EAs. We have implemented this large EA support for
in ext4. Note that this also helps to have a larger number of EAs since
large EAs get written out to a new inode instead of the EA block.

If value of an attribute is greater than 2048 bytes the value is not
saved in the external EA block, instead it is saved in an inode. The EA
entry saves the inode number in e_value_inum field (earlier this was
e_value_block that was unused). The maximum size of the EA is limited to
64K due to VFS limitations as can be seen in linux/limits.h. A new
EXT4_FEATURE_INCOMPAT_EA_INODE feature has been added for this.

These inodes are not linked into any directory since a single directory
per filesystem will cause a bottleneck. But e2fsck can be easily
modified to understand that these EA-inodes do not have dirents. Instead
a "goal" argument has been added to the ext4_new_inode() function to
help a localized selection of the EA inode. Since ext4_new_inode() only
used the dir argument to choose the group, we use goal to do the same.

Your feedback/review/comments are appreciated.

Thanks,
Kalpak.

--=-tdkxcPWs4VyVUBoebkik
Content-Disposition: attachment; filename=large_ea.patch
Content-Type: text/x-patch; name=large_ea.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: linux-2.6.19/fs/ext4/xattr.c
===================================================================
--- linux-2.6.19.orig/fs/ext4/xattr.c
+++ linux-2.6.19/fs/ext4/xattr.c
@@ -173,19 +173,26 @@ ext4_xattr_check_block(struct buffer_hea
 }
 
 static inline int
-ext4_xattr_check_entry(struct ext4_xattr_entry *entry, size_t size)
+ext4_xattr_check_entry(struct ext4_xattr_entry *entry, size_t size,
+		       struct inode *inode)
 {
 	size_t value_size = le32_to_cpu(entry->e_value_size);
 
-	if (entry->e_value_block != 0 || value_size > size ||
-	    le16_to_cpu(entry->e_value_offs) + value_size > size)
+	if ((entry->e_value_inum == 0) && (value_size > size ||
+	    le16_to_cpu(entry->e_value_offs) + value_size > size))
+		return -EIO;
+	if (entry->e_value_inum &&
+	    (entry->e_value_inum < le32_to_cpu(EXT4_FIRST_INO(inode->i_sb)) ||
+  	     entry->e_value_inum > le32_to_cpu(EXT4_SB(inode->i_sb)->
+							s_es->s_inodes_count)))
 		return -EIO;
 	return 0;
 }
 
 static int
 ext4_xattr_find_entry(struct ext4_xattr_entry **pentry, int name_index,
-		      const char *name, size_t size, int sorted)
+		      const char *name, size_t size, int sorted,
+		      struct inode *inode)
 {
 	struct ext4_xattr_entry *entry;
 	size_t name_len;
@@ -205,11 +212,68 @@ ext4_xattr_find_entry(struct ext4_xattr_
 			break;
 	}
 	*pentry = entry;
-	if (!cmp && ext4_xattr_check_entry(entry, size))
+	if (!cmp && ext4_xattr_check_entry(entry, size, inode))
 			return -EIO;
 	return cmp ? -ENODATA : 0;
 }
 
+/*
+ * Read the EA value from an inode.
+ */
+static int
+ext4_xattr_inode_read(struct inode *ea_inode, void *buf, size_t *size)
+{
+	unsigned long block = 0;
+	struct buffer_head *bh = NULL;
+	int err, blocksize;
+	size_t csize, ret_size = 0;
+
+	if (*size == 0 && ea_inode->i_size == 0)
+			return ret_size;
+
+	blocksize = ea_inode->i_sb->s_blocksize;
+	while (*size > 0) {
+		csize = blocksize < *size ? blocksize : *size;
+		bh = ext4_bread(NULL, ea_inode, block, 0, &err);
+		if (!bh)
+			return err;
+
+		memcpy(buf, bh->b_data, csize);
+		brelse(bh);
+
+		buf += csize;
+		*size -= csize;
+		block += 1;
+		ret_size += csize;
+	}
+
+	*size = ret_size;
+
+	return err;
+}
+
+/*
+ * Read the value from the EA inode.
+ */
+static int
+ext4_xattr_inode_get(struct inode *inode, int ea_ino, void *buffer, size_t *size)
+{
+	struct inode *ea_inode = NULL;
+	int err;
+
+	ea_inode = iget(inode->i_sb, ea_ino);
+	if (ea_inode == NULL || is_bad_inode(ea_inode)) {
+		ext4_error(inode->i_sb, "ext4_xattr_inode_get",
+			   "error while reading EA inode %d", ea_ino);
+		return -EIO;
+	}
+
+	err = ext4_xattr_inode_read(ea_inode, buffer, size);
+	iput(ea_inode);
+
+	return err;
+}
+
 static int
 ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 		     void *buffer, size_t buffer_size)
@@ -240,7 +304,7 @@ bad_block:	ext4_error(inode->i_sb, __FUN
 	}
 	ext4_xattr_cache_insert(bh);
 	entry = BFIRST(bh);
-	error = ext4_xattr_find_entry(&entry, name_index, name, bh->b_size, 1);
+	error = ext4_xattr_find_entry(&entry, name_index, name, bh->b_size, 1, inode);
 	if (error == -EIO)
 		goto bad_block;
 	if (error)
@@ -250,8 +314,16 @@ bad_block:	ext4_error(inode->i_sb, __FUN
 		error = -ERANGE;
 		if (size > buffer_size)
 			goto cleanup;
-		memcpy(buffer, bh->b_data + le16_to_cpu(entry->e_value_offs),
-		       size);
+		if (entry->e_value_inum) {
+			error = ext4_xattr_inode_get(inode,
+					     le32_to_cpu(entry->e_value_inum),
+					     buffer, &size);
+			if (error)
+				goto cleanup;
+		} else {
+			memcpy(buffer, bh->b_data + le16_to_cpu(entry->e_value_offs),
+			       size);
+		}
 	}
 	error = size;
 
@@ -285,7 +357,7 @@ ext4_xattr_ibody_get(struct inode *inode
 	if (error)
 		goto cleanup;
 	error = ext4_xattr_find_entry(&entry, name_index, name,
-				      end - (void *)entry, 0);
+				      end - (void *)entry, 0, inode);
 	if (error)
 		goto cleanup;
 	size = le32_to_cpu(entry->e_value_size);
@@ -293,8 +365,16 @@ ext4_xattr_ibody_get(struct inode *inode
 		error = -ERANGE;
 		if (size > buffer_size)
 			goto cleanup;
-		memcpy(buffer, (void *)IFIRST(header) +
-		       le16_to_cpu(entry->e_value_offs), size);
+		if (entry->e_value_inum) {
+			error = ext4_xattr_inode_get(inode,
+		       			     le32_to_cpu(entry->e_value_inum),
+					     buffer, &size);
+			if (error)
+				goto cleanup;
+		} else {
+			memcpy(buffer, (void *)IFIRST(header) +
+			       le16_to_cpu(entry->e_value_offs), size);
+		}
 	}
 	error = size;
 
@@ -505,6 +585,130 @@ ext4_xattr_release_block(handle_t *handl
 	}
 }
 
+/*
+ * Write the value of the EA in an inode.
+ */
+static int
+ext4_xattr_inode_write(handle_t *handle, struct inode *ea_inode,
+		       const void *buf, int bufsize)
+{
+	struct buffer_head *bh = NULL;
+	unsigned long block = 0;
+	int err, blocksize, csize;
+
+	blocksize = ea_inode->i_sb->s_blocksize;
+	while (bufsize > 0) {
+		if (bh != NULL)
+			brelse(bh);
+		csize = blocksize < bufsize ? blocksize : bufsize;
+		bh = ext4_getblk(handle, ea_inode, block, 1, &err);
+		if (!bh)
+			goto out;
+		err = ext4_journal_get_write_access(handle, bh);
+		if (err)
+			goto out;
+		memcpy(bh->b_data, buf, csize);
+
+		ea_inode->i_size += csize;
+		buf += csize;
+		bufsize -= csize;
+		block += 1;
+	}
+out:
+	if (bh)
+		brelse(bh);
+	EXT4_I(ea_inode)->i_disksize = ea_inode->i_size;
+	ext4_mark_inode_dirty(handle, ea_inode);
+
+	return err;
+}
+
+/*
+ * Create an inode to store the value of a large EA.
+ */
+static struct inode *
+ext4_xattr_inode_create(handle_t *handle, struct inode *inode)
+{
+	struct inode *ea_inode = NULL;
+
+	/* Let the next inode be the goal, so we try and allocate the EA inode
+	 * in the same group, or nearby one.
+	 */
+	ea_inode = ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
+				  S_IFREG|0600, inode->i_ino + 1);
+	if (!IS_ERR(ea_inode)) {
+		ea_inode->i_op = &ext4_file_inode_operations;
+		ea_inode->i_fop = &ext4_file_operations;
+		ext4_set_aops(inode);
+		ea_inode->i_generation = inode->i_generation;
+		ea_inode->i_flags |= EXT4_EA_INODE_FL;
+		EXT4_SB(ea_inode->i_sb)->s_es->s_feature_incompat |=
+			cpu_to_le32(EXT4_FEATURE_INCOMPAT_EA_INODE);
+	}
+
+	return ea_inode;
+}
+
+/*
+ * Unlink the inode storing the value of the EA.
+ */
+static int
+ext4_xattr_inode_unlink(handle_t *handle, struct inode *inode, int ea_ino)
+{
+	struct inode *ea_inode = NULL;
+
+	ea_inode = iget(inode->i_sb, ea_ino);
+	if (ea_inode == NULL || is_bad_inode(ea_inode)) {
+		ext4_error(inode->i_sb, "ext4_xattr_inode_unlink",
+			   "error while reading EA inode %d", ea_ino);
+		return -EIO;
+	}
+
+	ea_inode->i_nlink = 0;
+	iput(ea_inode);
+
+	return 0;
+}
+
+/*
+ * Add value of the EA in an inode.
+ */
+static int
+ext4_xattr_inode_set(handle_t *handle, struct inode *inode, int *ea_ino,
+		     const void *value, size_t value_len)
+{
+	struct inode *ea_inode = NULL;
+	int req_buffer_credits;
+	int err;
+
+	/* Create an inode for the EA value */
+	ea_inode = ext4_xattr_inode_create(handle, inode);
+	if (IS_ERR(ea_inode)) {
+		return -1;
+	}
+
+	/*
+	 * Make sure that enough buffer credits are available else extend the
+	 * transaction.
+	 */
+	req_buffer_credits = (value_len / inode->i_sb->s_blocksize) + 4;
+	if (handle->h_buffer_credits <= req_buffer_credits) {
+		if (ext4_journal_extend(handle, req_buffer_credits)) {
+			ext4_mark_inode_dirty(handle, inode);
+			ext4_journal_restart(handle, req_buffer_credits);
+		}
+	}
+	err = ext4_xattr_inode_write(handle, ea_inode, value, value_len);
+	if (err)
+		ea_inode->i_nlink=0;
+	else
+		*ea_ino = ea_inode->i_ino;
+
+	iput(ea_inode);
+
+	return err;
+}
+
 struct ext4_xattr_info {
 	int name_index;
 	const char *name;
@@ -521,15 +725,20 @@ struct ext4_xattr_search {
 };
 
 static int
-ext4_xattr_set_entry(struct ext4_xattr_info *i, struct ext4_xattr_search *s)
+ext4_xattr_set_entry(struct ext4_xattr_info *i, struct ext4_xattr_search *s,
+		     handle_t *handle, struct inode *inode)
 {
 	struct ext4_xattr_entry *last;
 	size_t free, min_offs = s->end - s->base, name_len = strlen(i->name);
+	int in_inode = 0;
+
+	if (EXT4_XATTR_SIZE(i->value_len) > EXT4_XATTR_MIN_LARGE_EA_SIZE)
+		in_inode++;
 
 	/* Compute min_offs and last. */
 	last = s->first;
 	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
-		if (!last->e_value_block && last->e_value_size) {
+		if (!last->e_value_inum && last->e_value_size) {
 			size_t offs = le16_to_cpu(last->e_value_offs);
 			if (offs < min_offs)
 				min_offs = offs;
@@ -537,16 +746,23 @@ ext4_xattr_set_entry(struct ext4_xattr_i
 	}
 	free = min_offs - ((void *)last - s->base) - sizeof(__u32);
 	if (!s->not_found) {
-		if (!s->here->e_value_block && s->here->e_value_size) {
+		if (!in_inode && !s->here->e_value_inum &&
+		    s->here->e_value_size) {
 			size_t size = le32_to_cpu(s->here->e_value_size);
 			free += EXT4_XATTR_SIZE(size);
 		}
 		free += EXT4_XATTR_LEN(name_len);
 	}
 	if (i->value) {
-		if (free < EXT4_XATTR_SIZE(i->value_len) ||
-		    free < EXT4_XATTR_LEN(name_len) +
-			   EXT4_XATTR_SIZE(i->value_len))
+		size_t value_len = EXT4_XATTR_SIZE(i->value_len);
+
+		if (in_inode) {
+			if (value_len > EXT4_XATTR_MAX_LARGE_EA_SIZE)
+				return -ENOSPC;
+			value_len = 0;
+		}
+		if (free < value_len || free < EXT4_XATTR_LEN(name_len) +
+		    value_len || value_len > EXT4_XATTR_MAX_LARGE_EA_SIZE)
 			return -ENOSPC;
 	}
 
@@ -560,7 +776,8 @@ ext4_xattr_set_entry(struct ext4_xattr_i
 		s->here->e_name_len = name_len;
 		memcpy(s->here->e_name, i->name, name_len);
 	} else {
-		if (!s->here->e_value_block && s->here->e_value_size) {
+		if (s->here->e_value_offs && !s->here->e_value_inum &&
+		    s->here->e_value_size) {
 			void *first_val = s->base + min_offs;
 			size_t offs = le16_to_cpu(s->here->e_value_offs);
 			void *val = s->base + offs;
@@ -589,13 +806,16 @@ ext4_xattr_set_entry(struct ext4_xattr_i
 			last = s->first;
 			while (!IS_LAST_ENTRY(last)) {
 				size_t o = le16_to_cpu(last->e_value_offs);
-				if (!last->e_value_block &&
-				    last->e_value_size && o < offs)
+				if (last->e_value_size && o < offs)
 					last->e_value_offs =
 						cpu_to_le16(o + size);
 				last = EXT4_XATTR_NEXT(last);
 			}
 		}
+		if (s->here->e_value_inum) {
+			ext4_xattr_inode_unlink(handle, inode, s->here->e_value_inum);
+			s->here->e_value_inum = 0;
+		}
 		if (!i->value) {
 			/* Remove the old name. */
 			size_t size = EXT4_XATTR_LEN(name_len);
@@ -609,13 +829,24 @@ ext4_xattr_set_entry(struct ext4_xattr_i
 	if (i->value) {
 		/* Insert the new value. */
 		s->here->e_value_size = cpu_to_le32(i->value_len);
-		if (i->value_len) {
-			size_t size = EXT4_XATTR_SIZE(i->value_len);
-			void *val = s->base + min_offs - size;
-			s->here->e_value_offs = cpu_to_le16(min_offs - size);
-			memset(val + size - EXT4_XATTR_PAD, 0,
-			       EXT4_XATTR_PAD); /* Clear the pad bytes. */
-			memcpy(val, i->value, i->value_len);
+		if (in_inode) {
+			int ea_ino = s->here->e_value_inum;
+			ext4_xattr_inode_set(handle, inode, &ea_ino, i->value,
+					     i->value_len);
+			s->here->e_value_inum = ea_ino;
+			s->here->e_value_offs = 0;
+		} else {
+			if (i->value_len) {
+				size_t size = EXT4_XATTR_SIZE(i->value_len);
+				void *val = s->base + min_offs - size;
+				s->here->e_value_offs = cpu_to_le16(min_offs -
+								    size);
+				s->here->e_value_inum = 0;
+				/* Clear the pad bytes */
+				memset(val + size - EXT4_XATTR_PAD, 0,
+				       EXT4_XATTR_PAD);
+				memcpy(val, i->value, i->value_len);
+			}
 		}
 	}
 	return 0;
@@ -658,7 +889,7 @@ ext4_xattr_block_find(struct inode *inod
 		bs->s.end = bs->bh->b_data + bs->bh->b_size;
 		bs->s.here = bs->s.first;
 		error = ext4_xattr_find_entry(&bs->s.here, i->name_index,
-					      i->name, bs->bh->b_size, 1);
+					      i->name, bs->bh->b_size, 1, inode);
 		if (error && error != -ENODATA)
 			goto cleanup;
 		bs->s.not_found = error;
@@ -682,8 +913,6 @@ ext4_xattr_block_set(handle_t *handle, s
 
 #define header(x) ((struct ext4_xattr_header *)(x))
 
-	if (i->value && i->value_len > sb->s_blocksize)
-		return -ENOSPC;
 	if (s->base) {
 		ce = mb_cache_entry_get(ext4_xattr_cache, bs->bh->b_bdev,
 					bs->bh->b_blocknr);
@@ -697,7 +926,7 @@ ext4_xattr_block_set(handle_t *handle, s
 			if (error)
 				goto cleanup;
 			lock_buffer(bs->bh);
-			error = ext4_xattr_set_entry(i, s);
+			error = ext4_xattr_set_entry(i, s, handle, inode);
 			if (!error) {
 				if (!IS_LAST_ENTRY(s->first))
 					ext4_xattr_rehash(header(s->base),
@@ -747,7 +976,7 @@ ext4_xattr_block_set(handle_t *handle, s
 		s->end = s->base + sb->s_blocksize;
 	}
 
-	error = ext4_xattr_set_entry(i, s);
+	error = ext4_xattr_set_entry(i, s, handle, inode);
 	if (error == -EIO)
 		goto bad_block;
 	if (error)
@@ -882,7 +1111,7 @@ ext4_xattr_ibody_find(struct inode *inod
 		/* Find the named attribute. */
 		error = ext4_xattr_find_entry(&is->s.here, i->name_index,
 					      i->name, is->s.end -
-					      (void *)is->s.base, 0);
+					      (void *)is->s.base, 0, inode);
 		if (error && error != -ENODATA)
 			return error;
 		is->s.not_found = error;
@@ -901,7 +1130,7 @@ ext4_xattr_ibody_set(handle_t *handle, s
 
 	if (EXT4_I(inode)->i_extra_isize == 0)
 		return -ENOSPC;
-	error = ext4_xattr_set_entry(i, s);
+	error = ext4_xattr_set_entry(i, s, handle, inode);
 	if (error)
 		return error;
 	header = IHDR(inode, ext4_raw_inode(&is->iloc));
@@ -1038,10 +1267,21 @@ ext4_xattr_set(struct inode *inode, int 
 	       const void *value, size_t value_len, int flags)
 {
 	handle_t *handle;
+	int buffer_credits;
 	int error, retries = 0;
 
+	buffer_credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
+	if (value_len >= EXT4_XATTR_MIN_LARGE_EA_SIZE) {
+		/* For ext4_new_inode */
+		buffer_credits +=  EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
+					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
+					2*EXT4_QUOTA_INIT_BLOCKS(inode->i_sb);;
+		/* For the blocks to be written in the EA inode */
+		buffer_credits += value_len / inode->i_sb->s_blocksize;
+	}
+
 retry:
-	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+	handle = ext4_journal_start(inode, buffer_credits);
 	if (IS_ERR(handle)) {
 		error = PTR_ERR(handle);
 	} else {
@@ -1162,10 +1402,9 @@ ext4_xattr_cmp(struct ext4_xattr_header 
 		    entry1->e_name_index != entry2->e_name_index ||
 		    entry1->e_name_len != entry2->e_name_len ||
 		    entry1->e_value_size != entry2->e_value_size ||
+		    entry1->e_value_inum != entry2->e_value_inum ||
 		    memcmp(entry1->e_name, entry2->e_name, entry1->e_name_len))
 			return 1;
-		if (entry1->e_value_block != 0 || entry2->e_value_block != 0)
-			return -EIO;
 		if (memcmp((char *)header1 + le16_to_cpu(entry1->e_value_offs),
 			   (char *)header2 + le16_to_cpu(entry2->e_value_offs),
 			   le32_to_cpu(entry1->e_value_size)))
@@ -1250,7 +1489,7 @@ static inline void ext4_xattr_hash_entry
 		       *name++;
 	}
 
-	if (entry->e_value_block == 0 && entry->e_value_size != 0) {
+	if (entry->e_value_inum == 0 && entry->e_value_size != 0) {
 		__le32 *value = (__le32 *)((char *)header +
 			le16_to_cpu(entry->e_value_offs));
 		for (n = (le32_to_cpu(entry->e_value_size) +
Index: linux-2.6.19/fs/ext4/xattr.h
===================================================================
--- linux-2.6.19.orig/fs/ext4/xattr.h
+++ linux-2.6.19/fs/ext4/xattr.h
@@ -38,7 +38,7 @@ struct ext4_xattr_entry {
 	__u8	e_name_len;	/* length of name */
 	__u8	e_name_index;	/* attribute name index */
 	__le16	e_value_offs;	/* offset in disk block of value */
-	__le32	e_value_block;	/* disk block attribute is stored on (n/i) */
+	__le32	e_value_inum;	/* inode in which the value is stored */
 	__le32	e_value_size;	/* size of attribute value */
 	__le32	e_hash;		/* hash value of name and value */
 	char	e_name[0];	/* attribute name */
@@ -56,6 +56,9 @@ struct ext4_xattr_entry {
 #define EXT4_XATTR_SIZE(size) \
 	(((size) + EXT4_XATTR_ROUND) & ~EXT4_XATTR_ROUND)
 
+#define EXT4_XATTR_MIN_LARGE_EA_SIZE	2048
+#define EXT4_XATTR_MAX_LARGE_EA_SIZE	(64 * 1024)
+
 # ifdef CONFIG_EXT4DEV_FS_XATTR
 
 extern struct xattr_handler ext4_xattr_user_handler;
Index: linux-2.6.19/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.19.orig/include/linux/ext4_fs.h
+++ linux-2.6.19/include/linux/ext4_fs.h
@@ -191,6 +191,7 @@ struct ext4_group_desc
 #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
+#define EXT4_EA_INODE_FL		0x00100000 /* Inode used for large EA */
 
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
@@ -604,13 +605,15 @@ static inline int ext4_valid_inum(struct
 #define EXT4_FEATURE_INCOMPAT_META_BG		0x0010
 #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
+#define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0100
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT4_FEATURE_INCOMPAT_RECOVER| \
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+					 EXT4_FEATURE_INCOMPAT_64BIT | \
+					 EXT4_FEATURE_INCOMPAT_EA_INODE)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR)
@@ -826,7 +829,8 @@ extern int ext4fs_dirhash(const char *na
 			  dx_hash_info *hinfo);
 
 /* ialloc.c */
-extern struct inode * ext4_new_inode (handle_t *, struct inode *, int);
+extern struct inode * ext4_new_inode (handle_t *, struct inode *, int,
+				      unsigned long);
 extern void ext4_free_inode (handle_t *, struct inode *);
 extern struct inode * ext4_orphan_get (struct super_block *, unsigned long);
 extern unsigned long ext4_count_free_inodes (struct super_block *);
Index: linux-2.6.19/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.19.orig/fs/ext4/ialloc.c
+++ linux-2.6.19/fs/ext4/ialloc.c
@@ -423,8 +423,12 @@ static int find_group_other(struct super
  *
  * For other inodes, search forward from the parent directory's block
  * group to find a free inode.
+ *
+ * If a goal inode is specified then try to allocate it else continue
+ * allocation as is.
  */
-struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
+struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode,
+			     unsigned long goal)
 {
 	struct super_block *sb;
 	struct buffer_head *bitmap_bh = NULL;
@@ -452,6 +456,41 @@ struct inode *ext4_new_inode(handle_t *h
 
 	sbi = EXT4_SB(sb);
 	es = sbi->s_es;
+
+	if (goal) {
+		group = (goal - 1) / EXT4_INODES_PER_GROUP(sb);
+		ino = (goal - 1) % EXT4_INODES_PER_GROUP(sb);
+		err = -EIO;
+
+		gdp = ext4_get_group_desc(sb, group, &bh2);
+		if (!gdp)
+			goto fail;
+
+		bitmap_bh = read_inode_bitmap (sb, group);
+		if (!bitmap_bh)
+			goto fail;
+
+		BUFFER_TRACE(bh, "get_write_access");
+		err = ext4_journal_get_write_access(handle, bitmap_bh);
+		if (err)
+			goto fail;
+
+		if (ext4_set_bit_atomic(sb_bgl_lock(sbi, group),
+					ino, bitmap_bh->b_data)) {
+			goto continue_allocation;
+		}
+
+		BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
+		err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+		if (err)
+			goto fail;
+
+		/* We've shortcircuited the allocation system successfully,
+		 * now finish filling in the inode.
+		 */
+		goto got;
+	}
+
 	if (S_ISDIR(mode)) {
 		if (test_opt (sb, OLDALLOC))
 			group = find_group_dir(sb, dir);
@@ -460,6 +499,8 @@ struct inode *ext4_new_inode(handle_t *h
 	} else
 		group = find_group_other(sb, dir);
 
+continue_allocation:
+
 	err = -ENOSPC;
 	if (group == -1)
 		goto out;
Index: linux-2.6.19/fs/ext4/namei.c
===================================================================
--- linux-2.6.19.orig/fs/ext4/namei.c
+++ linux-2.6.19/fs/ext4/namei.c
@@ -1661,7 +1661,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, mode);
+	inode = ext4_new_inode (handle, dir, mode, 0);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		inode->i_op = &ext4_file_inode_operations;
@@ -1695,7 +1695,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, mode);
+	inode = ext4_new_inode (handle, dir, mode, 0);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
@@ -1731,7 +1731,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, S_IFDIR | mode);
+	inode = ext4_new_inode (handle, dir, S_IFDIR | mode, 0);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
@@ -2136,7 +2136,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, S_IFLNK|S_IRWXUGO);
+	inode = ext4_new_inode (handle, dir, S_IFLNK|S_IRWXUGO, 0);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;

--=-tdkxcPWs4VyVUBoebkik--
