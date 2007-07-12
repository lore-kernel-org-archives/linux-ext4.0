From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
	features in larger inode
Date: Thu, 12 Jul 2007 17:44:35 +0530
Message-ID: <1184242475.4299.13.camel@garfield>
References: <1183275482.4010.133.camel@localhost.localdomain>
	 <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-GiLpj11SNWcqlJ8k5JRf"
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-GiLpj11SNWcqlJ8k5JRf
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-07-10 at 16:32 -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:38:01 -0400
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > This patch is on top of the nanosecond timestamp and i_version_hi
> > patches. 
> 
> This sort of information isn't needed (or desired) when this patch hits the
> git tree.  Please ensure that things like this are cleaned up before the
> patches go to Linus.

The incremental patch I have attached contains an updated Changelog
entry which cleans this up.

> > +	    !(EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND)) {
> > +		/* We need extra buffer credits since we may write into EA block
> > +		 * with this same handle */
> > +		if ((jbd2_journal_extend(handle,
> > +			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb))) == 0) {
> > +			ret = ext4_expand_extra_isize(inode,
> > +				EXT4_SB(inode->i_sb)->s_want_extra_isize,
> > +				iloc, handle);
> > +			if (ret) {
> > +				EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
> > +				if (!expand_message) {
> > +					ext4_warning(inode->i_sb, __FUNCTION__,
> > +					"Unable to expand inode %lu. Delete"
> > +					" some EAs or run e2fsck.",
> > +					inode->i_ino);
> > +					expand_message = 1;
> > +				}
> > +			}
> > +		}
> > +	}
> 
> Maybe that message should come out once per mount rather than once per boot
> (or once per modprobe)?

Done. Now the message gets printed the first time s_mnt_count changes,
which means once per mount.

