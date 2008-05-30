From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: remove quota allocation when ext4_mb_new_blocks
	fails
Date: Fri, 30 May 2008 14:05:04 -0700
Message-ID: <1212181504.3719.12.camel@localhost.localdomain>
References: <483F7450.7060004@cn.fujitsu.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57743 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbYE3VF1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 May 2008 17:05:27 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4UL5QDq027692
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 17:05:26 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4UL59WF158802
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 17:05:09 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4UL5989012644
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 17:05:09 -0400
In-Reply-To: <483F7450.7060004@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-05-30 at 11:28 +0800, Shen Feng wrote:
> Quota allocation is not removed When ext4_mb_new_blocks
> calls kmem_cache_alloc failed.
> 
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>

Reviewed-by: Mingming Cao <cmm@us.ibm.com>

Patch also queued up in ext4 patch queue
http://repo.or.cz/w/ext4-patch-queue.git
> ---
>  fs/ext4/mballoc.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 6180ebc..2411db6 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4043,8 +4043,9 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
> 
>  	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
>  	if (!ac) {
> +		ar->len = 0;
>  		*errp = -ENOMEM;
> -		return 0;
> +		goto out1;
>  	}
> 
>  	ext4_mb_poll_new_transaction(sb, handle);
> @@ -4052,7 +4053,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>  	*errp = ext4_mb_initialize_context(ac, ar);
>  	if (*errp) {
>  		ar->len = 0;
> -		goto out;
> +		goto out2;
>  	}
> 
>  	ac->ac_op = EXT4_MB_HISTORY_PREALLOC;
> @@ -4100,11 +4101,12 @@ repeat:
> 
>  	ext4_mb_release_context(ac);
> 
> -out:
> +out2:
> +	kmem_cache_free(ext4_ac_cachep, ac);
> +out1:
>  	if (ar->len < inquota)
>  		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
> 
> -	kmem_cache_free(ext4_ac_cachep, ac);
>  	return block;
>  }
>  static void ext4_mb_poll_new_transaction(struct super_block *sb,

