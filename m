From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Use DIV_ROUND_UP() on group desc block counting
Date: Mon, 11 Oct 2010 16:45:30 +0200
Message-ID: <20101011144529.GE3830@quack.suse.cz>
References: <1286793519-3774-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55827 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988Ab0JKOq3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Oct 2010 10:46:29 -0400
Content-Disposition: inline
In-Reply-To: <1286793519-3774-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 11-10-10 19:38:39, Namhyung Kim wrote:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
  OK. Merged.

								Honza
> ---
>  fs/ext3/super.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 75bbf77..3fce402 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1864,8 +1864,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  	sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
>  			       le32_to_cpu(es->s_first_data_block) - 1)
>  				       / EXT3_BLOCKS_PER_GROUP(sb)) + 1;
> -	db_count = (sbi->s_groups_count + EXT3_DESC_PER_BLOCK(sb) - 1) /
> -		   EXT3_DESC_PER_BLOCK(sb);
> +	db_count = DIV_ROUND_UP(sbi->s_groups_count, EXT3_DESC_PER_BLOCK(sb));
>  	sbi->s_group_desc = kmalloc(db_count * sizeof (struct buffer_head *),
>  				    GFP_KERNEL);
>  	if (sbi->s_group_desc == NULL) {
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
