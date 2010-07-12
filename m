From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] Add discard/nodiscard mount option for ext3
Date: Mon, 12 Jul 2010 17:19:21 +0200
Message-ID: <20100712151921.GA19433@atrey.karlin.mff.cuni.cz>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com> <1278508727-29135-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34479 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755600Ab0GLPTp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jul 2010 11:19:45 -0400
Content-Disposition: inline
In-Reply-To: <1278508727-29135-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Those mount option has the same meaning as in ext4 file system. It
> provide a way to enable/disable file system's trim support. The trim
> support is off by default, thus nodiscard option is not actually
> necessary.
  I kind of miss why ext3 should have a 'discard' mount option. When
user calls DISCARD ioctl on the filesystem, then he probably wants
discard to be performed.

								Honza
 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext3/super.c         |   14 +++++++++++++-
>  include/linux/ext3_fs.h |    1 +
>  2 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 1bee604..6baf7ef 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -662,6 +662,9 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  	if (test_opt(sb, DATA_ERR_ABORT))
>  		seq_puts(seq, ",data_err=abort");
>  
> +	if (test_opt(sb, DISCARD))
> +		seq_puts(seq, ",discard");
> +
>  	if (test_opt(sb, NOLOAD))
>  		seq_puts(seq, ",norecovery");
>  
> @@ -811,7 +814,8 @@ enum {
>  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
>  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
>  	Opt_noquota, Opt_ignore, Opt_barrier, Opt_err, Opt_resize,
> -	Opt_usrquota, Opt_grpquota
> +	Opt_usrquota, Opt_grpquota,
> +	Opt_discard, Opt_nodiscard,
>  };
>  
>  static const match_table_t tokens = {
> @@ -866,6 +870,8 @@ static const match_table_t tokens = {
>  	{Opt_usrquota, "usrquota"},
>  	{Opt_barrier, "barrier=%u"},
>  	{Opt_resize, "resize"},
> +	{Opt_discard, "discard"},
> +	{Opt_nodiscard, "nodiscard"},
>  	{Opt_err, NULL},
>  };
>  
> @@ -1242,6 +1248,12 @@ set_qf_format:
>  		case Opt_bh:
>  			clear_opt(sbi->s_mount_opt, NOBH);
>  			break;
> +		case Opt_discard:
> +			set_opt(sbi->s_mount_opt, DISCARD);
> +			break;
> +		case Opt_nodiscard:
> +			clear_opt(sbi->s_mount_opt, DISCARD);
> +			break;
>  		default:
>  			ext3_msg(sb, KERN_ERR,
>  				"error: unrecognized mount option \"%s\" "
> diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
> index 5f494b4..f3fdd94 100644
> --- a/include/linux/ext3_fs.h
> +++ b/include/linux/ext3_fs.h
> @@ -406,6 +406,7 @@ struct ext3_inode {
>  #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
>  #define EXT3_MOUNT_DATA_ERR_ABORT	0x400000 /* Abort on file data write
>  						  * error in ordered mode */
> +#define EXT3_MOUNT_DISCARD		0x800000 /* Issue DISCARD requests */
>  
>  /* Compatibility, for having both ext2_fs.h and ext3_fs.h included at once */
>  #ifndef _LINUX_EXT2_FS_H
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
