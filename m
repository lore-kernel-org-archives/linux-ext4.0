From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH] e2fsprogs: Expand inode size
Date: Wed, 02 May 2007 14:46:34 +0530
Message-ID: <1178097394.4529.30.camel@garfield>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-xhWpUJARbWJC/8MjyERd"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:42806 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbXEBJNh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2007 05:13:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-xhWpUJARbWJC/8MjyERd
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

With the addition of the *time_extra fields and i_version_hi field
beyond the EXT2_GOOD_OLD_INODE_SIZE, old filesystems need to have their
inodes expanded to avail these features. Obviously expansion of the
inode is possible only if the inode size > 128.

This patch adds a "-E expand_extra_isize" feature which makes sure that
_every_ used inode has i_extra_isize >= s_min_extra_isize if
s_min_extra_isize is set. Else it makes sure that i_extra_isize of every
inode is equal to sizeof(ext2_inode_large) - 128.

If no in-inode EAs are present then i_extra_isize can be easily
increased. If any in-inode EAs are present then they are moved to an
external EA block to create space for expansion in the inode. 

But if enough space is not available for moving the in-inode EAs to the
external EA block then some EA(s) would have to be deleted. In this
case, e2fsck will display each EA (starting from user. and going on to
more important ones) asking the user to delete one or more EA(s) to get
the required space for expansion. e2fsck will abort if this condition
arrives and it is being run in -y or -p mode. If the user refuses to
delete EAs, then the EXTRA_ISIZE feature would be disabled. This
guarantees us that at the end of the e2fsck run, all inodes will be
expanded or EXTRA_ISIZE won't be set.

Any comments or reviews are welcome.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Thanks,
Kalpak.


--=-xhWpUJARbWJC/8MjyERd
Content-Disposition: attachment; filename=e2fsprogs-expand-extra-isize.patch
Content-Type: text/x-patch; name=e2fsprogs-expand-extra-isize.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: e2fsprogs-1.40/lib/ext2fs/ext_attr.c
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/ext_attr.c
+++ e2fsprogs-1.40/lib/ext2fs/ext_attr.c
@@ -17,11 +17,13 @@
 #endif
 #include <string.h>
 #include <time.h>
+#include <errno.h>
 
 #include "ext2_fs.h"
 #include "ext2_ext_attr.h"
 
 #include "ext2fs.h"
+#include "et/com_err.h"
 
 #define NAME_HASH_SHIFT 5
 #define VALUE_HASH_SHIFT 16
