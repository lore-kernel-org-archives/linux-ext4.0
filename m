From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] mke2fs: disable resize_inode feature if 64bit feature is
 enabled
Date: Fri, 5 Jul 2013 09:21:28 +0800
Message-ID: <20130705012128.GA11793@gmail.com>
References: <1372928710-10461-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38187 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3GEBCv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jul 2013 21:02:51 -0400
Received: by mail-pd0-f170.google.com with SMTP id x11so1506355pdj.15
        for <linux-ext4@vger.kernel.org>; Thu, 04 Jul 2013 18:02:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1372928710-10461-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 04, 2013 at 05:05:10PM +0800, Eryu Guan wrote:
> Since auto_64-bit_support is on by default, resize_inode feature will
> be disabled when creating a >16T ext4 according to mke2fs.conf(5).
> 
> This should also be done when making ext4 with "-O 64bit" to enable
> 64bit feature explicitly. Otherwise online resize to enlarge a
> over-16T fs to larger would fail.
> 
> [root@localhost resize]# truncate -s 50t fs.img
> [root@localhost resize]# losetup /dev/loop0 fs.img
> [root@localhost resize]# mkfs -t ext4 -O 64bit /dev/loop0 30t
> [root@localhost resize]# mount /dev/loop0 mnt
> [root@localhost resize]# resize2fs /dev/loop0
> resize2fs 1.42.7 (21-Jan-2013)
> Filesystem at /dev/loop0 is mounted on /root/resize/mnt; on-line resizing required
> old_desc_blocks = 3840, new_desc_blocks = 6400
> resize2fs: Invalid argument While checking for on-line resizing support
> 
> And dmesg shows
> [688378.442623] EXT4-fs (loop0): resizing filesystem from 6710886400 to 13421772800 blocks
> [688378.443216] EXT4-fs warning (device loop0): verify_reserved_gdb:700: reserved GDT 3201 missing grp 177147 (5804756097)
> [688378.443222] EXT4-fs (loop0): resized filesystem to 8858370048
> [688378.528451] EXT4-fs warning (device loop0): ext4_group_extend:1710: can't shrink FS - resize aborted
> 
> With this fix resize2fs could do the online enlarge correctly.
> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
>  misc/mke2fs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index d96f156..e4102b9 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1790,6 +1790,9 @@ profile_error:
>  		fs_param.s_log_block_size = 2;
>  	}
>  	if ((fs_blocks_count > MAX_32_NUM) &&

Do we really need to check it?  My point is that we just clear
RESIZE_INODE flag if 64BIT flag is enabled.

                                                - Zheng

> +	    (fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT))
> +		fs_param.s_feature_compat &= ~EXT2_FEATURE_COMPAT_RESIZE_INODE;
> +	if ((fs_blocks_count > MAX_32_NUM) &&
>  	    !(fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) &&
>  	    get_bool_from_profile(fs_types, "auto_64-bit_support", 0)) {
>  		fs_param.s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
