From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] ext4: cleanup GFP flags inside resize path
Date: Fri, 14 Nov 2014 12:37:39 +0300
Message-ID: <87k32yt95o.fsf@openvz.org>
References: <1415551072-3949-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: tytso@mit.edu, cmm@us.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33916 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbaKNJhv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2014 04:37:51 -0500
Received: by mail-wi0-f178.google.com with SMTP id bs8so2078956wib.5
        for <linux-ext4@vger.kernel.org>; Fri, 14 Nov 2014 01:37:49 -0800 (PST)
In-Reply-To: <1415551072-3949-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> We must use GFP_NOFS instead GFP_KERNEL inside ext4_mb_add_groupinfo because resizing call
>  it inside journal transaction. Call trace:
> ioctl
>  ->ext4_group_add
>    ->journal_start
>    ->ext4_setup_new_descs
>      ->ext4_mb_add_groupinfo
It is appeared that there is one more case missed.
ext4_group_add
   ->journal_start
   ->ext4_flex_group_add
        ->ext4_update_super
               ->ext4_calculate_overhead  -> GFP_KERNEL
I'll send updated version soon.               
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/mballoc.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index dbfe15c..654e70d 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2385,7 +2385,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
>  	if (group % EXT4_DESC_PER_BLOCK(sb) == 0) {
>  		metalen = sizeof(*meta_group_info) <<
>  			EXT4_DESC_PER_BLOCK_BITS(sb);
> -		meta_group_info = kmalloc(metalen, GFP_KERNEL);
> +		meta_group_info = kmalloc(metalen, GFP_NOFS);
>  		if (meta_group_info == NULL) {
>  			ext4_msg(sb, KERN_ERR, "can't allocate mem "
>  				 "for a buddy group");
> @@ -2399,7 +2399,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
>  		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)];
>  	i = group & (EXT4_DESC_PER_BLOCK(sb) - 1);
>  
> -	meta_group_info[i] = kmem_cache_zalloc(cachep, GFP_KERNEL);
> +	meta_group_info[i] = kmem_cache_zalloc(cachep, GFP_NOFS);
>  	if (meta_group_info[i] == NULL) {
>  		ext4_msg(sb, KERN_ERR, "can't allocate buddy mem");
>  		goto exit_group_info;
> @@ -2428,7 +2428,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
>  	{
>  		struct buffer_head *bh;
>  		meta_group_info[i]->bb_bitmap =
> -			kmalloc(sb->s_blocksize, GFP_KERNEL);
> +			kmalloc(sb->s_blocksize, GFP_NOFS);
>  		BUG_ON(meta_group_info[i]->bb_bitmap == NULL);
>  		bh = ext4_read_block_bitmap(sb, group);
>  		BUG_ON(bh == NULL);
> -- 
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
