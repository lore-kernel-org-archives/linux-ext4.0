From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Make the extent validity check more paranoid
Date: Wed, 22 Apr 2009 21:04:30 -0500
Message-ID: <49EFCCAE.6050602@redhat.com>
References: <1240450174-25868-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57583 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZDWCEe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Apr 2009 22:04:34 -0400
In-Reply-To: <1240450174-25868-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> Instead of just checking that the extent block number is greater or
> equal than s_first_data_block, make sure it it is not pointing into
> the block group descriptors, since that is clearly wrong.  This helps
> prevent filesystem from getting very badly corrupted in case an extent
> block is corrupted.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Good idea.  Maybe we can get our friends with the corrupted fs to run
with these validation patches... I can get this into rawhide at least.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/ext4/extents.c |   18 ++++++++++++------
>  1 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 6132353..c28ffe2 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -326,11 +326,14 @@ ext4_ext_max_entries(struct inode *inode, int depth)
>  
>  static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
>  {
> -	ext4_fsblk_t block = ext_pblock(ext);
> +	ext4_fsblk_t block = ext_pblock(ext), valid_block;
>  	int len = ext4_ext_get_actual_len(ext);
>  	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
> -	if (unlikely(block < le32_to_cpu(es->s_first_data_block) ||
> -			((block + len) > ext4_blocks_count(es))))
> +
> +	valid_block = le32_to_cpu(es->s_first_data_block) +
> +		EXT4_SB(inode->i_sb)->s_gdb_count;
> +	if (unlikely(block <= valid_block ||
> +		     ((block + len) > ext4_blocks_count(es))))
>  		return 0;
>  	else
>  		return 1;
> @@ -339,10 +342,13 @@ static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
>  static int ext4_valid_extent_idx(struct inode *inode,
>  				struct ext4_extent_idx *ext_idx)
>  {
> -	ext4_fsblk_t block = idx_pblock(ext_idx);
> +	ext4_fsblk_t block = idx_pblock(ext_idx), valid_block;
>  	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
> -	if (unlikely(block < le32_to_cpu(es->s_first_data_block) ||
> -			(block >= ext4_blocks_count(es))))
> +
> +	valid_block = le32_to_cpu(es->s_first_data_block) +
> +		EXT4_SB(inode->i_sb)->s_gdb_count;
> +	if (unlikely(block <= valid_block ||
> +		     (block >= ext4_blocks_count(es))))
>  		return 0;
>  	else
>  		return 1;

