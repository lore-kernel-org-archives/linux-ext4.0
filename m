From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Sat, 26 Jan 2008 16:35:26 +1100
Message-ID: <20080126053526.GN155407@sgi.com>
References: <20080125195938t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080125195938t-sato@mail.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 25, 2008 at 07:59:38PM +0900, Takashi Sato wrote:
> The points of the implementation are followings.
> - Add calls of the freeze function (freeze_bdev) and
>   the unfreeze function (thaw_bdev) in ext3_ioctl().
> 
> - ext3_freeze_timeout() which calls the unfreeze function (thaw_bdev)
>   is registered to the delayed work queue to unfreeze the filesystem
>   automatically after the lapse of the specified time.

Seems like pointless complexity to me - what happens if a
timeout occurs while the filsystem is still freezing?

It's not uncommon for a freeze to take minutes if memory
is full of dirty data that needs to be flushed out, esp. if
dm-snap is doing COWs for every write issued....

> +	case EXT3_IOC_FREEZE: {
....
> +		if (inode->i_sb->s_frozen != SB_UNFROZEN)
> +			return -EINVAL;
....
> +		freeze_bdev(inode->i_sb->s_bdev);
....
> +	case EXT3_IOC_THAW: {
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +		if (inode->i_sb->s_frozen == SB_UNFROZEN)
> +			return -EINVAL;
.....
> +		/* Unfreeze */
> +		thaw_bdev(inode->i_sb->s_bdev, inode->i_sb);

That's inherently unsafe - you can have multiple unfreezes
running in parallel which seriously screws with the bdev semaphore
count that is used to lock the device due to doing multiple up()s
for every down.

Your timeout thingy guarantee that at some point you will get
multiple up()s occuring due to the timer firing racing with
a thaw ioctl. 

If this interface is to be more widely exported, then it needs
a complete revamp of the bdev is locked while it is frozen so
that there is no chance of a double up() ever occuring on the
bd_mount_sem due to racing thaws.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
