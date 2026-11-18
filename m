Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795002038;
	b=KJt26jFYydxfiTZ8NprAK7Kcbz8epqevvcXOlnQ8196vxaMSWK4k6HmJtLhB4grJkbuB
	 HvieJG2uIluuCdmCAtpmtQdFzZV5OH8/Wwamzw7+4wdpbSkHGKhpfJeoiy191QsY9+qv6
	 IDsNEFT/wmM5wCfrKffy35wbpVN2td+CkS1mXK3YovmKt/UIGZKPJcU2pUNwJd8OFZiAA
	 MBD5BEm6fUF6XCKZ3iLZxJSmUVQVC7gjxpdBU4wBekOmzWpjLfULmcUsFBGqAownFCa4m
	 +UU0pAWJF4bqk8wRCh9tD/zqtjfORF7NT3iBbTQp4ViFNwXRfhQCitRZrJiAluKXI1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795002038;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=/jusEW8MbjxMqC7NChUXoiR0Wnd+3pEn500MQ5TYY6M=;
	b=zoJyJnpswUuPyBhhZM1/qR6FthNmf9my1FUPD9j4OAkU8U+peJbIctRkgFjMUwR7F5kN
	 6XVfVTAE3UdiWJRVUyx6ZlZcgN+bO5b1IJlkgtx6VTzv8aqoD5dcyF5TccBkc+kdv7YZf
	 XUP2WkW1/rNHjka6EaXRRIazS1Sfk3cvDFYP4CZvppK+PcODl3TvFhJP/aHyYJ+ijlOZv
	 O9Dbi/nkEok31fMt6qAio6ejAYUjamG0xySqlh0j+wf5AGACQXbl8LipDmEtUF8YRWnJ3
	 v5c+XVC7XCiBhVNxzw+QTi6JWePjzVqPTeTwsMA/Xhwev1QWQdA5TItMljbGPCE3nqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OEzEsxUe;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="/GC5I8d1";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tBOYjrHj;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qYlNhwvv;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF8F606A31C;
	Wed, 18 Nov 2026 11:40:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AF8F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OEzEsxUe;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/GC5I8d1;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tBOYjrHj;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qYlNhwvv
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 357A722383;
	Wed, 18 Nov 2026 11:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795002035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/jusEW8MbjxMqC7NChUXoiR0Wnd+3pEn500MQ5TYY6M=;
	b=OEzEsxUe0oXh5Ksh33U4er9nMgpOnZYAF51A5LB7QScubJMjJmmreKZuu+03kCCf5vDI3A
	jBodPefZYV6UHF59U/CjOv1zTJycIZS3r+7R4eWjXcCFzeGGhaCO4wzMQsXaqUZhzGyEAC
	Gk0xaSOl1i/bUT5N5gC00TkNdUQGbA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795002035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/jusEW8MbjxMqC7NChUXoiR0Wnd+3pEn500MQ5TYY6M=;
	b=/GC5I8d1pTl3XEpgGj8vZX9DuR0qnXvgcJjMRno2mFTh9YgQ8YY7FK/I3cxFwg8BHtA+wP
	dTe6GK4jjwSmLGCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tBOYjrHj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qYlNhwvv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795002034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/jusEW8MbjxMqC7NChUXoiR0Wnd+3pEn500MQ5TYY6M=;
	b=tBOYjrHjmr6qWxt68l4LrD1VTvYyylwdALGC7wHuSGvPqetzg/uO8hB4VhhT3cbcgndcsY
	1xvsOyGaaBNblmz9vNig+0RPztf4CEkBHKZxSbx8swkCY3XE1jEixXtRUlVqKGCrFCfZth
	eRMlQebzAHAnOffy7009I5zYaHSXA/8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795002034;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/jusEW8MbjxMqC7NChUXoiR0Wnd+3pEn500MQ5TYY6M=;
	b=qYlNhwvvRsUw5X+3UeuxGP2qkUVd0mEietHTOJvMgxhYrxgvrct7X0RC8GMI0Hcy5PXFs5
	Hyae9Xupjk8YhkCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B0F51334C;
	Wed, 18 Nov 2026 11:40:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YmhFKrGO/WphDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 11:40:34 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 72D562501B; Wed, 18 Nov 2026 12:40:29 +0100 (CET)
Date: Wed, 18 Nov 2026 12:40:29 +0100
From: Jan Kara <jack@suse.cz>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, namjae.jeon@samsung.com, a.sangwan@samsung.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: check RLIMIT_FSIZE in insert range
Message-ID: <ikuv23k7bxucr6itc73yu3xavmzsgmlgxzbhb7ialnvsydvoru@irjhteshrokf>
References: <20261116185810.82581-1-dennylin0707@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116185810.82581-1-dennylin0707@gmail.com>
X-Rspamd-Queue-Id: 357A722383
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:dkim,suse.cz:email];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,samsung.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:email,suse.com:email]
X-Spam-Score: -11.51

On Mon 16-11-26 18:58:10, Hungyu Lin wrote:
> ext4_insert_range() grows the file by len bytes but only checks the new
> size against s_maxbytes. FALLOC_FL_INSERT_RANGE can therefore make a
> file larger than RLIMIT_FSIZE allows, while ftruncate() and the
> fallocate() modes that extend a file fail with -EFBIG and SIGXFSZ. xfs,
> f2fs and ntfs3 already refuse to insert a range past the limit.
> 
> Fix this by validating the new size with inode_newsize_ok(), as
> ext4_do_fallocate() and ext4_zero_range() do.
> 
> Fixes: 331573febb6a ("ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ad0d80e33f60..94b9e091ef5f 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5803,6 +5803,9 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
>  	/* Check whether the maximum file size would be exceeded */
>  	if (len > inode->i_sb->s_maxbytes - inode->i_size)
>  		return -EFBIG;
> +	ret = inode_newsize_ok(inode, inode->i_size + len);
> +	if (ret)
> +		return ret;
>  
>  	/*
>  	 * Persist the pending zeroed EOF block to ensure i_disksize
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
