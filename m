Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F66C4360F
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 11:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81DC62084F
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 11:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfCRLLA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 07:11:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:46580 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbfCRLK7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Mar 2019 07:10:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 91D60AE25;
        Mon, 18 Mar 2019 11:10:57 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E357C1E425D; Mon, 18 Mar 2019 12:10:56 +0100 (CET)
Date:   Mon, 18 Mar 2019 12:10:56 +0100
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
Subject: Re: [PATCH v2 2/2] ext4: cleanup bh release code in
 ext4_ind_remove_space()
Message-ID: <20190318111056.GF9415@quack2.suse.cz>
References: <1552633813-42832-1-git-send-email-yi.zhang@huawei.com>
 <1552633813-42832-3-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552633813-42832-3-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 15-03-19 15:10:13, zhangyi (F) wrote:
> Currently, we are releasing the indirect buffer where we are done with
> it in ext4_ind_remove_space(), so we can see the brelse() and
> BUFFER_TRACE() everywhere. It seems fragile and hard to read, and we
> may probably forget to release the buffer some day. This patch do some
> cleanup stuff, put all the releasing code together to the end of this
> function.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

OK, now when the cleanup is separate, I actually like it. So feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/indirect.c | 47 ++++++++++++++++++++++-------------------------
>  1 file changed, 22 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 9e96a0b..e1801b2 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -1219,6 +1219,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  	ext4_lblk_t offsets[4], offsets2[4];
>  	Indirect chain[4], chain2[4];
>  	Indirect *partial, *partial2;
> +	Indirect *p = NULL, *p2 = NULL;
>  	ext4_lblk_t max_block;
>  	__le32 nr = 0, nr2 = 0;
>  	int n = 0, n2 = 0;
> @@ -1260,7 +1261,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  		}
>  
>  
> -		partial = ext4_find_shared(inode, n, offsets, chain, &nr);
> +		partial = p = ext4_find_shared(inode, n, offsets, chain, &nr);
>  		if (nr) {
>  			if (partial == chain) {
>  				/* Shared branch grows from the inode */
> @@ -1285,13 +1286,11 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  				partial->p + 1,
>  				(__le32 *)partial->bh->b_data+addr_per_block,
>  				(chain+n-1) - partial);
> -			BUFFER_TRACE(partial->bh, "call brelse");
> -			brelse(partial->bh);
>  			partial--;
>  		}
>  
>  end_range:
> -		partial2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
> +		partial2 = p2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
>  		if (nr2) {
>  			if (partial2 == chain2) {
>  				/*
> @@ -1321,16 +1320,14 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  					   (__le32 *)partial2->bh->b_data,
>  					   partial2->p,
>  					   (chain2+n2-1) - partial2);
> -			BUFFER_TRACE(partial2->bh, "call brelse");
> -			brelse(partial2->bh);
>  			partial2--;
>  		}
>  		goto do_indirects;
>  	}
>  
>  	/* Punch happened within the same level (n == n2) */
> -	partial = ext4_find_shared(inode, n, offsets, chain, &nr);
> -	partial2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
> +	partial = p = ext4_find_shared(inode, n, offsets, chain, &nr);
> +	partial2 = p2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
>  
>  	/* Free top, but only if partial2 isn't its subtree. */
>  	if (nr) {
> @@ -1387,15 +1384,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  					   partial->p + 1,
>  					   partial2->p,
>  					   (chain+n-1) - partial);
> -			while (partial > chain) {
> -				BUFFER_TRACE(partial->bh, "call brelse");
> -				brelse(partial->bh);
> -			}
> -			while (partial2 > chain2) {
> -				BUFFER_TRACE(partial2->bh, "call brelse");
> -				brelse(partial2->bh);
> -			}
> -			return 0;
> +			goto cleanup;
>  		}
>  
>  		/*
> @@ -1410,8 +1399,6 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  					   partial->p + 1,
>  					   (__le32 *)partial->bh->b_data+addr_per_block,
>  					   (chain+n-1) - partial);
> -			BUFFER_TRACE(partial->bh, "call brelse");
> -			brelse(partial->bh);
>  			partial--;
>  		}
>  		if (partial2 > chain2 && depth2 <= depth) {
> @@ -1419,11 +1406,21 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  					   (__le32 *)partial2->bh->b_data,
>  					   partial2->p,
>  					   (chain2+n2-1) - partial2);
> -			BUFFER_TRACE(partial2->bh, "call brelse");
> -			brelse(partial2->bh);
>  			partial2--;
>  		}
>  	}
> +
> +cleanup:
> +	while (p && p > chain) {
> +		BUFFER_TRACE(p->bh, "call brelse");
> +		brelse(p->bh);
> +		p--;
> +	}
> +	while (p2 && p2 > chain2) {
> +		BUFFER_TRACE(p2->bh, "call brelse");
> +		brelse(p2->bh);
> +		p2--;
> +	}
>  	return 0;
>  
>  do_indirects:
> @@ -1431,7 +1428,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  	switch (offsets[0]) {
>  	default:
>  		if (++n >= n2)
> -			return 0;
> +			break;
>  		nr = i_data[EXT4_IND_BLOCK];
>  		if (nr) {
>  			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 1);
> @@ -1439,7 +1436,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  		}
>  	case EXT4_IND_BLOCK:
>  		if (++n >= n2)
> -			return 0;
> +			break;
>  		nr = i_data[EXT4_DIND_BLOCK];
>  		if (nr) {
>  			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 2);
> @@ -1447,7 +1444,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  		}
>  	case EXT4_DIND_BLOCK:
>  		if (++n >= n2)
> -			return 0;
> +			break;
>  		nr = i_data[EXT4_TIND_BLOCK];
>  		if (nr) {
>  			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 3);
> @@ -1456,5 +1453,5 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  	case EXT4_TIND_BLOCK:
>  		;
>  	}
> -	return 0;
> +	goto cleanup;
>  }
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