@@ -59,6 +61,34 @@ __u32 ext2fs_ext_attr_hash_entry(struct 
 #undef NAME_HASH_SHIFT
 #undef VALUE_HASH_SHIFT
 
+#define BLOCK_HASH_SHIFT 16
+/*
+ * Re-compute the extended attribute hash value after an entry has changed.
+ */
+static void ext2fs_attr_rehash(struct ext2_ext_attr_header *header,
+			       struct ext2_ext_attr_entry *entry)
+{
+	struct ext2_ext_attr_entry *here;
+	__u32 hash = 0;
+
+	entry->e_hash = ext2fs_ext_attr_hash_entry(entry, (char *) header +
+						   entry->e_value_offs);
+
+	here = ENTRY(header+1);
+	while (!EXT2_EXT_IS_LAST_ENTRY(here)) {
+		if (!here->e_hash) {
+			/* Block is not shared if an entry's hash value == 0 */
+			hash = 0;
+			break;
+		}
+		hash = (hash << BLOCK_HASH_SHIFT) ^
+		       (hash >> (8*sizeof(hash) - BLOCK_HASH_SHIFT)) ^
+		       here->e_hash;
+		here = EXT2_EXT_ATTR_NEXT(here);
+	}
+	header->h_hash = hash;
+}
+
 errcode_t ext2fs_read_ext_attr(ext2_filsys fs, blk_t block, void *buf)
 {
 	errcode_t	retval;
@@ -125,7 +155,7 @@ errcode_t ext2fs_adjust_ea_refcount(ext2
 	if (retval)
 		goto errout;
 
-	header = (struct ext2_ext_attr_header *) block_buf;
+	header =  BHDR(block_buf);
 	header->h_refcount += adjust;
 	if (newcount)
 		*newcount = header->h_refcount;
@@ -139,3 +169,888 @@ errout:
 		ext2fs_free_mem(&buf);
 	return retval;
 }
+
+struct ext2_attr_info {
+	int name_index;
+	const char *name;
+	const char *value;
+	int value_len;
+};
+
+struct ext2_attr_search {
+	struct ext2_ext_attr_entry *first;
+	char *base;
+	char *end;
+	struct ext2_ext_attr_entry *here;
+	int not_found;
+};
+
+struct ext2_attr_ibody_find {
+	ext2_ino_t ino;
+	struct ext2_attr_search s;
+};
+
+struct ext2_attr_block_find {
+	struct ext2_attr_search s;
+	char *block;
+};
+
+void ext2fs_attr_shift_entries(struct ext2_ext_attr_entry *entry,
+			       int value_offs_shift, char *to,
+			       char *from, int n)
+{
+	struct ext2_ext_attr_entry *last = entry;
+
+	/* Adjust the value offsets of the entries */
+	for (; !EXT2_EXT_IS_LAST_ENTRY(last); last = EXT2_EXT_ATTR_NEXT(last)) {
+		if (!last->e_value_block && last->e_value_size) {
+			last->e_value_offs = last->e_value_offs +
+							value_offs_shift;
+		}
+	}
+	/* Shift the entries by n bytes */
+	memmove(to, from, n);
+}
+
+/*
+ * This function returns the free space present in the inode or the EA block.
+ * total is number of bytes taken up by the EA entries and is used to shift the
+ * EAs in ext2fs_expand_extra_isize().
+ */
+int ext2fs_attr_free_space(struct ext2_ext_attr_entry *last,
+			   int *min_offs, char *base, int *total)
+{
+	for (; !EXT2_EXT_IS_LAST_ENTRY(last); last = EXT2_EXT_ATTR_NEXT(last)) {
+		*total += EXT2_EXT_ATTR_LEN(last->e_name_len);
+		if (!last->e_value_block && last->e_value_size) {
+			int offs = last->e_value_offs;
+			if (offs < *min_offs)
+				*min_offs = offs;
+		}
+	}
+
+	return (*min_offs - ((char *)last - base) - sizeof(__u32));
+}
+
+static int ext2fs_attr_check_names(struct ext2_ext_attr_entry *entry, char *end)
+{
+	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
+		struct ext2_ext_attr_entry *next = EXT2_EXT_ATTR_NEXT(entry);
+		if ((char *)next >= end)
+			return -EIO;
+		entry = next;
+	}
+	return 0;
+}
+
+static int ext2fs_attr_find_entry(struct ext2_ext_attr_entry **pentry,
+				  int name_index, const char *name, int size,
+				  int sorted)
+{
+	struct ext2_ext_attr_entry *entry;
+	int name_len;
+	int cmp = 1;
+
+	if (name == NULL)
+		return -EINVAL;
+	name_len = strlen(name);
+	entry = *pentry;
+	for (; !EXT2_EXT_IS_LAST_ENTRY(entry);
+ 		entry = EXT2_EXT_ATTR_NEXT(entry)) {
+		cmp = name_index - entry->e_name_index;
+		if (!cmp)
+			cmp = name_len - entry->e_name_len;
+		if (!cmp)
+			cmp = memcmp(name, entry->e_name, name_len);
+		if (cmp <= 0 && (sorted || cmp == 0))
+			break;
+	}
+	*pentry = entry;
+
+	return cmp ? -ENODATA : 0;
+}
+
+static int ext2fs_attr_block_find(ext2_filsys fs, struct ext2_inode *inode,
+				  struct ext2_attr_info *i,
+	 			  struct ext2_attr_block_find *bs)
+{
+	struct ext2_ext_attr_header *header;
+	int error;
+
+	if (inode->i_file_acl) {
+		/* The inode already has an extended attribute block. */
+		error = ext2fs_get_mem(fs->blocksize, &bs->block);
+		if (error)
+			return error;
+		error = ext2fs_read_ext_attr(fs, inode->i_file_acl, bs->block);
+		if (error) {
+			 com_err("ext2fs_attr_block_find %d ", error,
+				 ("while reading EA block."));
+		}
+
+		header = BHDR(bs->block);
+
+		/* Find the named attribute. */
+		bs->s.base = bs->block;
+		bs->s.first = (struct ext2_ext_attr_entry *)(header + 1);
+		bs->s.end = bs->block + fs->blocksize;
+		bs->s.here = bs->s.first;
+		error = ext2fs_attr_find_entry(&bs->s.here, i->name_index,
+					       i->name, fs->blocksize, 1);
+		if (error && error != -ENODATA)
+			goto cleanup;
+		bs->s.not_found = error;
+	}
+	error = 0;
+
+cleanup:
+	return error;
+}
+
+static int ext2fs_attr_ibody_find(ext2_filsys fs, struct ext2_inode_large *inode,
+		     		  struct ext2_attr_info *i,
+				  struct ext2_attr_ibody_find *is)
+{
+	__u32 *eamagic;
+	char *start;
+	int error;
+
+	if (EXT2_INODE_SIZE(fs->super) == EXT2_GOOD_OLD_INODE_SIZE)
+		return;
+
+	if (inode->i_extra_isize == 0)
+		return 0;
+	eamagic = IHDR(inode);
+
+	start = (char *) inode + EXT2_GOOD_OLD_INODE_SIZE +
+				inode->i_extra_isize + sizeof(__u32);
+	is->s.first = (struct ext2_ext_attr_entry *) start;
+	is->s.base = start;
+	is->s.here = is->s.first;
+	is->s.end = (char *) inode + EXT2_INODE_SIZE(fs->super);
+	if (*eamagic == EXT2_EXT_ATTR_MAGIC) {
+		error = ext2fs_attr_check_names((struct ext2_ext_attr_entry *)
+						start, is->s.end);
+		if (error)
+			return error;
+		/* Find the named attribute. */
+		error = ext2fs_attr_find_entry(&is->s.here, i->name_index,
+					       i->name, is->s.end -
+					       (char *)is->s.base, 0);
+		if (error && error != -ENODATA)
+			return error;
+		is->s.not_found = error;
+	}
+	return 0;
+}
+
+static int ext2fs_attr_set_entry(ext2_filsys fs, struct ext2_attr_info *i,
+				 struct ext2_attr_search *s)
+{
+	struct ext2_ext_attr_entry *last;
+	int free, min_offs = s->end - s->base, name_len = strlen(i->name);
+	int total_ino;
+
+	/* Compute min_offs and last. */
+	last = s->first;
+	for (; !EXT2_EXT_IS_LAST_ENTRY(last); last = EXT2_EXT_ATTR_NEXT(last)) {
+		if (!last->e_value_block && last->e_value_size) {
+			int offs = last->e_value_offs;
+
+			if (offs < min_offs)
+				min_offs = offs;
+		}
+	}
+	free = min_offs - ((char *)last - s->base) - sizeof(__u32);
+
+	if (!s->not_found) {
+		if (!s->here->e_value_block && s->here->e_value_size) {
+			int size = s->here->e_value_size;
+			free += EXT2_EXT_ATTR_SIZE(size);
+		}
+		free += EXT2_EXT_ATTR_LEN(name_len);
+	}
+	if (i->value) {
+		if (free < EXT2_EXT_ATTR_LEN(name_len) +
+			   EXT2_EXT_ATTR_SIZE(i->value_len))
+			return -ENOSPC;
+	}
+
+	if (i->value && s->not_found) {
+		/* Insert the new name. */
+		int size = EXT2_EXT_ATTR_LEN(name_len);
+		int rest = (char *)last - (char *)s->here + sizeof(__u32);
+
+		memmove((char *)s->here + size, s->here, rest);
+		memset(s->here, 0, size);
+		s->here->e_name_index = i->name_index;
+		s->here->e_name_len = name_len;
+		memcpy(s->here->e_name, i->name, name_len);
+	} else {
+		if (!s->here->e_value_block && s->here->e_value_size) {
+			char *first_val = s->base + min_offs;
+			int offs = s->here->e_value_offs;
+			char *val = s->base + offs;
+			int size = EXT2_EXT_ATTR_SIZE(s->here->e_value_size);
+
+			if (i->value && size == EXT2_EXT_ATTR_SIZE(i->value_len)) {
+				/* The old and the new value have the same
+				   size. Just replace. */
+				s->here->e_value_size = i->value_len;
+				memset(val + size - EXT2_EXT_ATTR_PAD, 0,
+				       EXT2_EXT_ATTR_PAD); /* Clear pad bytes. */
+				memcpy(val, i->value, i->value_len);
+				return 0;
+			}
+
+			/* Remove the old value. */
+			memmove(first_val + size, first_val, val - first_val);
+			memset(first_val, 0, size);
+			s->here->e_value_size = 0;
+			s->here->e_value_offs = 0;
+			min_offs += size;
+
+			/* Adjust all value offsets. */
+			last = s->first;
+			while (!EXT2_EXT_IS_LAST_ENTRY(last)) {
+				int o = last->e_value_offs;
+
+				if (!last->e_value_block &&
+				    last->e_value_size && o < offs)
+					last->e_value_offs = o + size;
+				last = EXT2_EXT_ATTR_NEXT(last);
+			}
+		}
+		if (!i->value) {
+			/* Remove the old name. */
+			int size = EXT2_EXT_ATTR_LEN(name_len);
+
+			last = ENTRY((char *)last - size);
+			memmove((char *)s->here, (char *)s->here + size,
+				(char *)last - (char *)s->here + sizeof(__u32));
+			memset(last, 0, size);
+		}
+	}
+
+	if (i->value) {
+		/* Insert the new value. */
+		s->here->e_value_size = i->value_len;
+		if (i->value_len) {
+			int size = EXT2_EXT_ATTR_SIZE(i->value_len);
+			char *val = s->base + min_offs - size;
+
+			s->here->e_value_offs = min_offs - size;
+			memset(val + size - EXT2_EXT_ATTR_PAD, 0,
+			       EXT2_EXT_ATTR_PAD); /* Clear the pad bytes. */
+			memcpy(val, i->value, i->value_len);
+		}
+	}
+	return 0;
+}
+
+static int ext2fs_attr_block_set(ext2_filsys fs, struct ext2_inode *inode,
+				 struct ext2_attr_info *i,
+				 struct ext2_attr_block_find *bs)
+{
+	struct ext2_attr_search *s = &bs->s;
+	char *new_buf = NULL, *old_block = NULL;
+	blk_t blk;
+	int clear_flag = 0, error;
+
+	if (i->value && i->value_len > fs->blocksize)
+		return -ENOSPC;
+
+	if(s->base) {
+		if (BHDR(s->base)->h_refcount != 1) {
+			int offset = (char *)s->here - bs->block;
+
+			/* Decrement the refcount of the shared block */
+			old_block = s->base;
+			BHDR(s->base)->h_refcount -= 1;
+
+			error = ext2fs_get_mem(fs->blocksize, &s->base);
+			if (error)
+				goto cleanup;
+			clear_flag = 1;
+			memcpy(s->base, bs->block, fs->blocksize);
+			s->first = ENTRY(BHDR(s->base)+1);
+			BHDR(s->base)->h_refcount = 1;
+			s->here = ENTRY(s->base + offset);
+			s->end = s->base + fs->blocksize;
+		}
+	} else {
+		error = ext2fs_get_mem(fs->blocksize, &s->base);
+		if (error)
+			goto cleanup;
+		clear_flag = 1;
+		memset(s->base, 0, fs->blocksize);
+		BHDR(s->base)->h_magic = EXT2_EXT_ATTR_MAGIC;
+		BHDR(s->base)->h_blocks = 1;
+		BHDR(s->base)->h_refcount = 1;
+		s->first = ENTRY(BHDR(s->base)+1);
+		s->here = ENTRY(BHDR(s->base)+1);
+		s->end = s->base + fs->blocksize;
+	}
+
+	error = ext2fs_attr_set_entry(fs, i, s);
+	if (error)
+		goto cleanup;
+
+	if (!EXT2_EXT_IS_LAST_ENTRY(s->first))
+		ext2fs_attr_rehash(BHDR(s->base), s->here);
+
+inserted:
+	if (!EXT2_EXT_IS_LAST_ENTRY(s->first)) {
+		if (bs->block && bs->block == s->base) {
+			/* We are modifying this block in-place */
+			new_buf = bs->block;
+			blk = inode->i_file_acl;
+			error = io_channel_write_blk(fs->io, blk, 1, s->base);
+			if (error)
+				goto cleanup;
+		} else {
+			/* We need to allocate a new block */
+			error = ext2fs_new_block(fs, 0, 0, &blk);
+			if (error)
+				goto cleanup;
+			ext2fs_block_alloc_stats(fs, blk, +1);
+			error = io_channel_write_blk(fs->io, blk, 1, s->base);
+			if (error)
+				goto cleanup;
+			new_buf = s->base;
+			if (old_block) {
+				BHDR(s->base)->h_refcount -= 1;
+				error = io_channel_write_blk(fs->io,
+						inode->i_file_acl, 1, s->base);
+				if (error)
+					goto cleanup;
+			}
+		}
+	}
+
+	/* Update the i_blocks if we added a new EA block */
+	if (!inode->i_file_acl && new_buf)
+		inode->i_blocks += fs->blocksize / 512;
+	/* Update the inode. */
+	inode->i_file_acl = new_buf ? blk : 0;
+
+cleanup:
+	if(clear_flag)
+		free(s->base);
+	return 0;
+}
+
+static int ext2fs_attr_ibody_set(ext2_filsys fs, struct ext2_inode_large *inode,
+				 struct ext2_attr_info *i,
+				 struct ext2_attr_ibody_find *is)
+{
+	__u32 *eamagic;
+	struct ext2_attr_search *s = &is->s;
+	int error;
+
+	if (EXT2_INODE_SIZE(fs->super) == EXT2_GOOD_OLD_INODE_SIZE)
+		return;
+
+	error = ext2fs_attr_set_entry(fs, i, s);
+	if (error)
+		return error;
+
+	eamagic = IHDR(inode);
+	if (!EXT2_EXT_IS_LAST_ENTRY(s->first))
+		*eamagic = EXT2_EXT_ATTR_MAGIC;
+	else
+		*eamagic = 0;
+
+	error = ext2fs_write_inode_full(fs, is->ino, (struct ext2_inode *)inode,
+					EXT2_INODE_SIZE(fs->super));
+	if (error) {
+		com_err("ext2fs_attr_ibody_set: %d ", error,
+			("while writing inode %lu."), is->ino);
+		exit(1);
+	}
+
+	return 0;
+}
+
+
+int ext2fs_attr_set(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
+		    int name_index, const char *name, const char *value,
+		    int value_len, int flags)
+{
+	struct ext2_inode_large *inode_large;
+	struct ext2_attr_info i = {
+		.name_index = name_index,
+		.name = name,
+		.value = value,
+		.value_len = value_len,
+	};
+	struct ext2_attr_ibody_find is = {
+		.ino = ino,
+		.s = { .not_found = -ENODATA, },
+	};
+	struct ext2_attr_block_find bs = {
+		.s = { .not_found = -ENODATA, },
+	};
+	int error;
+
+	if (!name)
+		return -EINVAL;
+	if (strlen(name) > 255)
+		return -ERANGE;
+
+	if (EXT2_INODE_SIZE(fs->super) != EXT2_GOOD_OLD_INODE_SIZE)
+		inode_large = (struct ext2_inode_large *) inode;
+
+	if (EXT2_INODE_SIZE(fs->super) != EXT2_GOOD_OLD_INODE_SIZE) {
+		error = ext2fs_attr_ibody_find(fs, inode_large, &i, &is);
+		if (error)
+			goto cleanup;
+	}
+	if (is.s.not_found)
+		error = ext2fs_attr_block_find(fs, inode, &i, &bs);
+	if (error)
+		goto cleanup;
+	if (is.s.not_found && bs.s.not_found) {
+		error = -ENODATA;
+		if (flags & XATTR_REPLACE)
+			goto cleanup;
+		error = 0;
+		if (!value)
+			goto cleanup;
+	} else {
+		error = -EEXIST;
+		if (flags & XATTR_CREATE)
+			goto cleanup;
+	}
+
+	if (!value) {
+		if (!is.s.not_found &&
+		    (EXT2_INODE_SIZE(fs->super) != EXT2_GOOD_OLD_INODE_SIZE))
+			error = ext2fs_attr_ibody_set(fs, inode_large, &i, &is);
+		else if (!bs.s.not_found)
+			error = ext2fs_attr_block_set(fs, inode, &i, &bs);
+	} else {
+		if (EXT2_INODE_SIZE(fs->super) != EXT2_GOOD_OLD_INODE_SIZE)
+			error = ext2fs_attr_ibody_set(fs, inode_large, &i, &is);
+		if (!error && !bs.s.not_found) {
+			i.value = NULL;
+			error = ext2fs_attr_block_set(fs, inode, &i, &bs);
+		} else if (error == -ENOSPC) {
+			error = ext2fs_attr_block_set(fs, inode, &i, &bs);
+			if (error)
+				goto cleanup;
+			if (!is.s.not_found) {
+				i.value = NULL;
+				if (EXT2_INODE_SIZE(fs->super) !=
+				    EXT2_GOOD_OLD_INODE_SIZE)
+					error = ext2fs_attr_ibody_set(fs, inode_large,
+								      &i, &is);
+			}
+		}
+	}
+
+cleanup:
+	return error;
+}
+
+static int ext2fs_attr_check_block(ext2_filsys fs, char *block)
+{
+	int error;
+
+	if (BHDR(block)->h_magic != (EXT2_EXT_ATTR_MAGIC) ||
+	    BHDR(block)->h_blocks != 1)
+		return -EIO;
+	error = ext2fs_attr_check_names((struct ext2_ext_attr_entry *)
+					(BHDR(block) + 1), block +
+					fs->blocksize);
+	return error;
+}
+
+static int ext2fs_attr_block_get(ext2_filsys fs, struct ext2_inode *inode,
+				 int name_index, const char *name, void *buffer,
+				 size_t buffer_size)
+{
+	struct ext2_ext_attr_header *header = NULL;
+	struct ext2_ext_attr_entry *entry;
+	char *block_buf = NULL;
+	int size;
+	int error;
+
+	error = -ENODATA;
+	if (!inode->i_file_acl)
+		goto cleanup;
+
+	error = ext2fs_get_mem(fs->blocksize, &block_buf);
+	if (error)
+		return error;
+	error = ext2fs_read_ext_attr(fs, inode->i_file_acl, block_buf);
+	if (error)
+		com_err("ext2fs_attr_block_get: %d ", error,
+			("while reading EA block."));
+
+	if (ext2fs_attr_check_block(fs, block_buf)) {
+bad_block:      com_err("ext2fs_attr_block_get: bad EA block %lu.",
+			inode->i_file_acl, ("in inode"));
+		error = -EIO;
+		goto cleanup;
+	}
+	header = BHDR(block_buf);
+	entry = (struct ext2_ext_attr_entry *)(header+1);
+	error = ext2fs_attr_find_entry(&entry, name_index, name,
+				       fs->blocksize, 1);
+	if (error == -EIO)
+		goto bad_block;
+	if (error)
+		goto cleanup;
+	size = entry->e_value_size;
+	if (buffer) {
+		error = -ERANGE;
+		if (size > buffer_size)
+			goto cleanup;
+		memcpy(buffer, block_buf + entry->e_value_offs, size);
+	}
+	error = size;
+
+cleanup:
+	if (block_buf)
+		ext2fs_free_mem (&block_buf);
+	return error;
+}
+
+static int ext2fs_attr_ibody_get(ext2_filsys fs, struct ext2_inode_large *inode,
+				 int name_index, const char *name, void *buffer,
+				 size_t buffer_size)
+{
+	struct ext2_attr_ibody_header *header;
+	struct ext2_ext_attr_entry *entry;
+	int size, error;
+	char *end, *start;
+	__u32 *eamagic;
+
+	if (EXT2_INODE_SIZE(fs->super) == EXT2_GOOD_OLD_INODE_SIZE)
+		return;
+
+	eamagic = IHDR(inode);
+	if (*eamagic != EXT2_EXT_ATTR_MAGIC)
+		return -ENODATA;
+
+	start = (char *) inode + EXT2_GOOD_OLD_INODE_SIZE +
+				inode->i_extra_isize + sizeof(__u32);
+	entry = (struct ext2_ext_attr_entry *) start;
+	end = (char *)inode + EXT2_INODE_SIZE(fs->super);
+	error = ext2fs_attr_check_names(entry, end);
+	if (error)
+		goto cleanup;
+	error = ext2fs_attr_find_entry(&entry, name_index, name,
+				       end - (char *)entry, 0);
+	if (error)
+		goto cleanup;
+	size = entry->e_value_size;
+	if (buffer) {
+		error = -ERANGE;
+		if (size > buffer_size)
+			goto cleanup;
+		memcpy(buffer, start + entry->e_value_offs, size);
+	}
+	error = size;
+
+cleanup:
+	return error;
+}
+
+
+int ext2fs_attr_get(ext2_filsys fs, struct ext2_inode *inode, int name_index,
+		    const char *name, char *buffer, size_t buffer_size)
+{
+	int error = -ENODATA;
+
+	if (EXT2_INODE_SIZE(fs->super) != EXT2_GOOD_OLD_INODE_SIZE)
+		error = ext2fs_attr_ibody_get(fs, (struct ext2_inode_large *)inode,
+					      name_index, name, buffer,
+					      buffer_size);
+	if (error == -ENODATA)
+		error = ext2fs_attr_block_get(fs, inode, name_index, name,
+					      buffer, buffer_size);
+
+	return error;
+}
+
+char *ext2_attr_index_prefix[] = {
+	[EXT2_ATTR_INDEX_USER] = EXT2_ATTR_INDEX_USER_PREFIX,
+	[EXT2_ATTR_INDEX_POSIX_ACL_ACCESS] = EXT2_ATTR_INDEX_POSIX_ACL_ACCESS_PREFIX,
+	[EXT2_ATTR_INDEX_POSIX_ACL_DEFAULT] = EXT2_ATTR_INDEX_POSIX_ACL_DEFAULT_PREFIX,
+	[EXT2_ATTR_INDEX_TRUSTED] = EXT2_ATTR_INDEX_TRUSTED_PREFIX,
+	[EXT2_ATTR_INDEX_LUSTRE] = EXT2_ATTR_INDEX_LUSTRE_PREFIX,
+	[EXT2_ATTR_INDEX_SECURITY] = EXT2_ATTR_INDEX_SECURITY_PREFIX,
+	NULL
+};
+
+int ext2fs_attr_get_next_attr(struct ext2_ext_attr_entry *entry, int name_index,
+			      char *buffer, int buffer_size, int start)
+{
+	const int prefix_len = strlen(ext2_attr_index_prefix[name_index]);
+	int total_len;
+
+	if (!start && !EXT2_EXT_IS_LAST_ENTRY(entry))
+		entry = EXT2_EXT_ATTR_NEXT(entry);
+
+	for (; !EXT2_EXT_IS_LAST_ENTRY(entry);
+	     entry = EXT2_EXT_ATTR_NEXT(entry)) {
+		if (!name_index)
+			break;
+		if (name_index == entry->e_name_index)
+			break;
+	}
+	if (EXT2_EXT_IS_LAST_ENTRY(entry))
+		return 0;
+
+	total_len = prefix_len + entry->e_name_len + 1;
+	if (buffer && total_len <= buffer_size) {
+		memcpy(buffer, ext2_attr_index_prefix[name_index], prefix_len);
+		memcpy(buffer + prefix_len, entry->e_name, entry->e_name_len);
+		buffer[prefix_len + entry->e_name_len] = '\0';
+	}
+
+	return total_len;
+}
+
+int ext2fs_expand_extra_isize(ext2_filsys fs, ext2_ino_t ino,
+			      struct ext2_inode_large *inode,
+			      int new_extra_isize, int *ret, int *needed_size)
+{
+	struct ext2_inode *inode_buf = NULL;
+	__u32 *eamagic = NULL;
+	struct ext2_ext_attr_header *header = NULL;
+	struct ext2_ext_attr_entry *entry = NULL, *last = NULL;
+       	struct ext2_attr_ibody_find is = {
+		.ino = ino,
+	       	.s = { .not_found = -ENODATA, },
+	};
+       	struct ext2_attr_block_find bs = {
+		.s = { .not_found = -ENODATA, },
+       	};
+	struct ext2_attr_info i = {
+		.value = NULL,
+		.value_len = 0,
+	};
+	char *start, *end, *block_buf = NULL, *buffer = NULL, *b_entry_name = NULL;
+	int total_ino = 0, total_blk, free, offs, tried_min_extra_isize = 0;
+	int s_min_extra_isize = fs->super->s_min_extra_isize, error = 0;
+
+	if (needed_size)
+		*needed_size = new_extra_isize;
+	error = ext2fs_get_mem(fs->blocksize, &block_buf);
+	if (error)
+		return error;
+
+	if (!inode) {
+		error = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode_buf);
+		if (error)
+			return error;
+
+		error = ext2fs_read_inode_full(fs, ino, inode_buf,
+					       EXT2_INODE_SIZE(fs->super));
+		if (error) {
+			com_err("ext2fs_expand_extra_isize: %d ", error,
+				("while reading inode %lu."), ino);
+			return error;
+		}
+		inode = (struct ext2_inode_large *)inode_buf;
+	}
+
+retry:
+	if (inode->i_extra_isize >= new_extra_isize)
+		return 0;
+
+	eamagic = IHDR(inode);
+	/* No extended attributes present */
+	if (*eamagic != EXT2_EXT_ATTR_MAGIC) {
+		memset((char *)inode + EXT2_GOOD_OLD_INODE_SIZE, 0,
+		       EXT2_INODE_SIZE(fs->super) - EXT2_GOOD_OLD_INODE_SIZE);
+		inode->i_extra_isize = new_extra_isize;
+		if (needed_size)
+			*needed_size = 0;
+		goto write_inode;
+	}
+
+	start = (char *) inode + EXT2_GOOD_OLD_INODE_SIZE +
+					inode->i_extra_isize + sizeof(__u32);
+	end = (char *) inode + EXT2_INODE_SIZE(fs->super);
+	last = entry = (struct ext2_ext_attr_entry *) start;
+	offs = end - start;
+	/* Consider space takenup by magic number */
+	total_ino = sizeof(__u32);
+	free = ext2fs_attr_free_space(last, &offs, start, &total_ino);
+
+	/* Enough free space available in the inode for expansion */
+	if (free >= new_extra_isize) {
+		ext2fs_attr_shift_entries(entry, inode->i_extra_isize -
+				new_extra_isize, (char *)inode +
+				EXT2_GOOD_OLD_INODE_SIZE + new_extra_isize,
+				(char *)start - sizeof(__u32), total_ino);
+		inode->i_extra_isize = new_extra_isize;
+		if (needed_size)
+			*needed_size = 0;
+		goto write_inode;
+	}
+
+	if (inode->i_file_acl) {
+		error = ext2fs_read_ext_attr(fs, inode->i_file_acl, block_buf);
+		if (error) {
+			 com_err("ext2fs_expand_extra_isize: %d ", error,
+				 (" while reading EA block %lu."), ino);
+		}
+
+		header = BHDR(block_buf);
+		if (header->h_magic != EXT2_EXT_ATTR_MAGIC) {
+			error = -1;
+			goto cleanup;
+		}
+		end = block_buf + fs->blocksize;
+		last = entry = (struct ext2_ext_attr_entry *)(header+1);
+		start = (char *) entry;
+		offs = end - start;
+		free = ext2fs_attr_free_space(last, &offs, start, &total_blk);
+		if (free < new_extra_isize) {
+			if (!tried_min_extra_isize && s_min_extra_isize) {
+				tried_min_extra_isize++;
+				new_extra_isize = s_min_extra_isize;
+				goto retry;
+			}
+			if (ret)
+				*ret = EXT2_EXPAND_EISIZE_NOSPC;
+			error = -1;
+			goto cleanup;
+		}
+	} else {
+		if (ret && *ret == EXT2_EXPAND_EISIZE_UNSAFE) {
+			*ret = EXT2_EXPAND_EISIZE_NEW_BLOCK;
+			error = 0;
+			goto cleanup;
+		}
+		free = fs->blocksize;
+	}
+
+	while (new_extra_isize > 0) {
+		int offs, size, entry_size;
+		struct ext2_ext_attr_entry *small_entry = NULL;
+		struct ext2_attr_info i = {
+			.value = NULL,
+			.value_len = 0,
+		};
+		unsigned int total_size, shift_bytes, temp = ~0U, extra_isize = 0;
+
+		start = (char *) inode + EXT2_GOOD_OLD_INODE_SIZE +
+					inode->i_extra_isize + sizeof(__u32);
+		end = (char *) inode + EXT2_INODE_SIZE(fs->super);
+		last = (struct ext2_ext_attr_entry *) start;
+
+		/* Find the entry best suited to be pushed into EA block */
+		entry = NULL;
+		for (; !EXT2_EXT_IS_LAST_ENTRY(last);
+			last = EXT2_EXT_ATTR_NEXT(last)) {
+			total_size = EXT2_EXT_ATTR_SIZE(last->e_value_size) +
+					EXT2_EXT_ATTR_LEN(last->e_name_len);
+			if (total_size <= free && total_size < temp) {
+				if (total_size < new_extra_isize) {
+					small_entry = last;
+				} else {
+					entry = last;
+					temp = total_size;
+				}
+			}
+		}
+
+		if (entry == NULL) {
+			if (small_entry) {
+				entry = small_entry;
+			} else {
+				if (!tried_min_extra_isize &&
+				    s_min_extra_isize) {
+					tried_min_extra_isize++;
+					new_extra_isize = s_min_extra_isize;
+					goto retry;
+				}
+				if (ret)
+					*ret = EXT2_EXPAND_EISIZE_NOSPC;
+				error = -1;
+				goto cleanup;
+			}
+		}
+		offs = entry->e_value_offs;
+		size = entry->e_value_size;
+		entry_size = EXT2_EXT_ATTR_LEN(entry->e_name_len);
+		i.name_index = entry->e_name_index;
+		error = ext2fs_get_mem(size, &buffer);
+		if (error)
+			goto cleanup;
+		error = ext2fs_get_mem(entry->e_name_len + 1, &b_entry_name);
+		if (error)
+			goto cleanup;
+		/* Save the entry name and the entry value */
+		memcpy((char *)buffer, (char *) start + offs,
+		       EXT2_EXT_ATTR_SIZE(size));
+		memcpy((char *)b_entry_name, (char *)entry->e_name,
+		       entry->e_name_len);
+		b_entry_name[entry->e_name_len] = '\0';
+		i.name = b_entry_name;
+
+		error = ext2fs_attr_ibody_find(fs, inode, &i, &is);
+		if (error)
+			goto cleanup;
+
+		error = ext2fs_attr_set_entry(fs, &i, &is.s);
+		if (error)
+			goto cleanup;
+
+		entry = (struct ext2_ext_attr_entry *) start;
+		if (entry_size + EXT2_EXT_ATTR_SIZE(size) >= new_extra_isize)
+			shift_bytes = new_extra_isize;
+		else
+			shift_bytes = entry_size + EXT2_EXT_ATTR_SIZE(size);
+		ext2fs_attr_shift_entries(entry, inode->i_extra_isize -
+			shift_bytes, (char *)inode +
+			EXT2_GOOD_OLD_INODE_SIZE + extra_isize + shift_bytes,
+			(char *)start - sizeof(__u32), total_ino - entry_size);
+
+		extra_isize += shift_bytes;
+		new_extra_isize -= shift_bytes;
+		if (needed_size)
+			*needed_size = new_extra_isize;
+		inode->i_extra_isize = extra_isize;
+
+		i.name = b_entry_name;
+		i.value = buffer;
+		i.value_len = size;
+		error = ext2fs_attr_block_find(fs, (struct ext2_inode *) inode,
+					       &i, &bs);
+		if (error)
+			goto cleanup;
+
+		/* Add entry which was removed from the inode into the block */
+		error = ext2fs_attr_block_set(fs, (struct ext2_inode *) inode,
+					      &i, &bs);
+		if (error)
+			goto cleanup;
+	}
+
+write_inode:
+	error = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *) inode,
+				 	EXT2_INODE_SIZE(fs->super));
+	if (error) {
+		com_err("ext2fs_expand_extra_isize: %d ", error,
+			("while writing inode %lu."), ino);
+		exit(1);
+	}
+cleanup:
+	if (inode_buf)
+		ext2fs_free_mem(&inode_buf);
+	if (block_buf)
+		ext2fs_free_mem(&block_buf);
+	if (buffer)
+		ext2fs_free_mem(&buffer);
+	if (b_entry_name)
+		ext2fs_free_mem(&b_entry_name);
+
+	return error;
+}
Index: e2fsprogs-1.40/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/unix.c
+++ e2fsprogs-1.40/e2fsck/unix.c
@@ -543,6 +543,9 @@ static void parse_extended_opts(e2fsck_t
 				continue;
 			}
 			ctx->ext_attr_ver = ea_ver;
