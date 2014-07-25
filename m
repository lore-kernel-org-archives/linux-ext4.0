From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] debugfs: allow do_write() to handle files over 4GB
Date: Thu, 24 Jul 2014 17:04:31 -0700
Message-ID: <20140725000431.GI8628@birch.djwong.org>
References: <1406245759-1617-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41833 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934753AbaGYAEi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2014 20:04:38 -0400
Content-Disposition: inline
In-Reply-To: <1406245759-1617-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 24, 2014 at 05:49:19PM -0600, Andreas Dilger wrote:
> Fix debugfs do_write() to correctly set i_size_high if the source
> file is larger than 4GB.  Otherwise, only the low 32 bits of the
> size is stored in i_size.

You might also want to set large_file if needed.  I wrote a helper to set an
inode's i_size* fields and turn on feature bits; it's been languishing at the
back end of the patchbomb for a while:
http://permalink.gmane.org/gmane.comp.file-systems.ext4/43861

--D

> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> ---
>  debugfs/debugfs.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index 1703aba..1184596 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -1719,6 +1719,8 @@ void do_write(int argc, char *argv[])
>  		current_fs->now ? current_fs->now : time(0);
>  	inode.i_links_count = 1;
>  	inode.i_size = statbuf.st_size;
> +	/* cast to (long long) to avoid shift warning if st_size is 32 bits */
> +	inode.i_size_high = (long long)statbuf.st_size >> 32;
>  	if (current_fs->super->s_feature_incompat &
>  	    EXT3_FEATURE_INCOMPAT_EXTENTS) {
>  		int i;
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
