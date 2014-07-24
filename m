From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: Add support for FIDTRIM, a best-effort ioctl for
 deep discard trim
Date: Thu, 24 Jul 2014 22:08:01 +1000
Message-ID: <20140724120801.GA26465@dastard>
References: <1406159238-7557-1-git-send-email-jpa@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Geremy Condra <gcondra@google.com>
To: JP Abgrall <jpa@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:3505 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758401AbaGXMIP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jul 2014 08:08:15 -0400
Content-Disposition: inline
In-Reply-To: <1406159238-7557-1-git-send-email-jpa@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 23, 2014 at 04:47:18PM -0700, JP Abgrall wrote:
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index ca1a11b..a1816ca 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -156,6 +156,7 @@ struct inodes_stat_t {
>  #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
>  #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
>  #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
> +#define FIDTRIM	_IOWR('X', 122, struct fstrim_range)	/* Deep discard trim */

The 'X' ioctl namespace is actually XFS's ioctl namespace. FIDTRIM
should be in the 'f' namespace - FIFREEZE and FITHAW were inherited
from XFS, which is where that came from originally, and it got
propagated to FITRIM and it wasn't caught on review. I only noticed
that now:

#define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
#define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
