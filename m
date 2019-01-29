Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEEAC169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 16:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E5FF214DA
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 16:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfA2QmM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 11:42:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:34442 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726374AbfA2QmL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Jan 2019 11:42:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B7003B169;
        Tue, 29 Jan 2019 16:42:08 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3BD161E3FFD; Tue, 29 Jan 2019 17:42:08 +0100 (CET)
Date:   Tue, 29 Jan 2019 17:42:08 +0100
From:   Jan Kara <jack@suse.cz>
To:     yangerkun <yangerkun@huawei.com>
Cc:     jack@suse.cz, miaoxie@huawei.com, yi.zhang@huawei.com,
        houtao1@huawei.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/2] ext2: get the exact max filesize in ext2_max_size
Message-ID: <20190129164208.GF29981@quack2.suse.cz>
References: <20190123131409.126156-1-yangerkun@huawei.com>
 <20190123131409.126156-3-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20190123131409.126156-3-yangerkun@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 23-01-19 21:14:09, yangerkun wrote:
> When mkfs.ext2 with '-b 65536' and mount(arm 64KB page size), function
> mount_fs will trigger WARNING since ext2_max_size will return value less
> than 0. Also, we cannot write any file in this fs since the sb->maxbytes
> is less than 0.
> 
> Fix it by get the exact max file size. First, get the max depth for
> indirect blocks and check does the max data blocks add indirect blocks
> will execced upper_limit. If right, bisect to get exact data blocks
> number which satisfy 'data blocks number + indirect blocks number ==
> upper_limit'.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>

Thanks for the patches but I was really looking for something simpler.
Something like the attached patch. Although your more precise function will
raise the maximum file size by couple of kilobytes I don't think the
complexity is really worth it...

								Honza

