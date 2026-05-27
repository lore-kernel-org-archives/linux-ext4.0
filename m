Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F603ED124
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 10:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779879256; cv=none; b=eu3nH5nJx3rlk6W6ZRSGQ4rtQgKulEgcu9ZtXm5by3ndOBo3wwU6WHHlfQJQ6HELi6l3G7j9gf62N7oLUT5Q0+ftBK0VEVCv5F57feEXFzrQQSlGzA8b/qnmH8e+VScz87r683DplSYI+B6SzT0v8WwOGbV7AmVHrktFWNqolzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779879256; c=relaxed/simple;
	bh=bKXR00K1hdg3T7lmt58rnNhOTDs8EEmClkSJvZjOQr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JW8Eaf2K4063y8yd2ricmWTixmO142kX+2ZfzMopIpsIawOapVa0PKvABYhiCWUohySrUXT1KEWeWkD4CPa6a5K1PFW01cZOlyESY4vD0cyAivQWc7O/zyOlIDMkuESW5EZyl+JZxsjatAh90nZL1k9Gnc8l6iIKZqQZV2wKYns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Kn5aga4s; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mpDw7S56; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Kn5aga4s; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mpDw7S56; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Kn5aga4s";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mpDw7S56";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Kn5aga4s";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mpDw7S56"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7E9506AC00;
	Wed, 27 May 2026 10:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779879253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8bfHryD5kL+IzjkbS2cG841pOORFQqr9my9VNgvfOF4=;
	b=Kn5aga4sxEFcd3tY3tsl4yU+O5y1KkV9+6nEavWJCU3h5fsuRq2pfIV7ZuEPoFGrVo+c6l
	SUfLFGV98lO5nya9k/z0Xhx/v+CLu/GBxloMH4dskpszD/fasfG0dTTO6ZLNiUhRVpZH8S
	wXZ53H2LI4xA3rdLqBIoenv1EnE9eyg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779879253;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8bfHryD5kL+IzjkbS2cG841pOORFQqr9my9VNgvfOF4=;
	b=mpDw7S56SJR0tuj8EZvSves/tKq1uF7qEaH9N5euV1FIzdbb2CAWOngrEd0OZCROEJqMM/
	MxWyYDetL4mT7mAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779879253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8bfHryD5kL+IzjkbS2cG841pOORFQqr9my9VNgvfOF4=;
	b=Kn5aga4sxEFcd3tY3tsl4yU+O5y1KkV9+6nEavWJCU3h5fsuRq2pfIV7ZuEPoFGrVo+c6l
	SUfLFGV98lO5nya9k/z0Xhx/v+CLu/GBxloMH4dskpszD/fasfG0dTTO6ZLNiUhRVpZH8S
	wXZ53H2LI4xA3rdLqBIoenv1EnE9eyg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779879253;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8bfHryD5kL+IzjkbS2cG841pOORFQqr9my9VNgvfOF4=;
	b=mpDw7S56SJR0tuj8EZvSves/tKq1uF7qEaH9N5euV1FIzdbb2CAWOngrEd0OZCROEJqMM/
	MxWyYDetL4mT7mAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 755035A7C1;
	Wed, 27 May 2026 10:54:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tYKeHFXNFmp0BwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 27 May 2026 10:54:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1793EA0EB5; Wed, 27 May 2026 12:54:13 +0200 (CEST)
Date: Wed, 27 May 2026 12:54:13 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 16/34] jbd2: Convert journal commit to bh_submit()
Message-ID: <b3pptezw7bh5yh2ntj3tnwpddgfuy3j6u26hw6yiessvcczwiz@duys3w356rdi>
References: <20260525171931.4144395-1-willy@infradead.org>
 <20260525171931.4144395-17-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525171931.4144395-17-willy@infradead.org>
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Mon 25-05-26 18:19:09, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call by using bh_submit()
> instead of submit_bh() in journal_submit_commit_record()
> and jbd2_journal_commit_transaction().  These both use
> journal_end_buffer_io_sync(), so it's more straightforward to do them
> both at once.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-ext4@vger.kernel.org

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

Another note for future work here: The BH_Shadow handling looks like a dead
code. We hold buffer lock when writing out bh to the journal and we do
acquire the buffer lock in do_get_write_access() anyway (which is the only
place that checks for BH_Shadow) so the buffer_shadow() check should never
trigger. Needs checking, some more thought, and possibly slightly expanding
the area where buffer lock is held in do_get_write_access() but it should
be relatively low hanging fruit. Then we can completely remove BH_Shadow
and use generic IO completion function.

								Honza

> ---
>  fs/jbd2/commit.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 8cf61e7185c4..38f318bb4279 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -29,8 +29,10 @@
>  /*
>   * IO end handler for temporary buffer_heads handling writes to the journal.
>   */
> -static void journal_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
> +static void journal_end_buffer_io_sync(struct bio *bio)
>  {
> +	bool uptodate = bio->bi_status == BLK_STS_OK;
> +	struct buffer_head *bh = bio_endio_bh(bio);
>  	struct buffer_head *orig_bh = bh->b_private;
>  
>  	BUFFER_TRACE(bh, "");
> @@ -147,13 +149,12 @@ static int journal_submit_commit_record(journal_t *journal,
>  	lock_buffer(bh);
>  	clear_buffer_dirty(bh);
>  	set_buffer_uptodate(bh);
> -	bh->b_end_io = journal_end_buffer_io_sync;
>  
>  	if (journal->j_flags & JBD2_BARRIER &&
>  	    !jbd2_has_feature_async_commit(journal))
>  		write_flags |= REQ_PREFLUSH | REQ_FUA;
>  
> -	submit_bh(write_flags, bh);
> +	bh_submit(bh, write_flags, journal_end_buffer_io_sync);
>  	*cbh = bh;
>  	return 0;
>  }
> @@ -751,9 +752,9 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  				lock_buffer(bh);
>  				clear_buffer_dirty(bh);
>  				set_buffer_uptodate(bh);
> -				bh->b_end_io = journal_end_buffer_io_sync;
> -				submit_bh(REQ_OP_WRITE | JBD2_JOURNAL_REQ_FLAGS,
> -					  bh);
> +				bh_submit(bh,
> +					REQ_OP_WRITE | JBD2_JOURNAL_REQ_FLAGS,
> +					journal_end_buffer_io_sync);
>  			}
>  			cond_resched();
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
