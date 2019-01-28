Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9E2C282C8
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 15:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A318920881
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 15:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfA1P0D (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:26:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:34868 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726678AbfA1P0D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Jan 2019 10:26:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DEE51AE04;
        Mon, 28 Jan 2019 15:26:00 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B9B8A1E3FEF; Mon, 28 Jan 2019 16:26:00 +0100 (CET)
Date:   Mon, 28 Jan 2019 16:26:00 +0100
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
Subject: Re: [PATCH v3 3/4] ext4: cleanup clean_bdev_aliases() calls
Message-ID: <20190128152600.GE5858@quack2.suse.cz>
References: <1548419456-4331-1-git-send-email-yi.zhang@huawei.com>
 <1548419456-4331-4-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548419456-4331-4-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 25-01-19 20:30:55, zhangyi (F) wrote:
> Now, we have already handle all cases of forgetting buffer in
> jbd2_journal_forget(), the buffer should not be mapped to blockdevice
> when reallocating it. So this patch remove all clean_bdev_aliases() and
> clean_bdev_bh_alias() calls which were invoked by ext4 explicitly.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 12 +-----------
>  fs/ext4/inode.c   |  7 -------
>  fs/ext4/page-io.c |  4 +---
>  3 files changed, 2 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index a054f51..ffb72d8 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4068,18 +4068,8 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
>  	} else
>  		allocated = ret;
>  	map->m_flags |= EXT4_MAP_NEW;
> -	/*
> -	 * if we allocated more blocks than requested
> -	 * we need to make sure we unmap the extra block
> -	 * allocated. The actual needed block will get
> -	 * unmapped later when we find the buffer_head marked
> -	 * new.
> -	 */
> -	if (allocated > map->m_len) {
> -		clean_bdev_aliases(inode->i_sb->s_bdev, newblock + map->m_len,
> -				   allocated - map->m_len);
> +	if (allocated > map->m_len)
>  		allocated = map->m_len;
> -	}
>  	map->m_len = allocated;
>  
>  map_out:
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e7adf87..3068c83 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -678,8 +678,6 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  		if (flags & EXT4_GET_BLOCKS_ZERO &&
>  		    map->m_flags & EXT4_MAP_MAPPED &&
>  		    map->m_flags & EXT4_MAP_NEW) {
> -			clean_bdev_aliases(inode->i_sb->s_bdev, map->m_pblk,
> -					   map->m_len);
>  			ret = ext4_issue_zeroout(inode, map->m_lblk,
>  						 map->m_pblk, map->m_len);
>  			if (ret) {
> @@ -1194,7 +1192,6 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
>  			if (err)
>  				break;
>  			if (buffer_new(bh)) {
> -				clean_bdev_bh_alias(bh);
>  				if (PageUptodate(page)) {
>  					clear_buffer_new(bh);
>  					set_buffer_uptodate(bh);
> @@ -2490,10 +2487,6 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
>  	}
>  
>  	BUG_ON(map->m_len == 0);
> -	if (map->m_flags & EXT4_MAP_NEW) {
> -		clean_bdev_aliases(inode->i_sb->s_bdev, map->m_pblk,
> -				   map->m_len);
> -	}
>  	return 0;
>  }
>  
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 2aa62d5..1559946 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -467,10 +467,8 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
>  				ext4_io_submit(io);
>  			continue;
>  		}
> -		if (buffer_new(bh)) {
> +		if (buffer_new(bh))
>  			clear_buffer_new(bh);
> -			clean_bdev_bh_alias(bh);
> -		}
>  		set_buffer_async_write(bh);
>  		nr_to_submit++;
>  	} while ((bh = bh->b_this_page) != head);
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
