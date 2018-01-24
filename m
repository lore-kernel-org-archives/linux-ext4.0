From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: make huge file flag user visible.
Date: Tue, 23 Jan 2018 21:03:33 -0800
Message-ID: <20180124050333.GC5594@magnolia>
References: <1516767348-30444-1-git-send-email-tgnottingham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca
To: Tyson Nottingham <tgnottingham@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50896 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932068AbeAXFDl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jan 2018 00:03:41 -0500
Content-Disposition: inline
In-Reply-To: <1516767348-30444-1-git-send-email-tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 23, 2018 at 08:15:48PM -0800, Tyson Nottingham wrote:
> Make huge file flag visible to clients of FS_IOC_GETFLAGS ioctl, e.g.
> the userspace tool lsattr, which expects the flag to be visible.

Pardon my asking, but why is this necessary?  Are there
userspace-visible effects of this flag?

--D

> 
> Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
> ---
>  fs/ext4/ext4.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3241475..dbd6318 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -400,7 +400,7 @@ struct flex_groups {
>  #define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
>  #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
>  
> -#define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags */
> +#define EXT4_FL_USER_VISIBLE		0x304FDFFF /* User visible flags */
>  #define EXT4_FL_USER_MODIFIABLE		0x204BC0FF /* User modifiable flags */
>  
>  /* Flags we can manipulate with through EXT4_IOC_FSSETXATTR */
> -- 
> 2.7.4
> 
