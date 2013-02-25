From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: cleanup sbi->s_kobj after quota initialization
 failure
Date: Tue, 26 Feb 2013 00:32:44 +0100
Message-ID: <20130225233244.GA20992@quack.suse.cz>
References: <512BCFBB.30208@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Aditya Kali <adityakali@google.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759567Ab3BYXcs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 18:32:48 -0500
Content-Disposition: inline
In-Reply-To: <512BCFBB.30208@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 25-02-13 15:55:23, Jeff Mahoney wrote:
> If ext4_enable_quotas fails, it jumps to failed_mount7, which doesn't
> tear down the kobj.
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> Cc: Aditya Kali <adityakali@google.com>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/ext4/super.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3794,7 +3794,7 @@ no_journal:
>  	    !(sb->s_flags & MS_RDONLY)) {
>  		err = ext4_enable_quotas(sb);
>  		if (err)
> -			goto failed_mount7;
> +			goto failed_mount8;
>  	}
>  #endif  /* CONFIG_QUOTA */
>  
> @@ -3813,6 +3813,10 @@ cantfind_ext4:
>  		ext4_msg(sb, KERN_ERR, "VFS: Can't find ext4 filesystem");
>  	goto failed_mount;
>  
> +failed_mount8:
> +	kobject_del(&sbi->s_kobj);
> +	kobject_put(&sbi->s_kobj);
> +	wait_for_completion(&sbi->s_kobj_unregister);
>  failed_mount7:
>  	ext4_unregister_li_request(sb);
>  failed_mount6:
> 
> -- 
> Jeff Mahoney
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
