Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1052F351C02;
	Wed, 26 Aug 2026 07:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730652; cv=none; b=o6V+db3EPQmskBy5xJYF7AXi8XPmVKzsSYbBERMtft5Gc4wHvWO2O6+UkONJiv59DBQQ4m/uuxTRY5kYoR3ei81oZAxUvO8ac66q1EHyE1aFRvchTE5z9xaKf0B4xeDFRXVLdxp317whSKu2SnFCp/qHxChkZAU30WZz2GdLlaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730652; c=relaxed/simple;
	bh=TLx5vRx0QY1S65tFDPp5wJgueNLqxmP5dA/0GjtdCn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zeh+tb458OUD/TL0m0XFlcgCoy+CQEtHB9E9JT1C3jbdMeouABPHNGI8q6NfKDoxrxruuoIsb6ZG+RUqr7QOPYMh09AOkF9pHpCDOqTLMS8hEBSVHim9rCNhIRuY2/KQ7mlBN55raJEBMJA44FO6fdwgZ92q1gKZScHQFREoAos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bOJhsNd1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AgUglSTa; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Xyev5vg1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Cd8hCTOw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bOJhsNd1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AgUglSTa";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Xyev5vg1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Cd8hCTOw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 42B98872A4;
	Wed, 26 Aug 2026 07:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=glArnehyUL2YejtLa4f66v/vgc+SEZ0NkBIAhIi2iwk=;
	b=bOJhsNd1B8Og00lesYJqxJNNprGFItCTU16fHAb64wV5jZlEDdStEu/cw24Mt7hUrBFnQQ
	B1Ocbl03DLX5PFZ+TSxkM9Y8WjSn51cwlLqaB4Dlm0Pf/+4zzoVqonHwb5h75Wlp1GaEyI
	jcoGukMgVXaosXuebRrC38o87y3aqio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730605;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=glArnehyUL2YejtLa4f66v/vgc+SEZ0NkBIAhIi2iwk=;
	b=AgUglSTa66RcS5qCcfN9puHEczwcTZ9PYAm5t7fVgAQ2De0SCPlwnKeKDARqlVyUMkymow
	x2W8mVcVji2YE8Dg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=glArnehyUL2YejtLa4f66v/vgc+SEZ0NkBIAhIi2iwk=;
	b=Xyev5vg1nzsBEzCsye4Q2+QAFN8tTRRAdM6x+S7LcTgZYN3Y/I7SyOmubnbNNFPb7JFSQQ
	1IMeWLPNQzpu8tHu1TKBVePCDqiHZb0kalYvKrf8EGlxJha+uT5+eWhCagZupYdyfXxZm/
	s+29udA1dB+7j1nov8SDVqhwFfRcLrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730601;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=glArnehyUL2YejtLa4f66v/vgc+SEZ0NkBIAhIi2iwk=;
	b=Cd8hCTOw4L/YTCZZLg8aUZVwYiOBuIngYJ4ROwtqP/aoxpJstMm3fwf91HaWQledpqzALG
	ATKNdLxz3Jal8XCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7924113686;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id huORHaOajmoEDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B2E6AA13B9; Tue, 25 Aug 2026 19:16:48 +0200 (CEST)
Date: Tue, 25 Aug 2026 19:16:48 +0200
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
Subject: Re: [PATCH v2 19/21] ext4, jbd2: report fast commit write errors
 with BH_Write_EIO
Message-ID: <xityjqv4msnqprnmtp5h4gqkzp5dsxifxgvh644vrw73oly2sz@s7ytrgtalxbl>
References: <cover.1785951556.git.coshi036@gmail.com>
 <970d8b9603d4620ab73038f49bc36831e37e00a0.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <970d8b9603d4620ab73038f49bc36831e37e00a0.1785951556.git.coshi036@gmail.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	R_RATELIMIT(0.00)[to_ip_from(RLhn4jw3wthgom179184pqozfe)];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,fiu.edu];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Thu 06-08-26 12:58:42, Chao Shi wrote:
> ext4_end_buffer_io_sync() is the third completion handler in this
> series that reports a failed write by clearing BH_Uptodate, and
> jbd2_fc_wait_bufs() is the only thing that looks at the result.
> Convert both.
> 
> Like the jbd2 handler, this one stops touching BH_Uptodate at all.
> ext4_fc_submit_bh() marks the buffer up to date before submitting, so
> setting it again on completion said nothing.  The local flag and the debug
> messages are reworded to describe the write rather than the buffer's
> contents, which the write does not change.
> 
> They have to move in the same patch.  The handler lives in ext4 and
> the wait in jbd2, but neither is used by anything else: the buffers
> are ext4's fast commit blocks, submitted by ext4_fc_submit_bh() and
> waited for by jbd2_fc_wait_bufs().  Converting one without the other
> silently disables fast commit write error reporting.
> 
> Acked-by: Weidong Zhu <weizhu@fiu.edu>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/fast_commit.c | 11 +++++------
>  fs/jbd2/journal.c     |  2 +-
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 8e2259799614..a2028fbd4540 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -203,17 +203,16 @@ static inline void ext4_fc_set_snap_err(int *snap_err, int err)
>  static void ext4_end_buffer_io_sync(struct bio *bio)
>  {
>  	struct buffer_head *bh;
> -	bool uptodate = bio_endio_bh(bio, &bh);
> +	bool success = bio_endio_bh(bio, &bh);
>  
>  	BUFFER_TRACE(bh, "");
> -	if (uptodate) {
> -		ext4_debug("%s: Block %lld up-to-date",
> +	if (success) {
> +		ext4_debug("%s: Block %lld written",
>  			   __func__, bh->b_blocknr);
> -		set_buffer_uptodate(bh);
>  	} else {
> -		ext4_debug("%s: Block %lld not up-to-date",
> +		ext4_debug("%s: Block %lld write failed",
>  			   __func__, bh->b_blocknr);
> -		clear_buffer_uptodate(bh);
> +		mark_buffer_write_io_error(bh);
>  	}
>  
>  	unlock_buffer(bh);
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 6e05dc47e20a..72e8ccbf7de4 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -886,7 +886,7 @@ int jbd2_fc_wait_bufs(journal_t *journal, int num_blks)
>  		 * Update j_fc_off so jbd2_fc_release_bufs can release remain
>  		 * buffer head.
>  		 */
> -		if (unlikely(!buffer_uptodate(bh))) {
> +		if (unlikely(buffer_write_io_error(bh))) {
>  			journal->j_fc_off = i + 1;
>  			return -EIO;
>  		}
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
