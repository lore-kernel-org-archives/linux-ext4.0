From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: optimize block allocation on grow indepth
Date: Wed, 1 Oct 2014 22:52:55 -0400
Message-ID: <20141002025255.GF16766@thunk.org>
References: <1411455752-2332-1-git-send-email-dmonakhov@openvz.org>
 <1411455752-2332-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60087 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbaJBCxD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Oct 2014 22:53:03 -0400
Content-Disposition: inline
In-Reply-To: <1411455752-2332-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 23, 2014 at 11:02:32AM +0400, Dmitry Monakhov wrote:
> It is reasonable to prepent newly created index to older one.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied with a minor change.

				- Ted

commit c69c690d41e6438ef8e3e9b09d9eb4f2fe669be2
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Wed Oct 1 22:52:39 2014 -0400

    ext4: optimize block allocation on grow indepth
    
    It is reasonable to prepent newld created index to older one.
    
    [ Dropped no longer used function parameter newext. -tytso ]
    
    Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8170b32..c3ed9af2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1263,16 +1263,24 @@ cleanup:
  *   just created block
  */
 static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
-				 unsigned int flags,
-				 struct ext4_extent *newext)
+				 unsigned int flags)
 {
 	struct ext4_extent_header *neh;
 	struct buffer_head *bh;
-	ext4_fsblk_t newblock;
+	ext4_fsblk_t newblock, goal = 0;
+	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
 	int err = 0;
 
-	newblock = ext4_ext_new_meta_block(handle, inode, NULL,
-		newext, &err, flags);
+	/* Try to prepend new index to old one */
+	if (ext_depth(inode))
+		goal = ext4_idx_pblock(EXT_FIRST_INDEX(ext_inode_hdr(inode)));
+	if (goal > le32_to_cpu(es->s_first_data_block)) {
+		flags |= EXT4_MB_HINT_TRY_GOAL;
+		goal--;
+	} else
+		goal = ext4_inode_to_goal_block(inode);
+	newblock = ext4_new_meta_blocks(handle, inode, goal, flags,
+					NULL, &err);
 	if (newblock == 0)
 		return err;
 
@@ -1373,7 +1381,7 @@ repeat:
 			err = PTR_ERR(path);
 	} else {
 		/* tree is full, time to grow in depth */
-		err = ext4_ext_grow_indepth(handle, inode, mb_flags, newext);
+		err = ext4_ext_grow_indepth(handle, inode, mb_flags);
 		if (err)
 			goto out;
 
