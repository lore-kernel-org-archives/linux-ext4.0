From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 03/25] mke2fs: don't let resize= turn on resize_inode
 when meta_bg is set
Date: Wed, 23 Oct 2013 17:08:53 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310231653590.1918@localhost.localdomain>
References: <20131018044854.7339.48457.stgit@birch.djwong.org> <20131018044915.7339.15471.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab3JWPJA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Oct 2013 11:09:00 -0400
In-Reply-To: <20131018044915.7339.15471.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Oct 2013, Darrick J. Wong wrote:

> Date: Thu, 17 Oct 2013 21:49:16 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 03/25] mke2fs: don't let resize= turn on resize_inode when
>     meta_bg is set
> 
> Passing the "-E resize=NNN" option to mke2fs sets the resize_inode
> feature.  However, resize_inode and meta_bg are mutually exclusive
> (and the feature flag parser enforces this); therefore, we shouldn't
> allow resize_inode to sneak in the back door like this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  misc/mke2fs.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 6e709b9..ce3c696 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2448,6 +2448,17 @@ int main (int argc, char *argv[])
>  	}
>  	fs->progress_ops = &ext2fs_numeric_progress_ops;
>  
> +	/* We can't have resize_inode sneak in via resize= on a meta_bg fs. */
> +	if (!quiet &&

It means that this will only be checked when user does _not_ run
with quiet mode, so it'll still be possible when run with -q. I
assume this is not what you wanted.

Thanks!
-Lukas


> +	    EXT2_HAS_INCOMPAT_FEATURE(fs->super,
> +				      EXT2_FEATURE_INCOMPAT_META_BG) &&
> +	    fs->super->s_reserved_gdt_blocks > 0) {
> +		printf(_("Reserving GDT blocks (resize_inode) is not possible "
> +			 "with the meta_bg feature.\nThey cannot be enabled "
> +			 "simultaneously.\n"));
> +		exit(1);
> +	}
> +
>  	/* Check the user's mkfs options for metadata checksumming */
>  	if (!quiet &&
>  	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
