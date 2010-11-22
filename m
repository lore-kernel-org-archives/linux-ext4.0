From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: Add FITRIM handle for ext3
Date: Mon, 22 Nov 2010 18:42:20 +0100
Message-ID: <20101122174220.GC5012@quack.suse.cz>
References: <1290425358-16253-1-git-send-email-lczerner@redhat.com>
 <1290425358-16253-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1290425358-16253-2-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 22-11-10 12:29:18, Lukas Czerner wrote:
> It takes fstrim_range structure as an argument. fstrim_range is definec in
> the include/linux/fs.h.
> 
> After the FITRIM is done, the number of actually discarded Bytes is stored
> in fstrim_range.len to give the user better insight on how much storage
> space has been really released for wear-leveling.
  Umm, why do we have to do this when FITRIM is already handled in
fs/ioctl.c? I'd expect us to just provide .trim_fs ioctl, no?

									Honza
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext3/ioctl.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
> index 8897481..fc080dd 100644
> --- a/fs/ext3/ioctl.c
> +++ b/fs/ext3/ioctl.c
> @@ -276,7 +276,29 @@ group_add_out:
>  		mnt_drop_write(filp->f_path.mnt);
>  		return err;
>  	}
> +	case FITRIM: {
>  
> +		struct super_block *sb = inode->i_sb;
> +		struct fstrim_range range;
> +		int ret = 0;
> +
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +
> +		if (copy_from_user(&range, (struct fstrim_range *)arg,
> +				   sizeof(range)))
> +			return -EFAULT;
> +
> +		ret = ext3_trim_fs(sb, &range);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (copy_to_user((struct fstrim_range *)arg, &range,
> +				 sizeof(range)))
> +			return -EFAULT;
> +
> +		return 0;
> +	}
>  
>  	default:
>  		return -ENOTTY;
> -- 
> 1.7.2.3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
