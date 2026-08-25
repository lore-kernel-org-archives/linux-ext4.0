Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115D7399CF0;
	Wed, 26 Aug 2026 07:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730609; cv=none; b=Y7z3S11nYoFGdSHfG2PAsWSIR8yKt4Yzz6A4jg0z6GOymgStmtk1eKfHAy7G4LJvR9dUrmuDoWJDjrPiOkr2hXwQhypQRQoaMavPpEgFf5m/foyHy7KAubZkNzErokoP9jI5OJDTmML/6t63xhI3fcrCTebYwAuHp3MaxePusEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730609; c=relaxed/simple;
	bh=/USUiUer2BhYo2LEKC+QSsOIR/yVyqPkcbr9uk6jFKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=of5BJgvWD7fj2wOpyj1IyXPu/nhebJ7K0pP4fScnKPbRzemQJHEcHz46mMaTEAMOpLHqqyNupHgdykgbVirf2H5IGMuIyVsu5GFV/fQv6m14Cl8n5DAWsXsotlpCnyKtilJYpgpT6uqz8Zt3vQKPpe758+EK75J3GhT8jnztNto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1UA75Abw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gZLeVzhx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XW6gcqHR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/Zv2i9tk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1UA75Abw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gZLeVzhx";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XW6gcqHR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/Zv2i9tk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 981E087351;
	Wed, 26 Aug 2026 07:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S2YAhMtG8uFdapykVU1pxCQGl20ZoAPCN+wmYAeKcPM=;
	b=1UA75Abw0TpUE89hXpAsxVccjAYd2IAhlicK1AmGNDTJb2gvCukIN3C7WiCQKPKLMJa2hq
	0hcS4pWHXm6YPp2Jxm9gjypDjWyorZ1myuAXT0IduYAHBrp9ZVnV7fYqrXQ6oPu5Wll+vS
	eSMcehDQjofjakPQd3ut8vQWkNUlcfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730601;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S2YAhMtG8uFdapykVU1pxCQGl20ZoAPCN+wmYAeKcPM=;
	b=gZLeVzhxgowMPXQCqWWsfRHeo/dWVgLOHzcWBiZ5x0AYMwywiSfJESK04SqdyBoRRwYIi/
	BAd7udDjGSXX+cCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S2YAhMtG8uFdapykVU1pxCQGl20ZoAPCN+wmYAeKcPM=;
	b=XW6gcqHRCtlLuH1nMPKIacpqY7mibISnObfF66CxihDbAM4tl29LC+fLIO0ICc5eHTdXR2
	zWrn47pG7ZgqICMrcPMK1Gjbi2C83SKU0fDsbR58QxYIPlIfWF2sJ6GUhtK4bBYHuV5hWv
	oXXz/3vRYuxSiqbrENCkzc1NvQenlvs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730597;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S2YAhMtG8uFdapykVU1pxCQGl20ZoAPCN+wmYAeKcPM=;
	b=/Zv2i9tk5nh2gUBKCOgxUlSCkfm8Q/1jm9aZu8rKwSUYKePrXlYEWwi3eDdU3QPCUP37SQ
	sK59n/+EZRsrlpAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6200D13680;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jaHtF6Oajmr9CwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7D034A13BD; Tue, 25 Aug 2026 19:19:04 +0200 (CEST)
Date: Tue, 25 Aug 2026 19:19:04 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Weidong Zhu <weizhu@fiu.edu>
Subject: Re: [PATCH v2 17/21] jbd2: report journal write errors with
 BH_Write_EIO
Message-ID: <e2wjbsip4hixztwcxx5kbvwrplwefyche5gsawnw33z4ei2vxa@7ecnu3nb3xjp>
References: <cover.1785951556.git.coshi036@gmail.com>
 <c700983eea955429d927791fe5fb9ffe6cf11056.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c700983eea955429d927791fe5fb9ffe6cf11056.1785951556.git.coshi036@gmail.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[suse.com:email,fiu.edu:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RLhn4jw3wthgom179184pqozfe)];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,fiu.edu];
	FREEMAIL_TO(0.00)[gmail.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]

