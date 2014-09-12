From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] tune2fs: warn if the filesystem journal is dirty
Date: Fri, 12 Sep 2014 14:18:40 -0700
Message-ID: <20140912211840.GC10150@birch.djwong.org>
References: <1410554380-2014-1-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Jim Garlick <garlick@llnl.gov>
To: Andreas Dilger <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18537 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbaILVSs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2014 17:18:48 -0400
Content-Disposition: inline
In-Reply-To: <1410554380-2014-1-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 12, 2014 at 02:39:40PM -0600, Andreas Dilger wrote:
> From: Jim Garlick <garlick@llnl.gov>
> 
> Running tune2fs on a filesystem with an unrecovered journal can
> cause the tune2fs settings changes in the superblock to be reverted
> when the journal is replayed if it contains an uncommitted copy of
> the superblock.  Print a warning if this is detected so that the
> user isn't surprised if it happens.
> 
> Signed-off-by: Jim Garlick <garlick@llnl.gov>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
>  misc/tune2fs.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index b65dab9..e5ec8a4 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -2395,6 +2395,7 @@ retry_open:
>  		ext2fs_mark_super_dirty(fs);
>  		printf(_("Setting stripe width to %d\n"), stripe_width);
>  	}
> +
>  	if (ext_mount_opts) {
>  		strncpy((char *)(fs->super->s_mount_opts), ext_mount_opts,
>  			sizeof(fs->super->s_mount_opts));
> @@ -2404,6 +2405,17 @@ retry_open:
>  		       ext_mount_opts);
>  		free(ext_mount_opts);
>  	}
> +
> +	/* Warn if file system needs recovery and it is opened for writing. */
> +	if ((open_flag & EXT2_FLAG_RW) && !(mount_flags & EXT2_MF_MOUNTED) &&
> +	    (sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
> +	    (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER)) {
> +		fprintf(stderr,
> +			_("Warning: needs_recovery flag is set. You may wish\n"
> +			  "replay the journal then rerun this command, or any\n"
> +			  "changes may be overwritten by journal recovery.\n"));

At a bare minimum this ought to be "You may wish *to* replay...", but I
suggest:

"You should replay the journal and then rerun this command because it is
possible that your changes will be overwritten by the journal recovery."

Otherwise looks fine to me.

--D

> +	}
> +
>  	free(device_name);
>  	remove_error_table(&et_ext2_error_table);
>  
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
