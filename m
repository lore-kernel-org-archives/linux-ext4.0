From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v3] ext4: Prevent race while waling extent tree
Date: Tue, 13 Nov 2012 09:22:03 +0100
Message-ID: <1352794923-28555-1-git-send-email-lczerner@redhat.com>
References: <1352732245-30132-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, zab@redhat.com, dmonakhov@openvz.org,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab2KMIWQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Nov 2012 03:22:16 -0500
In-Reply-To: <1352732245-30132-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently ext4_ext_walk_space() only takes i_data_sem for read when
searching for the extent at given block with ext4_ext_find_extent().
Then it drops the lock and the extent tree can be changed at will.
However later on we're searching for the 'next' extent, but the extent
tree might already have changed, so the information might not be
accurate.

In fact we can hit BUG_ON(end <= start) if the extent got inserted into
the tree after the one we found and before the block we were searching
for. This has been reproduced by running xfstests 225 in loop on s390x
architecture, but theoretically we could hit this on any other
architecture as well, but probably not as often.

Fix this by extending the critical section to include
ext4_ext_next_allocated_block() as well. It means that if there are any
operation going on on the particular inode, the fiemap will return
inaccurate data. However this will also fix the concerns about starving
writers to the extent tree, because we will put and reacquire the
semaphore with every iteration. This will not be particularly fast, but
fiemap is not critical operation.

However we also need to limit the access to the extent structure to the
critical section, because outside of it the content can change. So we
remove extent and next block parameters from ext4_ext_fiemap_cb()
function and pass just flags instead.

Also we have to move path reinitialization inside the critical section.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v3: reworked

 fs/ext4/ext4_extents.h |    5 ++---
 fs/ext4/extents.c      |   40 +++++++++++++++++++++-------------------
 2 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index cb1b2c9..356ad9f 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -149,9 +149,8 @@ struct ext4_ext_path {
  * positive retcode - signal for ext4_ext_walk_space(), see below
  * callback must return valid extent (passed or newly created)
  */
-typedef int (*ext_prepare_callback)(struct inode *, ext4_lblk_t,
-					struct ext4_ext_cache *,
-					struct ext4_extent *, void *);
+typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_cache *,
+				    unsigned int, void *);
 
 #define EXT_CONTINUE   0
 #define EXT_BREAK      1
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7011ac9..c097acf 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1968,7 +1968,8 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 	struct ext4_extent *ex;
 	ext4_lblk_t next, start = 0, end = 0;
 	ext4_lblk_t last = block + num;
-	int depth, exists, err = 0;
+	int exists, depth = 0, err = 0;
+	unsigned int flags = 0;
 
 	BUG_ON(func == NULL);
 	BUG_ON(inode == NULL);
@@ -1977,9 +1978,16 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 		num = last - block;
 		/* find extent for this block */
 		down_read(&EXT4_I(inode)->i_data_sem);
+
+		if (path && ext_depth(inode) != depth) {
+			/* depth was changed. we have to realloc path */
+			kfree(path);
+			path = NULL;
+		}
+
 		path = ext4_ext_find_extent(inode, block, path);
-		up_read(&EXT4_I(inode)->i_data_sem);
 		if (IS_ERR(path)) {
+			up_read(&EXT4_I(inode)->i_data_sem);
 			err = PTR_ERR(path);
 			path = NULL;
 			break;
@@ -1987,6 +1995,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 
 		depth = ext_depth(inode);
 		if (unlikely(path[depth].p_hdr == NULL)) {
+			up_read(&EXT4_I(inode)->i_data_sem);
 			EXT4_ERROR_INODE(inode, "path[%d].p_hdr == NULL", depth);
 			err = -EIO;
 			break;
@@ -2037,14 +2046,21 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			cbex.ec_block = le32_to_cpu(ex->ee_block);
 			cbex.ec_len = ext4_ext_get_actual_len(ex);
 			cbex.ec_start = ext4_ext_pblock(ex);
+			if (ext4_ext_is_uninitialized(ex))
+				flags |= FIEMAP_EXTENT_UNWRITTEN;
 		}
+		up_read(&EXT4_I(inode)->i_data_sem);
 
 		if (unlikely(cbex.ec_len == 0)) {
 			EXT4_ERROR_INODE(inode, "cbex.ec_len == 0");
 			err = -EIO;
 			break;
 		}
-		err = func(inode, next, &cbex, ex, cbdata);
+
+		if (next == EXT_MAX_BLOCKS)
+			flags |= FIEMAP_EXTENT_LAST;
+
+		err = func(inode, &cbex, flags, cbdata);
 		ext4_ext_drop_refs(path);
 
 		if (err < 0)
@@ -2057,12 +2073,6 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			break;
 		}
 
-		if (ext_depth(inode) != depth) {
-			/* depth was changed. we have to realloc path */
-			kfree(path);
-			path = NULL;
-		}
-
 		block = cbex.ec_block + cbex.ec_len;
 	}
 
@@ -4574,14 +4584,12 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 /*
  * Callback function called for each extent to gather FIEMAP information.
  */
-static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t next,
-		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
-		       void *data)
+static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_cache *newex,
+			      unsigned int flags, void *data)
 {
 	__u64	logical;
 	__u64	physical;
 	__u64	length;
-	__u32	flags = 0;
 	int		ret = 0;
 	struct fiemap_extent_info *fieinfo = data;
 	unsigned char blksize_bits;
@@ -4759,12 +4767,6 @@ found_delayed_extent:
 	physical = (__u64)newex->ec_start << blksize_bits;
 	length =   (__u64)newex->ec_len << blksize_bits;
 
-	if (ex && ext4_ext_is_uninitialized(ex))
-		flags |= FIEMAP_EXTENT_UNWRITTEN;
-
-	if (next == EXT_MAX_BLOCKS)
-		flags |= FIEMAP_EXTENT_LAST;
