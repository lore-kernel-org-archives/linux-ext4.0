From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 3/4]ext4: Return exchanged blocks count to user space
 in failure
Date: Wed, 02 Sep 2009 23:54:09 +0800
Message-ID: <4A9E9521.2010701@gmail.com>
References: <4A9DE3EA.1080602@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:8968 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZIBPyT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 11:54:19 -0400
Received: by ey-out-2122.google.com with SMTP id 25so215759eya.19
        for <linux-ext4@vger.kernel.org>; Wed, 02 Sep 2009 08:54:20 -0700 (PDT)
In-Reply-To: <4A9DE3EA.1080602@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Akira,

Akira Fujita wrote:
> ext4: Return exchanged blocks count to user space in failure
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> Return exchanged blocks count (moved_len) to user space,
> if ext4_move_extents() failed on the way.
Even with the patch, I still don't see how users can fix EXT4_IOC_MOVE_EXT failures,
because the orig file itself may be broken.
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> ---
>  fs/ext4/ioctl.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index b0b434b..efd11c8 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -255,10 +255,9 @@ setversion_out:
>  					me.donor_start, me.len, &me.moved_len);
>  		fput(donor_filp);
> 
> -		if (!err)
> -			if (copy_to_user((struct move_extent *)arg,
> -				&me, sizeof(me)))
> -				return -EFAULT;
> +		if (copy_to_user((struct move_extent *)arg, &me, sizeof(me)))
> +			return -EFAULT;
> +
>  		return err;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Best Regards,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