+		/* -E expand_extra_isize - enable EXTRA_ISIZE feature */
+		} else if (strcmp(token, "expand_extra_isize") == 0) {
+			ctx->flags |= E2F_FLAG_EXPAND_EISIZE;
 		} else {
 			fprintf(stderr, _("Unknown extended option: %s\n"),
 				token);
@@ -1109,6 +1112,54 @@ restart:
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 		fatal_error(ctx, 0);
 	check_if_skip(ctx);
+
+	if (EXT2_GOOD_OLD_INODE_SIZE + sb->s_want_extra_isize >
+							EXT2_INODE_SIZE(sb)) {
+		if (fix_problem(ctx, PR_0_WANT_EXTRA_ISIZE_INVALID, &pctx))
+			sb->s_want_extra_isize = sizeof(struct ext2_inode_large) -
+						       EXT2_GOOD_OLD_INODE_SIZE;
+	}
+	if (EXT2_GOOD_OLD_INODE_SIZE + sb->s_min_extra_isize >
+							EXT2_INODE_SIZE(sb)) {
+		if (fix_problem(ctx, PR_0_MIN_EXTRA_ISIZE_INVALID, &pctx))
+			sb->s_min_extra_isize = 0;
+	}
+	if (EXT2_INODE_SIZE(sb) > EXT2_GOOD_OLD_INODE_SIZE) {
+		ctx->want_extra_isize = sizeof(struct ext2_inode_large) -
+						     EXT2_GOOD_OLD_INODE_SIZE;
+		ctx->min_extra_isize = ~0L;
+		if (EXT2_HAS_RO_COMPAT_FEATURE(sb,
+				       EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)) {
+			if (ctx->want_extra_isize < sb->s_want_extra_isize)
+				ctx->want_extra_isize = sb->s_want_extra_isize;
+			if (ctx->want_extra_isize < sb->s_min_extra_isize)
+				ctx->want_extra_isize = sb->s_min_extra_isize;
+		}
+	}
+	else {
+		if (sb->s_feature_ro_compat &
+		    EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE) {
+			fix_problem(ctx, PR_0_CLEAR_EXTRA_ISIZE, &pctx);
+			sb->s_feature_ro_compat &=
+					~EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE;
+		}
+		sb->s_want_extra_isize = 0;
+		sb->s_min_extra_isize = 0;
+		ctx->flags &= ~E2F_FLAG_EXPAND_EISIZE;
+	}
+
+	if (ctx->options & E2F_OPT_READONLY) {
+		if (ctx->flags & (E2F_FLAG_EXPAND_EISIZE)) {
+			fprintf(stderr, _("Cannot enable EXTRA_ISIZE feature "
+					  "on read-only filesystem\n"));
+			exit(1);
+		}
+	} else {
+		if (sb->s_want_extra_isize > sb->s_min_extra_isize &&
+		    (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE))
+			ctx->flags |= E2F_FLAG_EXPAND_EISIZE;
+	}
+
 	if (bad_blocks_file)
 		read_bad_blocks_file(ctx, bad_blocks_file, replace_bad_blocks);
 	else if (cflag)
@@ -1214,6 +1265,41 @@ restart:
 		}
 	}
 
