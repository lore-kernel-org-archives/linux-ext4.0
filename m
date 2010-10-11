From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Return proper error code on ext3_fill_super()
Date: Mon, 11 Oct 2010 16:44:43 +0200
Message-ID: <20101011144443.GD3830@quack.suse.cz>
References: <1286791686-2973-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab0JKOpm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Oct 2010 10:45:42 -0400
Content-Disposition: inline
In-Reply-To: <1286791686-2973-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 11-10-10 19:08:06, Namhyung Kim wrote:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
  Looks OK. Merged.

							Honza
> ---
>  fs/ext3/super.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 421fad7..75bbf77 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1871,6 +1871,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  	if (sbi->s_group_desc == NULL) {
>  		ext3_msg(sb, KERN_ERR,
>  			"error: not enough memory");
> +		ret = -ENOMEM;
>  		goto failed_mount;
>  	}
>  
> @@ -1958,6 +1959,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  	}
>  	if (err) {
>  		ext3_msg(sb, KERN_ERR, "error: insufficient memory");
> +		ret = err;
>  		goto failed_mount3;
>  	}
>  
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
