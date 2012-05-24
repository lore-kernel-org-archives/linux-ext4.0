From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext3: force ro mount if ext3_setup_super() fails
Date: Thu, 24 May 2012 11:41:57 -0600
Message-ID: <49CDEB80-418A-492C-B3F1-8E2A46DA9E29@dilger.ca>
References: <4FBE6935.3000301@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:27683 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910Ab2EXRl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 May 2012 13:41:59 -0400
In-Reply-To: <4FBE6935.3000301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-24, at 11:00 AM, Eric Sandeen wrote:
> If ext3_setup_super() fails i.e. due to a too-high revision,
> the error is logged in dmesg but the fs is not mounted RO as
> indicated.
> 
> Tested by:
> 
> # mkfs.ext3 -r 4 /dev/sdb6
> # mount /dev/sdb6 /mnt/test
> # dmesg | grep "too high"
> [164152.114551] EXT3-fs (sdb6): error: revision level too high, forcing read-only mode
> # grep sdb6 /proc/mounts
> /dev/sdb6 /mnt/test2 ext3 rw,seclabel,relatime,errors=continue,user_xattr,acl,barrier=1,data=ordered 0 0
>                          ^^
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Andreas Dilger <adilger@whamcloud.com>

> ---
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index cf0b592..fef7af2 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2043,7 +2043,8 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
> 		goto failed_mount3;
> 	}
> 
> -	ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
> +	if (ext3_setup_super(sb, es, sb->s_flags & MS_RDONLY))
> +		sb->s_flags |= MS_RDONLY;

I was wondering if this should be:

	sb->s_flags |= ext3_setup_super(...)

but that might be over-thinking things.

> 	EXT3_SB(sb)->s_mount_state |= EXT3_ORPHAN_FS;
> 	ext3_orphan_cleanup(sb, es);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





