From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2] mke2fs: use ext2fs_open_file() in check_plausibility()
Date: Wed, 21 May 2014 11:00:30 -0700
Message-ID: <20140521180030.GA17413@birch.djwong.org>
References: <537CE3E1.10406@redhat.com>
 <537CE6C0.1050800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17395 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaEUSAj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2014 14:00:39 -0400
Content-Disposition: inline
In-Reply-To: <537CE6C0.1050800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 21, 2014 at 12:47:44PM -0500, Eric Sandeen wrote:
> The commit:
> 
> 802146c mke2fs: create a regular file if necessary
> 
> caused a regression on 32-bit machines; the open() fails if
> the file size is > 4G.
> 
> Using ext2fs_open_file() fixes it.
> 
> Resolves: Red Hat Bugzilla #1099892
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: against master!  Sorry, first patch was against the
> bisection point.
> 
> TBH I don't know if this should be using ext2fs_open_file(),
> or some other magic like O_LARGEFILE, but this works for me,
> and we use the stat/fstat wrapper here too, so ...

/me suspects do_write_internal() in create_inode.c should use this too.

As for the patch itself, looks good, so
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
> 
> 
> 
> diff --git a/misc/util.c b/misc/util.c
> index 1c0818f..7e91509 100644
> --- a/misc/util.c
> +++ b/misc/util.c
> @@ -194,10 +194,10 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
>  	char *fs_type = NULL;
>  	char *fs_label = NULL;
>  
> -	fd = open(device, fl, 0666);
> +	fd = ext2fs_open_file(device, fl, 0666);
>  	if ((fd < 0) && (errno == ENOENT) && (flags & CREATE_FILE)) {
>  		fl |= O_CREAT;
> -		fd = open(device, fl, 0666);
> +		fd = ext2fs_open_file(device, fl, 0666);
>  		if (fd >= 0 && (flags & VERBOSE_CREATE))
>  			printf(_("Creating regular file %s\n"), device);
>  	}
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
