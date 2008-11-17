From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH 2/2] Large EAs
Date: Tue, 18 Nov 2008 02:06:13 +0530
Message-ID: <1226954173.3972.70.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_HVHeWB1RxV8wxUSzEIpXrQ)"
Cc: TheodoreTso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Andreas Dilger <adilger@Sun.COM>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:44160 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYKQUzV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2008 15:55:21 -0500
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id mAHKZWCs000178
	for <linux-ext4@vger.kernel.org>; Mon, 17 Nov 2008 20:35:32 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0KAH00701VT6D500@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Tue,
 18 Nov 2008 04:35:32 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_HVHeWB1RxV8wxUSzEIpXrQ)
Content-type: text/plain
Content-transfer-encoding: 7BIT

This is the implementation for large EA support in ext4. Note that this also helps to have a larger number of EAs since large EAs get written out to a new inode instead of the EA block.

If value of an attribute is greater than 1/2 the blocksize, the value is not saved in the external EA block, instead it is saved in an inode. The EA entry saves the inode number in e_value_inum field (earlier this was
e_value_block that was unused). The EA inode has the same generation as the parent inode and the mtime of the EA inode is set to the inode number of the parent. A new EXT4_FEATURE_INCOMPAT_EA_INODE feature has been added for this.

This "large_xattr" feature is not enabled automatically and needs to be enabled by mkfs or using tune2fs. 

Signed-off-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>

 ext4.h  |    7 -
 xattr.c |  413 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 xattr.h |   11 +
 3 files changed, 386 insertions(+), 45 deletions(-)

Thanks,
Kalpak

--Boundary_(ID_HVHeWB1RxV8wxUSzEIpXrQ)
Content-type: text/x-patch; charset=UTF-8; name=ext4-large-eas.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=ext4-large-eas.patch

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: linux-2.6.27/fs/ext4/xattr.c
===================================================================
--- linux-2.6.27.orig/fs/ext4/xattr.c
+++ linux-2.6.27/fs/ext4/xattr.c
@@ -168,19 +168,27 @@ ext4_xattr_check_block(struct buffer_hea
 }
 
 static inline int
