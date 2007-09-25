From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/7] ext4: Introduce le32_t and le16_t
Date: Tue, 25 Sep 2007 08:56:09 -0500
Message-ID: <1190728569.28492.3.camel@norville.austin.ibm.com>
References: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com, cmm@us.ibm.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53373 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbXIYN4g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2007 09:56:36 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8PDuXEc009053
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 09:56:33 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8PDuXSK688764
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 09:56:33 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8PDuWw5027385
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 09:56:33 -0400
In-Reply-To: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-09-25 at 14:33 +0530, Aneesh Kumar K.V wrote:
> ext4 file system layout contain different split members
> like bg_block_bitmap  and bg_block_bitmap_hi. Introduce
> data type le32_t and le16_t to be used as the type of
> these split members. This prevents these members frome
> being accessed directly. Accesing them directly gives
> a compiler warning. This helps in catching some BUGS
> due to direct partial access of these split fields.

Ugh.  I don't like this typedef at all. It just makes the data type more
confusing.

Why not just change the name of bg_block_bitmap to something like
bg_block_bitmap_lo or _bg_block_bitmap?  It should be clear from the
name that it shouldn't be used without careful consideration.

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/super.c           |    8 ++++----
>  include/linux/ext4_fs.h   |    4 ++--
>  include/linux/ext4_fs_i.h |    4 ++++
>  3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index d035653..c8f8e4d 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -70,9 +70,9 @@ static void ext4_write_super_lockfs(struct super_block *sb);
>  ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
>  			       struct ext4_group_desc *bg)
>  {
> -	return le32_to_cpu(bg->bg_block_bitmap) |
> +	return le32_to_cpu(bg->bg_block_bitmap.value) |
>  		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
> -		 (ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi) << 32 : 0);
> +		 (ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi.value) << 32 : 0);
>  }
> 
>  ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
> @@ -94,9 +94,9 @@ ext4_fsblk_t ext4_inode_table(struct super_block *sb,
>  void ext4_block_bitmap_set(struct super_block *sb,
>  			   struct ext4_group_desc *bg, ext4_fsblk_t blk)
>  {
> -	bg->bg_block_bitmap = cpu_to_le32((u32)blk);
> +	bg->bg_block_bitmap.value = cpu_to_le32((u32)blk);
>  	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
> -		bg->bg_block_bitmap_hi = cpu_to_le32(blk >> 32);
> +		bg->bg_block_bitmap_hi.value = cpu_to_le32(blk >> 32);
>  }
> 
>  void ext4_inode_bitmap_set(struct super_block *sb,
> diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
> index 046a6a7..4494f8e 100644
> --- a/include/linux/ext4_fs.h
> +++ b/include/linux/ext4_fs.h
> @@ -150,7 +150,7 @@ struct ext4_allocation_request {
>   */
>  struct ext4_group_desc
>  {
> -	__le32	bg_block_bitmap;	/* Blocks bitmap block */
> +	le32_t	bg_block_bitmap;	/* Blocks bitmap block */
>  	__le32	bg_inode_bitmap;	/* Inodes bitmap block */
>  	__le32	bg_inode_table;		/* Inodes table block */
>  	__le16	bg_free_blocks_count;	/* Free blocks count */
> @@ -160,7 +160,7 @@ struct ext4_group_desc
>  	__u32	bg_reserved[2];		/* Likely block/inode bitmap checksum */
>  	__le16  bg_itable_unused;	/* Unused inodes count */
>  	__le16  bg_checksum;		/* crc16(sb_uuid+group+desc) */
> -	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
> +	le32_t	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
>  	__le32	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
>  	__le32	bg_inode_table_hi;	/* Inodes table block MSB */
>  };
> diff --git a/include/linux/ext4_fs_i.h b/include/linux/ext4_fs_i.h
> index 22ba80e..d7eb271 100644
> --- a/include/linux/ext4_fs_i.h
> +++ b/include/linux/ext4_fs_i.h
> @@ -27,6 +27,10 @@ typedef int ext4_grpblk_t;
>  /* data type for filesystem-wide blocks number */
>  typedef unsigned long long ext4_fsblk_t;
> 
> +/* data type to carry split 64 and 48 bits */
> +typedef struct { __le16 value; } le16_t;
> +typedef struct { __le32 value; } le32_t;
> +
>  struct ext4_reserve_window {
>  	ext4_fsblk_t	_rsv_start;	/* First byte reserved */
>  	ext4_fsblk_t	_rsv_end;	/* Last byte reserved or 0 */
-- 
David Kleikamp
IBM Linux Technology Center
