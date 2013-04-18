From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: disable defrag for metadata_csum file systems
Date: Fri, 19 Apr 2013 07:13:10 +0800
Message-ID: <51707E06.2050105@gmail.com>
References: <1366322282-4673-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55663 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3DRXNO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Apr 2013 19:13:14 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz11so1908539pad.16
        for <linux-ext4@vger.kernel.org>; Thu, 18 Apr 2013 16:13:13 -0700 (PDT)
In-Reply-To: <1366322282-4673-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Sorry, it seems that I got a delivery error.  So send again]

On 04/19/2013 05:58 AM, Theodore Ts'o wrote:
> It looks like there is absolutely no support for metadata checksums in
> fs/ext4/move_extent.c.  So if you try to defrag a file on a
> metadata_csum, it leaves the file system corrupted.
> 
> We really, really should get this fixed ASAP, but until we do, let's
> disable e4defrag on metadata_csum file systems so we avoid corrupting
> file systems.
> 
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Yes, I also notice this problem.  So currently it seems that the best
choice is to disable defrag for metadata_csum.

Reviewed-By: Zheng Liu <wenqing.lz@taobao.com>

Thanks,
						- Zheng

> ---
>  fs/ext4/ioctl.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 9491ac0..2d043da 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -450,6 +450,15 @@ group_extend_out:
>  			goto mext_out;
>  		}
>  
> +		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
> +			ext4_msg(sb, KERN_ERR,
> +				 "Online defrag not supported with "
> +				 "metadata_csum");
> +			err = -EOPNOTSUPP;
> +			goto mext_out;
> +		}
> +
>  		err = mnt_want_write_file(filp);
>  		if (err)
>  			goto mext_out;
> 

