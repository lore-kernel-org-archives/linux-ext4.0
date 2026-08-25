Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47101399CF0;
	Wed, 26 Aug 2026 08:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731454; cv=none; b=pQ10FwkW4bnR0PneSjCkJFKku5Qm7xbg7o2Uxk+lLZiSiFKKCM/fh5psO2mwNeL0RjyTr/5jI88LAYtjDtP0ZCop9DqS6AGLpPxEw/djJJU/X5iTlO97gcfEuEorTPMtjZPA6bVSA9Bu0G1ESVJ/VqXuw2Hnpjyq5CmKpDsu7ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731454; c=relaxed/simple;
	bh=7LF4q8CwrKhNlq26KmMg0JfO5NQyG28iY2elQAokL+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ImpO7yFhN234NtJI1JxP0YHuwHsnLoOzPvveOI+pRXG/dSQZclr2q2HaU0JlJeB9raCcLX/RoClfBTUPA+Tat8Jt/1tzGHy1PzKGP3kF3W+4HerjO6l9PvGQ5J2e3sNFm0blCAfjy47otTO2Lbf+YIsdEjATL0W3kOl4OfqY3ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0prtf3vC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qCgkkrcq; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cdtBSAWY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=13ibFp0I; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0prtf3vC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qCgkkrcq";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cdtBSAWY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="13ibFp0I"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C99121F814;
	Wed, 26 Aug 2026 07:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=isUrC9bXcIL3HeO7qQ0qisSBt8h7f1BtFkQM3qT4E78=;
	b=0prtf3vCOp902PloqtIgt5WZuPOcm9IbSytQljqiKVfdw+yEHRyZujBnOwVHO5z/QV21vT
	OkuYliKuBj7bNyJl1rH7mFmWzZYq/cdztYsfWt7Rn6nYF7NRIquRcBf88pvGgKBNcJ1opw
	hzyQ44M+Z5+cW5VP9wDjVwHSwgUiUW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730615;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=isUrC9bXcIL3HeO7qQ0qisSBt8h7f1BtFkQM3qT4E78=;
	b=qCgkkrcqav1C0k60wy68ujiZOXtI8vVwCqi9vNyA5mqicT/RSFo8rmjh/e5h59TCMqD/+5
	uoaGWHmVl4oHoQCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cdtBSAWY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=13ibFp0I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=isUrC9bXcIL3HeO7qQ0qisSBt8h7f1BtFkQM3qT4E78=;
	b=cdtBSAWYUuoNvw8BURMZstwD2wKDrqRlpkHeD/JVy8tXsiXL9jMH/bJsmPjMcRN1tOfDwV
	8/nMMNZBgXMTVETjJ452eD1kXykuL3mT02G4om49WYTpHBaXnY25onnh58diWwfdixBzcu
	KVHNjHbIpbNna/OtNsTBCyx3rWuTsnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=isUrC9bXcIL3HeO7qQ0qisSBt8h7f1BtFkQM3qT4E78=;
	b=13ibFp0IU8SX9ki3JSfnK3PIENIzeuXUl796gRQ6OybMStQ599B2I7qoAaMOm3KijwsjBv
	USSsTF3zeArPsWDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 18CC4136AE;
	Wed, 26 Aug 2026 07:49:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QusKBqSajmowDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8A882A13C2; Tue, 25 Aug 2026 19:24:38 +0200 (CEST)
Date: Tue, 25 Aug 2026 19:24:38 +0200
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
Subject: Re: [PATCH v2 21/21] buffer: clear BH_Write_EIO when a write
 succeeds, not when one starts