+	if (ctx->flags & E2F_FLAG_EXPAND_EISIZE) {
+		int min_extra_isize;
+
+		if (!ctx->expand_eisize_map)
+			goto set_min_extra_isize;
+
+		for (pctx.ino = 1; pctx.ino < fs->super->s_inodes_count;
+		     pctx.ino++) {
+			if (ext2fs_test_inode_bitmap(ctx->expand_eisize_map,
+			    pctx.ino)) {
+				fix_problem(ctx, PR_6_EXPAND_EISIZE, &pctx);
+				ext2fs_expand_extra_isize(fs, pctx.ino, 0,
+						  ctx->want_extra_isize, 0);
+			}
+		}
+		ext2fs_free_inode_bitmap(ctx->expand_eisize_map);
+
+set_min_extra_isize:
+		if (fs->super->s_min_extra_isize)
+			min_extra_isize = fs->super->s_min_extra_isize;
+		else
+			min_extra_isize = ctx->want_extra_isize;
+		if (ctx->min_extra_isize >= min_extra_isize &&
+		    !ctx->fs_unexpanded_inodes) {
+			fs->super->s_min_extra_isize = ctx->min_extra_isize;
+			ctx->fs->super->s_feature_ro_compat |=
+					EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE;
+		} else {
+			fs->super->s_min_extra_isize = 0;
+			ctx->fs->super->s_feature_ro_compat &=
+					~EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE;
+		}
+		ext2fs_mark_super_dirty(fs);
+	}
+
 	e2fsck_write_bitmaps(ctx);
 	
 	ext2fs_close(fs);