> > +		if (free < new_extra_isize) {
> > +			if (!tried_min_extra_isize && s_min_extra_isize) {
> > +				tried_min_extra_isize++;
> > +				new_extra_isize = s_min_extra_isize;
> 
> Aren't we missing a brelse(bh) here?

I have corrected this.

> >  
> > +#define IHDR(inode, raw_inode) \
> > +	((struct ext4_xattr_ibody_header *) \
> > +		((void *)raw_inode + \
> > +		EXT4_GOOD_OLD_INODE_SIZE + \
> > +		EXT4_I(inode)->i_extra_isize))
> > +#define IFIRST(hdr) ((struct ext4_xattr_entry *)((hdr)+1))
> 
> Neither of these _have_ to be implemented as macros and hence they should
> not be.

These macros existed before and have just been moved. There are similar
such macros in the ext3/4 xattr code and they should probably be changed
to inlines. But that should be done in a different patch.

Thanks,
Kalpak.

--=-GiLpj11SNWcqlJ8k5JRf
Content-Disposition: attachment; filename=ext4_expand_inode_extra_isize_correction.patch
Content-Type: text/x-patch; name=ext4_expand_inode_extra_isize_correction.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

We need to make sure that existing ext3 filesystems can also avail the new
fields that have been added to the ext4 inode. We use s_want_extra_isize and
s_min_extra_isize to decide by how much we should expand the inode. If
EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE feature is set then we expand the inode by
max(s_want_extra_isize, s_min_extra_isize , sizeof(ext4_inode) -
EXT4_GOOD_OLD_INODE_SIZE) bytes. Actually it is still an open question
about whether users should be able to set s_*_extra_isize smaller than
the known fields or not.

This patch also adds the functionality to expand inodes to include the
newly added fields. We start by trying to expand by s_want_extra_isize
bytes and if its fails we try to expand by s_min_extra_isize bytes. This
is done by changing the i_extra_isize if enough space is available in
the inode and no EAs are present. If EAs are present and there is enough
space in the inode then the EAs in the inode are shifted to make space.
If enough space is not available in the inode due to the EAs then 1 or
more EAs are shifted to the external EA block. In the worst case when
even the external EA block does not have enough space we inform the user
that some EA would need to be deleted or s_min_extra_isize would have to
be reduced.

This would be online expansion of inodes. expand_extra_isize option will also
be added to e2fsck which will expand all the inodes and if for any reason 
expansion fails for any inode then the EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE
feature will be reset.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.22/fs/ext4/inode.c
===================================================================
--- linux-2.6.22.orig/fs/ext4/inode.c
+++ linux-2.6.22/fs/ext4/inode.c
@@ -3130,9 +3130,8 @@ int ext4_expand_extra_isize(struct inode
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_xattr_entry *entry;
 
-	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize) {
+	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)
 		return 0;
-	}
 
 	raw_inode = ext4_raw_inode(&iloc);
 
@@ -3148,9 +3147,9 @@ int ext4_expand_extra_isize(struct inode
 		return 0;
 	}
 
-	/* try to expand with EA present */
+	/* try to expand with EAs present */
 	return ext4_expand_extra_isize_ea(inode, new_extra_isize,
-						raw_inode, handle);
+					  raw_inode, handle);
 }
 
 /*
@@ -3177,29 +3176,34 @@ int ext4_expand_extra_isize(struct inode
 int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
 {
 	struct ext4_iloc iloc;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	static unsigned int mnt_count;
 	int err, ret;
-	static int expand_message;
 
 	might_sleep();
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
-	if (EXT4_I(inode)->i_extra_isize <
-	    EXT4_SB(inode->i_sb)->s_want_extra_isize &&
+	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
 	    !(EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND)) {
-		/* We need extra buffer credits since we may write into EA block
-		 * with this same handle */
+		/*
+		 * We need extra buffer credits since we may write into EA block
+		 * with this same handle. If journal_extend fails, then it will
+		 * only result in a minor loss of functionality for that inode.
+		 * If this is felt to be critical, then e2fsck should be run to
+		 * force a large enough s_min_extra_isize.
+		 */
 		if ((jbd2_journal_extend(handle,
 			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb))) == 0) {
 			ret = ext4_expand_extra_isize(inode,
-				EXT4_SB(inode->i_sb)->s_want_extra_isize,
-				iloc, handle);
+						      sbi->s_want_extra_isize,
+						      iloc, handle);
 			if (ret) {
 				EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
-				if (!expand_message) {
+				if (mnt_count != sbi->s_es->s_mnt_count) {
 					ext4_warning(inode->i_sb, __FUNCTION__,
 					"Unable to expand inode %lu. Delete"
 					" some EAs or run e2fsck.",
 					inode->i_ino);
-					expand_message = 1;
+					mnt_count = sbi->s_es->s_mnt_count;
 				}
 			}
 		}
Index: linux-2.6.22/fs/ext4/xattr.c
===================================================================
--- linux-2.6.22.orig/fs/ext4/xattr.c
+++ linux-2.6.22/fs/ext4/xattr.c
@@ -501,7 +501,11 @@ out:
 	return;
 }
 
-static inline size_t ext4_xattr_free_space(struct ext4_xattr_entry *last,
+/*
+ * Find the available free space for EAs. This also returns the total number of
+ * bytes used by EA entries.
+ */
+static size_t ext4_xattr_free_space(struct ext4_xattr_entry *last,
 				    size_t *min_offs, void *base, int *total)
 {
 	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
@@ -613,7 +617,6 @@ ext4_xattr_set_entry(struct ext4_xattr_i
 			memmove(s->here, (void *)s->here + size,
 				(void *)last - (void *)s->here + sizeof(__u32));
 			memset(last, 0, size);
-
 		}
 	}
 
@@ -1076,6 +1079,10 @@ retry:
 	return error;
 }
 
+/*
+ * Shift the EA entries in the inode to create space for the increased
+ * i_extra_isize.
+ */
 static void ext4_xattr_shift_entries(struct ext4_xattr_entry *entry,
 				     int value_offs_shift, void *to,
 				     void *from, size_t n, int blocksize)
