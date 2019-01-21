Return-Path: <SRS0=MuWy=P5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A74C2F441
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 16:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FB3B20663
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 16:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbfAUQzv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Jan 2019 11:55:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:50844 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730085AbfAUQzu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Jan 2019 11:55:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A87FEAE1D;
        Mon, 21 Jan 2019 16:55:48 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B79561E1584; Mon, 21 Jan 2019 17:55:47 +0100 (CET)
Date:   Mon, 21 Jan 2019 17:55:47 +0100
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
Subject: Re: [PATCH v2 2/2] ext4: fix unsafe extent initialization
Message-ID: <20190121165547.GD21694@quack2.suse.cz>
References: <1545141822-3082-1-git-send-email-yi.zhang@huawei.com>
 <1545141822-3082-3-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545141822-3082-3-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 18-12-18 22:03:42, zhangyi (F) wrote:
> Current ext4 will call ext4_ext_convert_to_initialized() to split and
> initialize an unwritten extent if someone write something to it. It
> may also zeroout the nearby blocks and expand the split range if the
> allocated extent is smaller than the max zeroout threshold and fully
> inside i_size or new_size. But it may lead to inode inconsistency
> when system crash or the power fails for the below case.
> 
>  - Create an empty file and buffer write from block A to D (with delay
>    allocate).
>  - Buffer write from X to Z, now the i_size of this inode is updated
>    to Z.
>  - Zero range from part of block B to D, it will allocate an unwritten
>    extent from B to D. Note that it also will skip disksize update in
>    ext4_zero_range() -> ext4_update_disksize_before_punch() because
>    the i_size is large than the end of this zero range.
>  - The write-back kworker write block B and initialize the whole
>    unwritten extent from B to D, and then update the i_disksize to the
>    end of B.
>  - ext4_journal_stop()
>  - kjournald2 process weakup and call jbd2_journal_commit_transaction()
>    to commit journal and send FUA.
>  - System crash.
>  - System reboot and fsck complain about the extent size exceeds the
>    inode size.
> 
> So it's not safe enough only checking i_size and new_size, we should
> also take care of the i_disksize. This patch add checking i_disksize
> and updating i_disksize when zeroout the tail of the allocated extent
> to avoid this problem.
> 
> ---------------------
> 
> This problem can reproduce by xfstests generic/482 with fsstress seed
> -s 1544025012.
> 
> Fsck output:
> 
> fsck from util-linux 2.23.2
> e2fsck 1.42.9 (28-Dec-2013)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 15, end of extent exceeds allowed value
>         (logical block 294, physical block 34028, len 3)
> Clear? no
> 
> Inode 15, i_blocks is 3784, should be 3760.  Fix? no
> 
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  -(34028--34030)
> Fix? no
> 
> And the size of inode 15 is 0x127000, the extent tree is:
> 
> Level Entries       Logical          Physical Length Flags
>  1/ 1   1/  8    14 -    38   36110 -   36134     25
>  1/ 1   2/  8   128 -   137   34688 -   34697     10
>  1/ 1   3/  8   219 -   231   36305 -   36317     13
>  1/ 1   4/  8   284 -   293   36370 -   36379     10
>  1/ 1   5/  8   294 -   296   34028 -   34030      3
>  1/ 1   6/  8   297 -   511   35182 -   35396    215 Uninit
>  1/ 1   7/  8   512 -   523   34096 -   34107     12 Uninit
>  1/ 1   8/  8   630 -   813   35746 -   35929    184 Uninit
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Thanks for debugging this! The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

I just have to say that this i_disksize updating is really fragile and we
really need to consider how to clean that up because otherwise we are
likely do create similar bugs in the future again. But that's a separate
cleanup.

								Honza

> ---
>  fs/ext4/extents.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0307fc6..a054f51 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3472,6 +3472,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	struct ext4_map_blocks split_map;
>  	struct ext4_extent zero_ex1, zero_ex2;
>  	struct ext4_extent *ex, *abut_ex;
> +	loff_t i_size, new_size;
>  	ext4_lblk_t ee_block, eof_block;
>  	unsigned int ee_len, depth, map_len = map->m_len;
>  	int allocated = 0, max_zeroout = 0;
> @@ -3483,7 +3484,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		(unsigned long long)map->m_lblk, map_len);
>  
>  	sbi = EXT4_SB(inode->i_sb);
> -	eof_block = (i_size_read(inode) + inode->i_sb->s_blocksize - 1) >>
> +	i_size = i_size_read(inode);
> +	eof_block = (i_size + inode->i_sb->s_blocksize - 1) >>
>  		inode->i_sb->s_blocksize_bits;
>  	if (eof_block < map->m_lblk + map_len)
>  		eof_block = map->m_lblk + map_len;
> @@ -3663,6 +3665,24 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  			if (err)
>  				goto out;
>  			split_map.m_len = allocated;
> +
> +			/*
> +			 * Update the i_disksize if zeroout the tail of
> +			 * the second extent. Otherwise i_disksize update
> +			 * can be lost as the region may have been marked
> +			 * unwritten before writing back.
> +			 */
> +			new_size = ((loff_t)(split_map.m_lblk +
> +					     split_map.m_len)) <<
> +					     PAGE_SHIFT;
> +			if (new_size > i_size)
> +				new_size = i_size;
> +			if (new_size > EXT4_I(inode)->i_disksize) {
> +				EXT4_I(inode)->i_disksize = new_size;
> +				err = ext4_mark_inode_dirty(handle, inode);
> +				if (err)
> +					goto out;
> +			}
>  		}
>  		if (split_map.m_lblk - ee_block + split_map.m_len <
>  								max_zeroout) {
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
