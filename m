From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] Ext3: remove a useless check for the function
 ext3_free_blocks_sb
Date: Mon, 28 Jan 2013 15:07:57 +0100
Message-ID: <20130128140757.GB32246@quack.suse.cz>
References: <51045F97.9070602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756587Ab3A1OIG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 09:08:06 -0500
Content-Disposition: inline
In-Reply-To: <51045F97.9070602@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 26-01-13 14:58:31, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> Because 'block + count < block' always comes to false, it is useless
> to have this check, just remove it.
  As Andreas commented, the test is actually correct. BTW any reason why
you sent the patch three times?

								Honza

> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/ext3/balloc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index 22548f5..c557f22 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -507,7 +507,6 @@ void ext3_free_blocks_sb(handle_t *handle, struct super_block *sb,
>  	sbi = EXT3_SB(sb);
>  	es = sbi->s_es;
>  	if (block < le32_to_cpu(es->s_first_data_block) ||
> -	    block + count < block ||
>  	    block + count > le32_to_cpu(es->s_blocks_count)) {
>  		ext3_error (sb, "ext3_free_blocks",
>  			    "Freeing blocks not in datazone - "
> -- 1.7.11.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
