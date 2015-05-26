From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: BUG_ON assertion repeated for inode1, not done
 for inode2
Date: Tue, 26 May 2015 15:44:24 -0500
Message-ID: <5564DB28.1050908@redhat.com>
References: <5564B06E.6000604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: David Moore <dmoorefo@gmail.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbbEZUoi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 May 2015 16:44:38 -0400
In-Reply-To: <5564B06E.6000604@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/26/15 12:42 PM, David Moore wrote:
> During a source code review of fs/ext4/extents.c I noted identical
> consecutive lines. An assertion is repeated for inode1 and never done
> for inode2. This is not in keeping with the rest of the code in the
> ext4_swap_extents function and appears to be a bug.
> 
> Assert that the inode2 mutex is not locked.

Yep, it's been that way since 

fcf6b1b ext4: refactor ext4_move_extents code base

and it's pretty obviously not right as it is, and
if there's any doubt the comments make it clear:

+ * Locking:
+ *             i_mutex is held for both inodes
+ *             i_data_sem is locked for write for both inodes

Thanks,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: David Moore <dmoorefo@gmail.com>
> ---
>  fs/ext4/extents.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e003a1e..f38a6d6 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5542,7 +5542,7 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
> BUG_ON(!rwsem_is_locked(&EXT4_I(inode1)->i_data_sem));
> BUG_ON(!rwsem_is_locked(&EXT4_I(inode2)->i_data_sem));
>         BUG_ON(!mutex_is_locked(&inode1->i_mutex));
> -       BUG_ON(!mutex_is_locked(&inode1->i_mutex));
> +       BUG_ON(!mutex_is_locked(&inode2->i_mutex));
> 
>         *erp = ext4_es_remove_extent(inode1, lblk1, count);
>         if (unlikely(*erp))
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

