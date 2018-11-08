Return-Path: <SRS0=LXqi=NT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47066 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726359AbeKHXu5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 8 Nov 2018 18:50:57 -0500
Date: Thu, 8 Nov 2018 15:15:15 +0100
From: Jan Kara <jack@suse.cz>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: avoid unnecessary operation in ext2_error()
Message-ID: <20181108141515.GA28455@quack2.suse.cz>
References: <20181107134704.15821-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107134704.15821-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 07-11-18 21:47:04, Chengguang Xu wrote:
> If filesystem has already mounted as read-only, then we don't have
> to do it again.
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>

Makes sense. Thanks for the patch. I have added it to my tree.

								Honza

> ---
>  fs/ext2/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index cb91baa4275d..5e2861b947a6 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -73,7 +73,7 @@ void ext2_error(struct super_block *sb, const char *function,
>  
>  	if (test_opt(sb, ERRORS_PANIC))
>  		panic("EXT2-fs: panic from previous error\n");
> -	if (test_opt(sb, ERRORS_RO)) {
> +	if (!sb_rdonly(sb) && test_opt(sb, ERRORS_RO)) {
>  		ext2_msg(sb, KERN_CRIT,
>  			     "error: remounting filesystem read-only");
>  		sb->s_flags |= SB_RDONLY;
> -- 
> 2.17.2
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
