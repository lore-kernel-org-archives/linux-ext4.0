From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/1] [RFC] 64-bit inode version
Date: Tue, 15 May 2007 18:15:01 -0700
Message-ID: <1179278101.15438.11.camel@dyn9047017103.beaverton.ibm.com>
References: <1176297438.7350.23.camel@garfield>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Eric Sandeen <sandeen@redhat.com>, sct <sct@redhat.com>,
	TheodoreTso <tytso@mit.edu>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:59770 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760129AbXEPBPO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 May 2007 21:15:14 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4G1F9QV022977
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2007 21:15:09 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4G1F48w229772
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2007 19:15:09 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4G1F3p8015388
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2007 19:15:04 -0600
In-Reply-To: <1176297438.7350.23.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-04-11 at 18:47 +0530, Kalpak Shah wrote: 
> Hi,
> 
> This patch is on top of the nanosecond timestamp and i_version_hi
> patches. 
> 
> This patch adds 64-bit inode version support to ext4. The lower 32 bits
> are stored in the osd1.linux1.l_i_version field while the high 32 bits
> are stored in the i_version_hi field newly created in the ext4_inode.
> 
> We need to make sure that existing filesystems can also avail the new
> fields that have been added to the inode.

Hi Kalpak,

Failed to build ext4 as module. It is because CONFIG_EXT4DEV_FS_XATTR is
not configed but ext4_expand_extra_isize() assumes it's on.

