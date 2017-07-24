From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] libext2fs: add ea_inode support to set xattr
Date: Sun, 23 Jul 2017 23:30:50 -0400
Message-ID: <20170724033050.fpkwpyywelldzshi@thunk.org>
References: <20170707121246.6159-1-tahsin@google.com>
 <20170707121246.6159-4-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52694 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752092AbdGXDaw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Jul 2017 23:30:52 -0400
Content-Disposition: inline
In-Reply-To: <20170707121246.6159-4-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applied, with some style cleanups.  See below for the interdiff.

The cleanups are mostly checkpatch style warnings, plus simplifying
complexity by reducing indentation levels.  Yes, it makes the code
somewhat less parallel, but on the whole I think it makes the code
more readable.

					- Ted

 lib/ext2fs/ext_attr.c | 112 +++++++++++++++++++++------------------------
 1 file changed, 52 insertions(+), 60 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 7cecb1688..f4cc2d056 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -1334,7 +1334,7 @@ static errcode_t xattr_update_entry(ext2_filsys fs, struct ext2_xattr *x,
 
 	if (!x->name)
 		x->name = new_name;
-	
+
 	if (x->value)
 		ext2fs_free_mem(&x->value);
 	x->value = new_value;
@@ -1351,7 +1351,8 @@ fail:
 	return ret;
 }
 
-static int xattr_find_position(struct ext2_xattr *attrs, int count, const char *name)
+static int xattr_find_position(struct ext2_xattr *attrs, int count,
+			       const char *name)
 {
 	struct ext2_xattr *x;
 	int i;
@@ -1400,7 +1401,7 @@ errcode_t xattr_array_update(struct ext2_xattr_handle *h, const char *name,
 	if (!in_inode)
 		needed += EXT2_EXT_ATTR_SIZE(value_len);
 
-	if (0 <= old_idx && old_idx < h->ibody_count) {
+	if (old_idx >= 0 && old_idx < h->ibody_count) {
 		ibody_free += EXT2_EXT_ATTR_LEN(name_len);
 		if (!h->attrs[old_idx].ea_ino)
 			ibody_free += EXT2_EXT_ATTR_SIZE(
@@ -1408,75 +1409,66 @@ errcode_t xattr_array_update(struct ext2_xattr_handle *h, const char *name,
 	}
 
 	if (needed <= ibody_free) {
-		if (0 <= old_idx) {
-			/* Update the existing entry. */
-			ret = xattr_update_entry(h->fs, &h->attrs[old_idx],
-						 name, value, value_len,
-						 in_inode);
-			if (ret)
-				return ret;
-			if (h->ibody_count <= old_idx) {
-				/* Move entry from block to the end of ibody. */
-				tmp = h->attrs[old_idx];
-				memmove(h->attrs + h->ibody_count + 1,
-					h->attrs + h->ibody_count,
-					(old_idx - h->ibody_count)
-							* sizeof(*h->attrs));
-				h->attrs[h->ibody_count] = tmp;
-				h->ibody_count++;
-			}
-			return 0;
-		} else {
+		if (old_idx < 0) {
 			new_idx = h->ibody_count;
 			add_to_ibody = 1;
 			goto add_new;
 		}
+
+		/* Update the existing entry. */
+		ret = xattr_update_entry(h->fs, &h->attrs[old_idx], name,
+					 value, value_len, in_inode);
+		if (ret)
+			return ret;
+		if (h->ibody_count <= old_idx) {
+			/* Move entry from block to the end of ibody. */
+			tmp = h->attrs[old_idx];
+			memmove(h->attrs + h->ibody_count + 1,
+				h->attrs + h->ibody_count,
+				(old_idx - h->ibody_count) * sizeof(*h->attrs));
+			h->attrs[h->ibody_count] = tmp;
+			h->ibody_count++;
+		}
+		return 0;
 	}
 
 	if (h->ibody_count <= old_idx) {
 		block_free += EXT2_EXT_ATTR_LEN(name_len);
 		if (!h->attrs[old_idx].ea_ino)
-			block_free += EXT2_EXT_ATTR_SIZE(
-						h->attrs[old_idx].value_len);
+			block_free +=
+				EXT2_EXT_ATTR_SIZE(h->attrs[old_idx].value_len);
 	}
 
-	if (needed <= block_free) {
-		if (0 <= old_idx) {
-			/* Update the existing entry. */
-			ret = xattr_update_entry(h->fs, &h->attrs[old_idx],
-						 name, value, value_len,
-						 in_inode);
-			if (ret)
-				return ret;
-			if (old_idx < h->ibody_count) {
-				/*
-				 * Move entry from ibody to the block. Note that
-				 * entries in the block are sorted.
-				 */
-				new_idx = xattr_find_position(
-						h->attrs + h->ibody_count,
-						h->count - h->ibody_count,
-						name);
-				new_idx += h->ibody_count - 1;
-				tmp = h->attrs[old_idx];
-				memmove(h->attrs + old_idx,
-					h->attrs + old_idx + 1,
-					(new_idx - old_idx)*sizeof(*h->attrs));
-				h->attrs[new_idx] = tmp;
-				h->ibody_count--;
-			}
-			return 0;
-		} else {
+	if (needed > block_free)
+		return EXT2_ET_EA_NO_SPACE;
+
+	if (old_idx >= 0) {
+		/* Update the existing entry. */
+		ret = xattr_update_entry(h->fs, &h->attrs[old_idx], name,
+					 value, value_len, in_inode);
+		if (ret)
+			return ret;
+		if (old_idx < h->ibody_count) {
+			/*
+			 * Move entry from ibody to the block. Note that
+			 * entries in the block are sorted.
+			 */
 			new_idx = xattr_find_position(h->attrs + h->ibody_count,
-						      h->count - h->ibody_count,
-						      name);
-			new_idx += h->ibody_count;
-			add_to_ibody = 0;
-			goto add_new;
+				h->count - h->ibody_count, name);
+			new_idx += h->ibody_count - 1;
+			tmp = h->attrs[old_idx];
+			memmove(h->attrs + old_idx, h->attrs + old_idx + 1,
+				(new_idx - old_idx) * sizeof(*h->attrs));
+			h->attrs[new_idx] = tmp;
+			h->ibody_count--;
 		}
+		return 0;
 	}
 
-	return EXT2_ET_EA_NO_SPACE;
+	new_idx = xattr_find_position(h->attrs + h->ibody_count,
+				      h->count - h->ibody_count, name);
+	new_idx += h->ibody_count;
+	add_to_ibody = 0;
 
 add_new:
 	if (h->count == h->capacity) {
@@ -1520,7 +1512,7 @@ int space_used(struct ext2_xattr *attrs, int count)
 /*
  * The minimum size of EA value when you start storing it in an external inode
  * size of block - size of header - size of 1 entry - 4 null bytes
-*/
+ */
 #define EXT4_XATTR_MIN_LARGE_EA_SIZE(b)	\
 	((b) - EXT2_EXT_ATTR_LEN(3) - sizeof(struct ext2_ext_attr_header) - 4)
 
@@ -1579,8 +1571,8 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *h,
 	if (inode_size > EXT2_GOOD_OLD_INODE_SIZE) {
 		extra_isize = inode->i_extra_isize;
 		if (extra_isize == 0) {
-		    	extra_isize = fs->super->s_want_extra_isize;
-		    	if (extra_isize == 0)
+			extra_isize = fs->super->s_want_extra_isize;
+			if (extra_isize == 0)
 				extra_isize = sizeof(__u32);
 		}
 		ibody_free = inode_size - EXT2_GOOD_OLD_INODE_SIZE;