Index: e2fsprogs-1.40/lib/ext2fs/ext2_ext_attr.h
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/ext2_ext_attr.h
+++ e2fsprogs-1.40/lib/ext2fs/ext2_ext_attr.h
@@ -15,6 +15,9 @@
 /* Maximum number of references to one attribute block */
 #define EXT2_EXT_ATTR_REFCOUNT_MAX	1024
 
+#define XATTR_CREATE    0x1     /* set value, fail if attr already exists */
+#define XATTR_REPLACE   0x2     /* set value, fail if attr does not exist */
+
 struct ext2_ext_attr_header {
 	__u32	h_magic;	/* magic number for identification */
 	__u32	h_refcount;	/* reference count */
@@ -35,6 +38,32 @@ struct ext2_ext_attr_entry {
 #endif
 };
 
+#define BHDR(block) ((struct ext2_ext_attr_header *) block)
+#define IHDR(inode)			   	\
+	((__u32 *) ((char *)inode +	     	\
+		    EXT2_GOOD_OLD_INODE_SIZE +  \
+		    (inode)->i_extra_isize))
+#define ENTRY(ptr) ((struct ext2_ext_attr_entry *)(ptr))
+
+/* Name indexes */
+#define EXT2_ATTR_INDEX_USER		    	1
+#define EXT2_ATTR_INDEX_POSIX_ACL_ACCESS	2
+#define EXT2_ATTR_INDEX_POSIX_ACL_DEFAULT	3
+#define EXT2_ATTR_INDEX_TRUSTED			4
+#define EXT2_ATTR_INDEX_LUSTRE			5
+#define EXT2_ATTR_INDEX_SECURITY		6
+#define EXT2_ATTR_INDEX_MAX			7
+
+#define EXT2_ATTR_INDEX_USER_PREFIX		 "user."
+#define EXT2_ATTR_INDEX_POSIX_ACL_ACCESS_PREFIX	 "system.posix_acl_access"
+#define EXT2_ATTR_INDEX_POSIX_ACL_DEFAULT_PREFIX "system.posix_acl_default"
+#define EXT2_ATTR_INDEX_TRUSTED_PREFIX		 "trusted."
+#define EXT2_ATTR_INDEX_LUSTRE_PREFIX		 "lustre."
+#define EXT2_ATTR_INDEX_SECURITY_PREFIX		 "security."
+
+#define EXT2_ATTR_PREFIX(index) (index ## _PREFIX)
+#define EXT2_ATTR_PREFIX_LEN(index) (index ## _PRE_LEN)
+
 #define EXT2_EXT_ATTR_PAD_BITS		2
 #define EXT2_EXT_ATTR_PAD		((unsigned) 1<<EXT2_EXT_ATTR_PAD_BITS)
 #define EXT2_EXT_ATTR_ROUND		(EXT2_EXT_ATTR_PAD-1)
Index: e2fsprogs-1.40/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.40/e2fsck/e2fsck.h
@@ -170,6 +170,7 @@ struct resource_track {
 					* specified by the user */
 #define E2F_FLAG_RESTARTED	0x0200 /* E2fsck has been restarted */
 #define E2F_FLAG_RESIZE_INODE	0x0400 /* Request to recreate resize inode */
+#define E2F_FLAG_EXPAND_EISIZE	0x2000 /* Expand the inodes (i_extra_isize) */
 
 /*
  * Defines for indicating the e2fsck pass number
@@ -332,6 +333,15 @@ struct e2fsck_struct {
 
 	profile_t	profile;
 
+	/* Expand large inodes to atleast these many bytes */
+	int want_extra_isize;
+	/* minimum i_extra_isize found in used inodes. Should not be lesser
+	 * than s_min_extra_isize.
+	 */
+	__u32 min_extra_isize;
+	int fs_unexpanded_inodes;
+	ext2fs_inode_bitmap expand_eisize_map;
+
 	/*
 	 * For the use of callers of the e2fsck functions; not used by
 	 * e2fsck functions themselves.
Index: e2fsprogs-1.40/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-1.40/lib/ext2fs/ext2_fs.h
@@ -410,10 +410,17 @@ struct ext2_inode_large {
 	__u32	i_atime_extra;	/* extra Access time (nsec << 2 | epoch) */
 	__u32	i_crtime;	/* File creation time */
 	__u32	i_crtime_extra;	/* extra File creation time (nsec << 2 | epoch)*/
+	__u32   i_version_hi;   /* high 32 bits for 64-bit version */
 };
 
 #define i_size_high	i_dir_acl
 
+#define EXT2_FITS_IN_INODE(inode, field)		\
+	((offsetof(struct ext2_inode_large, field) +	\
+	 sizeof((inode)->field)) <=			\
+	 		 (EXT2_GOOD_OLD_INODE_SIZE +	\
+	     		  (inode)->i_extra_isize))	\
+
 #if defined(__KERNEL__) || defined(__linux__)
 #define i_reserved1	osd1.linux1.l_i_reserved1
 #define i_frag		osd2.linux2.l_i_frag
@@ -636,6 +643,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE| \
 					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
 
 /*
Index: e2fsprogs-1.40/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/pass1.c
+++ e2fsprogs-1.40/e2fsck/pass1.c
@@ -23,6 +23,7 @@
  * 	- A bitmap of which inodes have bad fields.	(inode_bad_map)
  * 	- A bitmap of which inodes are in bad blocks.	(inode_bb_map)
  * 	- A bitmap of which inodes are imagic inodes.	(inode_imagic_map)
+ *	- A bitmap of which inodes need to be expanded  (expand_eisize_map)
  * 	- A bitmap of which blocks are in use.		(block_found_map)
  * 	- A bitmap of which blocks are in use by two inodes	(block_dup_map)
  * 	- The data blocks of the directory inodes.	(dir_map)
@@ -239,15 +240,15 @@ static void check_size(e2fsck_t ctx, str
 	inode->i_size_high = 0;
 	e2fsck_write_inode(ctx, pctx->ino, pctx->inode, "pass1");
 }
-	
+
 static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 {
 	struct ext2_super_block *sb = ctx->fs->super;
 	struct ext2_inode_large *inode;
 	struct ext2_ext_attr_entry *entry;
 	char *start, *end;
-	unsigned int storage_size, remain;
-	int problem = 0;
+	unsigned int storage_size, remain, offs;
+	int problem = 0, no_problem = 0, retval;
 
 	inode = (struct ext2_inode_large *) pctx->inode;
 	storage_size = EXT2_INODE_SIZE(ctx->fs->super) -
@@ -348,16 +349,27 @@ static void check_inode_extra_space(e2fs
 	    (inode->i_extra_isize < min || inode->i_extra_isize > max)) {
 		if (!fix_problem(ctx, PR_1_EXTRA_ISIZE, pctx))
 			return;
-		inode->i_extra_isize = min;
+		inode->i_extra_isize = ctx->want_extra_isize;
 		e2fsck_write_inode_full(ctx, pctx->ino, pctx->inode,
 					EXT2_INODE_SIZE(sb), "pass1");
 		return;
 	}
 
-	eamagic = (__u32 *) (((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
-			inode->i_extra_isize);
-	if (*eamagic == EXT2_EXT_ATTR_MAGIC) {
-		/* it seems inode has an extended attribute(s) in body */
+	eamagic = IHDR(inode);
+	if (*eamagic != EXT2_EXT_ATTR_MAGIC &&
+	    (ctx->flags & E2F_FLAG_EXPAND_EISIZE) &&
+	    (inode->i_extra_isize < ctx->want_extra_isize)) {
+     		fix_problem(ctx, PR_1_EXPAND_EISIZE, pctx);
+		memset((char *)inode + EXT2_GOOD_OLD_INODE_SIZE, 0,
+ 	       		EXT2_INODE_SIZE(sb) - EXT2_GOOD_OLD_INODE_SIZE);
+		inode->i_extra_isize = ctx->want_extra_isize;
+		e2fsck_write_inode_full(ctx, pctx->ino,
+					(struct ext2_inode *) inode,
+					EXT2_INODE_SIZE(sb),
+					"check_inode_extra_space");
+		if (inode->i_extra_isize < ctx->min_extra_isize)
+			ctx->min_extra_isize = inode->i_extra_isize;
+	} else {
 		check_ea_in_inode(ctx, pctx);
 	}
 }