> @@ -3173,10 +3186,32 @@ ext4_reserve_inode_write(handle_t *handl
>  int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
>  {
>  	struct ext4_iloc iloc;
> -	int err;
> +	int err, ret;
> +	static int expand_message;
> 
>  	might_sleep();
>  	err = ext4_reserve_inode_write(handle, inode, &iloc);
> +	if (EXT4_I(inode)->i_extra_isize <
> +	    EXT4_SB(inode->i_sb)->s_want_extra_isize &&
> +	    !(EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND)) {
> +		/* We need extra buffer credits since we may write into EA block
> +		 * with this same handle */
> +		if ((jbd2_journal_extend(handle,
> +			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb))) == 0) {
> +			ret = ext4_expand_extra_isize(inode,
> +  					EXT4_SB(inode->i_sb)->s_want_extra_isize,
> +					iloc, handle);

Here is the place where ext4_expand_extra_isize can be called without
xattrs turned on.

> Index: linux-2.6.20/fs/ext4/xattr.c
> ===================================================================
> --- linux-2.6.20.orig/fs/ext4/xattr.c
> +++ linux-2.6.20/fs/ext4/xattr.c
> @@ -502,6 +502,20 @@ ext4_xattr_release_block(handle_t *handl
>  	}
>  }
> 
> +static inline size_t ext3_xattr_free_space(struct ext4_xattr_entry *last,
> +				    size_t *min_offs, void *base, int *total)

should renamed to ext4_xattr_free_space()

> +static void ext3_xattr_shift_entries(struct ext4_xattr_entry *entry,
> +				     int value_offs_shift, void *to,
> +				     void *from, size_t n, int blocksize)

Should rename to ext4_xxx_xxx().

> +/* Expand an inode by new_extra_isize bytes.
> + * Returns 0 on success or negative error number on failure.
> + */
> +int ext4_expand_extra_isize(struct inode *inode, int new_extra_isize,
> +			    struct ext4_iloc iloc, handle_t *handle)
> +{

....

> Index: linux-2.6.20/fs/ext4/xattr.h
> ===================================================================
> --- linux-2.6.20.orig/fs/ext4/xattr.h
> +++ linux-2.6.20/fs/ext4/xattr.h
> @@ -74,6 +74,9 @@ extern int ext4_xattr_set_handle(handle_
>  extern void ext4_xattr_delete_inode(handle_t *, struct inode *);
>  extern void ext4_xattr_put_super(struct super_block *);
> 
> +int ext4_expand_extra_isize(struct inode *inode, int new_extra_isize,
> +			    struct ext4_iloc iloc, handle_t *handle);
> +
>  extern int init_ext4_xattr(void);
>  extern void exit_ext4_xattr(void);
> 
> 

The following patch moved the ext4_expand_extra_isize() function to
inode.c and provide proper defines in xattr.h. Renamed the ext3
functions to ext4_xxx_xxx().

Compile tested. Can you Ack the changes. Appreciate if you can let me
know it passes your tests.

Signed-Off-By: Mingming Cao <cmm@us.ibm.com>
Index: linux-2.6.22-rc1/fs/ext4/inode.c
===================================================================
--- linux-2.6.22-rc1.orig/fs/ext4/inode.c	2007-05-15 17:44:25.000000000 -0700
+++ linux-2.6.22-rc1/fs/ext4/inode.c	2007-05-15 17:46:23.000000000 -0700
@@ -3097,6 +3097,40 @@
 }
 
 /*
+ * Expand an inode by new_extra_isize bytes.
+ * Returns 0 on success or negative error number on failure.
+ */
+int ext4_expand_extra_isize(struct inode *inode, unsigned int new_extra_isize,
+                        struct ext4_iloc iloc, handle_t *handle)
+{
+	struct ext4_inode *raw_inode;
+	struct ext4_xattr_ibody_header *header;
+	struct ext4_xattr_entry *entry;
+
+	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize) {
+		return 0;
+	}
+
+	raw_inode = ext4_raw_inode(&iloc);
+
+	header = IHDR(inode, raw_inode);
+        entry = IFIRST(header);
+
+	/* No extended attributes present */
+	if (!(EXT4_I(inode)->i_state & EXT4_STATE_XATTR) ||
+		header->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC)) {
+		memset((void *)raw_inode + EXT4_GOOD_OLD_INODE_SIZE, 0,
+			new_extra_isize);
+		EXT4_I(inode)->i_extra_isize = new_extra_isize;
+		return 0;
+	}
+
+	/* try to expand with EA present */
+	return ext4_expand_extra_isize_ea(inode, new_extra_isize,
+						raw_inode, handle);
+}
+
+/*
  * What we do here is to mark the in-core inode as clean with respect to inode
  * dirtiness (it may still be data-dirty).
  * This means that the in-core inode may be reaped by prune_icache
Index: linux-2.6.22-rc1/fs/ext4/xattr.c
===================================================================
--- linux-2.6.22-rc1.orig/fs/ext4/xattr.c	2007-05-15 17:44:25.000000000 -0700
+++ linux-2.6.22-rc1/fs/ext4/xattr.c	2007-05-15 17:46:23.000000000 -0700
@@ -66,13 +66,6 @@
 #define BFIRST(bh) ENTRY(BHDR(bh)+1)
 #define IS_LAST_ENTRY(entry) (*(__u32 *)(entry) == 0)
 
-#define IHDR(inode, raw_inode) \
-	((struct ext4_xattr_ibody_header *) \
-		((void *)raw_inode + \
-		 EXT4_GOOD_OLD_INODE_SIZE + \
-		 EXT4_I(inode)->i_extra_isize))
-#define IFIRST(hdr) ((struct ext4_xattr_entry *)((hdr)+1))
-
 #ifdef EXT4_XATTR_DEBUG
 # define ea_idebug(inode, f...) do { \
 		printk(KERN_DEBUG "inode %s:%lu: ", \
@@ -508,7 +501,7 @@
 	return;
 }
 
-static inline size_t ext3_xattr_free_space(struct ext4_xattr_entry *last,
+static inline size_t ext4_xattr_free_space(struct ext4_xattr_entry *last,
 				    size_t *min_offs, void *base, int *total)
 {
 	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
@@ -1083,7 +1076,7 @@
 	return error;
 }
 
-static void ext3_xattr_shift_entries(struct ext4_xattr_entry *entry,
+static void ext4_xattr_shift_entries(struct ext4_xattr_entry *entry,
 				     int value_offs_shift, void *to,
 				     void *from, size_t n, int blocksize)
 {
@@ -1103,13 +1096,14 @@
 	memmove(to, from, n);
 }
 
-/* Expand an inode by new_extra_isize bytes.
+/*
+ * Expand an inode by new_extra_isize bytes when EA presents.
  * Returns 0 on success or negative error number on failure.
+ *
  */
 int ext4_expand_extra_isize(struct inode *inode, int new_extra_isize,
-			    struct ext4_iloc iloc, handle_t *handle)
+			    struct ext4_inode *raw_inode, handle_t *handle)
 {
-	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_xattr_entry *entry, *last, *first;
 	struct buffer_head *bh = NULL;
@@ -1123,27 +1117,15 @@
 	int s_min_extra_isize = EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize;
 
 	down_write(&EXT4_I(inode)->xattr_sem);
-
 retry:
 	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize) {
 		up_write(&EXT4_I(inode)->xattr_sem);
 		return 0;
 	}
 
