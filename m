From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] tune2fs: warn if the filesystem journal is dirty
Date: Tue, 24 Nov 2015 15:26:03 -0800
Message-ID: <20151124232603.GB10580@birch.djwong.org>
References: <1448405834-25328-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Jim Garlick <garlick@llnl.gov>,
	Andreas Dilger <andreas.dilger@intel.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44165 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbbKXX0N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Nov 2015 18:26:13 -0500
Content-Disposition: inline
In-Reply-To: <1448405834-25328-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 24, 2015 at 03:57:14PM -0700, Andreas Dilger wrote:
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
> index cd1d17f..fcb963a 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -2397,6 +2397,7 @@ retry_open:
>  		ext2fs_mark_super_dirty(fs);
>  		printf(_("Setting stripe width to %d\n"), stripe_width);
>  	}
> +
>  	if (ext_mount_opts) {
>  		strncpy((char *)(fs->super->s_mount_opts), ext_mount_opts,
>  			sizeof(fs->super->s_mount_opts));
> @@ -2406,6 +2407,17 @@ retry_open:
>  		       ext_mount_opts);
>  		free(ext_mount_opts);
>  	}
> +
> +	/* Warn if file system needs recovery and it is opened for writing. */
> +	if ((open_flag & EXT2_FLAG_RW) && !(mount_flags & EXT2_MF_MOUNTED) &&
> +	    (sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
> +	    (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER)) {

ext2fs_has_feature_journal(sb) &&
ext2fs_has_feature_journal_needs_recovery(sb)

> +		fprintf(stderr,
> +			_("Warning: needs_recovery flag is set. You may wish\n"
> +			  "replay the journal then rerun this command, or any\n"

"You may wish to replay the journal..."

> +			  "changes may be overwritten by journal recovery.\n"));

I wonder if we ought simply to replay the journal in this situation, since
debugfs/fuse2fs can do it.

...or at least tell the user how to replay? ("e2fsck -E journal_only"/mount)

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
