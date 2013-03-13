From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Ext2: do not mark_inode_dirty to avoid BUG_ON
Date: Thu, 14 Mar 2013 00:09:28 +0100
Message-ID: <20130313230928.GA11068@quack.suse.cz>
References: <513EB7DD.3020103@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
Cc: jack@suse.cz, tyhicks@canonical.com, linux-ext4@vger.kernel.org,
	wangshilong1991@gmail.com
To: fanchaoting <fanchaoting@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934352Ab3CMXJc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 19:09:32 -0400
Content-Disposition: inline
In-Reply-To: <513EB7DD.3020103@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 12-03-13 13:06:37, fanchaoting wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> commit 8e3dffc651cb668e1ff4d8b89cc1c3dde7540d3b leads into
> a regression that casue BUG_ON when unlinking inode.
> 
> Reported-by: tyhicks@canonical.com
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
  I ended up fixing the problem by the attached patch. It looks cleaner to
me that way... Thanks for your fix anyway.

							Honza
> ---
>  fs/ext2/balloc.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index 9f9992b..06d82fc 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -562,7 +562,6 @@ error_return:
>  	if (freed) {
>  		percpu_counter_add(&sbi->s_freeblocks_counter, freed);
>  		dquot_free_block_nodirty(inode, freed);
> -		mark_inode_dirty(inode);
>  	}
>  }
>  
> -- 1.7.7.6 
> 
> 
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--AqsLC8rIMeq19msA
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext2-Fix-BUG_ON-in-evict-on-inode-deletion.patch"

>From c288d2969627be7ffc90904ac8c6aae0295fbf9f Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 13 Mar 2013 12:57:08 +0100
Subject: [PATCH] ext2: Fix BUG_ON in evict() on inode deletion

Commit 8e3dffc6 introduced a regression where deleting inode with
large extended attributes leads to triggering
  BUG_ON(inode->i_state != (I_FREEING | I_CLEAR))
in fs/inode.c:evict(). That happens because freeing of xattr block
dirtied the inode and it happened after clear_inode() has been called.

Fix the issue by moving removal of xattr block into ext2_evict_inode()
before clear_inode() call close to a place where data blocks are
truncated. That is also more logical place and removes surprising
requirement that ext2_free_blocks() mustn't dirty the inode.

Reported-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/ialloc.c |    1 -
 fs/ext2/inode.c  |    2 ++
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 8f370e0..7cadd82 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -118,7 +118,6 @@ void ext2_free_inode (struct inode * inode)
 	 * as writing the quota to disk may need the lock as well.
 	 */
 	/* Quota is already initialized in iput() */
-	ext2_xattr_delete_inode(inode);
 	dquot_free_inode(inode);
 	dquot_drop(inode);
 
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index c3881e5..fe60cc1 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -34,6 +34,7 @@
 #include "ext2.h"
 #include "acl.h"
 #include "xip.h"
+#include "xattr.h"
 
 static int __ext2_write_inode(struct inode *inode, int do_sync);
 
@@ -88,6 +89,7 @@ void ext2_evict_inode(struct inode * inode)
 		inode->i_size = 0;
 		if (inode->i_blocks)
 			ext2_truncate_blocks(inode, 0);
+		ext2_xattr_delete_inode(inode);
 	}
 
 	invalidate_inode_buffers(inode);
-- 
1.7.1


--AqsLC8rIMeq19msA--
