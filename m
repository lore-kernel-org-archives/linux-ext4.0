From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH] Large EAs in ext4
Date: Mon, 25 Aug 2008 21:30:23 +0530
Message-ID: <1219680023.31999.30.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_AA5YLOtMCkd/wmlsUJX/dw)"
Cc: Andreas Dilger <adilger@Sun.COM>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:42807 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYHYQF0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2008 12:05:26 -0400
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m7PFxhBB004597
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 15:59:46 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K6500J01Z2FTD00@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Mon,
 25 Aug 2008 23:59:43 +0800 (SGT)
Received: from [192.168.1.5] ([59.97.192.240])
 by mail-apac.sun.com (Sun Java System Messaging Server 6.2-6.01 (built Apr  3
 2006)) with ESMTPSA id <0K65007K7Z3HXJDA@mail-apac.sun.com> for
 linux-ext4@vger.kernel.org; Mon, 25 Aug 2008 23:59:43 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_AA5YLOtMCkd/wmlsUJX/dw)
Content-type: text/plain
Content-transfer-encoding: 7BIT

Hi,

This is the implementation for large EA support in ext4. Note that this
also helps to have a larger number of EAs since large EAs get written
out to a new inode instead of the EA block.

If value of an attribute is greater than 2048 bytes the value is not
saved in the external EA block, instead it is saved in an inode. The EA
entry saves the inode number in e_value_inum field (earlier this was
e_value_block that was unused). A new EXT4_FEATURE_INCOMPAT_EA_INODE
feature has been added for this.

These inodes are not linked into any directory since a single directory
per filesystem will cause a bottleneck. Instead a "goal" argument has
been added to the ext4_new_inode() function to help a localized
selection of the EA inode. Since ext4_new_inode() only used the dir
argument to choose the group, we use goal to do the same.

This "large_xattr" feature is not enabled automatically and needs to
enabled during mkfs or using tune2fs. I have also attached the e2fsprogs
patch for the same.

Your feedback/review/comments are appreciated.

Signed-off-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>

Thanks,
Kalpak.

