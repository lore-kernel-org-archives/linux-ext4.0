From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH V2] e2fsprogs: add ext2fs_group_blocks_count helper
Date: Thu, 21 Jul 2011 08:55:27 -0500
Message-ID: <4E282FCF.4050602@redhat.com>
References: <1311090411-13766-1-git-send-email-xiaoqiangnk@gmail.com> <4E25AE6A.6090909@redhat.com> <4E274CD0.1000801@redhat.com> <4E274F57.8020007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab1GUNzb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jul 2011 09:55:31 -0400
In-Reply-To: <4E274F57.8020007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/20/11 4:57 PM, Eric Sandeen wrote:
> Code to count the number of blocks in the last partial
> group is cut and pasted around the e2fsprogs codebase, and
> is wrong in at least one instancem as pointed out by
> Yongqiang Yang (but not fixed in this patch).
> 
> Making this a helper function should improve matters.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Argh V3 coming today, I got a little too fast and loose sending this one
at the end of the day yesterday didn't I:

> @@ -499,18 +499,8 @@ retry:
>  		ext2fs_bg_flags_zap(fs, i);
>  		if (csum_flag)
>  			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_UNINIT | EXT2_BG_INODE_ZEROED);
> -		if (i == fs->group_desc_count-1) {
> -			numblocks = (ext2fs_blocks_count(fs->super) -
> -				     fs->super->s_first_data_block) %
> -					     fs->super->s_blocks_per_group;
> -			if (!numblocks)
> -				numblocks = fs->super->s_blocks_per_group;
> -		} else {
> -			numblocks = fs->super->s_blocks_per_group;
> -			if (csum_flag)
> -				ext2fs_bg_flags_set(fs, i,
> -						    EXT2_BG_BLOCK_UNINIT);

still need to do that flag set with the new helper.

- Eric

> -		}
> +
> +		numblocks = ext2fs_group_blocks_count(fs, i);
>  
>  		has_super = ext2fs_bg_has_super(fs, i);
>  		if (has_super) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