Message-ID: <hkxjcqnftdmyouekxz25lilaaurbcak4tdmufhy6rqtgnm6n76@hisoy47c7vc3>
References: <cover.1785951556.git.coshi036@gmail.com>
 <1c976fd191aa6e99dbe65d6a1ec63f8706cc0dfa.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c976fd191aa6e99dbe65d6a1ec63f8706cc0dfa.1785951556.git.coshi036@gmail.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
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
	FREEMAIL_TO(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLr6u35b1fsnb818ss3au1oekd)];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,fiu.edu];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,fiu.edu:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: C99121F814
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Thu 06-08-26 12:58:44, Chao Shi wrote:
> BH_Write_EIO is cleared in __bh_submit(), when a buffer that has been
> written before is submitted for write again.  That is early: it says the
> error is gone at the moment we start trying to fix it, rather than when we
> have.
> 
> It also loses errors.  A task whose write fails sets the flag and then goes
> to look at it; if another task redirties the buffer and resubmits it in
> between, the submission clears the flag and the first task sees no error at
> all.  Neither of them is doing anything wrong.
> 
> Clear it on successful write completion instead, in the end io handlers -
> the same four the rest of this series has been converting, plus gfs2's,
> which already marked errors this way.  Then the flag means what it says:
> the last write of this buffer that finished, failed.  A resubmission no
> longer hides an error that has not been fixed yet, and one that has been
> fixed clears the flag when the data reaches the disk.
> 
> __bh_submit() keeps setting BH_Req, which is what the rest of the tree
> reads it for.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Acked-by: Weidong Zhu <weizhu@fiu.edu>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c           | 15 +++++++--------
>  fs/ext4/fast_commit.c |  1 +
>  fs/gfs2/lops.c        |  2 ++
>  fs/jbd2/commit.c      |  4 +++-
>  4 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 425fbfe72ad1..68ea0ef8470e 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -202,7 +202,9 @@ void bh_end_write(struct bio *bio)
>  	struct buffer_head *bh;
>  	bool success = bio_endio_bh(bio, &bh);
>  
> -	if (!success) {
> +	if (success) {
> +		clear_buffer_write_io_error(bh);
> +	} else {
>  		buffer_io_error(bh, ", lost sync page write");
>  		mark_buffer_write_io_error(bh);
>  	}
> @@ -433,7 +435,9 @@ void bh_end_async_write(struct bio *bio)
>  	BUG_ON(!buffer_async_write(bh));
>  
>  	folio = bh->b_folio;
> -	if (!success) {
> +	if (success) {
> +		clear_buffer_write_io_error(bh);
> +	} else {
>  		buffer_io_error(bh, ", lost async page write");
>  		mark_buffer_write_io_error(bh);
>  	}
> @@ -1114,7 +1118,6 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  		enum rw_hint write_hint, struct writeback_control *wbc,
>  		bio_end_io_t end_bio)
>  {
> -	const enum req_op op = opf & REQ_OP_MASK;
>  	struct bio *bio;
>  
>  	BUG_ON(!buffer_locked(bh));
> @@ -1122,11 +1125,7 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  	BUG_ON(buffer_delay(bh));
>  	BUG_ON(buffer_unwritten(bh));
>  
> -	/*
> -	 * Only clear out a write error when rewriting
> -	 */
> -	if (test_set_buffer_req(bh) && (op == REQ_OP_WRITE))
> -		clear_buffer_write_io_error(bh);
> +	set_buffer_req(bh);
>  
>  	if (buffer_meta(bh))
>  		opf |= REQ_META;
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index a2028fbd4540..95998827ff01 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -209,6 +209,7 @@ static void ext4_end_buffer_io_sync(struct bio *bio)
>  	if (success) {
>  		ext4_debug("%s: Block %lld written",
>  			   __func__, bh->b_blocknr);
> +		clear_buffer_write_io_error(bh);
>  	} else {
>  		ext4_debug("%s: Block %lld write failed",
>  			   __func__, bh->b_blocknr);
> diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> index 3df6e4b7e8b9..7440e5b72f8a 100644
> --- a/fs/gfs2/lops.c
> +++ b/fs/gfs2/lops.c
> @@ -179,6 +179,8 @@ static void gfs2_end_log_write_bh(struct gfs2_sbd *sdp, struct folio *folio,
>  	do {
>  		if (error)
>  			mark_buffer_write_io_error(bh);
> +		else
> +			clear_buffer_write_io_error(bh);
>  		unlock_buffer(bh);
>  		next = bh->b_this_page;
>  		size -= bh->b_size;
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index cd7ef783bd36..ebf6ba58ff4d 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -36,7 +36,9 @@ static void journal_end_buffer_io_sync(struct bio *bio)
>  	struct buffer_head *orig_bh = bh->b_private;
>  
>  	BUFFER_TRACE(bh, "");
> -	if (!success)
> +	if (success)
> +		clear_buffer_write_io_error(bh);
> +	else
>  		mark_buffer_write_io_error(bh);
>  	if (orig_bh) {
>  		clear_and_wake_up_bit(BH_Shadow, &orig_bh->b_state);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