@@ -1098,12 +1105,11 @@ static void ext4_xattr_shift_entries(str
 }
 
 /*
- * Expand an inode by new_extra_isize bytes when EA presents.
+ * Expand an inode by new_extra_isize bytes when EAs are present.
  * Returns 0 on success or negative error number on failure.
- *
  */
 int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
-			    struct ext4_inode *raw_inode, handle_t *handle)
+			       struct ext4_inode *raw_inode, handle_t *handle)
 {
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_xattr_entry *entry, *last, *first;
@@ -1177,6 +1183,7 @@ retry:
 			if (!tried_min_extra_isize && s_min_extra_isize) {
 				tried_min_extra_isize++;
 				new_extra_isize = s_min_extra_isize;
+				brelse(bh);
 				goto retry;
 			}
 			error = -1;
@@ -1193,16 +1200,19 @@ retry:
 			.value = NULL,
 			.value_len = 0,
 		};
-		unsigned int total_size, shift_bytes, temp = ~0U;
-
-		is = (struct ext4_xattr_ibody_find *) kmalloc(sizeof(struct
-					 ext4_xattr_ibody_find), GFP_KERNEL);
-		bs = (struct ext4_xattr_block_find *) kmalloc(sizeof(struct
-					 ext4_xattr_block_find), GFP_KERNEL);
-		memset((void *)is, 0, sizeof(struct ext4_xattr_ibody_find));
-		memset((void *)bs, 0, sizeof(struct ext4_xattr_block_find));
+		unsigned int total_size;  /* EA entry size + value size */
+		unsigned int shift_bytes; /* No. of bytes to shift EAs by? */
+		unsigned int min_total_size = ~0U;
+
+		is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_KERNEL);
+		bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_KERNEL);
+		if (!is || !bs) {
+			error = -ENOMEM;
+			goto cleanup;
+		}
 
-		is->s.not_found = bs->s.not_found = -ENODATA;
+		is->s.not_found = -ENODATA;
+		bs->s.not_found = -ENODATA;
 		is->iloc.bh = NULL;
 		bs->bh = NULL;
 
@@ -1213,12 +1223,12 @@ retry:
 			total_size =
 			EXT4_XATTR_SIZE(le32_to_cpu(last->e_value_size)) +
 					EXT4_XATTR_LEN(last->e_name_len);
-			if (total_size <= free && total_size < temp) {
+			if (total_size <= free && total_size < min_total_size) {
 				if (total_size < new_extra_isize) {
 					small_entry = last;
 				} else {
 					entry = last;
-					temp = total_size;
+					min_total_size = total_size;
 				}
 			}
 		}
@@ -1243,11 +1253,14 @@ retry:
 		i.name_index = entry->e_name_index,
 		buffer = kmalloc(EXT4_XATTR_SIZE(size), GFP_KERNEL);
 		b_entry_name = kmalloc(entry->e_name_len + 1, GFP_KERNEL);
+		if (!buffer || !b_entry_name) {
+			error = -ENOMEM;
+			goto cleanup;
+		}
 		/* Save the entry name and the entry value */
-		memcpy((void *)buffer, (void *)IFIRST(header) + offs,
+		memcpy(buffer, (void *)IFIRST(header) + offs,
 		       EXT4_XATTR_SIZE(size));
-		memcpy((void *)b_entry_name, (void *)entry->e_name,
-		       entry->e_name_len);
+		memcpy(b_entry_name, entry->e_name, entry->e_name_len);
 		b_entry_name[entry->e_name_len] = '\0';
 		i.name = b_entry_name;
 
@@ -1292,16 +1305,12 @@ retry:
 	}
 
 cleanup:
-	if (b_entry_name)
-		kfree(b_entry_name);
-	if (buffer)
-		kfree(buffer);
-	if (is) {
+	kfree(b_entry_name);
+	kfree(buffer);
+	if (is)
 		brelse(is->iloc.bh);
-		kfree(is);
-	}
-	if (bs)
-		kfree(bs);
+	kfree(is);
+	kfree(bs);
 	brelse(bh);
 	up_write(&EXT4_I(inode)->xattr_sem);
 	return error;

--=-GiLpj11SNWcqlJ8k5JRf--

