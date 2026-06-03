Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1F53845D9;
	Wed,  3 Jun 2026 18:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780510326; cv=none; b=otwKp2+ehJHdYxwxreItPmvpw34Bzo/KCHTi8X0m8pdz2ndKzBUlOxKrF0wxlqASyx2qo0mBfjkf0Erh5QGJnTM+p8BsLoXVvTOhR67jbmdmtdaiNcamO4u+6oXDub7EDSFQS/S8NOQCXp1TeUWa8uXOKAH/TJiJXnSrpeqNdVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780510326; c=relaxed/simple;
	bh=ydAx+UIlZHxA2cxCDnJZVLeB3M9YAYX+CiVD1fKl668=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nubME7pLJWe4a1nSxld+dS27+cD33HglljKkertW1OXbBi1nw2DvdR8Hc2CkgTuQHN4M2GbLRsPV0tiXx/sUDSebOWA9pD87gzCT6vUIDnlcl0hjsFMvgrYiTmbrOQENskzSuHzl+MMRswsGHXjxBD9Gp1eYcVAyWGXS+nXqIfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ACGOTo0Y; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ACGOTo0Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LTaDDDL84Cf14P+R0Jpd8aX+CFcEcvW5gFEjO+1GXGU=; b=ACGOTo0Yl7SBX0TiR13HxhrdAt
	6elhbtJ+gfKNy5Ivb3gc8v+ZPZwOVFRneel86f1w+WC9+Y8ksOxAfJ9kCPQsMpYUtL42xmEmuogug
	rPbooTdXZWItsYMAMt368TcLtoicbNRsuh8jnGMB3HeCv8wBkoAU+nt289bQYk7z43Gc56sK4FTbG
	dhs+qIC6kama7Nqd5hFMcv2MgQdGvGSoz9gxHvn1zvN93eq0mvt2oapYwYWfZIaNpM98J2iPUoIjd
	TphlCdFGC1Mr+D5XLwTJNyrRaEYncE7YNZHKvk+m2opJIm30lghJYt4fuTieOybLUjaVCy5d3jWxq
	J8psAsGg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wUq4C-00000004LAf-3Qiv;
	Wed, 03 Jun 2026 18:11:48 +0000
Date: Wed, 3 Jun 2026 19:11:48 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jia Zhu <zhujia.zj@bytedance.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: avoid full buffer walks for large folio partial
 writes
Message-ID: <aiBuZE5NWMfOGAA6@casper.infradead.org>
References: <20260603134800.25155-1-zhujia.zj@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603134800.25155-1-zhujia.zj@bytedance.com>

On Wed, Jun 03, 2026 at 09:48:00PM +0800, Jia Zhu wrote:
> Ext4 buffered writes into large folios still walk every buffer_head in the
> folio in ext4_block_write_begin() and again in block_commit_write(). Before
> regular files used large folios this was cheap, but a large folio can
> contain hundreds of buffer_heads. Small overwrites of an existing large
> folio therefore pay work proportional to the folio size instead of the
> write size.

Is this a common case for you, or is this something you noticed by
inspection?

> Start the ext4 write_begin walk at the first buffer that overlaps the
> write. For already-uptodate large folio overwrites, add a partial commit
> path which marks only the written buffers uptodate and dirty. Leave
> non-uptodate folios on the old full-buffer commit path so BH_New cleanup
> and folio-uptodate discovery are preserved.

Wouldn't you get just as much benefit from this?

+++ b/fs/buffer.c
@@ -2096,6 +2096,7 @@ void block_commit_write(struct folio *folio, size_t from,
size_t to)
 {
        size_t block_start, block_end;
        bool partial = false;
+       bool uptodate = folio_test_uptodate(folio);
        unsigned blocksize;
        struct buffer_head *bh, *head;

@@ -2118,6 +2119,8 @@ void block_commit_write(struct folio *folio, size_t from, size_t to)
                        clear_buffer_new(bh);

                block_start = block_end;
+               if (uptodate && block_start >= to)
+                       break;
                bh = bh->b_this_page;
        } while (bh != head);

> @@ -1191,17 +1191,18 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
>  	head = folio_buffers(folio);
>  	if (!head)
>  		head = create_empty_buffers(folio, blocksize, 0);
> -	block = EXT4_PG_TO_LBLK(inode, folio->index);
> +	if (from == to)
> +		return 0;
> +	block_start = round_down(from, blocksize);
> +	block = EXT4_PG_TO_LBLK(inode, folio->index) +
> +		(block_start >> inode->i_blkbits);
> +	bh = head;
> +	for (i = 0; i < block_start; i += blocksize)
> +		bh = bh->b_this_page;
>  
> -	for (bh = head, block_start = 0; bh != head || !block_start;
> -	    block++, block_start = block_end, bh = bh->b_this_page) {
> +	for (; block_start < to;
> +	     block++, block_start = block_end, bh = bh->b_this_page) {
>  		block_end = block_start + blocksize;
> -		if (block_end <= from || block_start >= to) {
> -			if (folio_test_uptodate(folio)) {
> -				set_buffer_uptodate(bh);
> -			}
> -			continue;
> -		}
>  		if (WARN_ON_ONCE(buffer_new(bh)))
>  			clear_buffer_new(bh);
>  		if (!buffer_mapped(bh)) {
> 

I'm unconvinced that this is safe ... but all of this is a distraction
form what we should really be doing which is converting ext4 to use
iomap instead of buffer heads.
