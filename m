From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Cleanup ext3_setup_super()
Date: Mon, 11 Oct 2010 16:45:57 +0200
Message-ID: <20101011144556.GF3830@quack.suse.cz>
References: <1286714219-3183-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55847 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab0JKOq4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Oct 2010 10:46:56 -0400
Content-Disposition: inline
In-Reply-To: <1286714219-3183-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 10-10-10 21:36:59, Namhyung Kim wrote:
> Fix mount-count check to emit warning only if s_max_mnt_count
> is greater than 0 according to man tune2fs(8). Also removes
> unnecessary casts.
  Good spotting. Merged.

								Honza

> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
> 
> If this looks fine, I'll send the same patches for ext2 and ext4.
> Thanks.
> 
>  fs/ext3/super.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 5dbf4db..4caeffa 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1306,9 +1306,9 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
>  		ext3_msg(sb, KERN_WARNING,
>  			"warning: mounting fs with errors, "
>  			"running e2fsck is recommended");
> -	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) >= 0 &&
> +	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) > 0 &&
>  		 le16_to_cpu(es->s_mnt_count) >=
> -		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
> +			le16_to_cpu(es->s_max_mnt_count))
>  		ext3_msg(sb, KERN_WARNING,
>  			"warning: maximal mount count reached, "
>  			"running e2fsck is recommended");
> @@ -1325,7 +1325,7 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
>                     valid forever! :) */
>  	es->s_state &= cpu_to_le16(~EXT3_VALID_FS);
>  #endif
> -	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
> +	if (!le16_to_cpu(es->s_max_mnt_count))
>  		es->s_max_mnt_count = cpu_to_le16(EXT3_DFL_MAX_MNT_COUNT);
>  	le16_add_cpu(&es->s_mnt_count, 1);
>  	es->s_mtime = cpu_to_le32(get_seconds());
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
