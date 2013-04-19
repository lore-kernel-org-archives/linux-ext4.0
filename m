From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: disable defrag for metadata_csum file systems
Date: Fri, 19 Apr 2013 02:17:27 -0400
Message-ID: <20130419061727.GA10053@thunk.org>
References: <1366322282-4673-1-git-send-email-tytso@mit.edu>
 <51707E06.2050105@gmail.com>
 <20130419054738.GA5617@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42790 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309Ab3DSGRa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 02:17:30 -0400
Content-Disposition: inline
In-Reply-To: <20130419054738.GA5617@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 18, 2013 at 10:47:38PM -0700, Darrick J. Wong wrote:
> 
> I think this happens because mext_insert_extents() open-codes the metadata
> dirtying and forgets to update the extent block header.  It should call
> ext4_ext_dirty() at the end, instead. :(

Yes.  The following patch seems to fix the problem.

I'm wondering if we could significantly simplify the move_extent.c
file by allocating two tmp_inodes and then using
ext4_ext_insert_extent() the same way fs/ext4/migrate.c handles
things.  But that's a potential cleanup for later....

						- Ted

commit fa3a0fc57b3d3c885dd7354508c9f20fc0c4a184
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Apr 19 02:14:18 2013 -0400

    ext4: set the extent leaf checksum when processing EXT4_IOC_MOVE_EXT
    
    The EXT4_IOC_MOVE_EXT which is used by the e4defrag program was not
    properly setting the checksum in the extent leaf block.  Fix this.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 779d26b..269122e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2574,6 +2574,11 @@ extern int ext4_check_blockref(const char *, unsigned int,
 struct ext4_ext_path;
 struct ext4_extent;
 
+#define ext4_ext_dirty(handle, inode, path) \
+		ext4__ext_dirty(__func__, __LINE__, (handle), (inode), (path))
+extern int ext4__ext_dirty(const char *where, unsigned int line,
+			   handle_t *handle, struct inode *inode,
+			   struct ext4_ext_path *path);
 extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
 extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
 extern int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6fcb375..ff019ed 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -157,11 +157,8 @@ static int ext4_ext_get_access(handle_t *handle, struct inode *inode,
  *  - ENOMEM
  *  - EIO
  */
-#define ext4_ext_dirty(handle, inode, path) \
-		__ext4_ext_dirty(__func__, __LINE__, (handle), (inode), (path))
-static int __ext4_ext_dirty(const char *where, unsigned int line,
-			    handle_t *handle, struct inode *inode,
-			    struct ext4_ext_path *path)
+int ext4__ext_dirty(const char *where, unsigned int line, handle_t *handle,
+		    struct inode *inode, struct ext4_ext_path *path)
 {
 	int err;
 	if (path->p_bh) {
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 309ca89..a05a622 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -410,8 +410,7 @@ mext_insert_extents(handle_t *handle, struct inode *orig_inode,
 						end_ext, eh, range_to_move);
 
 	if (depth) {
-		ret = ext4_handle_dirty_metadata(handle, orig_inode,
-						 orig_path->p_bh);
+		ret = ext4_ext_dirty(handle, orig_inode, orig_path);
 		if (ret)
 			return ret;
 	} else {
