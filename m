From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V2] ext4: force ro mount if ext4_setup_super() fails
Date: Thu, 24 May 2012 11:30:24 -0600
Message-ID: <97DEB011-4E1C-4D8C-8C36-44F7DF571E7E@dilger.ca>
References: <4FBE693F.6090705@redhat.com> <4FBE6977.5040604@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:48117 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2EXRaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 May 2012 13:30:25 -0400
In-Reply-To: <4FBE6977.5040604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-24, at 11:01 AM, Eric Sandeen wrote:
> If ext4_setup_super() fails i.e. due to a too-high revision,
> the error is logged in dmesg but the fs is not mounted RO as
> indicated.
> 
> Tested by:
> 
> # mkfs.ext4 -r 4 /dev/sdb6
> # mount /dev/sdb6 /mnt/test
> # dmesg | grep "too high"
> [164919.759248] EXT4-fs (sdb6): revision level too high, forcing read-only mode
> # grep sdb6 /proc/mounts
> /dev/sdb6 /mnt/test2 ext4 rw,seclabel,relatime,data=ordered 0 0
>                          ^^
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Andreas Dilger <adilger@whamcloud.com>

> ---
> 
> V2, fix subject C&P error, oops.
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e1fb1d5..be67c0b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3592,7 +3592,8 @@ no_journal:
> 		goto failed_mount4;
> 	}
> 
> -	ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY);
> +	if (ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY))
> +		sb->s_flags |= MS_RDONLY;
> 
> 	/* determine the minimum size of new large inodes, if present */
> 	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