@@ -460,6 +472,155 @@ extern void e2fsck_setup_tdb_icount(e2fs
 		*ret = 0;
 }
 
+extern char *ext2_attr_index_prefix[];
+
+int e2fsck_pass1_delete_attr(e2fsck_t ctx, struct ext2_inode_large *inode,
+			     struct problem_context *pctx, int needed_size)
+{
+	struct ext2_ext_attr_header *header;
+	struct ext2_ext_attr_entry *entry_ino, *entry_blk, *entry;
+	char *start, name[4096], block_buf[4096];
+	int len, index = EXT2_ATTR_INDEX_USER, entry_size, ea_size;
+	int in_inode = 1, prefix_len, error;
+	unsigned int freed_bytes = inode->i_extra_isize;
+
+	start = (char *) inode + EXT2_GOOD_OLD_INODE_SIZE +
+					inode->i_extra_isize + sizeof(__u32);
+	entry_ino = (struct ext2_ext_attr_entry *) start;
+
+	if (inode->i_file_acl) {
+		error = ext2fs_read_ext_attr(ctx->fs, inode->i_file_acl,
+					     block_buf);
+		if (error) {
+			 com_err("e2fsck_pass1_delete_attr: %d ", error,
+				 _(" while reading EA block %lu."), pctx->ino);
+		}
+
+		header = BHDR(block_buf);
+		if (header->h_magic != EXT2_EXT_ATTR_MAGIC) {
+			error = -1;
+			return 0;
+		}
+		entry_blk = (struct ext2_ext_attr_entry *)(header+1);
+	}
+	entry = entry_ino;
+	len = sizeof(entry->e_name);
+	entry_size = ext2fs_attr_get_next_attr(entry, index, name, len, 1);
+
+	while (freed_bytes < needed_size) {
+		if (entry_size && name[0] != '\0') {
+			pctx->str = name;
+			if (fix_problem(ctx, PR_1_EISIZE_DELETE_EA, pctx)) {
+				int i;
+
+				ea_size = EXT2_EXT_ATTR_LEN(entry->e_name_len) +
+					  EXT2_EXT_ATTR_SIZE(entry->e_value_size);
+				i = strlen(ext2_attr_index_prefix[entry->e_name_index]);
+				error = ext2fs_attr_set(ctx->fs, pctx->ino,
+							(struct ext2_inode *)inode,
+							index, &name[i], 0, 0, 0);
+				if (!error)
+					freed_bytes += ea_size;
+			}
+		}
+		len = sizeof(entry->e_name);
+		entry_size = ext2fs_attr_get_next_attr(entry, index, name, len, 0);
+		entry = EXT2_EXT_ATTR_NEXT(entry);
+		if (EXT2_EXT_IS_LAST_ENTRY(entry)) {
+			if (in_inode) {
+				entry = entry_blk;
+			        len = sizeof(entry->e_name);
+				entry_size = ext2fs_attr_get_next_attr(entry,
+							index, name, len, 1);
+				in_inode = 0;
+			} else {
+				index += 1;
+				in_inode = 1;
+				if (!entry && index < EXT2_ATTR_INDEX_MAX)
+					entry = (struct ext2_ext_attr_entry *) start;
+				else
+					return freed_bytes;
+			}
+		}
+	}
+
+	return freed_bytes;
+}
+
+int e2fsck_pass1_expand_eisize(e2fsck_t ctx, struct ext2_inode_large *inode,
+			       struct problem_context *pctx)
+{
+	int needed_size = 0, retval, ret = EXT2_EXPAND_EISIZE_UNSAFE;
+	static int message;
+
+retry:
+	retval = ext2fs_expand_extra_isize(ctx->fs, pctx->ino, inode,
+					   ctx->want_extra_isize, &ret,
+					   &needed_size);
+	if (ret & EXT2_EXPAND_EISIZE_NEW_BLOCK)
+		goto mark_expand_eisize_map;
+	if (!retval) {
+		e2fsck_write_inode_full(ctx, pctx->ino,
+					(struct ext2_inode *)inode,
+					EXT2_INODE_SIZE(ctx->fs->super),
+					"pass1");
+		return 0;
+	}
+
+	if (ret & EXT2_EXPAND_EISIZE_NOSPC) {
+		if (ctx->options & (E2F_OPT_PREEN | E2F_OPT_YES)) {
+			fix_problem(ctx, PR_1_EA_BLK_NOSPC, pctx);
+			ctx->flags |= E2F_FLAG_ABORT;
+			return -1;
+		}
+
+		if (!message) {
+			pctx->num = ctx->fs->super->s_min_extra_isize;
+			fix_problem(ctx, PR_1_EXPAND_EISIZE_WARNING, pctx);
+			message = 1;
+		}
+delete_EA:
+		retval = e2fsck_pass1_delete_attr(ctx, inode, pctx,
+						  needed_size);
+		if (retval >= ctx->want_extra_isize)
+			goto retry;
+
+		needed_size -= retval;
+
+		/*
+		 * We loop here until either the user deletes EA(s) or
+		 * EXTRA_ISIZE feature is disabled.
+		 */
+		if (fix_problem(ctx, PR_1_CLEAR_EXTRA_ISIZE, pctx)) {
+			ctx->fs->super->s_feature_ro_compat &=
+					~EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE;
+			ext2fs_mark_super_dirty(ctx->fs);
+		} else {
+			goto delete_EA;
+		}
+		ctx->fs_unexpanded_inodes++;
+
+		/* No EA was deleted, inode cannot be expanded */
+		return -1;
+	}
+
+mark_expand_eisize_map:
+	if (!ctx->expand_eisize_map) {
+		pctx->errcode = ext2fs_allocate_inode_bitmap(ctx->fs,
+					 _("expand extrz isize map"),
+					 &ctx->expand_eisize_map);
+		if (pctx->errcode) {
+			fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR,
+				    pctx);
+			exit(1);
+		}
+	}
+
+	/* Add this inode to the expand_eisize_map */
+	ext2fs_mark_inode_bitmap(ctx->expand_eisize_map, pctx->ino);
+	return 0;
+}
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
 	int	i;