> ---
>  fs/ext2/super.c | 115 ++++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 92 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 73b2d52..b3eb6e9 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -753,11 +753,16 @@ static int ext2_check_descriptors(struct super_block *sb)
>   * block limit, and also a limit of (2^32 - 1) 512-byte sectors in i_blocks.
>   * We need to be 1 filesystem block less than the 2^32 sector limit.
>   */
> -static loff_t ext2_max_size(int bits)
> +static loff_t ext2_max_size(struct super_block *sb, int bits)
>  {
> -	loff_t res = EXT2_NDIR_BLOCKS;
> -	int meta_blocks;
> +	loff_t res;
> +	loff_t max_meta_blocks;
> +	loff_t used_data_blocks;
> +	loff_t max_data_blocks;
>  	loff_t upper_limit;
> +	int depth;
> +	loff_t high, low;
> +
>  
>  	/* This is calculated to be the largest file size for a
>  	 * dense, file such that the total number of
> @@ -771,24 +776,88 @@ static loff_t ext2_max_size(int bits)
>  	/* total blocks in file system block size */
>  	upper_limit >>= (bits - 9);
>  
> +	/* Try to get max depth of metadata blocks */
> +	depth = 0;
> +	max_meta_blocks = 0;
> +	used_data_blocks = 0;
> +	max_data_blocks = EXT2_NDIR_BLOCKS;
> +	if (max_meta_blocks + max_data_blocks > upper_limit)
> +		goto bisect;
> +
> +	depth++;
> +	max_meta_blocks = 1;
> +	used_data_blocks = max_data_blocks;
> +	max_data_blocks += 1LL << (bits - 2);
> +	if (max_meta_blocks + max_data_blocks > upper_limit)
> +		goto bisect;
> +
> +	depth++;
> +	max_meta_blocks += 1 + (1LL << (bits - 2));
> +	used_data_blocks = max_data_blocks;
> +	max_data_blocks += 1LL << (2 * (bits - 2));
> +	if (max_meta_blocks + max_data_blocks > upper_limit)
> +		goto bisect;
> +
> +	depth++;
> +	max_meta_blocks += 1 + (1LL << (bits - 2)) + (1LL << (2 * (bits - 2)));
> +	used_data_blocks = max_data_blocks;
> +	max_data_blocks += 1LL << (3 * (bits - 2));
> +	if (max_meta_blocks + max_data_blocks > upper_limit)
> +		goto bisect;
> +
> +	goto out;
> +bisect:
> +	low = 0;
> +	if (depth == 0)
> +		high = EXT2_NDIR_BLOCKS;
> +	else
> +		high = 1 << (depth * (bits - 2));
> +	while (low <= high) {
> +		int offsets[4];
> +		loff_t mid = (low + high) >> 1;
> +		depth = ext2_block_to_path(sb, mid + used_data_blocks - 1, offsets, NULL);
> +		if (!depth)
> +			return -EIO;
> +
> +		max_meta_blocks = 0;
> +		if (depth == 1)
> +			max_meta_blocks = 0;
> +
> +		if (depth == 2)
> +			max_meta_blocks = 1;
> +
> +		if (depth == 3) {
> +			/* Indirect blocks */
> +			max_meta_blocks += 1;
> +			/* Double indirect blocks */
> +			max_meta_blocks += 1;
> +			max_meta_blocks += offsets[1];
> +		}
>  
> -	/* indirect blocks */
> -	meta_blocks = 1;
> -	/* double indirect blocks */
> -	meta_blocks += 1 + (1LL << (bits-2));
> -	/* tripple indirect blocks */
> -	meta_blocks += 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));
> -
> -	upper_limit -= meta_blocks;
> -	upper_limit <<= bits;
> -
> -	res += 1LL << (bits-2);
> -	res += 1LL << (2*(bits-2));
> -	res += 1LL << (3*(bits-2));
> -	res <<= bits;
> -	if (res > upper_limit)
> -		res = upper_limit;
> -
> +		if (depth == 4) {
> +			/* Indirect blocks */
> +			max_meta_blocks += 1;
> +			/* Double indirect blocks */
> +			max_meta_blocks += 1 + (1 << (bits - 2));
> +			/* Tripple indirect blocks */
> +			max_meta_blocks += 1;
> +			if (offsets[1])
> +				max_meta_blocks += (offsets[1] - 1) * (1 << (bits - 2));
> +
> +			max_meta_blocks += 1;
> +			max_meta_blocks += offsets[2];
> +		}
> +		if (max_meta_blocks + mid + used_data_blocks > upper_limit)
> +			high = mid - 1;
> +		if (max_meta_blocks + mid + used_data_blocks < upper_limit)
> +			low = mid + 1;
> +		if (max_meta_blocks + mid + used_data_blocks == upper_limit) {
> +			max_data_blocks = mid + used_data_blocks;
> +			break;
> +		}
> +	}
> +out:
> +	res = max_data_blocks << bits;
>  	if (res > MAX_LFS_FILESIZE)
>  		res = MAX_LFS_FILESIZE;
>  
> @@ -995,7 +1064,9 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  		}
>  	}
>  
> -	sb->s_maxbytes = ext2_max_size(sb->s_blocksize_bits);
> +	sbi->s_addr_per_block_bits =
> +		ilog2 (EXT2_ADDR_PER_BLOCK(sb));
> +	sb->s_maxbytes = ext2_max_size(sb, sb->s_blocksize_bits);
>  	sb->s_max_links = EXT2_LINK_MAX;
>  
>  	if (le32_to_cpu(es->s_rev_level) == EXT2_GOOD_OLD_REV) {
> @@ -1035,8 +1106,6 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  					sizeof (struct ext2_group_desc);
>  	sbi->s_sbh = bh;
>  	sbi->s_mount_state = le16_to_cpu(es->s_state);
> -	sbi->s_addr_per_block_bits =
> -		ilog2 (EXT2_ADDR_PER_BLOCK(sb));
>  	sbi->s_desc_per_block_bits =
>  		ilog2 (EXT2_DESC_PER_BLOCK(sb));
>  
> -- 
> 2.9.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--IS0zKkzwUGydFO0o
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext2-Fix-underflow-in-ext2_max_size.patch"

From a06dc132deae0c0f9b7cb681940ba1e0b40b40dc Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 29 Jan 2019 17:17:24 +0100
Subject: [PATCH] ext2: Fix underflow in ext2_max_size()

When ext2 filesystem is created with 64k block size, ext2_max_size()
will return value less than 0. Also, we cannot write any file in this fs
since the sb->maxbytes is less than 0. The core of the problem is that
the size of block index tree for such large block size is more than
i_blocks can carry. So fix the computation to count with this
possibility.

File size limits computed with the new function for the full range of
possible block sizes look like:

bits file_size
10     17247252480
11    275415851008
12   2196873666560
13   2197948973056
14   2198486220800
15   2198754689024
16   2198888775680

Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/super.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 73b2d528237f..5cc04a2a78a1 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -758,6 +758,7 @@ static loff_t ext2_max_size(int bits)
 	loff_t res = EXT2_NDIR_BLOCKS;
 	int meta_blocks;
 	loff_t upper_limit;
+	unsigned int ppb = 1 << (bits-2);
 
 	/* This is calculated to be the largest file size for a
 	 * dense, file such that the total number of
@@ -771,24 +772,29 @@ static loff_t ext2_max_size(int bits)
 	/* total blocks in file system block size */
 	upper_limit >>= (bits - 9);
 
+	/* Compute how many blocks we can address by block tree */
+	res += 1LL << (bits-2);
+	res += 1LL << (2*(bits-2));
+	res += 1LL << (3*(bits-2));
+	/* Does block tree limit file size? */
+	if (res < upper_limit)
+		goto check_lfs;
 
+	res = upper_limit;
+	/* How many metadata blocks are needed for addressing upper_limit? */
+	upper_limit -= EXT2_NDIR_BLOCKS;
 	/* indirect blocks */
 	meta_blocks = 1;
+	upper_limit -= 1LL << (bits-2);
 	/* double indirect blocks */
 	meta_blocks += 1 + (1LL << (bits-2));
-	/* tripple indirect blocks */
-	meta_blocks += 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));
-
-	upper_limit -= meta_blocks;
-	upper_limit <<= bits;
-
-	res += 1LL << (bits-2);
-	res += 1LL << (2*(bits-2));
-	res += 1LL << (3*(bits-2));
+	upper_limit -= 1LL << (2*(bits-2));
+	/* tripple indirect blocks for the rest */
+	meta_blocks += 1 + DIV_ROUND_UP(upper_limit, ppb) +
+		DIV_ROUND_UP(upper_limit, ppb*ppb);
+	res -= meta_blocks;
+check_lfs:
 	res <<= bits;
-	if (res > upper_limit)
-		res = upper_limit;
-
 	if (res > MAX_LFS_FILESIZE)
 		res = MAX_LFS_FILESIZE;
 
-- 
2.16.4


--IS0zKkzwUGydFO0o--
