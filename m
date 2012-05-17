From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsck: Let end_blk to be the maximum value of u32.
Date: Thu, 17 May 2012 01:12:57 -0600
Message-ID: <FE59692A-FABC-4D9A-BED7-7880E968133D@dilger.ca>
References: <1337158225-4627-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:20800 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761032Ab2EQHNE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 May 2012 03:13:04 -0400
In-Reply-To: <1337158225-4627-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-16, at 2:50 AM, Tao Ma wrote:
> Now we can use fallocate to create a large file while keep the size
> to be small. It will cause the e2fsck complain about it. The test
> script is simple and I have pasted it here.

We had previously added the EXT4_EOFBLOCKS_FL to distinguish the
case between "corrupt i_size should be extended to match i_blocks"
and "valid fallocate case of blocks allocated beyond i_size".

This was removed recently, but I didn't really understand the reason
why it was removed.

Cheers, Andreas

> DEVICE=/dev/sdb1
> mount -t ext4 $DEVICE /mnt/ext4
> for((i=0;i<10;i++))do fallocate -n -o $[$i*8192] -l 4096 /mnt/ext4/a;done
> umount $DEVICE
> e2fsck -fn $DEVICE
> 
> The error message will be like this:
> e2fsck 1.42.3 (14-May-2012)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 12 has zero length extent
> 	(invalid logical block 0, physical block 32775)
> Clear? no
> 
> Inode 12, i_blocks is 88, should be 0.  Fix? no
> 
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  -(8231--8232) -(32770--32778)
> Fix? no
> 
> Now actually the end_blk can be any value which is less than
> u32, so make end_blk be the maximum value of u32.
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
> lib/ext2fs/extent.c |    4 +---
> 1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
> index eb096d6..e2815c2 100644
> --- a/lib/ext2fs/extent.c
> +++ b/lib/ext2fs/extent.c
> @@ -253,9 +253,7 @@ extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
> 		ext2fs_le16_to_cpu(eh->eh_entries);
> 	handle->path[0].max_entries = ext2fs_le16_to_cpu(eh->eh_max);
> 	handle->path[0].curr = 0;
> -	handle->path[0].end_blk =
> -		(EXT2_I_SIZE(handle->inode) + fs->blocksize - 1) >>
> -		 EXT2_BLOCK_SIZE_BITS(fs->super);
> +	handle->path[0].end_blk = ((((unsigned long long) 1) << 32) - 1);
> 	handle->path[0].visit_num = 1;
> 	handle->level = 0;
> 	handle->magic = EXT2_ET_MAGIC_EXTENT_HANDLE;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