@@ -479,6 +640,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	int		imagic_fs;
 	int		busted_fs_time = 0;
 	int		inode_size;
+	int		retval;
 	
 #ifdef RESOURCE_TRACK
 	init_resource_track(&rtrack);
@@ -916,6 +1078,21 @@ void e2fsck_pass1(e2fsck_t ctx)
 		} else
 			check_blocks(ctx, &pctx, block_buf);
 
+		if (ctx->flags & E2F_FLAG_EXPAND_EISIZE) {
+			struct ext2_inode_large *inode_l;
+
+			inode_l = (struct ext2_inode_large *) inode;
+
+			if (inode_l->i_extra_isize < ctx->want_extra_isize) {
+				fix_problem(ctx, PR_1_EXPAND_EISIZE, &pctx);
+				retval = e2fsck_pass1_expand_eisize(ctx, inode_l,
+								    &pctx);
+			}
+			if ((inode_l->i_extra_isize < ctx->min_extra_isize) &&
+			    retval == 0)
+				ctx->min_extra_isize = inode_l->i_extra_isize;
+		}
+
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			return;
 
@@ -1223,7 +1400,7 @@ static void adjust_extattr_refcount(e2fs
 			fix_problem(ctx, PR_1_EXTATTR_READ_ABORT, &pctx);
 			return;
 		}
