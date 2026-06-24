Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4264F285CA4
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 11:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782300773; cv=none; b=NjQfN2iVfL6z0RfQ6cV2RKtDdTU5C6gBctrNEhDtptIsYQIigET/mAgw44myCejtPgjU9jFIwfrTBB9sZ3t7pXg9meFAPECe3C3X2iGYUVzZhdhFL4k8U7f00Ho7JrVSHA8HvdT7u9lmSlSFIT/Z9o8Gfw48uzxPGFi33WGVKrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782300773; c=relaxed/simple;
	bh=aHaWD9971cVM2vsiPrTmGyda01a87LHzoYp3m3Jrvug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/a7LL8T3EKYWD+twO7xzmLRlIDyJcRvKG5Xtv2XLS2kkcfkUYbXGIp341yESxL9LZNyk1gh6NlyTqUKLz2z5JtUmlJaoOPVcC7oVItb/p90kIg88SOJECSBQDBaZzlxT26dm40tLz6ArzOKfCfuH5m7qPWuXYe2DsSUU5AzB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KYPhvu6L; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z5LzWKIT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KYPhvu6L; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z5LzWKIT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KYPhvu6L";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z5LzWKIT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KYPhvu6L";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z5LzWKIT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 211E575BDD;
	Wed, 24 Jun 2026 11:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782300770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=29agRwTSPogDcDq96ulPkYtXy5jTSOg7J9tK00hmlTc=;
	b=KYPhvu6LNyKEgZqs3gzl13OryrZqcm+zAlDrygb+hob0skcnC6e9eA3tJUUkGi25x5Qqu+
	bbY10dQSp5M4QFYci1si0bKrTOjgjzwKnhN6t+0eH4HbWLj+Btl1mjYuqbvVldPRhCb58K
	jIbp3oNAwvtnj02hnHer5XUyppgB+Zw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782300770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=29agRwTSPogDcDq96ulPkYtXy5jTSOg7J9tK00hmlTc=;
	b=Z5LzWKIT/if9ecBH8hAzZ5Hlo/YeoRY+/IG+QXxQGHIvLMtwA5/J03AO8W3XzZ89ETHKrM
	aqqCGkeoZZwVrZBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KYPhvu6L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Z5LzWKIT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782300770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=29agRwTSPogDcDq96ulPkYtXy5jTSOg7J9tK00hmlTc=;
	b=KYPhvu6LNyKEgZqs3gzl13OryrZqcm+zAlDrygb+hob0skcnC6e9eA3tJUUkGi25x5Qqu+
	bbY10dQSp5M4QFYci1si0bKrTOjgjzwKnhN6t+0eH4HbWLj+Btl1mjYuqbvVldPRhCb58K
	jIbp3oNAwvtnj02hnHer5XUyppgB+Zw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782300770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=29agRwTSPogDcDq96ulPkYtXy5jTSOg7J9tK00hmlTc=;
	b=Z5LzWKIT/if9ecBH8hAzZ5Hlo/YeoRY+/IG+QXxQGHIvLMtwA5/J03AO8W3XzZ89ETHKrM
	aqqCGkeoZZwVrZBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1450B779A8;
	Wed, 24 Jun 2026 11:32:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XzTvBGLAO2pmFgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 24 Jun 2026 11:32:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9C38CA093E; Wed, 24 Jun 2026 13:32:45 +0200 (CEST)
Date: Wed, 24 Jun 2026 13:32:45 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: zero non-uptodate buffers before encryption in
 writeback
Message-ID: <ipktws7ahaikdxuese5jybuvyh6s4rcrhv6nykx4q6algik2ml@auadhzbcjuvd>
References: <20260624065948.85415-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624065948.85415-1-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 211E575BDD
X-Spam-Score: -2.51

On Wed 24-06-26 14:59:48, Yun Zhou wrote:
> ext4_bio_write_folio() encrypts the folio content from offset 0 up to
> round_up(len, blocksize) before submitting IO. When blocksize < PAGE_SIZE,
> this range may include blocks that are not being written out (holes,
> delay, or unwritten blocks). If the folio was freshly allocated by the
> page cache (via write_begin) for a partial-page write, these non-target
> blocks may remain uninitialized from the buddy allocator.
> 
> The encryption engine (AES-XTS) then reads these uninitialized bytes as
> operands, triggering a KMSAN uninit-value report in aes_encrypt().
> 
> Fix this by zeroing any non-uptodate buffer that is not being written
> out, before calling fscrypt_encrypt_pagecache_blocks(). This ensures the
> crypto engine never operates on uninitialized data regardless of which
> blocks are actually being submitted for IO.
> 
> The common case of blocksize == PAGE_SIZE is unaffected since there can
> be no non-overlapping blocks within a single-block folio.
> 
> Reported-by: syzbot+7add5c56bc2a14145d20@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=7add5c56bc2a14145d20
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

Eric has just sent patch set that deletes this code [1]. So I think this
patch isn't needed anymore.

[1] lore.kernel.org/20260624050334.124606-1-ebiggers@kernel.org

								Honza

> ---
>  fs/ext4/page-io.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index bc674aa4a656..2d380b5a1501 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -555,12 +555,22 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
>  	 * block which might be needed.  This may cause some unneeded blocks
>  	 * (e.g. holes) to be unnecessarily encrypted, but this is rare and
>  	 * can't happen in the common case of blocksize == PAGE_SIZE.
> +	 *
> +	 * Zero out any non-uptodate buffers that are not being written out,
> +	 * to prevent uninitialized memory from being fed into the crypto
> +	 * engine.
>  	 */
>  	if (fscrypt_inode_uses_fs_layer_crypto(inode)) {
>  		gfp_t gfp_flags = GFP_NOFS;
>  		unsigned int enc_bytes = round_up(len, i_blocksize(inode));
>  		struct page *bounce_page;
>  
> +		do {
> +			if (!buffer_async_write(bh) && !buffer_uptodate(bh))
> +				folio_zero_range(folio, bh_offset(bh),
> +						 bh->b_size);
> +		} while ((bh = bh->b_this_page) != head);
> +
>  		/*
>  		 * Since bounce page allocation uses a mempool, we can only use
>  		 * a waiting mask (i.e. request guaranteed allocation) on the
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