-	raw_inode = ext4_raw_inode(&iloc);
-
 	header = IHDR(inode, raw_inode);
 	entry = IFIRST(header);
 
-	/* No extended attributes present */
-	if (!(EXT4_I(inode)->i_state & EXT4_STATE_XATTR) ||
-	    header->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC)) {
-		memset((void *)raw_inode + EXT4_GOOD_OLD_INODE_SIZE, 0,
-		       new_extra_isize);
-		EXT4_I(inode)->i_extra_isize = new_extra_isize;
-		goto cleanup;
-	}
-
 	/*
 	 * Check if enough free space is available in the inode to shift the
 	 * entries ahead by new_extra_isize.
@@ -1155,10 +1137,10 @@
 	last = entry;
 	total_ino = sizeof(struct ext4_xattr_ibody_header);
 
-	free = ext3_xattr_free_space(last, &min_offs, base, &total_ino);
+	free = ext4_xattr_free_space(last, &min_offs, base, &total_ino);
 	if (free >= new_extra_isize) {
 		entry = IFIRST(header);
-		ext3_xattr_shift_entries(entry,	EXT4_I(inode)->i_extra_isize
+		ext4_xattr_shift_entries(entry,	EXT4_I(inode)->i_extra_isize
 				- new_extra_isize, (void *)raw_inode +
 				EXT4_GOOD_OLD_INODE_SIZE + new_extra_isize,
 				(void *)header, total_ino,
@@ -1188,7 +1170,7 @@
 		first = BFIRST(bh);
 		end = bh->b_data + bh->b_size;
 		min_offs = end - base;
-		free = ext3_xattr_free_space(first, &min_offs, base,
+		free = ext4_xattr_free_space(first, &min_offs, base,
 					     &total_blk);
 		if (free < new_extra_isize) {
 			if (!tried_min_extra_isize && s_min_extra_isize) {
@@ -1287,7 +1269,7 @@
 		else
 			shift_bytes = entry_size + size;
 		/* Adjust the offsets and shift the remaining entries ahead */
-		ext3_xattr_shift_entries(entry, EXT4_I(inode)->i_extra_isize -
+		ext4_xattr_shift_entries(entry, EXT4_I(inode)->i_extra_isize -
 			shift_bytes, (void *)raw_inode +
 			EXT4_GOOD_OLD_INODE_SIZE + extra_isize + shift_bytes,
 			(void *)header, total_ino - entry_size,
Index: linux-2.6.22-rc1/fs/ext4/xattr.h
===================================================================
--- linux-2.6.22-rc1.orig/fs/ext4/xattr.h	2007-05-15 17:44:25.000000000 -0700
+++ linux-2.6.22-rc1/fs/ext4/xattr.h	2007-05-15 17:48:26.000000000 -0700
@@ -56,6 +56,13 @@
 #define EXT4_XATTR_SIZE(size) \
 	(((size) + EXT4_XATTR_ROUND) & ~EXT4_XATTR_ROUND)
 
+#define IHDR(inode, raw_inode) \
+	((struct ext4_xattr_ibody_header *) \
+		((void *)raw_inode + \
+		EXT4_GOOD_OLD_INODE_SIZE + \
+		EXT4_I(inode)->i_extra_isize))
+#define IFIRST(hdr) ((struct ext4_xattr_entry *)((hdr)+1))
+
 # ifdef CONFIG_EXT4DEV_FS_XATTR
 
 extern struct xattr_handler ext4_xattr_user_handler;
@@ -74,8 +81,8 @@
 extern void ext4_xattr_delete_inode(handle_t *, struct inode *);
 extern void ext4_xattr_put_super(struct super_block *);
 
-int ext4_expand_extra_isize(struct inode *inode, int new_extra_isize,
-			    struct ext4_iloc iloc, handle_t *handle);
+extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
+			    struct ext4_inode *raw_inode, handle_t *handle);
 
 extern int init_ext4_xattr(void);
 extern void exit_ext4_xattr(void);
@@ -132,6 +139,13 @@
 {
 }
 
+static int
+ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
+			    struct ext4_inode *raw_inode, handle_t *handle)
+{
+	return -EOPNOTSUPP;
+}
+
 #define ext4_xattr_handlers	NULL
 
 # endif  /* CONFIG_EXT4DEV_FS_XATTR */
