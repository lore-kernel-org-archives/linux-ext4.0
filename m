Return-Path: <SRS0=JALT=N2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34596 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387833AbeKPCel (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Nov 2018 21:34:41 -0500
Date: Thu, 15 Nov 2018 17:26:10 +0100
From: Jan Kara <jack@suse.cz>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: change reusable parameter to true when calling
 mb_cache_entry_create()
Message-ID: <20181115162610.GA12786@quack2.suse.cz>
References: <20181115064008.21056-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115064008.21056-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 15-11-18 14:40:08, Chengguang Xu wrote:
> Reusable parameter of mb_cache_entry_create() is bool type,
> so it's better to set true instead of 1.
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>

Applied after fixing the whitespace damage. Thanks.

								Honza

> ---
>  fs/ext2/xattr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 62d9a659a8ff..6bab2432b717 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -835,7 +835,8 @@ ext2_xattr_cache_insert(struct mb_cache *cache, struct buffer_head *bh)
>  	__u32 hash = le32_to_cpu(HDR(bh)->h_hash);
>  	int error;
>  
> -	error = mb_cache_entry_create(cache, GFP_NOFS, hash, bh->b_blocknr, 1);
> +	error = mb_cache_entry_create(cache, GFP_NOFS, hash,
> +					bh->b_blocknr,true);
>  	if (error) {
>  		if (error == -EBUSY) {
>  			ea_bdebug(bh, "already in cache (%d cache entries)",
> -- 
> 2.17.2
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
