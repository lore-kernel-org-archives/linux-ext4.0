From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 punch hole 3/5] Ext4 Punch Hole Support: Enable Kernel Space
 Fiemap
Date: Tue, 15 Mar 2011 14:18:10 -0700
Message-ID: <4D7FD792.3080101@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:42927 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1COVSQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 17:18:16 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2FL31qU029289
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:03:01 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2FLIBfs127490
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:18:11 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2FLIB19031424
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:18:11 -0600
Received: from [127.0.0.1] (IBM-3CEFE379E05.tucson.ibm.com [9.11.169.120])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p2FLI9v5031324
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:18:10 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch modifies the existing fiemap routines to
make them usable by internal kernel functions.
The existing fiemap routines were not suitable for
internal use, because they assume that the data they
collect needs to be copied to user space.

The existing ext4_ext_fiemap_cb routine has been renamed to
ext4_ext_fiemap and modified to store its findings in a
fiemap_extent poitner passed in by the calling function.

A simpler ext4_ext_fiemap_cb routine has been added that
is simply a wrapper to this function and copies the
found results to the appropriate space (ie kernel
space or user space) based on a flag parameter.

Lastly two top level wrapper functions have been added:
ext4_ext_fiemap_cb_kern() and ext4_ext_fiemap_cb_user()
These two functions implement the required function
signature needed by ext4_ext_walk_space().  Any function
that needs to collect fiemap information can now call
ext4_ext_walk_space() and pass one of these two functions
as the call back.  These two functions basically just call
the general purpose ext4_ext_fiemap_cb and pass it the
respective space flag for user space or kernel space.

These new fiemap modifications will be used by the hole
punch routines to identify when an extent is already
punched out.

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 2e29abb... 1093cc1... M	fs/ext4/ext4_extents.h
:100644 100644 b78b41f... dacb0a1... M	fs/ext4/extents.c
 fs/ext4/ext4_extents.h |    4 +
 fs/ext4/extents.c      |  177 ++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 168 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 2e29abb..1093cc1 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -132,6 +132,10 @@ typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_path *,
 #define EXT_CONTINUE   0
 #define EXT_BREAK      1
 #define EXT_REPEAT     2
+#define EXT_FOUND_HOLE 3
+
+#define EXT_USER_SPACE 0
+#define EXT_KERN_SPACE 1
  /* Maximum logical block in a file; ext4_extent's ee_block is __le32 */
 #define EXT_MAX_BLOCK	0xffffffff
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b78b41f..dacb0a1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3985,12 +3985,79 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 	return ret > 0 ? ret2 : ret;
 }
 +
+/**
+ * ext4_fiemap_fill_next_extent - Fiemap helper function
+ * @fieinfo:    Fiemap context passed into ->fiemap
+ * @logical:    Extent logical start offset, in bytes
+ * @phys:       Extent physical start offset, in bytes
+ * @len:        Extent length, in bytes
+ * @flags:      FIEMAP_EXTENT flags that describe this extent
+ *
+ * Similar to fiemap_fill_next_extent, but for internal
+ * use.  This function will populate extent info as passed in via
+ * arguments, but fieinfo is assumed to be kernel space memory
+ * not user space memory.  On sucess, extent count
+ * on fieinfo is incremented.
+ *
+ * Returns 0 on success, -errno on error, 1 if this was the last
+ * extent that will fit in user array.
+ */
+
+static int ext4_fiemap_fill_next_extent(struct fiemap_extent_info *fieinfo,
+				u64 logical, u64 phys, u64 len, u32 flags)
+{
+	struct fiemap_extent *dest;
+	int ret = 0;
+
+	dest = fieinfo->fi_extents_start;
+
+	/* only count the extents */
+	if (fieinfo->fi_extents_max == 0) {
+		fieinfo->fi_extents_mapped++;
+		ret = (flags & FIEMAP_EXTENT_LAST) ? 1 : 0;
+		return ret;
+	}
+
+	if (fieinfo->fi_extents_mapped >= fieinfo->fi_extents_max)
+		return 1;
+
+	if (flags & FIEMAP_EXTENT_DELALLOC)
+		flags |= FIEMAP_EXTENT_UNKNOWN;
+	if (flags & FIEMAP_EXTENT_DATA_ENCRYPTED)
+		flags |= FIEMAP_EXTENT_ENCODED;
+	if (flags & (FIEMAP_EXTENT_DATA_TAIL|FIEMAP_EXTENT_DATA_INLINE))
+		flags |= FIEMAP_EXTENT_NOT_ALIGNED;
+
+	dest += fieinfo->fi_extents_mapped;
+
+	memset(dest, 0, sizeof(struct fiemap_extent));
+	dest->fe_logical = logical;
+	dest->fe_physical = phys;
+	dest->fe_length = len;
+	dest->fe_flags = flags;
+
+	fieinfo->fi_extents_mapped++;
+	if (fieinfo->fi_extents_mapped == fieinfo->fi_extents_max)
+		return 1;
+	ret = (flags & FIEMAP_EXTENT_LAST) ? 1 : 0;
+	return ret;
+}
+
 /*
- * Callback function called for each extent to gather FIEMAP information.
+ * ext4_ext_fiemap()
+ * Function used by fiemap call back functions
+ * to gather FIEMAP information for each extent
+ *
+ * @inode:  The files inode
+ * @newex:  Specifies the blocks to search for
+ * @ex:     The extent to gather information about
+ * @result: Pointer to structure to hold the results
  */