On Thu 06-08-26 12:58:40, Chao Shi wrote:
> The journal's own write completion handler,
> journal_end_buffer_io_sync(), reports a failed write by clearing
> BH_Uptodate, and the three places that wait for journal writes look for
> that.  This series is removing that convention: a buffer whose write failed
> still holds the data that was supposed to reach the disk, and saying it is
> not up to date makes callers rewrite, re-read or WARN over data that was
> never wrong.
> 
> Set BH_Write_EIO instead, with mark_buffer_write_io_error(), and test it in
> journal_wait_on_commit_record() and in the two commit-phase waits.
> 
> The handler stops touching BH_Uptodate in either direction.  Setting it on
> success was never needed: every caller marks the buffer up to date before
> submitting the write, because a buffer with no valid data is not something
> you can write out.  The local flag is renamed to match what it now means.
> 
> The two changes have to go together, because commit phase 4 waits on a
> mixed list: descriptor blocks are submitted with
> journal_end_buffer_io_sync(), while revoke blocks go through
> write_dirty_buffer() and land in bh_end_write().  bh_end_write() already
> sets BH_Write_EIO, so converting the consumer alone would keep working for
> revoke blocks and silently stop detecting failed descriptor writes.  With
> the handler converted, both halves of the list report the same way.
> 
> mark_buffer_write_io_error() is safe on all of these buffers.  The shadow
> buffers from jbd2_journal_write_metadata_buffer() have no folio and no
> associated mapping, so it does nothing beyond setting the flag.  Descriptor
> and commit blocks are ordinary buffers on the journal device, and marking
> the journal's mapping with the error is what write_dirty_buffer() already
> does for revoke blocks on the same device.
> 
> Acked-by: Weidong Zhu <weizhu@fiu.edu>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/commit.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 0c85af91f9b2..cd7ef783bd36 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -32,14 +32,12 @@
>  static void journal_end_buffer_io_sync(struct bio *bio)
>  {
>  	struct buffer_head *bh;
> -	bool uptodate = bio_endio_bh(bio, &bh);
> +	bool success = bio_endio_bh(bio, &bh);
>  	struct buffer_head *orig_bh = bh->b_private;
>  
>  	BUFFER_TRACE(bh, "");
> -	if (uptodate)
> -		set_buffer_uptodate(bh);
> -	else
> -		clear_buffer_uptodate(bh);
> +	if (!success)
> +		mark_buffer_write_io_error(bh);
>  	if (orig_bh) {
>  		clear_and_wake_up_bit(BH_Shadow, &orig_bh->b_state);
>  	}
> @@ -169,7 +167,7 @@ static int journal_wait_on_commit_record(journal_t *journal,
>  	clear_buffer_dirty(bh);
>  	wait_on_buffer(bh);
>  
> -	if (unlikely(!buffer_uptodate(bh)))
> +	if (unlikely(buffer_write_io_error(bh)))
>  		ret = -EIO;
>  	put_bh(bh);            /* One for getblk() */
>  
> @@ -834,7 +832,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  		wait_on_buffer(bh);
>  		cond_resched();
>  
> -		if (unlikely(!buffer_uptodate(bh)))
> +		if (unlikely(buffer_write_io_error(bh)))
>  			err = -EIO;
>  		jbd2_unfile_log_bh(bh);
>  		stats.run.rs_blocks_logged++;
> @@ -877,7 +875,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  		wait_on_buffer(bh);
>  		cond_resched();
>  
> -		if (unlikely(!buffer_uptodate(bh)))
> +		if (unlikely(buffer_write_io_error(bh)))
>  			err = -EIO;
>  
>  		BUFFER_TRACE(bh, "ph5: control buffer writeout done: unfile");
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
