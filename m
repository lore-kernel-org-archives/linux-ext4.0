From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] ext4: Use both hi and lo bits of the group desc
	values.
Date: Fri, 21 Nov 2008 00:14:32 +0530
Message-ID: <20081120184432.GB11212@skywalker>
References: <1227205580-27596-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227205580-27596-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227205580-27596-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:59663 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYKTSsc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Nov 2008 13:48:32 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mAKIlfT3007620
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:47:41 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAKIiiA3099412
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:44:45 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAKIii5I004848
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:44:44 +1100
Content-Disposition: inline
In-Reply-To: <1227205580-27596-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 20, 2008 at 11:56:20PM +0530, Aneesh Kumar K.V wrote:
> Rename the lower bits with suffix _lo and add helper
> to access the values. Also rename bg_itable_unused_hi
> to bg_pad as in e2fsprogs. bg_itable_unused_hi is never
> used before
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/balloc.c  |   11 ++++---
>  fs/ext4/ext4.h    |   24 +++++++++++++--
>  fs/ext4/ialloc.c  |   83 ++++++++++++++++++++++++++++-------------------------
>  fs/ext4/inode.c   |    2 +-
>  fs/ext4/mballoc.c |   15 +++++----
>  fs/ext4/resize.c  |    4 +-
>  fs/ext4/super.c   |   64 +++++++++++++++++++++++++++++++++++++++-
>  7 files changed, 143 insertions(+), 60 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index d268f5f..efe68d9 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -102,9 +102,9 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
>  		if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
>  			ext4_error(sb, __func__,
>  				  "Checksum bad for group %u\n", block_group);
> -			gdp->bg_free_blocks_count = 0;
> -			gdp->bg_free_inodes_count = 0;
> -			gdp->bg_itable_unused = 0;
> +			ext4_free_blks_set(sb, gdp, 0);
> +			ext4_free_inodes_set(sb, gdp, 0);
> +			ext4_itable_unused_set(sb, gdp, 0);
>  			memset(bh->b_data, 0xff, sb->s_blocksize);
>  			return 0;
>  		}
> @@ -444,7 +444,8 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
>  		}
>  	}
>  	spin_lock(sb_bgl_lock(sbi, block_group));
> -	le16_add_cpu(&desc->bg_free_blocks_count, blocks_freed);
> +	blocks_freed += ext4_free_blks_count(sb, desc);
> +	ext4_free_blks_set(sb, desc, blocks_freed);
>  	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
>  	spin_unlock(sb_bgl_lock(sbi, block_group));
>  	percpu_counter_add(&sbi->s_freeblocks_counter, blocks_freed);
> @@ -742,7 +743,7 @@ ext4_fsblk_t ext4_count_free_blocks(struct super_block *sb)
>  		gdp = ext4_get_group_desc(sb, i, NULL);
>  		if (!gdp)
>  			continue;
> -		desc_count += le16_to_cpu(gdp->bg_free_blocks_count);
> +		desc_count += ext4_free_blks_count(sb, gdp);
>  	}
> 

blocks_freed is used later so use count;

@@ -372,7 +372,7 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	struct ext4_group_desc *desc;
 	struct ext4_super_block *es;
 	struct ext4_sb_info *sbi;
-	int err = 0, ret;
+	int err = 0, ret, count;
 	ext4_grpblk_t blocks_freed;
 	struct ext4_group_info *grp;
 
@@ -444,7 +444,8 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 		}
 	}
 	spin_lock(sb_bgl_lock(sbi, block_group));
-	le16_add_cpu(&desc->bg_free_blocks_count, blocks_freed);
+	count = blocks_freed + ext4_free_blks_count(sb, desc);
+	ext4_free_blks_set(sb, desc, count);
 	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_add(&sbi->s_freeblocks_counter, blocks_freed);