-static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
-		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
-		       void *data)
+static int ext4_ext_fiemap(struct inode *inode,
+			struct ext4_ext_cache *newex,
+			struct ext4_extent *ex,
+			struct fiemap_extent *result)
 {
 	__u64	logical;
 	__u64	physical;
@@ -3998,7 +4065,6 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 	loff_t	size;
 	__u32	flags = 0;
 	int		ret = 0;
-	struct fiemap_extent_info *fieinfo = data;
 	unsigned char blksize_bits;
  	blksize_bits = inode->i_sb->s_blocksize_bits;
@@ -4047,7 +4113,7 @@ out:
 					page_cache_release(pages[index]);
 				/* just a hole. */
 				kfree(pages);
-				return EXT_CONTINUE;
+				return EXT_FOUND_HOLE;
 			}
  			/* Try to find the 1st mapped buffer. */
@@ -4160,15 +4226,100 @@ found_delayed_extent:
 	if (logical + length >= size)
 		flags |= FIEMAP_EXTENT_LAST;
 -	ret = fiemap_fill_next_extent(fieinfo, logical, physical,
-					length, flags);
-	if (ret < 0)
-		return ret;
-	if (ret == 1)
-		return EXT_BREAK;
+
+	result->fe_logical = logical;
+	result->fe_physical = physical;
+	result->fe_length = length;
+	result->fe_flags = flags;
+
 	return EXT_CONTINUE;
 }
 +/*
+ * ext4_ext_fiemap_cb()
+ * General purpose callback function called for each extent to
+ * gather FIEMAP information. The "space" parameter may be set to
+ * EXT_USER_SPACE to indicate that "data" refers to user space
+ * memory, or EXT_KERN_SPACE to indicate that it is kernel space
+ * memory
+ *
+ * @inode:  The files inode
+ * @newex:  Specifies the blocks to search for
+ * @ex:     The extent to gather information about
+ * @data:   Pointer to a struct fiemap_extent to hold the result
+ * @space:  Indicates if data points to user space or kernel space
+ */
+static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_cache *newex,
+			struct ext4_extent *ex, void *data, unsigned int space)
+{
+	struct fiemap_extent_info *fieinfo = data;
+	struct fiemap_extent result;
+	int ret = 0;
+
+	memset(&result, 0, sizeof(result));
+	ret = ext4_ext_fiemap(inode, newex, ex, &result);
+
+	/* If fiemap found a hole, dont bother filling out the fieinfo */
+	if (ret == EXT_FOUND_HOLE)
+		return EXT_CONTINUE;
+
+	/* If it found something to report, then fill out the fieinfo */
+	if (ret == EXT_CONTINUE) {
+		if (space == EXT_KERN_SPACE)
+			ret = ext4_fiemap_fill_next_extent(fieinfo,
+				result.fe_logical, result.fe_physical,
+				result.fe_length, result.fe_flags);
+
+		else if (space == EXT_USER_SPACE)
+			ret = fiemap_fill_next_extent(fieinfo,
+				result.fe_logical, result.fe_physical,
+				result.fe_length, result.fe_flags);
+		else
+			return -ENOTSUPP;
+
+		if (ret < 0)
+			return ret;
+		if (ret == 1)
+			return EXT_BREAK;
+		return EXT_CONTINUE;
+	}
+
+	return ret;
+}
+
+/*
+ * ext4_ext_fiemap_cb_kern()
+ * Kernel space callback function called for each extent to
+ * gather FIEMAP information. This callback should be used
+ * by internal functions that need to collect fiemap info
+ * that does not need to be transferd to user space memory
+ */
+static int ext4_ext_fiemap_cb_kern(struct inode *inode,
+				struct ext4_ext_path *path,
+				struct ext4_ext_cache *newex,
+				struct ext4_extent *ex,
+				void *data)
+{
+	return ext4_ext_fiemap_cb(inode, newex, ex, data, EXT_KERN_SPACE);
+}
+
+/*
+ * ext4_ext_fiemap_cb_user()
+ * User space callback function called for each extent to
+ * gather FIEMAP information. This callback should be used
+ * for gathering fiemap info that needs to be transfered to
+ * user space memory
+ */
+static int ext4_ext_fiemap_cb_user(struct inode *inode,
+				struct ext4_ext_path *path,
+				struct ext4_ext_cache *newex,
+				struct ext4_extent *ex,
+				void *data)
+{
+	return ext4_ext_fiemap_cb(inode, newex, ex, data, EXT_USER_SPACE);
+}
+
+
 /* fiemap flags we can handle specified here */
 #define EXT4_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
 @@ -4238,7 +4389,7 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		 * ext4_ext_fiemap_cb will push extents back to user.
 		 */
 		error = ext4_ext_walk_space(inode, start_blk, len_blks,
-					  ext4_ext_fiemap_cb, fieinfo);
+					  ext4_ext_fiemap_cb_user, fieinfo);
 	}
  	return error;
-- 
1.7.1


