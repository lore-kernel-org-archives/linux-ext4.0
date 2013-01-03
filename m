From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/4] resize2fs: fix 32-bit overflow issue which can corrupt
 64-bit file systems
Date: Thu, 03 Jan 2013 09:56:51 -0600
Message-ID: <50E5AA43.2080200@redhat.com>
References: <1357222408-7310-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab3ACP4v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jan 2013 10:56:51 -0500
In-Reply-To: <1357222408-7310-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/3/13 8:13 AM, Theodore Ts'o wrote:
> Fix a 32-bit overflow bug caused by a missing blk64_t cast which can
> cause the block bitmap to get corrupted when doing an off-line resize
> of a 64-bit file system.

Yikes - seems like there are quite a few places where we need to
audit this kind of thing

4 resize/online.c           <global>                   171 size = fs->group_desc_count * sb->s_blocks_per_group +

size is a blk_t / __u32

a e2fsck/super.c            check_resize_inode         421 expect = pblk + (j * fs->super->s_blocks_per_group);

j is dgrp_t / __u32

f e2fsck/super.c            check_backup_super_block   931 (g * fs->super->s_blocks_per_group);

g is dgrp_t / __u32

1 lib/ext2fs/alloc.c        check_block_uninit          43 blk = (group * fs->super->s_blocks_per_group) +

group is dgrp_t / __u32

e lib/ext2fs/extent.c       extent_node_split          947 goal_blk = (group * handle->fs->super->s_blocks_per_group) +

group is dgrp_t ...


1 lib/ext2fs/mkjournal.c    write_journal_inode        361 es.goal = (fs->super->s_blocks_per_group * group) +
8 resize/resize2fs.c        blocks_to_move             828 blk = ((g+1) * fs->super->s_blocks_per_group) +

... etc.  Some of those might not matter (we might not get into that resize code) but this look like a lot of potential for trouble.

-Eric



> This problem can be reproduced as follows:
> 
> rm -f foo.img; touch foo.img
> truncate -s 8T foo.img
> mke2fs -F -t ext4 -O 64bit foo.img
> e2fsck -f foo.img
> truncate -s 21T foo.img
> resize2fs foo.img
> e2fsck -fy foo.img
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  resize/resize2fs.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index 092cfbd..0407e41 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -197,8 +197,7 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
>  		if (!(ext2fs_bg_flags_test(fs, g, EXT2_BG_BLOCK_UNINIT)))
>  			continue;
>  
> -		blk = (g * fs->super->s_blocks_per_group) +
> -			fs->super->s_first_data_block;
> +		blk = ext2fs_group_first_block2(fs, g);
>  
>  		ext2fs_super_and_bgd_loc2(fs, g, &super_blk,
>  					  &old_desc_blk, &new_desc_blk, 0);
> @@ -846,8 +845,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
>  			 * The block bitmap is uninitialized, so skip
>  			 * to the next block group.
>  			 */
> -			blk = ((g+1) * fs->super->s_blocks_per_group) +
> -				fs->super->s_first_data_block - 1;
> +			blk = ext2fs_group_first_block2(fs, g+1) - 1;
>  			continue;
>  		}
>  		if (ext2fs_test_block_bitmap2(old_fs->block_map, blk) &&
> 

