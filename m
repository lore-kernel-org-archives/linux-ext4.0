From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fsck get error with the file which is > 2TB in 4k block file
 system
Date: Thu, 21 Oct 2010 10:06:12 -0500
Message-ID: <4CC056E4.8000208@redhat.com>
References: <AANLkTik6mjHAZG2ePmDyBmb6CRhV8=dD_tTTdhCzykca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: ck ya <ykwan0201@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab0JUPGQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Oct 2010 11:06:16 -0400
In-Reply-To: <AANLkTik6mjHAZG2ePmDyBmb6CRhV8=dD_tTTdhCzykca@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ck ya wrote:
> I compiled the latest e2fsprogs, and do fsck with -nvf on my ext4 file system.
> It showed
> Inode 18, i_blocks is 17179870744, should be 17179870744. Fix? no
> The i_blocks is the same.
> 
> I found ext2fs_inode_i_blocks() has problem.  The function check
> EXT4_FEATURE_RO_COMPAT_HUGE_FILE with "s_feature_compat".  It should
> be "s_feature_ro_compat".

Seems right to me, if you add [PATCH] to the subject emails like
these, and add:

Signed-off-by: ck ya <ykwan0201@gmail.com>
---

after the patch,

it'd be ideal.

Thanks,
-Eric

> Thanks.
> 
> diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
> index a48b696..d67c6ec 100644
> --- a/lib/ext2fs/blknum.c
> +++ b/lib/ext2fs/blknum.c
> @@ -49,7 +49,7 @@ blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
>                                         struct ext2_inode *inode)
>  {
>         return (inode->i_blocks |
> -               ((fs->super->s_feature_incompat &
> +               ((fs->super->s_feature_ro_incompat &
>                   EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ?
>                  (__u64) inode->osd2.linux2.l_i_blocks_hi << 32 : 0)) -
>                 (inode->i_file_acl ? fs->blocksize >> 9 : 0);
> @@ -62,7 +62,7 @@ blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
>                                         struct ext2_inode *inode)
>  {
>         return (inode->i_blocks |
> -               ((fs->super->s_feature_incompat &
> +               ((fs->super->s_feature_ro_incompat &
>                   EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ?
>                  (__u64)inode->osd2.linux2.l_i_blocks_hi << 32 : 0));
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

