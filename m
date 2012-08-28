From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH, RFC] ext3: don't clear orphan list on ro mount with
 errors
Date: Tue, 28 Aug 2012 10:02:25 +0200
Message-ID: <20120828080225.GB5146@quack.suse.cz>
References: <503BC685.7090707@redhat.com>
 <503BCAE0.7010900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab2H1IC1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Aug 2012 04:02:27 -0400
Content-Disposition: inline
In-Reply-To: <503BCAE0.7010900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 27-08-12 14:30:40, Eric Sandeen wrote:
> When we have a filesystem with an orphan inode list *and* in error
> state, things behave differently if:
> 
> 1) e2fsck -p is done prior to mount: e2fsck fixes things and exits
>    happily (barring other significant problems)
> 
> vs.
> 
> 2) mount is done first, then e2fsck -p: due to the orphan inode
>    list removal, more errors are found and e2fsck exits with
>    UNEXPECTED INCONSISTENCY.
> 
> The 2nd case above, on the root filesystem, has the tendency to halt
> the boot process, which is unfortunate.
> 
> The situation can be improved by not clearing the orphan
> inode list when the fs is mounted readonly.
  Yeah, makes sense. I've added the patch to my tree. Thanks.

								Honza
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index ff9bcdc..485b4fa 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1490,10 +1490,12 @@ static void ext3_orphan_cleanup (struct super_block * sb,
>  	}
>  
>  	if (EXT3_SB(sb)->s_mount_state & EXT3_ERROR_FS) {
> -		if (es->s_last_orphan)
> +		/* don't clear list on RO mount w/ errors */
> +		if (es->s_last_orphan && !(s_flags & MS_RDONLY)) {
>  			jbd_debug(1, "Errors on filesystem, "
>  				  "clearing orphan list.\n");
> -		es->s_last_orphan = 0;
> +			es->s_last_orphan = 0;
> +		}
>  		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
>  		return;
>  	}
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
