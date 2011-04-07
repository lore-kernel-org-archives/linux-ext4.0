From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Allow indirect-block file to grow the file size
 to max file size
Date: Thu, 07 Apr 2011 11:24:30 -0700
Message-ID: <4D9E015E.5010009@redhat.com>
References: <4D143B0D.2030302@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab1DGSYg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Apr 2011 14:24:36 -0400
In-Reply-To: <4D143B0D.2030302@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/23/10 10:17 PM, Kazuya Mio wrote:
> Hi,
> 
> We can create 4402345721856 byte file with indirect block mapping.
> However, if we grow an indirect-block file to the size with ftruncate(),
> we can see the ext4 warning. The following patch fixes this problem.

Ted, ping^2 on this one?

-Eric

> How to reproduce:
> # dd if=/dev/zero of=/mnt/mp1/hoge bs=1 count=0 seek=4402345721856
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.000221428 s, 0.0 kB/s
> # tail -n 1 /var/log/messages
> Nov 25 15:10:27 test kernel: EXT4-fs warning (device sda8): ext4_block_to_path:345: block 1074791436 > max in inode 12
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> ---
>  fs/ext4/inode.c |   23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 05a0790..c429753 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4677,8 +4677,8 @@ void ext4_truncate(struct inode *inode)
>  	Indirect chain[4];
>  	Indirect *partial;
>  	__le32 nr = 0;
> -	int n;
> -	ext4_lblk_t last_block;
> +	int n = 0;
> +	ext4_lblk_t last_block, max_block;
>  	unsigned blocksize = inode->i_sb->s_blocksize;
>  
>  	if (!ext4_can_truncate(inode))
> @@ -4700,14 +4700,18 @@ void ext4_truncate(struct inode *inode)
>  
>  	last_block = (inode->i_size + blocksize-1)
>  					>> EXT4_BLOCK_SIZE_BITS(inode->i_sb);
> +	max_block = (EXT4_SB(inode->i_sb)->s_bitmap_maxbytes + blocksize-1)
> +					>> EXT4_BLOCK_SIZE_BITS(inode->i_sb);
>  
>  	if (inode->i_size & (blocksize - 1))
>  		if (ext4_block_truncate_page(handle, mapping, inode->i_size))
>  			goto out_stop;
>  
> -	n = ext4_block_to_path(inode, last_block, offsets, NULL);
> -	if (n == 0)
> -		goto out_stop;	/* error */
> +	if (last_block != max_block) {
> +		n = ext4_block_to_path(inode, last_block, offsets, NULL);
> +		if (n == 0)
> +			goto out_stop;	/* error */
> +	}
>  
>  	/*
>  	 * OK.  This truncate is going to happen.  We add the inode to the
> @@ -4738,7 +4742,13 @@ void ext4_truncate(struct inode *inode)
>  	 */
>  	ei->i_disksize = inode->i_size;
>  
> -	if (n == 1) {		/* direct blocks */
> +	if (last_block == max_block) {
> +		/*
> +		 * It is unnecessary to free any data blocks if last_block is
> +		 * equal to the indirect block limit.
> +		 */
> +		goto out_unlock;
> +	} else if (n == 1) {		/* direct blocks */
>  		ext4_free_data(handle, inode, NULL, i_data+offsets[0],
>  			       i_data + EXT4_NDIR_BLOCKS);
>  		goto do_indirects;
> @@ -4798,6 +4808,7 @@ do_indirects:
>  		;
>  	}
>  
> +out_unlock:
>  	up_write(&ei->i_data_sem);
>  	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
>  	ext4_mark_inode_dirty(handle, inode);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

