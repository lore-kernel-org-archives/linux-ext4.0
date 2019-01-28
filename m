Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51468C282C8
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 15:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D3C42148E
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 15:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfA1Pju (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:39:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:36762 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726266AbfA1Pju (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Jan 2019 10:39:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7B8FCAD1A;
        Mon, 28 Jan 2019 15:39:49 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 2FBBD1E3FEF; Mon, 28 Jan 2019 16:39:49 +0100 (CET)
Date:   Mon, 28 Jan 2019 16:39:49 +0100
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
Subject: Re: [PATCH v3 4/4] ext4: convert ext4_split_extent() to return
 requested length
Message-ID: <20190128153949.GG5858@quack2.suse.cz>
References: <1548419456-4331-1-git-send-email-yi.zhang@huawei.com>
 <1548419456-4331-5-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548419456-4331-5-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 25-01-19 20:30:56, zhangyi (F) wrote:
> After we remove clean_bdev_aliases() calls which used to unmap extra
> blocks in ext4_ext_handle_unwritten_extents(), return extra initialized
> region in ext4_ext_convert_to_initialized() is no longer needed, so
> in order to simplify logic, this patch convert to return the requested
> size instead.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ffb72d8..ffe9671 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3456,9 +3456,8 @@ static int ext4_split_extent(handle_t *handle,
>   *    of the logical span [map->m_lblk, map->m_lblk + map->m_len).
>   *
>   * Post-conditions on success:
> - *  - the returned value is the number of blocks beyond map->l_lblk
> - *    that are allocated and initialized.
> - *    It is guaranteed to be >= map->m_len.
> + *  - The returned value is the minimum number of requested blocks or
> + *    initialized blocks. It is guaranteed to be <= map->m_len.
>   */
>  static int ext4_ext_convert_to_initialized(handle_t *handle,
>  					   struct inode *inode,
> @@ -3700,7 +3699,6 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  
>  			split_map.m_len += split_map.m_lblk - ee_block;
>  			split_map.m_lblk = ee_block;
> -			allocated = map->m_len;
>  		}
>  	}
>  
> @@ -3709,6 +3707,9 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	if (err > 0)
>  		err = 0;
>  out:
> +	if (allocated > map->m_len)
> +		allocated = map->m_len;
> +
>  	/* If we have gotten a failure, don't zero out status tree */
>  	if (!err) {
>  		err = ext4_zeroout_es(inode, &zero_ex1);
> @@ -4065,11 +4066,10 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
>  	if (ret <= 0) {
>  		err = ret;
>  		goto out2;
> -	} else
> -		allocated = ret;
> +	}
> +
> +	allocated = ret;
>  	map->m_flags |= EXT4_MAP_NEW;
> -	if (allocated > map->m_len)
> -		allocated = map->m_len;
>  	map->m_len = allocated;
>  
>  map_out:
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
