From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 4/6] ext4: change lru to round-robin in extent status
 tree shrinker
Date: Tue, 2 Sep 2014 23:37:38 -0400
Message-ID: <20140903033738.GB2504@thunk.org>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-5-git-send-email-wenqing.lz@taobao.com>
 <20140827150121.GC22211@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34023 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbaICDhv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Sep 2014 23:37:51 -0400
Content-Disposition: inline
In-Reply-To: <20140827150121.GC22211@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 27, 2014 at 05:01:21PM +0200, Jan Kara wrote:
> On Thu 07-08-14 11:35:51, Zheng Liu wrote:
>   This comment is not directly related to this patch but looking into the
> code made me think about it. It seems ugly to call __es_shrink() from
> internals of ext4_es_insert_extent(). Also thinking about locking
> implications makes me shudder a bit and finally this may make the pressure
> on the extent cache artificially bigger because MM subsystem is not aware
> of the shrinking you do here. I would prefer to leave shrinking on
> the slab subsystem itself.

If we fail, the allocation we only try to free at most one extent, so
I don't think it's going to make the slab system that confused; it's
the equivalent of freeing an entry and then using allocating it again.

> Now GFP_ATOMIC allocation we use for extent cache makes it hard for the
> slab subsystem and actually we could fairly easily use GFP_NOFS. We can just
> allocate the structure before grabbing i_es_lock with GFP_NOFS allocation and
> in case we don't need the structure, we can just free it again. It may
> introduce some overhead from unnecessary alloc/free but things get simpler
> that way (no need for that locked_ei argument for __es_shrink(), no need
> for internal calls to __es_shrink() from within the filesystem).

The tricky bit is that even __es_remove_extent() can require a memory
allocation, and in the worst case, it's possible that
ext4_es_insert_extent() can require *two* allocations.  For example,
if you start with a single large extent, and then need to insert a
subregion with a different set of flags into the already existing
extent, thus resulting in three extents where you started with one.

And in some cases, no allocation is required at all....

One thing that can help is that so long as we haven't done something
critical, such as erase a delalloc region, we always release the write
lock and retry the allocation with GFP_NOFS, and the try the operation
again.

So we may need to think a bit about what's the best way to improve
this, although it is separate topic from making the shrinker be less
heavyweight.

>   Nothing seems to prevent reclaim from freeing the inode after we drop
> s_es_lock. So we could use freed memory. I don't think we want to pin the
> inode here by grabbing a refcount since we don't want to deal with iput()
> in the shrinker (that could mean having to delete the inode from shrinker
> context). But what we could do it to grab ei->i_es_lock before dropping
> s_es_lock. Since ext4_es_remove_extent() called from ext4_clear_inode()
> always grabs i_es_lock, we are protected from inode being freed while we
> hold that lock. But please add comments about this both to the
> __es_shrink() and ext4_es_remove_extent().

Something like this should work, yes?

						- Ted

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 25da1bf..4768f7f 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -981,32 +981,27 @@ retry:
 
 		list_del_init(&ei->i_es_list);
 		sbi->s_es_nr_inode--;
-		spin_unlock(&sbi->s_es_lock);
+		if (ei->i_es_shk_nr == 0)
+			continue;
 
 		/*
 		 * Normally we try hard to avoid shrinking precached inodes,
 		 * but we will as a last resort.
 		 */
-		if (!retried && ext4_test_inode_state(&ei->vfs_inode,
-						EXT4_STATE_EXT_PRECACHED)) {
+		if ((!retried && ext4_test_inode_state(&ei->vfs_inode,
+				       EXT4_STATE_EXT_PRECACHED)) ||
+		    ei == locked_ei ||
+		    !write_trylock(&ei->i_es_lock)) {
 			nr_skipped++;
-			spin_lock(&sbi->s_es_lock);
-			__ext4_es_list_add(sbi, ei);
-			continue;
-		}
-
-		if (ei->i_es_shk_nr == 0) {
-			spin_lock(&sbi->s_es_lock);
-			continue;
-		}
-
-		if (ei == locked_ei || !write_trylock(&ei->i_es_lock)) {
-			nr_skipped++;
-			spin_lock(&sbi->s_es_lock);
 			__ext4_es_list_add(sbi, ei);
+			if (spin_is_contended(&sbi->s_es_lock)) {
+				spin_unlock(&sbi->s_es_lock);
+				spin_lock(&sbi->s_es_lock);
+			}
 			continue;
 		}
