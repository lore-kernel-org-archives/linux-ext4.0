From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4 v2] ext4: Fix trimmed block count computing
Date: Mon, 5 Mar 2012 13:38:20 +0100
Message-ID: <20120305123820.GE6643@quack.suse.cz>
References: <1330690318-22627-1-git-send-email-lczerner@redhat.com>
 <1330690318-22627-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756981Ab2CEMiW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 07:38:22 -0500
Content-Disposition: inline
In-Reply-To: <1330690318-22627-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 02-03-12 13:11:56, Lukas Czerner wrote:
> Currently when there is not enough free block in the block group to
> discard (grp->bb_free < minlen) the 'trimmed' is bumped up anyway with
> the number of discarded blocks from the previous iteration. Fix this
> by bumping up 'trimmed' only if the ext4_trim_all_free() was actually
> run.
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> v2: nothing changed
> 
>  fs/ext4/mballoc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 16a3aeb..f20688e 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -5083,8 +5083,8 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  				ret = cnt;
>  				break;
>  			}
> +			trimmed += cnt;
>  		}
> -		trimmed += cnt;
>  
>  		/*
>  		 * For every group except the first one, we are sure
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