--Boundary_(ID_AA5YLOtMCkd/wmlsUJX/dw)
Content-type: text/x-patch; charset=UTF-8; name=ext4-large-eas.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=ext4-large-eas.patch

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: linux-2.6.26/fs/ext4/xattr.c
===================================================================
--- linux-2.6.26.orig/fs/ext4/xattr.c
+++ linux-2.6.26/fs/ext4/xattr.c
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
@@ -200,11 +208,102 @@ ext4_xattr_find_entry(struct ext4_xattr_
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
+		return ret_size;
+
+	blocksize = ea_inode->i_sb->s_blocksize;
+
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
+struct  inode *ext4_xattr_inode_iget(struct inode *parent, int ea_ino, int *err)
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
+	if (ea_inode->i_mtime.tv_sec != parent->i_ino ||
+	    ea_inode->i_generation != parent->i_generation) {
+		ext4_error(parent->i_sb, __func__,
+			   "Backpointer from EA inode to parent invalid.");
+		*err = -EINVAL;
+		goto error;
+	}
+
+	if (!(ea_inode->i_flags | EXT4_EA_INODE_FL)) {
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
@@ -235,7 +334,8 @@ bad_block:	ext4_error(inode->i_sb, __fun
 	}
 	ext4_xattr_cache_insert(bh);
 	entry = BFIRST(bh);
-	error = ext4_xattr_find_entry(&entry, name_index, name, bh->b_size, 1);
+	error = ext4_xattr_find_entry(&entry, name_index, name, bh->b_size, 1,
+				      inode);
 	if (error == -EIO)
 		goto bad_block;
 	if (error)
@@ -245,8 +345,16 @@ bad_block:	ext4_error(inode->i_sb, __fun
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
 
@@ -280,7 +388,7 @@ ext4_xattr_ibody_get(struct inode *inode
 	if (error)
 		goto cleanup;
 	error = ext4_xattr_find_entry(&entry, name_index, name,
-				      end - (void *)entry, 0);
+				      end - (void *)entry, 0, inode);
 	if (error)
 		goto cleanup;
 	size = le32_to_cpu(entry->e_value_size);
@@ -288,8 +396,16 @@ ext4_xattr_ibody_get(struct inode *inode
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
 
@@ -511,7 +627,7 @@ static size_t ext4_xattr_free_space(stru
 {
 	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
 		*total += EXT4_XATTR_LEN(last->e_name_len);
-		if (!last->e_value_block && last->e_value_size) {
+		if (!last->e_value_inum && last->e_value_size) {
 			size_t offs = le16_to_cpu(last->e_value_offs);
 			if (offs < *min_offs)
 				*min_offs = offs;
@@ -520,6 +636,156 @@ static size_t ext4_xattr_free_space(stru
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
+	int size = 0, err = 0, csize;
+	int ret = 0;
+	int retries = 0;
+
+retry:
+	while (ret >= 0 && ret < max_blocks) {
+		block += ret;
+		max_blocks -= ret;
+
+		ret = ext4_get_blocks_wrap(handle, ea_inode, block, max_blocks,
+					   &dummy, 1, 1);
+		if (ret <= 0) {
+			ext4_mark_inode_dirty(handle, ea_inode);
+			if (ret == -ENOSPC &&
+			    ext4_should_retry_alloc(ea_inode->i_sb, &retries)) {
+				ret = 0;
+				goto retry;
+			}
+			break;
+		}
+		size = ret << ea_inode->i_blkbits;
+	}
+
+	block = 0;
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
+		ext4_journal_dirty_metadata(handle, bh);
+
+		buf += csize;
+		bufsize -= csize;
+		block += 1;
+	}
+
+out:
+	brelse(bh);
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
+	/*
+	 * Let the next inode be the goal, so we try and allocate the EA inode
+	 * in the same group, or nearby one.
+	 */
+	ea_inode = ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
+				  S_IFREG|0600, inode->i_ino + 1);
+	if (!IS_ERR(ea_inode)) {
+		ea_inode->i_op = &ext4_file_inode_operations;
+		ea_inode->i_fop = &ext4_file_operations;
+		ext4_set_aops(inode);
+		ea_inode->i_generation = inode->i_generation;
+		EXT4_I(ea_inode)->i_flags |= EXT4_EA_INODE_FL;
+
+		/*
+		 * Save the parent inode number in the i_mtime field.
+		 * A back-pointer from EA inode to parent inode will be useful
+		 * for e2fsck.
+		 */
+		ea_inode->i_mtime.tv_sec = inode->i_ino;
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
+	int req_buffer_credits;
+	int err;
+
+	/* Create an inode for the EA value */
+	ea_inode = ext4_xattr_inode_create(handle, inode);
+	if (IS_ERR(ea_inode))
+		return -1;
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
@@ -536,15 +802,22 @@ struct ext4_xattr_search {
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
+	    EXT4_XATTR_SIZE(i->value_len) > EXT4_XATTR_MIN_LARGE_EA_SIZE)
+		in_inode++;
 
 	/* Compute min_offs and last. */
 	last = s->first;
 	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
-		if (!last->e_value_block && last->e_value_size) {
+		if (!last->e_value_inum && last->e_value_size) {
 			size_t offs = le16_to_cpu(last->e_value_offs);
 			if (offs < min_offs)
 				min_offs = offs;
@@ -552,16 +825,23 @@ ext4_xattr_set_entry(struct ext4_xattr_i
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
+		if (in_inode) {
+			if (value_len > EXT4_XATTR_MAX_LARGE_EA_SIZE)
+				return -ENOSPC;
+			value_len = 0;
+		}
+		if (free < value_len ||
+		    free < EXT4_XATTR_LEN(name_len) + value_len)
 			return -ENOSPC;
 	}
 
@@ -575,7 +855,8 @@ ext4_xattr_set_entry(struct ext4_xattr_i
 		s->here->e_name_len = name_len;
 		memcpy(s->here->e_name, i->name, name_len);
 	} else {
-		if (!s->here->e_value_block && s->here->e_value_size) {
+		if (s->here->e_value_offs && !s->here->e_value_inum &&
+		    s->here->e_value_size) {
 			void *first_val = s->base + min_offs;
 			size_t offs = le16_to_cpu(s->here->e_value_offs);
 			void *val = s->base + offs;
@@ -604,13 +885,16 @@ ext4_xattr_set_entry(struct ext4_xattr_i
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
@@ -624,13 +908,24 @@ ext4_xattr_set_entry(struct ext4_xattr_i
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
@@ -673,7 +968,7 @@ ext4_xattr_block_find(struct inode *inod
 		bs->s.end = bs->bh->b_data + bs->bh->b_size;
 		bs->s.here = bs->s.first;
 		error = ext4_xattr_find_entry(&bs->s.here, i->name_index,
-					      i->name, bs->bh->b_size, 1);
+					     i->name, bs->bh->b_size, 1, inode);
 		if (error && error != -ENODATA)
 			goto cleanup;
 		bs->s.not_found = error;
@@ -697,8 +992,6 @@ ext4_xattr_block_set(handle_t *handle, s
 
 #define header(x) ((struct ext4_xattr_header *)(x))
 
-	if (i->value && i->value_len > sb->s_blocksize)
-		return -ENOSPC;
 	if (s->base) {
 		ce = mb_cache_entry_get(ext4_xattr_cache, bs->bh->b_bdev,
 					bs->bh->b_blocknr);
@@ -713,7 +1006,7 @@ ext4_xattr_block_set(handle_t *handle, s
 				ce = NULL;
 			}
 			ea_bdebug(bs->bh, "modifying in-place");
-			error = ext4_xattr_set_entry(i, s);
+			error = ext4_xattr_set_entry(i, s, handle, inode);
 			if (!error) {
 				if (!IS_LAST_ENTRY(s->first))
 					ext4_xattr_rehash(header(s->base),
@@ -764,7 +1057,7 @@ ext4_xattr_block_set(handle_t *handle, s
 		s->end = s->base + sb->s_blocksize;
 	}
 
-	error = ext4_xattr_set_entry(i, s);
+	error = ext4_xattr_set_entry(i, s, handle, inode);
 	if (error == -EIO)
 		goto bad_block;
 	if (error)
@@ -896,7 +1189,7 @@ ext4_xattr_ibody_find(struct inode *inod
 		/* Find the named attribute. */
 		error = ext4_xattr_find_entry(&is->s.here, i->name_index,
 					      i->name, is->s.end -
-					      (void *)is->s.base, 0);
+					      (void *)is->s.base, 0, inode);
 		if (error && error != -ENODATA)
 			return error;
 		is->s.not_found = error;
@@ -915,7 +1208,7 @@ ext4_xattr_ibody_set(handle_t *handle, s
 
 	if (EXT4_I(inode)->i_extra_isize == 0)
 		return -ENOSPC;
-	error = ext4_xattr_set_entry(i, s);
+	error = ext4_xattr_set_entry(i, s, handle, inode);
 	if (error)
 		return error;
 	header = IHDR(inode, ext4_raw_inode(&is->iloc));
@@ -1059,10 +1352,23 @@ ext4_xattr_set(struct inode *inode, int 
 	       const void *value, size_t value_len, int flags)
 {
 	handle_t *handle;
+	int buffer_credits;
 	int error, retries = 0;
 
+	buffer_credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
+	if ((value_len >= EXT4_XATTR_MIN_LARGE_EA_SIZE) &&
+	    (EXT4_SB(inode->i_sb)->s_es->s_feature_incompat &
+	     EXT4_FEATURE_INCOMPAT_EA_INODE)) {
+		/* For new inode */
+		buffer_credits +=  EXT4_SINGLEDATA_TRANS_BLOCKS(inode->i_sb) +3;
+
+		/* For the blocks to be written in the EA inode */
+		buffer_credits += (value_len + inode->i_sb->s_blocksize - 1) /
+				   inode->i_sb->s_blocksize;
+	}
+
 retry:
-	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+	handle = ext4_journal_start(inode, buffer_credits);
 	if (IS_ERR(handle)) {
 		error = PTR_ERR(handle);
 	} else {
@@ -1094,7 +1400,7 @@ static void ext4_xattr_shift_entries(str
 
 	/* Adjust the value offsets of the entries */
 	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
-		if (!last->e_value_block && last->e_value_size) {
+		if (!last->e_value_inum && last->e_value_size) {
 			new_offs = le16_to_cpu(last->e_value_offs) +
 							value_offs_shift;
 			BUG_ON(new_offs + le32_to_cpu(last->e_value_size)
@@ -1331,7 +1637,8 @@ cleanup:
 /*
  * ext4_xattr_delete_inode()
  *
- * Free extended attribute resources associated with this inode. This
+ * Free extended attribute resources associated with this inode. Traverse
+ * all the entries and unlink any EA-inodes associated with this inode. This
  * is called immediately before an inode is freed. We have exclusive
  * access to the inode.
  */
@@ -1339,7 +1646,29 @@ void
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
+
+delete_external_ea:
 	if (!EXT4_I(inode)->i_file_acl)
 		goto cleanup;
 	bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
@@ -1356,6 +1685,15 @@ ext4_xattr_delete_inode(handle_t *handle
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
 
@@ -1430,10 +1768,9 @@ ext4_xattr_cmp(struct ext4_xattr_header 
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
@@ -1518,7 +1855,7 @@ static inline void ext4_xattr_hash_entry
 		       *name++;
 	}
 
-	if (entry->e_value_block == 0 && entry->e_value_size != 0) {
+	if (entry->e_value_inum == 0 && entry->e_value_size != 0) {
 		__le32 *value = (__le32 *)((char *)header +
 			le16_to_cpu(entry->e_value_offs));
 		for (n = (le32_to_cpu(entry->e_value_size) +
Index: linux-2.6.26/fs/ext4/xattr.h
===================================================================
--- linux-2.6.26.orig/fs/ext4/xattr.h
+++ linux-2.6.26/fs/ext4/xattr.h
@@ -38,7 +38,7 @@ struct ext4_xattr_entry {
 	__u8	e_name_len;	/* length of name */
 	__u8	e_name_index;	/* attribute name index */
 	__le16	e_value_offs;	/* offset in disk block of value */
-	__le32	e_value_block;	/* disk block attribute is stored on (n/i) */
+	__le32	e_value_inum;	/* inode in which the value is stored */
 	__le32	e_value_size;	/* size of attribute value */
 	__le32	e_hash;		/* hash value of name and value */
 	char	e_name[0];	/* attribute name */
@@ -63,6 +63,9 @@ struct ext4_xattr_entry {
 		EXT4_I(inode)->i_extra_isize))
 #define IFIRST(hdr) ((struct ext4_xattr_entry *)((hdr)+1))
 
+#define EXT4_XATTR_MIN_LARGE_EA_SIZE	2048
+#define EXT4_XATTR_MAX_LARGE_EA_SIZE	(1024 * 1024)
+
 # ifdef CONFIG_EXT4DEV_FS_XATTR
 
 extern struct xattr_handler ext4_xattr_user_handler;
Index: linux-2.6.26/fs/ext4/ext4.h
===================================================================
--- linux-2.6.26.orig/fs/ext4/ext4.h
+++ linux-2.6.26/fs/ext4/ext4.h
@@ -230,6 +230,7 @@ struct ext4_group_desc
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
 #define EXT4_EXT_MIGRATE		0x00100000 /* Inode is migrating */
+#define EXT4_EA_INODE_FL		0x00200000 /* Inode used for large EA */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
@@ -751,6 +752,7 @@ static inline int ext4_valid_inum(struct
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP               0x0100
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
+#define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -758,7 +760,8 @@ static inline int ext4_valid_inum(struct
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
 					 EXT4_FEATURE_INCOMPAT_64BIT| \
-					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
+					 EXT4_FEATURE_INCOMPAT_EA_INODE)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
@@ -995,7 +998,8 @@ extern int ext4fs_dirhash(const char *na
 			  dx_hash_info *hinfo);
 
 /* ialloc.c */
-extern struct inode * ext4_new_inode (handle_t *, struct inode *, int);
+extern struct inode *ext4_new_inode(handle_t *, struct inode *, int,
+				      unsigned long);
 extern void ext4_free_inode (handle_t *, struct inode *);
 extern struct inode * ext4_orphan_get (struct super_block *, unsigned long);
 extern unsigned long ext4_count_free_inodes (struct super_block *);
Index: linux-2.6.26/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.26.orig/fs/ext4/ialloc.c
+++ linux-2.6.26/fs/ext4/ialloc.c
@@ -484,8 +484,12 @@ static int find_group_other(struct super
  *
  * For other inodes, search forward from the parent directory's block
  * group to find a free inode.
+ *
+ * If a goal inode is specified then try to allocate it else continue
+ * allocation as is.
  */
-struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
+struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode,
+			     unsigned long goal)
 {
 	struct super_block *sb;
 	struct buffer_head *bitmap_bh = NULL;
@@ -497,7 +501,7 @@ struct inode *ext4_new_inode(handle_t *h
 	struct ext4_super_block * es;
 	struct ext4_inode_info *ei;
 	struct ext4_sb_info *sbi;
-	int ret2, err = 0;
+	int ret2 = 0, err = 0;
 	struct inode *ret;
 	ext4_group_t i;
 	int free = 0;
@@ -514,6 +518,42 @@ struct inode *ext4_new_inode(handle_t *h
 
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
+		/*
+		 * We've shortcircuited the allocation system successfully,
+		 * now finish filling in the inode.
+		 */
+		goto got;
+	}
+
 	if (S_ISDIR(mode)) {
 		if (test_opt (sb, OLDALLOC))
 			ret2 = find_group_dir(sb, dir, &group);
@@ -522,6 +562,8 @@ struct inode *ext4_new_inode(handle_t *h
 	} else
 		ret2 = find_group_other(sb, dir, &group);
 
+continue_allocation:
+
 	err = -ENOSPC;
 	if (ret2 == -1)
 		goto out;
Index: linux-2.6.26/fs/ext4/namei.c
===================================================================
--- linux-2.6.26.orig/fs/ext4/namei.c
+++ linux-2.6.26/fs/ext4/namei.c
@@ -1730,7 +1730,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, mode);
+	inode = ext4_new_inode (handle, dir, mode, 0);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		inode->i_op = &ext4_file_inode_operations;
@@ -1764,7 +1764,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, mode);
+	inode = ext4_new_inode (handle, dir, mode, 0);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
@@ -1800,7 +1800,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, S_IFDIR | mode);
+	inode = ext4_new_inode (handle, dir, S_IFDIR | mode, 0);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
@@ -2200,7 +2200,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext4_new_inode (handle, dir, S_IFLNK|S_IRWXUGO);
+	inode = ext4_new_inode (handle, dir, S_IFLNK|S_IRWXUGO, 0);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
Index: linux-2.6.26/fs/ext4/migrate.c
===================================================================
--- linux-2.6.26.orig/fs/ext4/migrate.c
+++ linux-2.6.26/fs/ext4/migrate.c
@@ -482,9 +482,8 @@ int ext4_ext_migrate(struct inode *inode
 		retval = PTR_ERR(handle);
 		goto err_out;
 	}
-	tmp_inode = ext4_new_inode(handle,
-				inode->i_sb->s_root->d_inode,
-				S_IFREG);
+	tmp_inode = ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
+				   S_IFREG, 0);
 	if (IS_ERR(tmp_inode)) {
 		retval = -ENOMEM;
 		ext4_journal_stop(handle);

--Boundary_(ID_AA5YLOtMCkd/wmlsUJX/dw)
Content-type: text/x-patch; charset=UTF-8; name=e2fsprogs-large-xattrs.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=e2fsprogs-large-xattrs.patch

Index: e2fsprogs-1.40.11/lib/blkid/probe.h
===================================================================
--- e2fsprogs-1.40.11.orig/lib/blkid/probe.h
+++ e2fsprogs-1.40.11/lib/blkid/probe.h
@@ -119,6 +119,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP		0x0100
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
+#define	EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
Index: e2fsprogs-1.40.11/lib/e2p/feature.c
===================================================================
--- e2fsprogs-1.40.11.orig/lib/e2p/feature.c
+++ e2fsprogs-1.40.11/lib/e2p/feature.c
@@ -71,6 +71,8 @@ static struct feature feature_list[] = {
 			"64bit" },
 	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP,
 			"mmp" },
+	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_EA_INODE,
+			"large_xattr" },
 	{	0, 0, 0 },
 };
 
Index: e2fsprogs-1.40.11/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.40.11.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-1.40.11/lib/ext2fs/ext2_fs.h
@@ -265,6 +265,7 @@ struct ext2_dx_countlimit {
 #define EXT2_DIRSYNC_FL 		0x00010000 /* Synchronous directory modifications */
 #define EXT2_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define EXT4_EXTENTS_FL 		0x00080000 /* Inode uses extents */
+#define	EXT4_EA_INODE_FL		0x00200000 /* Inode used for large EA */
 #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
 
 #define EXT2_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
@@ -661,11 +662,13 @@ struct ext2_super_block {
 #define EXT3_FEATURE_INCOMPAT_EXTENTS		0x0040
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP		0x0100
+#define	EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
-				       EXT4_FEATURE_INCOMPAT_MMP)
+				       EXT4_FEATURE_INCOMPAT_MMP| \
+				       EXT4_FEATURE_INCOMPAT_EA_INODE)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
Index: e2fsprogs-1.40.11/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.40.11.orig/misc/mke2fs.c
+++ e2fsprogs-1.40.11/misc/mke2fs.c
@@ -925,7 +925,8 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE|
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG|
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP|
+		EXT4_FEATURE_INCOMPAT_EA_INODE,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|
Index: e2fsprogs-1.40.11/misc/tune2fs.c
===================================================================
--- e2fsprogs-1.40.11.orig/misc/tune2fs.c
+++ e2fsprogs-1.40.11/misc/tune2fs.c
@@ -113,7 +113,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_COMPAT_DIR_INDEX,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_EA_INODE,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER |
@@ -457,6 +458,9 @@ mmp_error:
 			ext2fs_free_mem(&buf);
 	}
 
+        if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_EA_INODE))
+		sb->s_feature_incompat |= EXT4_FEATURE_INCOMPAT_EA_INODE;
+
 	if (FEATURE_ON(E2P_FEATURE_COMPAT, EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
 		/*
 		 * If adding a journal flag, let the create journal
Index: e2fsprogs-1.40.11/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.40.11.orig/e2fsck/pass1.c
+++ e2fsprogs-1.40.11/e2fsck/pass1.c
@@ -248,7 +248,9 @@ static void check_size(e2fsck_t ctx, str
 	inode->i_size_high = 0;
 	e2fsck_write_inode(ctx, pctx->ino, pctx->inode, "pass1");
 }
-	
+
+extern char *ext2_attr_index_prefix[];
+
 static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 {
 	struct ext2_super_block *sb = ctx->fs->super;
@@ -287,18 +289,38 @@ static void check_ea_in_inode(e2fsck_t c
 		/* attribute len eats this space */
 		remain -= EXT2_EXT_ATTR_SIZE(entry->e_name_len);
 
-		/* check value size */
-		if (entry->e_value_size == 0 || entry->e_value_size > remain) {
+		if (entry->e_value_size == 0) {
 			pctx->num = entry->e_value_size;
 			problem = PR_1_ATTR_VALUE_SIZE;
 			goto fix;
 		}
 
-		/* e_value_block must be 0 in inode's ea */
-		if (entry->e_value_block != 0) {
-			pctx->num = entry->e_value_block;
-			problem = PR_1_ATTR_VALUE_BLOCK;
-			goto fix;
+		if (entry->e_value_inum == 0) {
+			/* check value size */
+			if (entry->e_value_size > remain) {
+				pctx->num = entry->e_value_size;
+				problem = PR_1_ATTR_VALUE_SIZE;
+				goto fix;
+			}
+		} else {
+			if ((entry->e_value_inum < EXT2_FIRST_INODE(ctx->fs->super)) ||
+			    (entry->e_value_inum > ctx->fs->super->s_inodes_count)) {
+				pctx->num = pctx->ino;
+				pctx->ino = entry->e_value_inum;
+
+				if (fix_problem(ctx, PR_1_ATTR_VALUE_EA_INODE, pctx)) {
+					int i;
+
+					/* Delete corrupt EA entry */
+					i = strlen(ext2_attr_index_prefix[
+						     entry->e_name_index]);
+					ext2fs_attr_set(ctx->fs, pctx->ino,
+							pctx->inode,
+							entry->e_name_index,
+							&entry->e_name[i], 0,
+							0, 0);
+				}
+			}
 		}
 
 		hash = ext2fs_ext_attr_hash_entry(entry,
@@ -314,7 +336,11 @@ static void check_ea_in_inode(e2fsck_t c
 		e2fsck_lfsck_found_ea(ctx, pctx->ino, inode, entry,
 				      start + entry->e_value_offs);
 
-		remain -= entry->e_value_size;
+		/* If EA value is stored in external inode then it does not
+		 * consume space here
+		 */
+		if (entry->e_value_inum == 0)
+			remain -= entry->e_value_size;
 
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
@@ -488,8 +514,6 @@ extern void e2fsck_setup_tdb_icount(e2fs
 		*ret = 0;
 }
 
-extern char *ext2_attr_index_prefix[];
-
 int e2fsck_pass1_delete_attr(e2fsck_t ctx, struct ext2_inode_large *inode,
 			     struct problem_context *pctx, int needed_size)
 {
@@ -1705,20 +1729,35 @@ static int check_ext_attr(e2fsck_t ctx, 
 				goto clear_extattr;
 			break;
 		}
-		if (entry->e_value_block != 0) {
-			if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
-				goto clear_extattr;
-		}
-		if (entry->e_value_offs + entry->e_value_size > fs->blocksize) {
-			if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
-				goto clear_extattr;
-			break;
-		}
-		if (entry->e_value_size &&
-		    region_allocate(region, entry->e_value_offs,
-				    EXT2_EXT_ATTR_SIZE(entry->e_value_size))) {
-			if (fix_problem(ctx, PR_1_EA_ALLOC_COLLISION, pctx))
-				goto clear_extattr;
+		if (entry->e_value_inum != 0) {
+		        if ((entry->e_value_inum < EXT2_FIRST_INODE(ctx->fs->super)) ||
+		            (entry->e_value_inum > ctx->fs->super->s_inodes_count)) {
+				pctx->num = pctx->ino;
+		                pctx->ino = entry->e_value_inum;
+				if (fix_problem(ctx, PR_1_ATTR_VALUE_EA_INODE, pctx)) {
+					int i;
+
+					/* Delete corrupt EA entry */
+					i = strlen(ext2_attr_index_prefix[
+							entry->e_name_index]);
+					ext2fs_attr_set(fs, pctx->ino, inode,
+                                                        entry->e_name_index,
+							&entry->e_name[i], 0,
+							0,0);
+				}
+			}
+		} else {
+			if (entry->e_value_offs + entry->e_value_size > fs->blocksize) {
+				if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
+					goto clear_extattr;
+				break;
+			}
+			if (entry->e_value_size &&
+			    region_allocate(region, entry->e_value_offs,
+					    EXT2_EXT_ATTR_SIZE(entry->e_value_size))) {
+				if (fix_problem(ctx, PR_1_EA_ALLOC_COLLISION, pctx))
+					goto clear_extattr;
+			}
 		}
 
 		hash = ext2fs_ext_attr_hash_entry(entry, block_buf +
Index: e2fsprogs-1.40.11/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.40.11.orig/e2fsck/problem.c
+++ e2fsprogs-1.40.11/e2fsck/problem.c
@@ -898,6 +898,10 @@ static struct e2fsck_problem problem_tab
 	     "without deletion of an EA.\n"),
 	  PROMPT_FIX, 0 },
 
+        /* Inode has illegal EA value inode */
+        { PR_1_ATTR_VALUE_EA_INODE,
+          N_("@i %n has @I EA value @i %i.\n"),
+          PROMPT_FIX, PR_PREEN_OK },
 
 	/* Pass 1b errors */
 
Index: e2fsprogs-1.40.11/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.40.11.orig/e2fsck/problem.h
+++ e2fsprogs-1.40.11/e2fsck/problem.h
@@ -533,6 +533,9 @@ struct problem_context {
  */
 #define PR_1_CLEAR_EXTRA_ISIZE		0x01006C
 
+/* Invalid EA inode */
+#define PR_1_ATTR_VALUE_EA_INODE	0x01006D
+
 /*
  * Pass 1b errors
  */
Index: e2fsprogs-1.40.11/lib/ext2fs/ext2_ext_attr.h
===================================================================
--- e2fsprogs-1.40.11.orig/lib/ext2fs/ext2_ext_attr.h
+++ e2fsprogs-1.40.11/lib/ext2fs/ext2_ext_attr.h
@@ -30,7 +30,7 @@ struct ext2_ext_attr_entry {
 	__u8	e_name_len;	/* length of name */
 	__u8	e_name_index;	/* attribute name index */
 	__u16	e_value_offs;	/* offset in disk block of value */
-	__u32	e_value_block;	/* disk block attribute is stored on (n/i) */
+	__u32	e_value_inum;	/* inode in which the value is stored */
 	__u32	e_value_size;	/* size of attribute value */
 	__u32	e_hash;		/* hash value of name and value */
 #if 1
@@ -38,6 +38,9 @@ struct ext2_ext_attr_entry {
 #endif
 };
 
+#define	EXT4_XATTR_MIN_LARGE_EA_SIZE	2048
+#define	EXT4_XATTR_MAX_LARGE_EA_SIZE	(64 * 1024)
+
 #define BHDR(block) ((struct ext2_ext_attr_header *) block)
 #define IHDR(inode)			   	\
 	((__u32 *) ((char *)inode +	     	\
Index: e2fsprogs-1.40.11/lib/ext2fs/ext_attr.c
===================================================================
--- e2fsprogs-1.40.11.orig/lib/ext2fs/ext_attr.c
+++ e2fsprogs-1.40.11/lib/ext2fs/ext_attr.c
@@ -45,7 +45,7 @@ __u32 ext2fs_ext_attr_hash_entry(struct 
 	}
 
 	/* The hash needs to be calculated on the data in little-endian. */
-	if (entry->e_value_block == 0 && entry->e_value_size != 0) {
+	if (entry->e_value_inum == 0 && entry->e_value_size != 0) {
 		__u32 *value = (__u32 *)data;
 		for (n = (entry->e_value_size + EXT2_EXT_ATTR_ROUND) >>
 			 EXT2_EXT_ATTR_PAD_BITS; n; n--) {
@@ -206,7 +206,7 @@ void ext2fs_attr_shift_entries(struct ex
 
 	/* Adjust the value offsets of the entries */
 	for (; !EXT2_EXT_IS_LAST_ENTRY(last); last = EXT2_EXT_ATTR_NEXT(last)) {
-		if (!last->e_value_block && last->e_value_size) {
+		if (last->e_value_inum == 0 && last->e_value_size) {
 			last->e_value_offs = last->e_value_offs +
 							value_offs_shift;
 		}
@@ -225,7 +225,7 @@ int ext2fs_attr_free_space(struct ext2_e
 {
 	for (; !EXT2_EXT_IS_LAST_ENTRY(last); last = EXT2_EXT_ATTR_NEXT(last)) {
 		*total += EXT2_EXT_ATTR_LEN(last->e_name_len);
-		if (!last->e_value_block && last->e_value_size) {
+		if (last->e_value_inum == 0 && last->e_value_size) {
 			int offs = last->e_value_offs;
 			if (offs < *min_offs)
 				*min_offs = offs;
@@ -364,7 +364,7 @@ static errcode_t ext2fs_attr_set_entry(e
 	/* Compute min_offs and last. */
 	for (last = s->first; !EXT2_EXT_IS_LAST_ENTRY(last);
 	     last = EXT2_EXT_ATTR_NEXT(last)) {
-		if (!last->e_value_block && last->e_value_size) {
+		if (last->e_value_inum == 0 && last->e_value_size) {
 			int offs = last->e_value_offs;
 
 			if (offs < min_offs)
@@ -374,7 +374,7 @@ static errcode_t ext2fs_attr_set_entry(e
 	free = min_offs - ((char *)last - s->base) - sizeof(__u32);
 
 	if (!s->not_found) {
-		if (!s->here->e_value_block && s->here->e_value_size) {
+		if (s->here->e_value_inum == 0 && s->here->e_value_size) {
 			int size = s->here->e_value_size;
 			free += EXT2_EXT_ATTR_SIZE(size);
 		}
@@ -397,7 +397,7 @@ static errcode_t ext2fs_attr_set_entry(e
 		s->here->e_name_len = name_len;
 		memcpy(s->here->e_name, i->name, name_len);
 	} else {
-		if (!s->here->e_value_block && s->here->e_value_size) {
+		if (s->here->e_value_inum == 0 && s->here->e_value_size) {
 			char *first_val = s->base + min_offs;
 			int offs = s->here->e_value_offs;
 			char *val = s->base + offs;
@@ -426,7 +426,7 @@ static errcode_t ext2fs_attr_set_entry(e
 			while (!EXT2_EXT_IS_LAST_ENTRY(last)) {
 				int o = last->e_value_offs;
 
-				if (!last->e_value_block &&
+				if (last->e_value_inum == 0 &&
 				    last->e_value_size && o < offs)
 					last->e_value_offs = o + size;
 				last = EXT2_EXT_ATTR_NEXT(last);
Index: e2fsprogs-1.40.11/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.40.11.orig/lib/ext2fs/swapfs.c
+++ e2fsprogs-1.40.11/lib/ext2fs/swapfs.c
@@ -110,7 +110,7 @@ void ext2fs_swap_ext_attr_entry(struct e
 				struct ext2_ext_attr_entry *from_entry)
 {
 	to_entry->e_value_offs  = ext2fs_swab16(from_entry->e_value_offs);
-	to_entry->e_value_block = ext2fs_swab32(from_entry->e_value_block);
+	to_entry->e_value_inum = ext2fs_swab32(from_entry->e_value_inum);
 	to_entry->e_value_size  = ext2fs_swab32(from_entry->e_value_size);
 	to_entry->e_hash	= ext2fs_swab32(from_entry->e_hash);
 }
Index: e2fsprogs-1.40.11/e2fsck/pass4.c
===================================================================
--- e2fsprogs-1.40.11.orig/e2fsck/pass4.c
+++ e2fsprogs-1.40.11/e2fsck/pass4.c
@@ -39,6 +39,12 @@ static int disconnect_inode(e2fsck_t ctx
 	} else {
 		e2fsck_read_inode(ctx, i, inode, "pass4: disconnect_inode");
 	}
+
+	if (inode->i_flags & EXT4_EA_INODE_FL) {
+		ext2fs_icount_store(ctx->inode_count, i, 1);
+		return 0;
+	}
+
 	clear_problem_context(&pctx);
 	pctx.ino = i;
 	pctx.inode = inode;
Index: e2fsprogs-1.40.11/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.40.11.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.40.11/lib/ext2fs/ext2fs.h
@@ -485,7 +485,8 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
-					 EXT4_FEATURE_INCOMPAT_MMP)
+					 EXT4_FEATURE_INCOMPAT_MMP|\
+					 EXT4_FEATURE_INCOMPAT_EA_INODE)
 
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
@@ -493,7 +494,8 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
-					 EXT4_FEATURE_INCOMPAT_MMP)
+					 EXT4_FEATURE_INCOMPAT_MMP|\
+					 EXT4_FEATURE_INCOMPAT_EA_INODE)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\

--Boundary_(ID_AA5YLOtMCkd/wmlsUJX/dw)--
