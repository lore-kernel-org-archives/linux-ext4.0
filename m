From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: call ext3_mark_recovery_complete() when recovery
 is really needed
Date: Tue, 1 Nov 2011 23:43:07 +0100
Message-ID: <20111101224307.GF18701@quack.suse.cz>
References: <1320113179-27491-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab1KAWnI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 18:43:08 -0400
Content-Disposition: inline
In-Reply-To: <1320113179-27491-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 01-11-11 10:06:19, Eryu Guan wrote:
> Call ext3_mark_recovery_complete() in ext3_fill_super() only if
> needs_recovery is non-zero.
> 
> Besides that, print out "recovery complete" message after calling
> ext3_mark_recovery_complete().
  OK, I don't see a problem in this patch. But is there some benefit in it?
I'm slightly nervous it could change something subtle...

								Honza
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
>  fs/ext3/super.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 7beb69a..2681e0d 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2060,9 +2060,10 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  	EXT3_SB(sb)->s_mount_state |= EXT3_ORPHAN_FS;
>  	ext3_orphan_cleanup(sb, es);
>  	EXT3_SB(sb)->s_mount_state &= ~EXT3_ORPHAN_FS;
> -	if (needs_recovery)
> +	if (needs_recovery) {
> +		ext3_mark_recovery_complete(sb, es);
>  		ext3_msg(sb, KERN_INFO, "recovery complete");
> -	ext3_mark_recovery_complete(sb, es);
> +	}
>  	ext3_msg(sb, KERN_INFO, "mounted filesystem with %s data mode",
>  		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal":
>  		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
> -- 
> 1.7.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