-ext4_xattr_check_entry(struct ext4_xattr_entry *entry, size_t size)
+ext4_xattr_check_entry(struct ext4_xattr_entry *entry, size_t size,
+		       struct inode *inode)
 {
 	size_t value_size = le32_to_cpu(entry->e_value_size);
 
-	if (entry->e_value_block != 0 || value_size > size ||
-	    le16_to_cpu(entry->e_value_offs) + value_size > size)
+	if ((entry->e_value_inum == 0) &&
+	    (value_size > size ||
+	     le16_to_cpu(entry->e_value_offs) + value_size > size))
+		return -EIO;
+	if (entry->e_value_inum &&
+	    (entry->e_value_inum < le32_to_cpu(EXT4_FIRST_INO(inode->i_sb)) ||
+	     entry->e_value_inum > le32_to_cpu(EXT4_SB(inode->i_sb)->
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
@@ -200,11 +208,103 @@ ext4_xattr_find_entry(struct ext4_xattr_
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
+		return 0;
+
+	blocksize = ea_inode->i_sb->s_blocksize;
+
+	while (ret_size < *size) {
+		csize = (*size - ret_size) > blocksize ? blocksize :
+							*size - ret_size;
+		bh = ext4_bread(NULL, ea_inode, block, 0, &err);
+		if (!bh)
+			return err;
+
+		memcpy(buf, bh->b_data, csize);
+		brelse(bh);
+
+		buf += csize;
+		block += 1;
+		ret_size += csize;
+	}
+
+	*size = ret_size;
+
+	return err;
+}
+
+struct inode *ext4_xattr_inode_iget(struct inode *parent, int ea_ino, int *err)
+{
+	struct inode *ea_inode = NULL;
+
+	ea_inode = ext4_iget(parent->i_sb, ea_ino);
+	if (ea_inode == NULL || is_bad_inode(ea_inode)) {
+		ext4_error(parent->i_sb, __func__,
+			   "error while reading EA inode %d", ea_ino);
+		*err = -EIO;
+		return NULL;
+	}
+
+	if (ea_inode->i_xattr_inode_parent != parent->i_ino ||
+	    ea_inode->i_generation != parent->i_generation) {
+		ext4_error(parent->i_sb, __func__,
+			   "Backpointer from EA inode %d to parent invalid.",
+			   ea_ino);
+		*err = -EINVAL;
+		goto error;
+	}
+
+	if (!(EXT4_I(ea_inode)->i_flags & EXT4_EA_INODE_FL)) {
+		ext4_error(parent->i_sb, __func__, "EA inode %d does not "
+			   "have EXT4_EA_INODE_FL flag set.\n", ea_ino);
+		*err = -EINVAL;
+		goto error;
+	}
+
+	*err = 0;
+	return ea_inode;
+
+error:
+	iput(ea_inode);
+	return NULL;
+}
+
+/*
+ * Read the value from the EA inode.
+ */
+static int
+ext4_xattr_inode_get(struct inode *inode, int ea_ino, void *buffer,
+		     size_t *size)
+{
+	struct inode *ea_inode = NULL;
+	int err;
+
+	ea_inode = ext4_xattr_inode_iget(inode, ea_ino, &err);
+	if (err)
+		return err;
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
@@ -235,7 +335,8 @@ bad_block:	ext4_error(inode->i_sb, __fun
 	}
 	ext4_xattr_cache_insert(bh);
 	entry = BFIRST(bh);
-	error = ext4_xattr_find_entry(&entry, name_index, name, bh->b_size, 1);
+	error = ext4_xattr_find_entry(&entry, name_index, name, bh->b_size, 1,
+				      inode);
 	if (error == -EIO)
 		goto bad_block;
 	if (error)
@@ -245,8 +346,16 @@ bad_block:	ext4_error(inode->i_sb, __fun
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
+			memcpy(buffer, bh->b_data +
+			       le16_to_cpu(entry->e_value_offs), size);
+		}
 	}
 	error = size;
 
@@ -280,7 +389,7 @@ ext4_xattr_ibody_get(struct inode *inode
 	if (error)
 		goto cleanup;
 	error = ext4_xattr_find_entry(&entry, name_index, name,
-				      end - (void *)entry, 0);
+				      end - (void *)entry, 0, inode);
 	if (error)
 		goto cleanup;
 	size = le32_to_cpu(entry->e_value_size);
@@ -288,8 +397,16 @@ ext4_xattr_ibody_get(struct inode *inode
 		error = -ERANGE;
 		if (size > buffer_size)
 			goto cleanup;
-		memcpy(buffer, (void *)IFIRST(header) +
-		       le16_to_cpu(entry->e_value_offs), size);
+		if (entry->e_value_inum) {
+			error = ext4_xattr_inode_get(inode,
+					     le32_to_cpu(entry->e_value_inum),
+					     buffer, &size);
+			if (error)
+				goto cleanup;
+		} else {
+			memcpy(buffer, (void *)IFIRST(header) +
+			       le16_to_cpu(entry->e_value_offs), size);
+		}
 	}
 	error = size;
 
@@ -511,7 +628,7 @@ static size_t ext4_xattr_free_space(stru
 {
 	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
 		*total += EXT4_XATTR_LEN(last->e_name_len);
-		if (!last->e_value_block && last->e_value_size) {
+		if (!last->e_value_inum && last->e_value_size) {
 			size_t offs = le16_to_cpu(last->e_value_offs);
 			if (offs < *min_offs)
 				*min_offs = offs;
@@ -520,6 +637,149 @@ static size_t ext4_xattr_free_space(stru
 	return (*min_offs - ((void *)last - base) - sizeof(__u32));
 }
 
+/*
+ * Write the value of the EA in an inode.
+ */
+static int
+ext4_xattr_inode_write(handle_t *handle, struct inode *ea_inode,
+		       const void *buf, int bufsize)
+{
+	struct buffer_head *bh = NULL, dummy;
+	unsigned long block = 0;
+	unsigned blocksize = ea_inode->i_sb->s_blocksize;
+	unsigned max_blocks = (bufsize + blocksize - 1) >> ea_inode->i_blkbits;
+	int csize, wsize = 0;
+	int ret = 0;
+	int retries = 0;
+
+retry:
+	while (ret >= 0 && ret < max_blocks) {
+		block += ret;
+		max_blocks -= ret;
+
+		ret = ext4_get_blocks_wrap(handle, ea_inode, block, max_blocks,
+					   &dummy, 1, 1, 0);
+		if (ret <= 0) {
+			ext4_mark_inode_dirty(handle, ea_inode);
+			if (ret == -ENOSPC &&
+			    ext4_should_retry_alloc(ea_inode->i_sb, &retries)) {
+				ret = 0;
+				goto retry;
+			}
+			break;
+		}
+	}
+
+	block = 0;
+	while (wsize < bufsize) {
+		if (bh != NULL)
+			brelse(bh);
+		csize = (bufsize - wsize) > blocksize ? blocksize :
+								bufsize - wsize;
+		bh = ext4_getblk(handle, ea_inode, block, 0, &ret);
+		if (!bh)
+			goto out;
+		ret = ext4_journal_get_write_access(handle, bh);
+		if (ret)
+			goto out;
+
+		memcpy(bh->b_data, buf, csize);
+		set_buffer_uptodate(bh);
+		ext4_journal_dirty_metadata(handle, bh);
+
+		buf += csize;
+		wsize += csize;
+		block += 1;
+	}
+
+	i_size_write(ea_inode, wsize);
+	ext4_update_i_disksize(ea_inode, wsize);
+
+	ext4_mark_inode_dirty(handle, ea_inode);
+
+out:
+	brelse(bh);
+
+	return ret;
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
+	/*
+	 * Let the next inode be the goal, so we try and allocate the EA inode
+	 * in the same group, or nearby one.
+	 */
+	ea_inode = ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
+				  S_IFREG|0600, inode->i_ino + 1);
+
+	if (!IS_ERR(ea_inode)) {
+		ea_inode->i_op = &ext4_file_inode_operations;
+		ea_inode->i_fop = &ext4_file_operations;
+		ext4_set_aops(inode);
+		ea_inode->i_generation = inode->i_generation;
+		EXT4_I(ea_inode)->i_flags |= EXT4_EA_INODE_FL;
+
+		/*
+		 * A back-pointer from EA inode to parent inode will be useful
+		 * for e2fsck.
+		 */
+		ea_inode->i_xattr_inode_parent = inode->i_ino;
+	}
+
+	return ea_inode;
+}
+
+/*
+ * Unlink the inode storing the value of the EA.
+ */
+static int
+ext4_xattr_inode_unlink(struct inode *inode, int ea_ino)
+{
+	struct inode *ea_inode = NULL;
+	int err;
+
+	ea_inode = ext4_xattr_inode_iget(inode, ea_ino, &err);
+	if (err)
+		return err;
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
+	int err;
+
+	/* Create an inode for the EA value */
+	ea_inode = ext4_xattr_inode_create(handle, inode);
+	if (IS_ERR(ea_inode))
+		return -1;
+
+	err = ext4_xattr_inode_write(handle, ea_inode, value, value_len);
+	if (err)
+		ea_inode->i_nlink = 0;
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
@@ -536,15 +796,23 @@ struct ext4_xattr_search {
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
+	if ((EXT4_SB(inode->i_sb)->s_es->s_feature_incompat &
+	     EXT4_FEATURE_INCOMPAT_EA_INODE) &&
+	    (EXT4_XATTR_SIZE(i->value_len) >
+	     EXT4_XATTR_MIN_LARGE_EA_SIZE(inode->i_sb->s_blocksize)))
+		in_inode++;
 
 	/* Compute min_offs and last. */
 	last = s->first;
 	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
-		if (!last->e_value_block && last->e_value_size) {
+		if (!last->e_value_inum && last->e_value_size) {
 			size_t offs = le16_to_cpu(last->e_value_offs);
 			if (offs < min_offs)
 				min_offs = offs;
@@ -552,16 +820,21 @@ ext4_xattr_set_entry(struct ext4_xattr_i
 	}
 	free = min_offs - ((void *)last - s->base) - sizeof(__u32);
 	if (!s->not_found) {
-		if (!s->here->e_value_block && s->here->e_value_size) {
+		if (in_inode == 0 && !s->here->e_value_inum &&
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
+		if (in_inode)
+			value_len = 0;
+
+		if (free < value_len ||
+		    free < EXT4_XATTR_LEN(name_len) + value_len)
 			return -ENOSPC;
 	}
 
@@ -575,7 +848,8 @@ ext4_xattr_set_entry(struct ext4_xattr_i
 		s->here->e_name_len = name_len;
 		memcpy(s->here->e_name, i->name, name_len);
 	} else {
-		if (!s->here->e_value_block && s->here->e_value_size) {
+		if (s->here->e_value_offs && !s->here->e_value_inum &&
+		    s->here->e_value_size) {
 			void *first_val = s->base + min_offs;
 			size_t offs = le16_to_cpu(s->here->e_value_offs);
 			void *val = s->base + offs;
@@ -604,13 +878,16 @@ ext4_xattr_set_entry(struct ext4_xattr_i
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
+			ext4_xattr_inode_unlink(inode, s->here->e_value_inum);
+			s->here->e_value_inum = 0;
+		}
 		if (!i->value) {
 			/* Remove the old name. */
 			size_t size = EXT4_XATTR_LEN(name_len);
@@ -624,13 +901,24 @@ ext4_xattr_set_entry(struct ext4_xattr_i
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
@@ -673,7 +961,7 @@ ext4_xattr_block_find(struct inode *inod
 		bs->s.end = bs->bh->b_data + bs->bh->b_size;
 		bs->s.here = bs->s.first;
 		error = ext4_xattr_find_entry(&bs->s.here, i->name_index,
-					      i->name, bs->bh->b_size, 1);
+					     i->name, bs->bh->b_size, 1, inode);
 		if (error && error != -ENODATA)
 			goto cleanup;
 		bs->s.not_found = error;
@@ -697,8 +985,6 @@ ext4_xattr_block_set(handle_t *handle, s
 
 #define header(x) ((struct ext4_xattr_header *)(x))
 
-	if (i->value && i->value_len > sb->s_blocksize)
-		return -ENOSPC;
 	if (s->base) {
 		ce = mb_cache_entry_get(ext4_xattr_cache, bs->bh->b_bdev,
 					bs->bh->b_blocknr);
@@ -713,7 +999,7 @@ ext4_xattr_block_set(handle_t *handle, s
 				ce = NULL;
 			}
 			ea_bdebug(bs->bh, "modifying in-place");
-			error = ext4_xattr_set_entry(i, s);
+			error = ext4_xattr_set_entry(i, s, handle, inode);
 			if (!error) {
 				if (!IS_LAST_ENTRY(s->first))
 					ext4_xattr_rehash(header(s->base),
@@ -764,7 +1050,7 @@ ext4_xattr_block_set(handle_t *handle, s
 		s->end = s->base + sb->s_blocksize;
 	}
 
-	error = ext4_xattr_set_entry(i, s);
+	error = ext4_xattr_set_entry(i, s, handle, inode);
 	if (error == -EIO)
 		goto bad_block;
 	if (error)
@@ -896,7 +1182,7 @@ ext4_xattr_ibody_find(struct inode *inod
 		/* Find the named attribute. */
 		error = ext4_xattr_find_entry(&is->s.here, i->name_index,
 					      i->name, is->s.end -
-					      (void *)is->s.base, 0);
+					      (void *)is->s.base, 0, inode);
 		if (error && error != -ENODATA)
 			return error;
 		is->s.not_found = error;
@@ -915,7 +1201,7 @@ ext4_xattr_ibody_set(handle_t *handle, s
 
 	if (EXT4_I(inode)->i_extra_isize == 0)
 		return -ENOSPC;
-	error = ext4_xattr_set_entry(i, s);
+	error = ext4_xattr_set_entry(i, s, handle, inode);
 	if (error)
 		return error;
 	header = IHDR(inode, ext4_raw_inode(&is->iloc));
@@ -1065,10 +1351,26 @@ ext4_xattr_set(struct inode *inode, int 
 	       const void *value, size_t value_len, int flags)
 {
 	handle_t *handle;
+	struct super_block *sb = inode->i_sb;
+	int buffer_credits;
 	int error, retries = 0;
 
+	buffer_credits = EXT4_DATA_TRANS_BLOCKS(sb);
+	if ((value_len >= EXT4_XATTR_MIN_LARGE_EA_SIZE(sb->s_blocksize)) &&
+	    (EXT4_SB(sb)->s_es->s_feature_incompat &
+	     EXT4_FEATURE_INCOMPAT_EA_INODE)) {
+		int nrblocks = (value_len + sb->s_blocksize - 1) /
+								sb->s_blocksize;
+
+		/* For new inode */
+		buffer_credits += EXT4_SINGLEDATA_TRANS_BLOCKS(sb) + 3;
+
+		/* For data blocks of EA inode */
+		buffer_credits += ext4_meta_trans_blocks(inode, nrblocks, 0);
+	}
+
 retry:
-	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+	handle = ext4_journal_start(inode, buffer_credits);
 	if (IS_ERR(handle)) {
 		error = PTR_ERR(handle);
 	} else {
@@ -1078,7 +1380,7 @@ retry:
 					      value, value_len, flags);
 		error2 = ext4_journal_stop(handle);
 		if (error == -ENOSPC &&
-		    ext4_should_retry_alloc(inode->i_sb, &retries))
+		    ext4_should_retry_alloc(sb, &retries))
 			goto retry;
 		if (error == 0)
 			error = error2;
@@ -1100,7 +1402,7 @@ static void ext4_xattr_shift_entries(str
 
 	/* Adjust the value offsets of the entries */
 	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
-		if (!last->e_value_block && last->e_value_size) {
+		if (!last->e_value_inum && last->e_value_size) {
 			new_offs = le16_to_cpu(last->e_value_offs) +
 							value_offs_shift;
 			BUG_ON(new_offs + le32_to_cpu(last->e_value_size)
@@ -1337,7 +1639,8 @@ cleanup:
 /*
  * ext4_xattr_delete_inode()
  *
- * Free extended attribute resources associated with this inode. This
+ * Free extended attribute resources associated with this inode. Traverse
+ * all the entries and unlink any EA-inodes associated with this inode. This
  * is called immediately before an inode is freed. We have exclusive
  * access to the inode.
  */
@@ -1345,7 +1648,29 @@ void
 ext4_xattr_delete_inode(handle_t *handle, struct inode *inode)
 {
 	struct buffer_head *bh = NULL;
+	struct ext4_xattr_ibody_header *header;
+	struct ext4_inode *raw_inode;
+	struct ext4_iloc iloc;
+	struct ext4_xattr_entry *entry;
+	int error;
+
+	if (!(EXT4_I(inode)->i_state & EXT4_STATE_XATTR))
+		goto delete_external_ea;
+
+	error = ext4_get_inode_loc(inode, &iloc);
+	if (error)
+		goto cleanup;
+	raw_inode = ext4_raw_inode(&iloc);
+	header = IHDR(inode, raw_inode);
+	entry = IFIRST(header);
+	for (; !IS_LAST_ENTRY(entry); entry = EXT4_XATTR_NEXT(entry)) {
+		if (entry->e_value_inum) {
+			ext4_xattr_inode_unlink(inode, entry->e_value_inum);
+			entry->e_value_inum = 0;
+		}
+	}
 
+delete_external_ea:
 	if (!EXT4_I(inode)->i_file_acl)
 		goto cleanup;
 	bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
@@ -1362,6 +1687,15 @@ ext4_xattr_delete_inode(handle_t *handle
 			EXT4_I(inode)->i_file_acl);
 		goto cleanup;
 	}
+
+	entry = BFIRST(bh);
+	for (; !IS_LAST_ENTRY(entry); entry = EXT4_XATTR_NEXT(entry)) {
+		if (entry->e_value_inum) {
+			ext4_xattr_inode_unlink(inode, entry->e_value_inum);
+			entry->e_value_inum = 0;
+		}
+	}
+
 	ext4_xattr_release_block(handle, inode, bh);
 	EXT4_I(inode)->i_file_acl = 0;
 
@@ -1436,10 +1770,9 @@ ext4_xattr_cmp(struct ext4_xattr_header 
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
@@ -1524,7 +1857,7 @@ static inline void ext4_xattr_hash_entry
 		       *name++;
 	}
 
-	if (entry->e_value_block == 0 && entry->e_value_size != 0) {
+	if (entry->e_value_inum == 0 && entry->e_value_size != 0) {
 		__le32 *value = (__le32 *)((char *)header +
 			le16_to_cpu(entry->e_value_offs));
 		for (n = (le32_to_cpu(entry->e_value_size) +
Index: linux-2.6.27/fs/ext4/xattr.h
===================================================================
--- linux-2.6.27.orig/fs/ext4/xattr.h
+++ linux-2.6.27/fs/ext4/xattr.h
@@ -38,7 +38,7 @@ struct ext4_xattr_entry {
 	__u8	e_name_len;	/* length of name */
 	__u8	e_name_index;	/* attribute name index */
 	__le16	e_value_offs;	/* offset in disk block of value */
-	__le32	e_value_block;	/* disk block attribute is stored on (n/i) */
+	__le32	e_value_inum;	/* inode in which the value is stored */
 	__le32	e_value_size;	/* size of attribute value */
 	__le32	e_hash;		/* hash value of name and value */
 	char	e_name[0];	/* attribute name */
@@ -63,6 +63,15 @@ struct ext4_xattr_entry {
 		EXT4_I(inode)->i_extra_isize))
 #define IFIRST(hdr) ((struct ext4_xattr_entry *)((hdr)+1))
 
+#define i_xattr_inode_parent i_mtime.tv_sec
+
+/*
+ * The minimum size of EA value when you start storing it in an external inode
+ * should be half the blocksize.
+ */
+#define EXT4_XATTR_MIN_LARGE_EA_SIZE(b)	((b) >> 1)
+#define EXT4_XATTR_MAX_LARGE_EA_SIZE	(1024 * 1024)
+
 # ifdef CONFIG_EXT4_FS_XATTR
 
 extern struct xattr_handler ext4_xattr_user_handler;
Index: linux-2.6.27/fs/ext4/ext4.h
===================================================================
--- linux-2.6.27.orig/fs/ext4/ext4.h
+++ linux-2.6.27/fs/ext4/ext4.h
@@ -242,9 +242,10 @@ struct flex_groups {
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
 #define EXT4_EXT_MIGRATE		0x00100000 /* Inode is migrating */
+#define EXT4_EA_INODE_FL		0x00200000 /* Inode used for large EA */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
-#define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
+#define EXT4_FL_USER_VISIBLE		0x002BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x000B80FF /* User modifiable flags */
 
 /*
@@ -768,6 +769,7 @@ static inline int ext4_valid_inum(struct
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP               0x0100
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
+#define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -775,7 +777,8 @@ static inline int ext4_valid_inum(struct
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
 					 EXT4_FEATURE_INCOMPAT_64BIT| \
-					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
+					 EXT4_FEATURE_INCOMPAT_EA_INODE)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \

--Boundary_(ID_HVHeWB1RxV8wxUSzEIpXrQ)--