-		header = (struct ext2_ext_attr_header *) block_buf;
+		header = BHDR(block_buf);
 		pctx.blkcount = header->h_refcount;
 		should_be = header->h_refcount + adjust_sign * count;
 		pctx.num = should_be;
@@ -1329,7 +1506,7 @@ static int check_ext_attr(e2fsck_t ctx, 
 	pctx->errcode = ext2fs_read_ext_attr(fs, blk, block_buf);
 	if (pctx->errcode && fix_problem(ctx, PR_1_READ_EA_BLOCK, pctx))
 		goto clear_extattr;
-	header = (struct ext2_ext_attr_header *) block_buf;
+	header = BHDR(block_buf);
 	pctx->blk = inode->i_file_acl;
 	if (((ctx->ext_attr_ver == 1) &&
 	     (header->h_magic != EXT2_EXT_ATTR_MAGIC_v1)) ||
Index: e2fsprogs-1.40/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.40/lib/ext2fs/ext2fs.h
@@ -424,6 +424,12 @@ typedef struct ext2_icount *ext2_icount_
 #define EXT2_CHECK_MAGIC(struct, code) \
 	  if ((struct)->magic != (code)) return (code)
 
+/*
+ * Flags for returning status of ext2fs_expand_extra_isize()
+ */
+#define EXT2_EXPAND_EISIZE_UNSAFE	0x0001
+#define EXT2_EXPAND_EISIZE_NEW_BLOCK 	0x0002
+#define EXT2_EXPAND_EISIZE_NOSPC	0x0004
 
 /*
  * For ext2 compression support
@@ -462,6 +468,7 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT3_FEATURE_INCOMPAT_RECOVER)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
+					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
 
 /*
Index: e2fsprogs-1.40/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/problem.h
+++ e2fsprogs-1.40/e2fsck/problem.h
@@ -196,6 +196,16 @@ struct problem_context {
 /* Superblock hint for external journal incorrect */
 #define PR_0_DIRHASH_HINT			0x000034
 
+/* Invalid s_min_extra_isize */
+#define PR_0_MIN_EXTRA_ISIZE_INVALID		0x00003A
+
+/* Invalid s_want_extra_isize */
+#define PR_0_WANT_EXTRA_ISIZE_INVALID		0x00003B
+
+/* Clear EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE flag */
+#define PR_0_CLEAR_EXTRA_ISIZE			0x00003C
+
+
 /*
  * Pass 1 errors
  */
@@ -455,6 +465,25 @@ struct problem_context {
 /* inode appears to be a directory */
 #define PR_1_TREAT_AS_DIRECTORY		0x010055
 
+/* Warning for user that all inodes need to be expanded atleast by
+ * s_min_extra_isize
+ */
+#define PR_1_EXPAND_EISIZE_WARNING	0x010068
+
+/* Expand the inode */
+#define PR_1_EXPAND_EISIZE		0x010069
+
+/* Delete an EA so that EXTRA_ISIZE may be enabled */
+#define PR_1_EISIZE_DELETE_EA		0x01006A
+
+/* An EA needs to be deleted by e2fsck is being run with -p or -y */
+#define PR_1_EA_BLK_NOSPC		0x01006B
+
+/* Disable EXTRA_ISIZE feature as inode cannot be expanded
+ * without deletion of an EA
+ */
+#define PR_1_CLEAR_EXTRA_ISIZE		0x01006C
+
 /*
  * Pass 1b errors
  */
@@ -900,6 +929,9 @@ struct problem_context {
 /* Inode rangeused, but not marked used in bitmap */
 #define PR_5_INODE_RANGE_USED		0x050017
 
+/* Expand the inodes which need a new EA block */
+#define PR_6_EXPAND_EISIZE		0x060001
+
 /*
  * Function declarations
  */
Index: e2fsprogs-1.40/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/problem.c
+++ e2fsprogs-1.40/e2fsck/problem.c
@@ -351,6 +351,19 @@ static struct e2fsck_problem problem_tab
 	  N_("Adding dirhash hint to @f.\n\n"),
 	  PROMPT_NONE, 0 },
 
+	{ PR_0_MIN_EXTRA_ISIZE_INVALID,
+	  N_("@S has invalid s_min_extra_isize.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	{ PR_0_WANT_EXTRA_ISIZE_INVALID,
+	  N_("@S has invalid s_want_extra_isize.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	{ PR_0_CLEAR_EXTRA_ISIZE,
+	  N_("Disable extra_isize feature since @f has 128 byte inodes.  "),
+	  PROMPT_NONE, 0 },
+
+
 	/* Pass 1 errors */
 	
 	/* Pass 1: Checking inodes, blocks, and sizes */
@@ -784,6 +797,38 @@ static struct e2fsck_problem problem_tab
 	  N_("@i %i is a %It but it looks like it is really a directory.\n"),
 	  PROMPT_FIX, 0 },
 
+	/* expand inode */
+	{ PR_1_EXPAND_EISIZE_WARNING,
+	  N_("\ne2fsck is being run with \"expand_extra_isize\" option or\n"
+	     "s_min_extra_isize of %d bytes has been set in the superblock.\n"
+	     "Inode %i does not have enough free space.  Either some EAs\n"
+	     "need to be deleted from this inode or the RO_COMPAT_EXTRA_ISIZE\n"
+	     "flag must be cleared.\n\n"), PROMPT_NONE, PR_PREEN_OK | PR_NO_OK |
+   	     PR_PREEN_NOMSG },
+
+	/* expand inode */
+	{ PR_1_EXPAND_EISIZE,
+	  N_("Expanding @i %i.\n"),
+	  PROMPT_NONE, PR_PREEN_OK | PR_NO_OK | PR_PREEN_NOMSG },
+
+	/* delete an EA so that EXTRA_ISIZE feature may be enabled */
+	{ PR_1_EISIZE_DELETE_EA,
+	  N_("Delete EA %s of @i %i so that EXTRA_ISIZE feature may be "
+	     "enabled?\n"), PROMPT_FIX, PR_NO_OK | PR_PREEN_NO },
+
+	/* an EA needs to be deleted by e2fsck is being run with -p or -y */
+	{ PR_1_EA_BLK_NOSPC,
+	  N_("An EA needs to be deleted for @i %i but e2fsck is being run\n"
+	     "with -p or -y mode.\n"),
+	  PROMPT_ABORT, 0 },
+
+	/* disable EXTRA_ISIZE feature since inode cannot be expanded */
+	{ PR_1_CLEAR_EXTRA_ISIZE,
+	  N_("Disable EXTRA_ISIZE feature since @i %i cannot be expanded\n"
+	     "without deletion of an EA.\n"),
+	  PROMPT_FIX, 0 },
+
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
@@ -1494,6 +1539,11 @@ static struct e2fsck_problem problem_tab
 	  " +(%i--%j)",
 	  PROMPT_NONE, PR_LATCH_IBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
 
+	/* Expand inode */
+	{ PR_6_EXPAND_EISIZE,
+	  N_("Expanding @i %i.\n"),
+	  PROMPT_NONE, PR_PREEN_OK | PR_NO_OK | PR_PREEN_NOMSG },
+
 	{ 0 }
 };
 
Index: e2fsprogs-1.40/e2fsck/e2fsck.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/e2fsck.c
+++ e2fsprogs-1.40/e2fsck/e2fsck.c
@@ -150,6 +150,7 @@ errcode_t e2fsck_reset_context(e2fsck_t 
 	ctx->fs_tind_count = 0;
 	ctx->fs_fragmented = 0;
 	ctx->large_files = 0;
+	ctx->fs_unexpanded_inodes = 0;
 
 	/* Reset the superblock to the user's requested value */
 	ctx->superblock = ctx->use_superblock;

--=-xhWpUJARbWJC/8MjyERd--
