Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD442BEC55
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 13:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783603736; cv=none; b=Qst35wsc83UqVzvt4Y3yAHEIBt4Fv78DlxmccFfI8GwDCpHQyBEzbu74amc33Ja/tT5cyPIa7w5B2EhvQyvimFWg9ZST6PjV3I7fw/8t+TN94u1m+7a/M8Itqna8UAPULarcN1tZJd0T6DTsNnaJ4+N4aLkj8886/vHLGC8FzRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783603736; c=relaxed/simple;
	bh=p1K1mcNSqjbT22KEGbfpP9NhoutYWbpLG0WJeLPtfA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GtXWs+QNxTqK75VSwa5gGGsVSTMpab/f9S34Co2C1BcezVQkoDtbBQq7N1BfB92otbLM6UTSjF4SS961QIJRnCUTIiiJR75Ps1Vj9SmZLKqqQ0qNqZmNZKoyiq1wZ0xLv2RdxB4YgwOgAySm1nd3v8/Qsg1mflpwS51nonOdfME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0eogvIeT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kmQwIFNU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0eogvIeT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kmQwIFNU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0eogvIeT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kmQwIFNU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0eogvIeT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kmQwIFNU"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0C50175F59;
	Thu,  9 Jul 2026 13:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783603733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NaoZYFQ3Y831ClcXXqeoGt2tr/cXFsCrqSj3Sfpbg0E=;
	b=0eogvIeTEidTeluvE39x07DbB0hd0fMPN314wh3VzuITO8vQamV7YRRPW+b98qbVWN6hsH
	jQFoZLSvgML2jfct4O9wY0nH3WQ3jwt/eooapnS3VaYuEpaMkGIyqEjhsYTayjXrKmc7iw
	NHDd+TR4+eRDiq5glDE5hzcaIETWnGc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783603733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NaoZYFQ3Y831ClcXXqeoGt2tr/cXFsCrqSj3Sfpbg0E=;
	b=kmQwIFNUNrJ4ICq8sevZIbHxIZty26WKI1KfFFs/uA7hFJK5WSdrlvtBQGJXE4Z3jVOrhT
	X6P1tGcDml4o09Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783603733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NaoZYFQ3Y831ClcXXqeoGt2tr/cXFsCrqSj3Sfpbg0E=;
	b=0eogvIeTEidTeluvE39x07DbB0hd0fMPN314wh3VzuITO8vQamV7YRRPW+b98qbVWN6hsH
	jQFoZLSvgML2jfct4O9wY0nH3WQ3jwt/eooapnS3VaYuEpaMkGIyqEjhsYTayjXrKmc7iw
	NHDd+TR4+eRDiq5glDE5hzcaIETWnGc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783603733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NaoZYFQ3Y831ClcXXqeoGt2tr/cXFsCrqSj3Sfpbg0E=;
	b=kmQwIFNUNrJ4ICq8sevZIbHxIZty26WKI1KfFFs/uA7hFJK5WSdrlvtBQGJXE4Z3jVOrhT
	X6P1tGcDml4o09Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02E77779AA;
	Thu,  9 Jul 2026 13:28:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uJKzABWiT2qUMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Jul 2026 13:28:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B58CAA12D7; Thu, 09 Jul 2026 15:28:52 +0200 (CEST)
Date: Thu, 9 Jul 2026 15:28:52 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 9/9] ext4: protect WRITE_ZEROES written extents with
 orphan list
Message-ID: <gygyxxz56znv4eyzv7j4m6lumwotanjayu5ruuggndmeoqrsvb@vevjrmizsvxr>
References: <20260708062049.1982410-1-yi.zhang@huaweicloud.com>
 <20260708062049.1982410-10-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708062049.1982410-10-yi.zhang@huaweicloud.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	URIBL_BLOCKED(0.00)[suse.cz:email,huawei.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,huawei.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Wed 08-07-26 14:20:49, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In ext4_alloc_file_blocks(), the WRITE_ZEROES path converts unwritten
> extents to written in one transaction while i_disksize is updated to
> cover them only in a later transaction. A crash in between leaves
> written extents beyond i_disksize on disk, which fsck will complain
> about this.
> 
> Add the inode to the orphan list in the same handle that does the
> conversion, and remove it once i_disksize has caught up. Fold
> ext4_convert_unwritten_extents() into the same handle so the orphan
> add and the conversion are atomic. Also add a check before conversion
> to ensure the conversion does not extend beyond the end of the file.
> 
> Reported-by: Jan Kara <jack@suse.cz>
> Closes: https://lore.kernel.org/linux-ext4/3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt/
> Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 45 +++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 39 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index c083703bf704..9a1b06c8dd97 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4585,6 +4585,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  	loff_t epos = 0, old_size = i_size_read(inode);
>  	unsigned int blkbits = inode->i_blkbits;
>  	bool alloc_zero = false;
> +	bool orphan = false;
>  
>  	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
>  	map.m_lblk = offset >> blkbits;
> @@ -4659,12 +4660,35 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  
>  		if (alloc_zero &&
>  		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
> +			WARN_ON_ONCE(map.m_lblk + map.m_len >
> +				EXT4_B_TO_LBLK(inode, new_size ?: old_size));
> +
>  			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
>  						 map.m_len);
> -			if (likely(!ret))
> -				ret = ext4_convert_unwritten_extents(NULL,
> +			if (unlikely(ret))
> +				break;
> +
> +			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
> +						    credits);
> +			if (IS_ERR(handle)) {
> +				ret = PTR_ERR(handle);
> +				break;
> +			}
> +
> +			if (new_size) {
> +				ret = ext4_orphan_add(handle, inode);
> +				orphan = true;
> +				if (ret) {
> +					ext4_journal_stop(handle);
> +					break;
> +				}
> +			}
> +
> +			ret = ext4_convert_unwritten_extents(handle,
>  					inode, (loff_t)map.m_lblk << blkbits,
>  					(loff_t)map.m_len << blkbits);
> +			ret2 = ext4_journal_stop(handle);
> +			ret = ret ? ret : ret2;
>  			if (ret)
>  				break;
>  		}
> @@ -4678,7 +4702,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  		goto retry;
>  
>  	if (!epos || !new_size)
> -		return ret;
> +		goto out;
>  
>  	/*
>  	 * Allocate blocks, update the file size to match the size of the
> @@ -4687,12 +4711,16 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  	if (epos > new_size)
>  		epos = new_size;
>  
> -	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> -	if (IS_ERR(handle))
> -		return ret ? ret : PTR_ERR(handle);
> +	handle = ext4_journal_start(inode, EXT4_HT_MISC, 2);
> +	if (IS_ERR(handle)) {
> +		ret = ret ? ret : PTR_ERR(handle);
> +		goto out;
> +	}
>  
>  	ext4_update_inode_size(inode, epos);
>  	ret2 = ext4_mark_inode_dirty(handle, inode);
> +	if (orphan && inode->i_nlink)
> +		ext4_orphan_del(handle, inode);
>  	ext4_update_inode_fsync_trans(handle, inode, 1);
>  	ret3 = ext4_journal_stop(handle);
>  	ret2 = ret3 ? ret3 : ret2;
> @@ -4701,6 +4729,11 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  		pagecache_isize_extended(inode, old_size, epos);
>  
>  	return ret ? ret : ret2;
> +
> +out:
> +	if (orphan && inode->i_nlink)
> +		ext4_orphan_del(NULL, inode);
> +	return ret;
>  }
>  
>  static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
