Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8BA3AB290
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 08:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775811141; cv=none; b=qBnfJRtfbhpz1qf03yqrrBJTTYHeOdw0E/mB7fJBWSeP2XRBk1881Usx70JimKqWeourww5UqSX4kX0T/zWg810Fae7Kqy3NT/R5fkfRsRuQLpTqon/UxWxznKcsvpuLSE/wNzS3LOGoC66GYLi0s7rolpoKXLbLnm/GBj4VpjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775811141; c=relaxed/simple;
	bh=2NF4CMzdVYJS+90CHEA+68ig7xbItwmKkaLQrQS1wX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FxzaHdMlZGA86CLs6SjlvG/PW5YFFB6tiDk2Sa9zwfOaHXIwsaMTxq5C9RTd4vkTZNz1+cX2txDkYvmjAe8AapS4axV6MVJzBC0JLrtoPrvmMvEBsGrHRdxtgfkltBCpMJfNgIfQI80DxCRfTewfmb5/MIvEyyLQ+406e5S5yYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=umvHFZ9d; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LHBWfGxJ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1FFuLjaj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Naqda7/5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="umvHFZ9d";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LHBWfGxJ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1FFuLjaj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Naqda7/5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ACF0C5BCD9;
	Fri, 10 Apr 2026 08:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775811138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDyO4k9B0CglAcYyPRfUWEeqKYLsjkgP04eByE2FkcA=;
	b=umvHFZ9dbM79L/u1GPpnISgGAua5NIjD7hsJNubBpb1IookyAxuACcikQ5LbIhiCltqKod
	stYRQtgfzn0Ogb4UyNtrVLOkPWhk0fq73oMt4QvJZWRdVlhr4740fkl+ZOo8z8uzxOLAOM
	+uf0f2jIE4on35RidnnB46jBsF+DccQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775811138;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDyO4k9B0CglAcYyPRfUWEeqKYLsjkgP04eByE2FkcA=;
	b=LHBWfGxJsiDgNRnuZNxod/Mr96o/5slXWuHB4L3JCa70l+pQiRRMOsAZayGjbJ0vqJtK/I
	suFMC7++ESc53GDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1FFuLjaj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Naqda7/5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775811136; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDyO4k9B0CglAcYyPRfUWEeqKYLsjkgP04eByE2FkcA=;
	b=1FFuLjajZeVxCt6zWo8qPGXAEQf9DghIUO8grmrQqAlEYp1O2/JdbB0om0NO3AAmEiVO9t
	fXZL2gWXIzDR5x/D69WFqWjRUTMyiKdy5DBtaBeeCZSSznK0DobauDMidN5Sy7Gzgzb49+
	Cq8JRWiVcT2NdXJtD3aMLfutXH55LY0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775811136;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDyO4k9B0CglAcYyPRfUWEeqKYLsjkgP04eByE2FkcA=;
	b=Naqda7/5VfnHTbpWWUa3Ba1WFDXlZN6StPp866IhPGqvP6zg6oLsD3zvB35c9pI9UXDbnS
	3tWRPhx7XATN2DAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F0B94A0B2;
	Fri, 10 Apr 2026 08:52:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5RrOJkC62GkHGgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 10 Apr 2026 08:52:16 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5504AA0A81; Fri, 10 Apr 2026 10:52:16 +0200 (CEST)
Date: Fri, 10 Apr 2026 10:52:16 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave@stgolabs.net, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	libaokun@linux.alibaba.com, yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, 
	yukuai@fnnas.com
Subject: Re: [PATCH v2] jbd2: fix deadlock in jbd2_journal_cancel_revoke()
Message-ID: <zyzdcmnkvrqgqzslms4ba3vrnk7gsbry3z2dgkpto3a2vidngx@2i4i36ndeebi>
References: <20260409114204.917154-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409114204.917154-1-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,stgolabs.net,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,huawei.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: ACF0C5BCD9

On Thu 09-04-26 19:42:03, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Commit f76d4c28a46a ("fs/jbd2: use sleeping version of
> __find_get_block()") changed jbd2_journal_cancel_revoke() to use
> __find_get_block_nonatomic() which holds the folio lock instead of
> i_private_lock. This breaks the lock ordering (folio -> buffer) and
> causes an ABBA deadlock when the filesystem blocksize < pagesize:
> 
>      T1                                T2
> ext4_mkdir()
>  ext4_init_new_dir()
>   ext4_append()
>    ext4_getblk()
>     lock_buffer()    <- A
>                                    sync_blockdev()
>                                     blkdev_writepages()
>                                      writeback_iter()
>                                       writeback_get_folio()
>                                        folio_lock()   <- B
>      ext4_journal_get_create_access()
>       jbd2_journal_cancel_revoke()
>        __find_get_block_nonatomic()
>         folio_lock()  <- B
>                                      block_write_full_folio()
>                                       lock_buffer()   <- A
> 
> This can occasionally cause generic/013 to hang.
> 
> Fix by only calling __find_get_block_nonatomic() when the passed
> buffer_head doesn't belong to the bdev, which is the only case that we
> need to look up its bdev alias. Otherwise, the lookup is redundant since
> the found buffer_head is equal to the one we passed in.
> 
> Fixes: f76d4c28a46a ("fs/jbd2: use sleeping version of __find_get_block()")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Indeed, good catch! Sadly, lockep didn't tell us about this as it tracks
neither buffer locks nor folio locks... The patch looks good. Feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
> v1->v2:
>  - Switch to using sb_is_blkdev_sb() to check whether the bh belongs to
>    the bdev.
> 
>  fs/jbd2/revoke.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
> index 9016ddb82447..e4c2fbd381f1 100644
> --- a/fs/jbd2/revoke.c
> +++ b/fs/jbd2/revoke.c
> @@ -428,6 +428,7 @@ void jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
>  	journal_t *journal = handle->h_transaction->t_journal;
>  	int need_cancel;
>  	struct buffer_head *bh = jh2bh(jh);
> +	struct address_space *bh_mapping = bh->b_folio->mapping;
>  
>  	jbd2_debug(4, "journal_head %p, cancelling revoke\n", jh);
>  
> @@ -464,13 +465,14 @@ void jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
>  	 * buffer_head?  If so, we'd better make sure we clear the
>  	 * revoked status on any hashed alias too, otherwise the revoke
>  	 * state machine will get very upset later on. */
> -	if (need_cancel) {
> +	if (need_cancel && !sb_is_blkdev_sb(bh_mapping->host->i_sb)) {
>  		struct buffer_head *bh2;
> +
>  		bh2 = __find_get_block_nonatomic(bh->b_bdev, bh->b_blocknr,
>  						 bh->b_size);
>  		if (bh2) {
> -			if (bh2 != bh)
> -				clear_buffer_revoked(bh2);
> +			WARN_ON_ONCE(bh2 == bh);
> +			clear_buffer_revoked(bh2);
>  			__brelse(bh2);
>  		}
>  	}
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
