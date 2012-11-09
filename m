From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH v2] ext4: Prevent race while waling extent tree
Date: Fri, 09 Nov 2012 16:27:20 +0400
Message-ID: <87y5ibm05z.fsf@openvz.org>
References: <1352457533-11642-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, zab@redhat.com, Lukas Czerner <lczerner@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55084 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab2KIM1X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Nov 2012 07:27:23 -0500
Received: by mail-lb0-f174.google.com with SMTP id n3so2981787lbo.19
        for <linux-ext4@vger.kernel.org>; Fri, 09 Nov 2012 04:27:21 -0800 (PST)
In-Reply-To: <1352457533-11642-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri,  9 Nov 2012 11:38:53 +0100, Lukas Czerner <lczerner@redhat.com> wrote:
> Currently ext4_ext_walk_space() only takes i_data_sem for read when
> searching for the extent at given block with ext4_ext_find_extent().
> Then it drops the lock and the extent tree can be changed at will.
> However later on we're searching for the 'next' extent, but the extent
> tree might already have changed, so the information might not be
> accurate.
> 
> In fact we can hit BUG_ON(end <= start) if the extent got inserted into
> the tree after the one we found and before the block we were searching
> for. This has been reproduced by running xfstests 225 in loop on s390x
> architecture, but theoretically we could hit this on any other
> architecture as well, but probably not as often.
> 
> ext4_ext_walk_space() is currently only used from ext4_fiemap().
> 
> Fix this by extending the critical section to include
> ext4_ext_next_allocated_block() as well. It means that if there are any
> operation going on on the particular inode, the fiemap will return
> inaccurate data. However this will also fix the concerns about starving
> writers to the extent tree, because we will put and reacquire the
> semaphore with every iteration. This will not be particularly fast, but
> fiemap is not critical operation.
See comments below
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> v2: Extend the critical section rather than put the whole function under
>     the lock.
> 
>  fs/ext4/extents.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7011ac9..d444281 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1978,7 +1978,6 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
>  		/* find extent for this block */
>  		down_read(&EXT4_I(inode)->i_data_sem);
>  		path = ext4_ext_find_extent(inode, block, path);
> -		up_read(&EXT4_I(inode)->i_data_sem);
>  		if (IS_ERR(path)) {
>  			err = PTR_ERR(path);
>  			path = NULL;
First of all: you should drop i_data_sem here, and in all other error
handlers
> @@ -1993,6 +1992,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
>  		}
>  		ex = path[depth].p_ext;
>  		next = ext4_ext_next_allocated_block(path);
> +		up_read(&EXT4_I(inode)->i_data_sem);
>  
>  		exists = 0;
>  		if (!ex) {
> -- 
> 1.7.7.6
Also i believe that BUG_ON is still possible because after you drop
i_data_sem, path[depth].p_ext may contains semi-random data
(for example after i_depth change) so your previous fix was more
intrusive, but 100% safe. IMHO it is safe to drop sem a bit later
right after you have finished with 'path' on current iteration
for example like this(caution i'm not test this patch):
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7011ac9..2d2d2af 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1978,10 +1978,10 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 		/* find extent for this block */
 		down_read(&EXT4_I(inode)->i_data_sem);
 		path = ext4_ext_find_extent(inode, block, path);
-		up_read(&EXT4_I(inode)->i_data_sem);
 		if (IS_ERR(path)) {
 			err = PTR_ERR(path);
 			path = NULL;
+			up_read(&EXT4_I(inode)->i_data_sem);
 			break;
 		}
 
@@ -1989,6 +1989,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 		if (unlikely(path[depth].p_hdr == NULL)) {
 			EXT4_ERROR_INODE(inode, "path[%d].p_hdr == NULL", depth);
 			err = -EIO;
+			up_read(&EXT4_I(inode)->i_data_sem);
 			break;
 		}
 		ex = path[depth].p_ext;
@@ -2028,6 +2029,8 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			BUG();
 		}
 		BUG_ON(end <= start);
+		up_read(&EXT4_I(inode)->i_data_sem);
+		BUG_ON(end <= start);
 
 		if (!exists) {
 			cbex.ec_block = start;
@@ -2045,7 +2048,6 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			break;
 		}
 		err = func(inode, next, &cbex, ex, cbdata);
-		ext4_ext_drop_refs(path);
 
 		if (err < 0)
 			break;

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
