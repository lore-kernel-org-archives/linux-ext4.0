From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: fix error in computing blocks of the ending group
Date: Tue, 19 Jul 2011 11:18:50 -0500
Message-ID: <4E25AE6A.6090909@redhat.com>
References: <1311090411-13766-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab1GSQSz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jul 2011 12:18:55 -0400
In-Reply-To: <1311090411-13766-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/19/2011 10:46 AM, Yongqiang Yang wrote:
> If the blocks of a filesystem is a multiple of blocks_per_group,
> blocks of the ending group is computed wrongly.  This patch computes
> it by substracting blocks processed from blocks of the filesystem.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  e2fsck/pass5.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
> index f9d746c..7c4e336 100644
> --- a/e2fsck/pass5.c
> +++ b/e2fsck/pass5.c
> @@ -227,7 +227,7 @@ redo_counts:
>  				if (group == (int)fs->group_desc_count - 1)
>  					cmp_block =
>  						EXT2FS_NUM_B2C(fs,
> -		ext2fs_blocks_count(fs->super) % fs->super->s_blocks_per_group);
> +					ext2fs_blocks_count(fs->super) - i);
>  			}
>  
>  			bitmap = 0;

I think it would be clearer to just get the last group block count from
superblock information, rather than from using the loop counter.

For example resize does:

        if (i == fs->group_desc_count-1) {
                numblocks = (ext2fs_blocks_count(fs->super) -
                             fs->super->s_first_data_block) %
                                     fs->super->s_blocks_per_group;
                if (!numblocks)
                        numblocks = fs->super->s_blocks_per_group;


same as this function in alloc_sb.c:

        if (group == fs->group_desc_count-1) {
                num_blocks = (ext2fs_blocks_count(fs->super) -
                             fs->super->s_first_data_block) %
                        fs->super->s_blocks_per_group;
                if (!num_blocks)
                        num_blocks = fs->super->s_blocks_per_group;


Hm, seems maybe an ext2fs_blocks_in_group() helper function might be
nice, since this is a little verbose, and is used fairly often.

-Eric
